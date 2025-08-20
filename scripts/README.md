# Scripts de Automação

Esta pasta contém scripts utilitários para o YouTube Automation System.

## Arquivos

### `start.sh`
Script principal para inicialização do ambiente Docker.

**Uso:**
```bash
# Executar normalmente
./scripts/start.sh

# Executar limpando dados antigos
./scripts/start.sh --clean
```

**Funcionalidades:**
- ✅ Verifica se Docker e Docker Compose estão instalados
- 🛑 Para containers existentes
- 🗑️ Opção para limpar volumes do banco de dados
- 🔨 Constrói imagens Docker atualizadas
- 🚀 Inicia todos os serviços
- 📊 Verifica status dos serviços
- 📝 Mostra logs recentes

**Serviços iniciados:**
- 🗄️ MySQL (porta 3306)
- 🔧 n8n (porta 5678)
- 📡 API Node.js (porta 3000)

**Comandos úteis após inicialização:**
```bash
# Ver logs em tempo real
docker-compose -f docker/docker-compose.yml logs -f

# Parar sistema
docker-compose -f docker/docker-compose.yml down

# Reiniciar serviços
docker-compose -f docker/docker-compose.yml restart

# Verificar status
docker-compose -f docker/docker-compose.yml ps
```

## Configuração

Antes de executar o script, certifique-se de:

1. **Configurar variáveis de ambiente:**
   - Copie `.env.example` para `.env`
   - Configure as APIs keys necessárias

2. **Importar workflow no n8n:**
   - Acesse http://localhost:5678
   - Importe `workflows/youtube_mysql_tool_otimizado.json`
   - Configure credenciais MySQL e APIs
