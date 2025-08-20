# Postman Collection e Environment

Esta pasta contém os arquivos de configuração do Postman para testar a API de Automação do YouTube.

## Arquivos

### `postman_collection.json`
Collection completa do Postman com todos os endpoints da API:
- Endpoints de vídeos (buscar, adicionar, atualizar status)
- Endpoints de estatísticas (contadores, relatórios)
- Endpoints de temas (listar, selecionar)
- Endpoints de download (collection e environment)

### `postman_environment.json`
Environment local do Postman com variáveis configuradas:
- `baseUrl`: http://localhost:3000
- Configurações específicas para desenvolvimento local

## Como Usar

1. **Importar Collection:**
   - Abra o Postman
   - Clique em "Import"
   - Selecione o arquivo `postman_collection.json`

2. **Importar Environment:**
   - No Postman, vá para "Environments"
   - Clique em "Import"
   - Selecione o arquivo `postman_environment.json`

3. **Configurar Environment:**
   - Selecione o environment "YouTube Automation Local"
   - Certifique-se de que o servidor esteja rodando em localhost:3000

4. **Download via API:**
   - Collection: GET /api/postman-collection
   - Environment: GET /api/postman-environment

## Endpoints Disponíveis

- **GET** `/api/postman-collection` - Download da collection
- **GET** `/api/postman-environment` - Download do environment

Ambos os arquivos podem ser baixados diretamente pela API para facilitar a distribuição e atualização.
