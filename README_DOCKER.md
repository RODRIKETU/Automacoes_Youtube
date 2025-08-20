# 🐳 Docker Setup - YouTube Automation System

Este guia explica como executar todo o sistema YouTube Automation usando Docker Compose.

## 📋 Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado
- Pelo menos 4GB de RAM disponível
- Tokens de API configurados

## 🚀 Início Rápido

### 1. Configuração Inicial

```bash
# Clone o repositório
git clone https://github.com/RODRIKETU/Automacoes_Youtube.git
cd Automacoes_Youtube

# Execute o script de inicialização
./start.sh
```

### 2. Configuração Manual (Alternativa)

```bash
# 1. Configurar credenciais (já incluídas)
cp .env.production .env

# 2. Editar apenas os tokens de API no arquivo .env
nano .env
# MySQL já configurado: rodriketu / Overcome2020k

# 3. Iniciar os serviços
docker-compose up -d
```

## 🏗️ Arquitetura dos Containers

### Serviços Inclusos:

| Serviço | Container | Porta | Descrição |
|---------|-----------|-------|-----------|
| **MySQL** | `youtube_mysql` | 3306 | Banco de dados principal |
| **n8n** | `youtube_n8n` | 5678 | Automação com FFmpeg |
| **API** | `youtube_api` | 3000 | Servidor Node.js |
| **Web** | `youtube_web` | 8080 | Interface responsiva |

### Volumes Persistentes:
- `mysql_data`: Dados do banco MySQL
- `n8n_data`: Configurações e workflows do n8n
- `./workflows`: Workflows compartilhados

## 🔧 Configuração de Tokens

### Arquivo `.env` - Tokens Obrigatórios:

```bash
# APIs Essenciais (configure estas)
HUGGING_FACE_TOKEN=hf_your_token_here
YOUTUBE_API_KEY=your_youtube_api_key_here
ELEVENLABS_API_KEY=your_elevenlabs_api_key_here
GOOGLE_GEMINI_API_KEY=your_google_gemini_api_key_here

# Credenciais do Sistema (já configuradas)
DB_USER=rodriketu
DB_PASSWORD=Overcome2020k
N8N_ENCRYPTION_KEY=youtube-automation-2025-secure-key
```

## 🔐 Credenciais Padrão

### **Banco de Dados MySQL**
- **Usuário**: `rodriketu`
- **Senha**: `Overcome2020k`
- **Database**: `youtube_automation`
- **Porta**: `3306`

### **Conexão ao MySQL do Container**
```bash
# Conectar ao MySQL
docker exec -it youtube_mysql mysql -u rodriketu -p
# Senha: Overcome2020k
```
```

## 📖 Como Usar

### 1. Acessar a Interface Web
- URL: http://localhost:8080
- Selecione um tema de vídeo
- Clique em "Criar Vídeo" para iniciar a automação

### 2. Configurar n8n (Primeira vez)
- URL: http://localhost:5678
- Importe o workflow: `workflows/youtube_otimizado_mysql.json`
- Configure as credenciais MySQL:
  - Host: `mysql`
  - Usuário: `n8nuser`
  - Senha: (conforme .env)
  - Database: `youtube_automation`

### 3. Monitorar API
- URL: http://localhost:3000
- Endpoints disponíveis:
  - `GET /health` - Status da API
  - `GET /temas` - Lista de temas
  - `POST /automation/start` - Iniciar automação

## 🛠️ Comandos Úteis

### Gerenciamento de Containers:

```bash
# Ver status
docker-compose ps

# Ver logs em tempo real
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f n8n

# Reiniciar um serviço
docker-compose restart api

# Parar tudo
docker-compose down

# Parar e remover volumes (CUIDADO!)
docker-compose down -v
```

### Debugging:

```bash
# Acessar container do n8n
docker exec -it youtube_n8n sh

# Acessar container MySQL
docker exec -it youtube_mysql mysql -u root -p

# Ver logs de erro do nginx
docker-compose logs web
```

### Backup e Restore:

```bash
# Backup do banco
docker exec youtube_mysql mysqldump -u root -p youtube_automation > backup.sql

# Restore do banco
docker exec -i youtube_mysql mysql -u root -p youtube_automation < backup.sql
```

## 🔍 Verificação de Funcionamento

### Health Checks Automáticos:
- MySQL: `mysqladmin ping`
- n8n: `curl -f http://localhost:5678/healthz`
- API: `curl -f http://localhost:3000/health`

### Testes Manuais:

```bash
# Testar API
curl http://localhost:3000/health

# Testar listagem de temas
curl http://localhost:3000/temas

# Testar n8n
curl http://localhost:5678/healthz
```

## 🚨 Solução de Problemas

### Problemas Comuns:

**1. Container não inicia:**
```bash
# Ver logs detalhados
docker-compose logs nome_do_container

# Reconstruir imagem
docker-compose build --no-cache nome_do_container
```

**2. Banco não conecta:**
```bash
# Verificar se MySQL está rodando
docker-compose ps mysql

# Testar conexão manual
docker exec -it youtube_mysql mysql -u n8nuser -p
```

**3. n8n não acessa banco:**
- Verificar variáveis de ambiente no .env
- Aguardar MySQL inicializar completamente (pode levar 1-2 minutos)

**4. Ports em uso:**
```bash
# Ver quais ports estão em uso
netstat -tulpn | grep :3000

# Alterar ports no docker-compose.yml se necessário
```

### Logs Importantes:

```bash
# Logs completos de inicialização
docker-compose up

# Logs apenas de erros
docker-compose logs | grep -i error

# Logs do banco de dados
docker-compose logs mysql | grep -i error
```

## 🔐 Segurança

### Configurações de Produção:
- Altere senhas padrão no `.env`
- Use HTTPS em produção
- Configure firewall para portas específicas
- Faça backup regular dos dados

### Variáveis Sensíveis:
- Nunca commite o arquivo `.env`
- Use secrets do Docker em produção
- Rotacione tokens de API regularmente

## 📊 Monitoramento

### Métricas dos Containers:

```bash
# Uso de recursos
docker stats

# Espaço em disco
docker system df

# Logs estruturados
docker-compose logs --timestamps
```

### Integração com Ferramentas:
- Prometheus/Grafana para métricas
- ELK Stack para logs centralizados
- Portainer para interface web

## 🔄 Atualizações

### Atualizar Sistema:

```bash
# Baixar atualizações
git pull origin main

# Reconstruir imagens
docker-compose build --no-cache

# Reiniciar com novas imagens
docker-compose up -d
```

### Migração de Dados:
- Backup sempre antes de atualizar
- Teste em ambiente de desenvolvimento primeiro
- Verifique compatibility dos workflows n8n

## 📚 Recursos Adicionais

- [Documentação n8n](https://docs.n8n.io/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [MySQL Docker](https://hub.docker.com/_/mysql)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)
