# 🔄 Migração: GROQ → Google Speech API

## 📋 Resumo da Migração

Este documento descreve a migração da API GROQ (Whisper) para a **Google Speech-to-Text API** no sistema de automação do YouTube.

## 🎯 Principais Mudanças

### 1. **API Endpoint**
- ❌ **Antes**: `https://api.groq.com/openai/v1/audio/transcriptions`
- ✅ **Agora**: `https://speech.googleapis.com/v1/speech:recognize`

### 2. **Autenticação**
- ❌ **Antes**: `Bearer gsk_SUA_APIKEY` (GROQ API Key)
- ✅ **Agora**: `Bearer {{ $env.GOOGLE_GEMINI_API_KEY }}` (Google API Key)

### 3. **Formato de Requisição**
- ❌ **Antes**: `multipart-form-data` com arquivo binário
- ✅ **Agora**: `application/json` com conteúdo base64

### 4. **Modelo de IA**
- ❌ **Antes**: `whisper-large-v3` (GROQ)
- ✅ **Agora**: `latest_long` (Google Speech)

### 5. **Formato de Resposta**
```json
// GROQ Response (Anterior)
{
  "words": [
    {
      "word": "palavra",
      "start": 1.23,
      "end": 1.45
    }
  ]
}

// Google Speech Response (Atual)
{
  "results": [
    {
      "alternatives": [
        {
          "transcript": "texto completo",
          "words": [
            {
              "word": "palavra",
              "startTime": "1.23s",
              "endTime": "1.45s"
            }
          ]
        }
      ]
    }
  ]
}
```

## 🔧 Configuração

### 1. **Variáveis de Ambiente**
Adicione no seu arquivo `.env`:
```bash
# Google APIs
GOOGLE_GEMINI_API_KEY=your_google_api_key_here
GOOGLE_GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent
```

### 2. **Ativação de APIs no Google Cloud**
Certifique-se de que as seguintes APIs estão ativadas:
- ✅ Speech-to-Text API
- ✅ Cloud Storage API (se necessário)
- ✅ Generative AI API (Gemini)

### 3. **Criação da API Key**
1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Vá para **APIs & Services** > **Credentials**
3. Clique em **Create Credentials** > **API Key**
4. Restrinja a key para as APIs necessárias

## 🏗️ Alterações nos Workflows

### 1. **youtube.json** (Workflow Original)
- **Nó atualizado**: `transcreve audio no Google Speech`
- **Código JavaScript**: Adaptado para processar resposta do Google Speech
- **Variáveis**: Usa `GOOGLE_GEMINI_API_KEY`

### 2. **youtube_otimizado_mysql.json** (Workflow Otimizado)
- **Nó atualizado**: `Transcreve no Google Speech`
- **Base64 encoding**: Mantido para compatibilidade com MySQL
- **Timestamps**: Convertidos do formato Google (`1.23s` → `1.23`)

## 📊 Comparação de Recursos

| Recurso | GROQ | Google Speech |
|---------|------|---------------|
| **Qualidade** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Velocidade** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Precisão em PT-BR** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Word Timestamps** | ✅ | ✅ |
| **Custo** | $ | $$ |
| **Limites de Rate** | Moderado | Generoso |

## 🚀 Vantagens da Google Speech API

### ✅ **Benefícios**
1. **Melhor suporte ao português brasileiro**
2. **Maior precisão em timestamps**
3. **Integração nativa com ecossistema Google**
4. **Melhor handling de áudio de diferentes qualidades**
5. **Suporte a modelos especializados**

### ⚠️ **Considerações**
1. **Custo ligeiramente maior**
2. **Necessita autenticação Google Cloud**
3. **Rate limits diferentes**

## 🔍 Troubleshooting

### Problema: "Authentication failed"
```bash
# Verifique se a API key está correta
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://speech.googleapis.com/v1/speech:recognize
```

### Problema: "API not enabled"
1. Vá para [Google Cloud Console](https://console.cloud.google.com/)
2. Enable a **Speech-to-Text API**
3. Aguarde alguns minutos para propagação

### Problema: "Invalid audio format"
- Certifique-se de que o áudio está em formato suportado (MP3, WAV, FLAC)
- Verifique se o `sampleRateHertz` está correto
- Confirme que o base64 encoding está correto

## 🧪 Teste da Migração

### 1. **Teste Manual**
```bash
# Teste a API diretamente
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "config": {
      "encoding": "MP3",
      "sampleRateHertz": 44100,
      "languageCode": "pt-BR",
      "enableWordTimeOffsets": true
    },
    "audio": {
      "content": "BASE64_AUDIO_CONTENT"
    }
  }' \
  "https://speech.googleapis.com/v1/speech:recognize"
```

### 2. **Teste no n8n**
1. Importe o workflow atualizado
2. Configure as variáveis de ambiente
3. Execute um teste com áudio de amostra
4. Verifique se os timestamps estão corretos

## 📚 Documentação Adicional

- [Google Speech-to-Text API](https://cloud.google.com/speech-to-text/docs)
- [Supported audio formats](https://cloud.google.com/speech-to-text/docs/encoding)
- [Best practices](https://cloud.google.com/speech-to-text/docs/best-practices)

## 🔄 Rollback (Se Necessário)

Se precisar voltar para o GROQ:
1. Restaure os workflows da versão anterior
2. Altere as variáveis de ambiente
3. Ajuste o código JavaScript para formato GROQ

---

*Migração realizada em: Agosto 2025*  
*Testado em: n8n + Docker + MySQL*
