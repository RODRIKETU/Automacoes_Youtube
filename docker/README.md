# 🐳 Docker Configuration

Este diretório contém todos os arquivos relacionados ao Docker para o YouTube Automation System.

## 📁 Arquivos

- **docker-compose.yml** - Configuração completa dos serviços
- **Dockerfile.api** - Build da API Node.js  
- **Dockerfile.n8n** - Build customizado do n8n (opcional)
- **nginx.conf** - Configuração do servidor web nginx

## 🚀 Como usar

### Opção 1: Docker Compose da raiz (Recomendado)
```bash
# Na raiz do projeto
docker-compose up -d
```

### Opção 2: Docker Compose desta pasta
```bash
# Dentro da pasta docker/
docker-compose up -d
```

## 🔧 Serviços Inclusos

- **MySQL 8.0** - Banco de dados principal
- **n8n** - Plataforma de automação  
- **API Node.js** - Servidor da aplicação
- **Nginx** - Servidor web (opcional, profile: web)

## 📍 Portas

- `3000` - API e Interface Web
- `5678` - n8n Interface
- `3306` - MySQL Database  
- `80` - Nginx (se ativo)

## 🔐 Variáveis de Ambiente

Configure no arquivo `.env` na raiz do projeto:

```bash
DB_HOST=localhost
DB_PORT=3306
DB_NAME=youtube_automation  
DB_USER=rodriketu
DB_PASSWORD=Overcome2020k
N8N_ENCRYPTION_KEY=youtube-automation-2025-secure-key
```

## 📚 Mais Informações

Veja a documentação completa em `docs/README_DOCKER.md`
