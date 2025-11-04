# ---------- Stage 1: Build Angular App ----------
FROM node:20 AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build Angular app
RUN npm run build --configuration=production

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:1.25-alpine

# Environment variable (can override at runtime)
ENV NG_APP_URL="https://task.thingsrms.com/v1"

# Copy built app
COPY --from=build /app/dist/ /usr/share/nginx/html/

# Copy the runtime config template
COPY src/assets/config.template.json /usr/share/nginx/html/assets/config.template.json

# Add bash for runtime replacement
RUN apk add --no-cache bash

# Entrypoint to replace runtime vars in config.json
# RUN echo '#!/bin/bash\n\
# set -e\n\
# cp /usr/share/nginx/html/assets/config.template.json /usr/share/nginx/html/assets/config.json\n\
# sed -i "s|__API_URL__|${NG_APP_URL}|g" /usr/share/nginx/html/assets/config.json\n\
# echo "✅ Environment variables injected into config.json"\n\
# nginx -g "daemon off;"' > /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80
