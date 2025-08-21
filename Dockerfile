# ==================================
# === STAGE 1: Build do projeto  ===
# ==================================
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .


# =====================================
# === STAGE 2: Imagem de Produção  ===
# =====================================
FROM node:18-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/ .

# Porta da aplicação
EXPOSE 9000

# Força a variável de ambiente PORT para 9000
ENV PORT=9000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
