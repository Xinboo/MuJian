FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM joseluisq/static-web-server:2-alpine
COPY --from=build /app/dist /public
ENV SERVER_PORT=80
ENV SERVER_ROOT=/public
ENV SERVER_COMPRESSION=true
ENV SERVER_FALLBACK_PAGE=/public/index.html
ENV SERVER_CACHE_CONTROL_HEADERS=true
EXPOSE 80
