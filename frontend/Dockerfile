# FROM ubuntu:latest

# # Install dependencies
# RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# # Install Flutter
# RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# # Verify Flutter installation
# RUN flutter doctor

# WORKDIR /usr/src/app

# COPY . .

# RUN flutter pub get
# RUN flutter build web

# EXPOSE 8081
# CMD ["flutter", "run", "-d", "web-server", "--web-port", "8081"]


# Stage 1 - Install dependencies and build the app
FROM ubuntu:20.04 AS builder

RUN apt-get update
RUN apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa
RUN apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Change stable channel
RUN flutter channel stable

# Enable web capabilities
RUN flutter config --enable-web
RUN flutter upgrade
RUN flutter pub global activate webdev

# RUN flutter doctor -v

# Copy files to container and build
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web --web-renderer canvaskit

# Stage 2 - Create the run-time image
FROM nginx:stable-alpine AS runner

COPY default.conf /etc/nginx/conf.d
# COPY package.json /usr/share/nginx/html
COPY --from=builder /app/build/web /usr/share/nginx/html