# 🔐 Configuração de Credenciais no n8n

## 📋 Visão Geral

Este guia mostra como configurar todas as credenciais de API diretamente na interface do n8n, mantendo-as seguras e centralizadas.

## 🎯 Credenciais Necessárias

### 1. **Google Speech API / Gemini**
- **Tipo**: HTTP Header Auth
- **Header**: `Authorization`
- **Valor**: `Bearer YOUR_GOOGLE_API_KEY`

### 2. **ElevenLabs TTS**
- **Tipo**: HTTP Header Auth  
- **Header**: `xi-api-key`
- **Valor**: `YOUR_ELEVENLABS_API_KEY`

### 3. **Hugging Face**
- **Tipo**: HTTP Header Auth
- **Header**: `Authorization`
- **Valor**: `Bearer YOUR_HUGGING_FACE_TOKEN`

### 4. **YouTube API**
- **Tipo**: HTTP Header Auth
- **Header**: `Authorization`
- **Valor**: `Bearer YOUR_YOUTUBE_API_KEY`

## 🛠️ Como Configurar no n8n

### **Passo 1: Acessar Credenciais**
1. Abra o n8n: `http://localhost:5678`
2. Vá em **Settings** (⚙️) > **Credentials**
3. Clique em **Create New**

### **Passo 2: Google Speech API**
1. **Credential Type**: `HTTP Header Auth`
2. **Credential Name**: `Google Speech API`
3. **Header Name**: `Authorization`
4. **Header Value**: `Bearer YOUR_GOOGLE_API_KEY`
5. Clique em **Save**

### **Passo 3: ElevenLabs TTS**
1. **Credential Type**: `HTTP Header Auth`
2. **Credential Name**: `ElevenLabs`
3. **Header Name**: `xi-api-key`
4. **Header Value**: `YOUR_ELEVENLABS_API_KEY`
5. Clique em **Save**

### **Passo 4: Hugging Face**
1. **Credential Type**: `HTTP Header Auth`
2. **Credential Name**: `Hugging Face`
3. **Header Name**: `Authorization`
4. **Header Value**: `Bearer YOUR_HUGGING_FACE_TOKEN`
5. Clique em **Save**

### **Passo 5: YouTube API**
1. **Credential Type**: `HTTP Header Auth`
2. **Credential Name**: `YouTube API`
3. **Header Name**: `Authorization`
4. **Header Value**: `Bearer YOUR_YOUTUBE_API_KEY`
5. Clique em **Save**

## 📥 Configurar nos Workflows

### **Importar Workflows**
1. Vá em **Workflows** > **Import from File**
2. Selecione `workflows/youtube_mysql_tool_otimizado.json`
3. Clique em **Import**

### **Associar Credenciais aos Nós**

#### **Nó: "Transcreve no Google Speech"**
1. Clique no nó HTTP Request
2. Em **Authentication**: Selecione `Google Speech API`
3. Salve o workflow

#### **Nó: "HTTP ElevenLabs"**
1. Clique no nó HTTP Request
2. Em **Authentication**: Selecione `ElevenLabs`
3. Salve o workflow

#### **Nó: "Gerar Imagem"** (Hugging Face)
1. Clique no nó HTTP Request
2. Em **Authentication**: Selecione `Hugging Face`
3. Salve o workflow

#### **Nós do YouTube**
1. Para cada nó relacionado ao YouTube
2. Em **Authentication**: Selecione `YouTube API`
3. Salve o workflow

## 🔑 Onde Obter as API Keys

### **Google Speech API**
1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Ative a **Speech-to-Text API**
3. Vá em **Credentials** > **Create API Key**
4. Copie a chave gerada

### **ElevenLabs**
1. Acesse [ElevenLabs](https://elevenlabs.io/)
2. Faça login/registre-se
3. Vá em **Profile** > **API Keys**
4. Gere uma nova chave

### **Hugging Face**
1. Acesse [Hugging Face](https://huggingface.co/)
2. Faça login/registre-se
3. Vá em **Settings** > **Access Tokens**
4. Crie um novo token

### **YouTube API**
1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Ative a **YouTube Data API v3**
3. Crie credenciais OAuth 2.0 ou API Key
4. Configure os escopos necessários

## ✅ Verificação da Configuração

### **Teste Individual dos Nós**
1. No workflow, clique com botão direito em cada nó HTTP
2. Selecione **Execute Node**
3. Verifique se não há erros de autenticação

### **Logs de Erro Comuns**
- **401 Unauthorized**: Credencial incorreta ou inválida
- **403 Forbidden**: API key sem permissões necessárias
- **404 Not Found**: URL da API incorreta

## 🔒 Melhores Práticas de Segurança

### ✅ **Recomendações**
1. **Use nomes descritivos** para as credenciais
2. **Teste cada credencial** após configurar
3. **Monitore o uso** das APIs
4. **Rotacione as chaves** periodicamente
5. **Configure rate limits** quando possível

### ⚠️ **Avisos Importantes**
- Nunca compartilhe suas API keys
- Use diferentes chaves para dev/prod
- Configure alertas de uso excessivo
- Faça backup das configurações do n8n

## 🔄 Workflow Específico: MySQL Otimizado

### **Nós que Precisam de Credenciais**
| Nó | Credencial | Tipo |
|----|------------|------|
| Transcreve no Google Speech | Google Speech API | HTTP Header |
| HTTP ElevenLabs | ElevenLabs | HTTP Header |
| Gerar Imagem | Hugging Face | HTTP Header |
| Upload YouTube | YouTube API | OAuth2/API Key |

### **Configuração do MySQL**
- As credenciais do MySQL já estão configuradas nos nós MySQL
- Usuário: `rodriketu` / Senha: `Overcome2020k`
- Não precisam de configuração adicional

## 🚀 Testando o Setup Completo

### **1. Teste de Conectividade**
```bash
# Teste Google Speech API
curl -H "Authorization: Bearer YOUR_KEY" \
  https://speech.googleapis.com/v1/speech:recognize

# Teste ElevenLabs
curl -H "xi-api-key: YOUR_KEY" \
  https://api.elevenlabs.io/v1/voices

# Teste Hugging Face
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api-inference.huggingface.co/models/runwayml/stable-diffusion-v1-5
```

### **2. Executar Workflow Completo**
1. Acesse a interface web: `http://localhost:3000`
2. Selecione um tema
3. Clique em "Criar Vídeo"
4. Monitore a execução no n8n

## 📞 Troubleshooting

### **Problema: Credencial não aparece na lista**
- Verifique se salvou corretamente
- Recarregue a página do n8n
- Verifique o tipo de credencial (HTTP Header Auth)

### **Problema: Erro 401 nos requests**
- Verifique se a API key está correta
- Confirme o formato do header (com/sem "Bearer")
- Teste a chave em ferramenta externa (Postman, curl)

### **Problema: Workflow não executa**
- Verifique se todas as credenciais estão associadas
- Confirme se o MySQL está rodando
- Verifique os logs do n8n no Docker

---

*💡 **Dica**: Salve as configurações do n8n regularmente através de **Settings** > **Export/Import***
