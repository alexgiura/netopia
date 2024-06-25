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

# Set up non-root user
RUN groupadd -r flutteruser && useradd -r -g flutteruser flutteruser

# Give flutteruser permissions for apt and flutter directory
RUN mkdir -p /usr/local/flutter && \
    chown -R flutteruser: /usr/local/flutter /home/flutteruser /var/lib/apt/lists /var/cache/apt/archives


USER flutteruser

# Switch to root temporarily to install dependencies
USER root

RUN apt-get update
RUN apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa
RUN apt-get clean

# Switch back to non-root user
USER flutteruser

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Change stable channel
RUN flutter channel beta

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

COPY frontend/default.conf /etc/nginx/conf.d
# COPY package.json /usr/share/nginx/html
COPY --from=builder /app/build/web /usr/share/nginx/html
