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



# Copy built app
COPY --from=build /app/dist/ /usr/share/nginx/html/



# Add bash for runtime replacement
RUN apk add --no-cache bash


ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80
