# ---------- Stage 1: Build Angular App ----------
FROM node:20 AS build

#ENV NG_APP_URL=${NG_APP_URL}

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --configuration=production --output-path=dist/TestEnv

# ---------- Stage 2: Nginx Server ----------
FROM nginx:1.25-alpine

# Copy the actual build output
COPY --from=build /app/dist/TestEnv /usr/share/nginx/html
COPY src/assets/config.template.json /usr/share/nginx/html/assets/config.template.json


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
