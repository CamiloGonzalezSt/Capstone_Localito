# ---- API de Localito (Node 20 + Express + TypeScript) ----
# Contexto de build: raíz del monorepo
FROM node:20-alpine AS build
WORKDIR /app

# Dependencias (aprovecha caché de capas)
COPY package.json package-lock.json .npmrc ./
COPY packages/shared/package.json packages/shared/
COPY apps/api/package.json apps/api/
COPY apps/web/package.json apps/web/
RUN npm ci

# Código y compilación
COPY packages/shared packages/shared
COPY apps/api apps/api
RUN npm run build -w packages/shared && npm run build -w apps/api

# ---- Imagen final ----
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app /app

EXPOSE 3000
CMD ["npm", "run", "start", "-w", "apps/api"]
