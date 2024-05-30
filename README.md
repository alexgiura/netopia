# ERP Project

This document provides instructions on how to set up the ERP Insiders project.

## Project Setup Instructions

Follow these steps to set up the project:

1. Open the "proxy" folder and run the following command:
   ```bash
   docker compose up -d --build
   ```
2. Open the "backend" folder and run the following command:
   ```bash
   docker compose up -d --build
   ```
3. For connecting Flutter app with backend, open http://localhost:8080 in browser. This it's traefik dashboard, follow Services->erp-app-backend@docker->copy url (example: http://172.18.0.5:8080).

4. In Fluter app frontend->lib->graphql->graphql_client.dart, and you need change ip address example:(http://172.18.0.5:8080/graphql).

5. Open the project in Visual Studio Code and run the application.

## Traefik Configuration

In Traefik, we only include the "backend" container. This allows us to have access to features like hot reloading and other benefits when we make changes to the code.
