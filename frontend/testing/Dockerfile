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

# Install sudo
RUN apt-get update && apt-get install -y sudo

# Set up non-root user with sudo access and create a home directory
RUN groupadd -r flutteruser && \
    useradd -m -r -g flutteruser -G sudo flutteruser && \
    echo "flutteruser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/flutteruser && \
    chmod 0440 /etc/sudoers.d/flutteruser

# Give flutteruser ownership of the flutter directory and their home directory
RUN mkdir -p /usr/local/flutter && chown -R flutteruser:flutteruser /usr/local/flutter /home/flutteruser

# Install dependencies as root
RUN apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa && apt-get clean

# Switch to flutteruser
USER flutteruser

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Perform flutter actions with flutteruser, using sudo if necessary
RUN flutter channel beta
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web --web-renderer canvaskit

# Stage 2 - Create the run-time image
FROM nginx:stable-alpine AS runner

COPY frontend/default.conf /etc/nginx/conf.d
COPY --from=builder /app/build/web /usr/share/nginx/html
