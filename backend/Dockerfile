# # Use the official Golang base image.
# FROM golang:latest

# # Set the working directory inside the container.
# WORKDIR /app

# # Copy go.mod and go.sum files to the working directory.
# COPY go.mod go.sum ./

# # Download all dependencies. Dependencies will be cached if the go.mod and go.sum files have not changed since the last build.
# RUN go mod download

# # Copy the source code from the current directory to the working directory inside the container.
# COPY .. .

# # Build the Go app.
# RUN  go build -o erp-api ./app/main/app.go

# # Expose the port your API will run on.
# EXPOSE 8080

# # Start the API.
# CMD ["./erp-api"]



# Folosește imaginea oficială Golang ca imagine de bază.
FROM golang:latest AS builder

# Setează directorul de lucru în interiorul containerului.
WORKDIR /app

# Copiază fișierele go.mod și go.sum în directorul de lucru.
RUN ls -la  # Listăm fișierele din directorul curent
COPY go.mod go.sum ./

# Download toate dependențele. Dependențele vor fi cache-uite dacă fișierele go.mod și go.sum nu s-au schimbat de la ultimul build.
RUN go mod download

# Copiază întregul cod sursă în directorul de lucru din interiorul containerului.
COPY . .

# Construiește aplicația Go.
RUN go build -o erp-api ./app/main/app.go

# Folosește o imagine mai mică pentru runtime.
FROM alpine:latest

# Setează directorul de lucru la runtime.
WORKDIR /root/

# Copiază binarul construit din stagiul de build.
COPY --from=builder /app/erp-api .

# Expune portul pe care va rula API-ul tău.
EXPOSE 8080

# Rulează aplicația.
CMD ["./erp-api"]
