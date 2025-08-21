# ==================================
# === STAGE 1: O Build do projeto ===
# ==================================
FROM node:18-alpine AS builder

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /usr/src/app

COPY package*.json ./

# Instala todas as dependências, incluindo as de desenvolvimento,
RUN npm install

# Copia o restante dos arquivos do projeto para o contêiner.
COPY . .


# =====================================
# === STAGE 2: A Imagem de Produção ===
# =====================================
# Utiliza uma nova imagem base, mais leve e limpa, para a produção.
FROM node:18-alpine

# Define o diretório de trabalho da imagem final.
WORKDIR /usr/src/app

# Copia apenas os arquivos essenciais do stage anterior (builder).
# Apenas os 'package.json' para que o Node saiba quais módulos carregar,
# a pasta 'node_modules' (já instalada) e o código da aplicação.
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/ .

# Expõe a porta que o aplicativo vai usar.
EXPOSE 3000

# Comando para iniciar a aplicação.
CMD ["npm", "start"]
