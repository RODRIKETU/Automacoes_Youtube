# 🔐 Credenciais do Sistema - YouTube Automation

## 📋 Informações de Acesso

### 🗄️ **Banco de Dados MySQL**
- **Usuário**: `rodriketu`
- **Senha**: `Overcome2020k`
- **Database**: `youtube_automation`
- **Host**: `localhost`
- **Porta**: `3306`

### 👤 **Usuários do Sistema**

#### **Usuário Principal**
- **Username**: `rodriketu`
- **Password**: `Overcome2020k`
- **Permissões**: Administrador completo
- **Acesso**: Todas as tabelas e operações

#### **Usuário n8n (Compatibilidade)**
- **Username**: `n8n_youtube`
- **Password**: `Overcome2020k`
- **Permissões**: SELECT, INSERT, UPDATE, DELETE
- **Acesso**: Limitado ao banco `youtube_automation`

## 🔧 Configuração Rápida

### 1. **MySQL Local**
```bash
# Conectar ao MySQL
mysql -u rodriketu -p
# Senha: Overcome2020k

# Usar database
USE youtube_automation;
```

### 2. **Aplicação Node.js**
```bash
# Copiar arquivo de produção
cp .env.production .env

# Ou configurar manualmente
echo "DB_USER=rodriketu" >> .env
echo "DB_PASSWORD=Overcome2020k" >> .env
```

### 3. **Docker Compose**
```bash
# As credenciais já estão configuradas
docker-compose up -d
```

## 🐳 Docker Configuration

### **Variáveis de Ambiente**
```yaml
environment:
  - DB_USER=rodriketu
  - DB_PASSWORD=Overcome2020k
  - DB_NAME=youtube_automation
  - MYSQL_ROOT_PASSWORD=Overcome2020k
```

### **Conectar ao MySQL no Container**
```bash
# Conectar ao container MySQL
docker exec -it youtube_mysql mysql -u rodriketu -p
# Senha: Overcome2020k

# Ou como root
docker exec -it youtube_mysql mysql -u root -p
# Senha: Overcome2020k
```

## 🌐 Acessos Web

### **Interface Web**
- **URL**: http://localhost:3000
- **Usuário**: (sem autenticação configurada)

### **n8n Interface**
- **URL**: http://localhost:5678
- **Usuário**: (configuração inicial necessária)

### **API Endpoints**
- **Base URL**: http://localhost:3000/api
- **Autenticação**: (não configurada por padrão)

## 🔒 Segurança

### ⚠️ **Avisos Importantes**
1. **Altere as senhas em produção**
2. **Configure firewall no servidor**
3. **Use HTTPS em produção**
4. **Limite acesso por IP se necessário**
5. **Faça backup regular do banco**

### 🛡️ **Melhorias de Segurança Recomendadas**

#### **1. Alterar Senhas**
```sql
-- Alterar senha do usuário
ALTER USER 'rodriketu'@'%' IDENTIFIED BY 'nova_senha_super_segura';
FLUSH PRIVILEGES;
```

#### **2. Restringir Acesso por IP**
```sql
-- Criar usuário com IP específico
CREATE USER 'rodriketu'@'192.168.1.100' IDENTIFIED BY 'senha_segura';
GRANT ALL PRIVILEGES ON youtube_automation.* TO 'rodriketu'@'192.168.1.100';
```

#### **3. Configurar SSL/TLS**
```bash
# Gerar certificado para MySQL
mysql_ssl_rsa_setup --uid=mysql
```

## 📁 Arquivos de Configuração

### **.env.production** (Produção)
```env
DB_USER=rodriketu
DB_PASSWORD=Overcome2020k
# ... outras configurações
```

### **.env.example** (Template)
```env
DB_USER=rodriketu
DB_PASSWORD=Overcome2020k
# ... outras configurações
```

### **docker-compose.yml**
```yaml
environment:
  - DB_USER=${DB_USER:-rodriketu}
  - DB_PASSWORD=${DB_PASSWORD:-Overcome2020k}
```

## 🚀 Scripts de Inicialização

### **Configuração Automática**
```bash
#!/bin/bash
# setup.sh

# Copiar configurações
cp .env.production .env

# Inicializar banco
mysql -u root -p < setup_mysql.sql

# Iniciar aplicação
npm install
npm start
```

### **Docker Setup**
```bash
#!/bin/bash
# docker-setup.sh

# Construir e iniciar containers
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs
docker-compose logs -f
```

## 🔍 Troubleshooting

### **Erro de Conexão MySQL**
```bash
# Verificar se MySQL está rodando
sudo systemctl status mysql

# Testar conexão
mysql -u rodriketu -p -h localhost
```

### **Erro de Permissão**
```sql
-- Verificar permissões
SHOW GRANTS FOR 'rodriketu'@'%';

-- Re-conceder permissões
GRANT ALL PRIVILEGES ON youtube_automation.* TO 'rodriketu'@'%';
FLUSH PRIVILEGES;
```

### **Reset de Senha**
```sql
-- Como root
ALTER USER 'rodriketu'@'%' IDENTIFIED BY 'nova_senha';
FLUSH PRIVILEGES;
```

---

## 📞 Suporte

Para problemas relacionados às credenciais:
1. Verifique os logs da aplicação
2. Teste a conexão manualmente
3. Confirme as permissões do usuário
4. Verifique a configuração de firewall

---

*🔐 **Lembre-se**: Mantenha essas informações seguras e atualize regularmente as senhas em ambiente de produção.*
