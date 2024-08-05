package handlers

import (
	"backend/db"
	"context"
	"encoding/json"
	"fmt"
	amqp "github.com/rabbitmq/amqp091-go"
	"go.uber.org/zap"
	"os"
	"os/signal"
	"syscall"
	"time"
)

type TaskMessage struct {
	Task               string `json:"task"`
	EfacturaDocumentID string `json:"efacturaDocumentID"`
	CheckInterval      int    `json:"checkInterval"`
	MaxWaitTime        int    `json:"maxWaitTime"`
}

func (r *Resolver) sendToRabbitMQ(ctx context.Context, msg TaskMessage) error {
	rabbitMQURL := fmt.Sprintf("amqp://%s:%s@%s:%s/",
		r.RabbitMQSettings.User,
		r.RabbitMQSettings.Password,
		r.RabbitMQSettings.Host,
		r.RabbitMQSettings.Port)

	conn, err := amqp.Dial(rabbitMQURL)
	if err != nil {
		return fmt.Errorf("failed to connect to RabbitMQ: %w", err)
	}
	defer conn.Close()

	ch, err := conn.Channel()
	if err != nil {
		return fmt.Errorf("failed to open a channel: %w", err)
	}
	defer ch.Close()

	q, err := ch.QueueDeclare(
		"efactura_status_check",
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		return fmt.Errorf("failed to declare a queue: %w", err)
	}

	body, err := json.Marshal(msg)
	if err != nil {
		return fmt.Errorf("failed to marshal message: %w", err)
	}

	err = ch.Publish(
		"",
		q.Name,
		false,
		false,
		amqp.Publishing{
			ContentType: "application/json",
			Body:        body,
		})
	if err != nil {
		return fmt.Errorf("failed to publish a message: %w", err)
	}

	r.Logger.Info("Message sent to RabbitMQ", zap.String("body", string(body)))
	return nil
}
func (r *Resolver) ConsumeFromRabbitMQ() error {
	rabbitMQURL := fmt.Sprintf("amqp://%s:%s@%s:%s/",
		r.RabbitMQSettings.User,
		r.RabbitMQSettings.Password,
		r.RabbitMQSettings.Host,
		r.RabbitMQSettings.Port)

	var conn *amqp.Connection
	var err error
	for i := 0; i < 10; i++ { // Increase retry attempts
		conn, err = amqp.Dial(rabbitMQURL)
		if err == nil {
			break
		}
		r.Logger.Warn("Failed to connect to RabbitMQ, retrying...", zap.Error(err))
		time.Sleep(5 * time.Second) // Increase wait time between retries
	}
	if err != nil {
		return fmt.Errorf("failed to connect to RabbitMQ: %w", err)
	}
	defer conn.Close()

	ch, err := conn.Channel()
	if err != nil {
		return fmt.Errorf("failed to open a channel: %w", err)
	}
	defer ch.Close()

	q, err := ch.QueueDeclare(
		"efactura_status_check",
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		return fmt.Errorf("failed to declare a queue: %w", err)
	}

	msgs, err := ch.Consume(
		q.Name,
		"",
		false,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		return fmt.Errorf("failed to register a consumer: %w", err)
	}

	sigterm := make(chan os.Signal, 1)
	signal.Notify(sigterm, syscall.SIGINT, syscall.SIGTERM)

	for {
		select {
		case d := <-msgs:
			go func(d amqp.Delivery) {
				var task TaskMessage
				if err := json.Unmarshal(d.Body, &task); err != nil {
					r.Logger.Error("Error decoding JSON", zap.Error(err))
					return
				}

				r.Logger.Info("Received a message", zap.String("body", string(d.Body)))
				r.processTask(task)
				if err := d.Ack(false); err != nil {
					r.Logger.Error("Failed to acknowledge message", zap.Error(err))
				}

			}(d)
		case <-sigterm:
			r.Logger.Info("Termination signal received. Shutting down consumer")
			return nil
		}
	}
}

func (r *Resolver) processTask(task TaskMessage) {
	ctx := context.Background()
	status := string(db.CoreEfacturaDocumentStatusProcessing)

	ticker := time.NewTicker(time.Duration(task.CheckInterval) * time.Millisecond)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			statusPtr, err := r.CheckEfacturaUploadState(ctx, task.EfacturaDocumentID)

			if err != nil {
				r.Logger.Error("Error checking status", zap.Error(err))
				return
			}
			if statusPtr != nil && *statusPtr != status {
				r.Logger.Info("Document status reached new status", zap.String("documentID", task.EfacturaDocumentID), zap.String("status", *statusPtr))
				return
			}
		}
	}
}
