# 🔐 Guia de Segurança - YouTube Automation

## ✅ Implementações de Segurança

### 1. **Gerenciamento de Credenciais**

**❌ Antes (Inseguro):**
- Tokens hardcoded nos workflows
- Credenciais expostas em variáveis de ambiente
- Riscos de vazamento em repositórios

**✅ Agora (Seguro):**
- Credenciais gerenciadas pelo n8n
- Tokens armazenados de forma criptografada
- Workflows usam referências seguras

### 2. **Configuração Segura**

#### **No n8n:**
1. Acesse: Settings → Credentials
2. Configure cada API individualmente
3. Use nomes descritivos (ex: "Google_Speech_API")
4. Teste as conexões antes de salvar

#### **Nos Workflows:**
- Placeholders substituídos: `[CONFIGURE_NO_N8N]`
- Referências seguras aos credentials do n8n
- Sem exposição de tokens nos JSONs

### 3. **Arquivos de Configuração**

#### **.env.example**
```bash
# Apenas configurações não-sensíveis
N8N_WEBHOOK_URL=http://localhost:5678/webhook/start-youtube-automation
N8N_ENCRYPTION_KEY=youtube-automation-2025-secure-key
```

#### **.env.production**
```bash
# Database credentials (mantidas para funcionalidade)
DB_USER=rodriketu
DB_PASSWORD=Overcome2020k

# API tokens removidos - configurar no n8n!
```

### 4. **Fluxo de Configuração Segura**

1. **Clone o projeto**
2. **Configure banco MySQL** (credenciais locais)
3. **Configure APIs no n8n** (seguir CONFIGURACAO_N8N_CREDENCIAIS.md)
4. **Importe workflows** (sem credenciais hardcoded)
5. **Teste o sistema**

### 5. **Benefícios da Nova Arquitetura**

- ✅ **Criptografia**: Tokens criptografados pelo n8n
- ✅ **Isolamento**: Credenciais separadas dos workflows
- ✅ **Rotação**: Fácil atualização de tokens
- ✅ **Auditoria**: Log de uso das credenciais
- ✅ **Repositório Limpo**: Sem segredos no Git

### 6. **Verificação de Segurança**

Execute este checklist antes da produção:

```bash
# ✅ Verificar se não há tokens nos arquivos
grep -r "sk-" . --exclude-dir=node_modules
grep -r "hf_" . --exclude-dir=node_modules
grep -r "Bearer " . --include="*.json"

# ✅ Verificar placeholders nos workflows
grep -c "\[CONFIGURE_NO_N8N\]" youtube*.json

# ✅ Verificar configuração n8n
# Acesse n8n → Settings → Credentials
```

### 7. **Melhores Práticas**

#### **Para Desenvolvedores:**
- Nunca commitar tokens reais
- Usar sempre placeholders em exemplos
- Documentar processo de configuração
- Testar com credenciais de desenvolvimento

#### **Para Produção:**
- Usar tokens com escopo mínimo necessário
- Configurar alertas de uso anômalo
- Fazer backup das configurações n8n
- Rotacionar tokens periodicamente

#### **Para Deployment:**
- Verificar configuração antes do deploy
- Usar ambiente isolado para testes
- Monitorar logs de API
- Implementar rate limiting

## 🚨 Resolução de Problemas

### **Erro: "Authentication failed"**
1. Verificar se credencial está configurada no n8n
2. Testar conexão na interface do n8n
3. Verificar escopo/permissões do token
4. Regenerar token se necessário

### **Erro: "Credential not found"**
1. Verificar nome da credencial no workflow
2. Confirmar que foi salva no n8n
3. Recarregar workflow se necessário

### **Dicas de Debug:**
- Usar modo debug do n8n
- Verificar logs detalhados
- Testar APIs individualmente
- Confirmar permissões de cada token

---

> 📚 **Documentação Relacionada:**
> - [CONFIGURACAO_N8N_CREDENCIAIS.md](CONFIGURACAO_N8N_CREDENCIAIS.md)
> - [CREDENCIAIS.md](CREDENCIAIS.md)
> - [README.md](README.md)
