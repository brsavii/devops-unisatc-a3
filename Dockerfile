FROM node:18-alpine

# Diretório de trabalho
WORKDIR /app

# Instala dependências
COPY package*.json ./
RUN npm ci

# Copia código
COPY . .

# Build (se necessário)
RUN npm run build

# Exponha a porta do Strapi
ENV PORT=1337
EXPOSE 1337

# Inicia Strapi apontando para sqlite (.tmp/db)
CMD ["npm", "run", "start"]
