# Use the official Golang base image.
FROM golang:latest

# Set the working directory inside the container.
WORKDIR /app

# Copy go.mod and go.sum files to the working directory.
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files have not changed since the last build.
RUN go mod download

# Copy the source code from the current directory to the working directory inside the container.
COPY .. .

# Build the Go app.
RUN  go build -o erp-api ./app/main/app.go

# Expose the port your API will run on.
EXPOSE 8080

# Start the API.
CMD ["./erp-api"]