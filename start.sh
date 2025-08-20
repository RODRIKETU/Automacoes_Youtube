#!/bin/bash

# Script de inicialização do YouTube Automation System
# Este script configura e inicia todo o ambiente Docker

set -e

echo "🎬 YouTube Automation System - Docker Setup"
echo "============================================"

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Por favor, instale o Docker primeiro."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado. Por favor, instale o Docker Compose primeiro."
    exit 1
fi

# Verificar se arquivo .env existe
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env a partir do template..."
    cp .env.docker .env
    echo "⚠️  IMPORTANTE: Edite o arquivo .env com seus tokens de API antes de continuar!"
    echo "   Tokens necessários:"
    echo "   - HUGGING_FACE_TOKEN"
    echo "   - YOUTUBE_API_KEY" 
    echo "   - ELEVENLABS_API_KEY"
    echo "   - GROQ_API_KEY"
    echo ""
    read -p "Pressione ENTER depois de configurar os tokens no arquivo .env..."
fi

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose down --remove-orphans 2>/dev/null || true

# Remover volumes antigos (opcional)
read -p "🗑️  Deseja remover dados antigos do banco? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose down -v
    echo "✅ Volumes removidos"
fi

# Construir imagens
echo "🔨 Construindo imagens Docker..."
docker-compose build --no-cache

# Iniciar serviços
echo "🚀 Iniciando serviços..."
docker-compose up -d

# Aguardar serviços ficarem prontos
echo "⏳ Aguardando serviços ficarem prontos..."
sleep 30

# Verificar status dos serviços
echo "📊 Status dos serviços:"
docker-compose ps

# Verificar logs para erros
echo "📝 Verificando logs recentes..."
docker-compose logs --tail=20

echo ""
echo "🎉 Sistema iniciado com sucesso!"
echo ""
echo "📍 URLs de acesso:"
echo "   🌐 Interface Web: http://localhost:8080"
echo "   🔧 n8n Editor:    http://localhost:5678"
echo "   📡 API:           http://localhost:3000"
echo "   🗄️  MySQL:        localhost:3306"
echo ""
echo "📋 Comandos úteis:"
echo "   Ver logs:         docker-compose logs -f"
echo "   Parar sistema:    docker-compose down"
echo "   Reiniciar:        docker-compose restart"
echo "   Status:           docker-compose ps"
echo ""
echo "📚 Para importar o workflow:"
echo "   1. Acesse http://localhost:5678"
echo "   2. Importe o arquivo workflows/youtube_otimizado_mysql.json"
echo "   3. Configure as credenciais do MySQL e APIs"
echo ""
