# 📱 Web Interface

Este diretório contém todas as páginas HTML da interface web do YouTube Automation System.

## 📁 Páginas

### 🏠 **interface_selecao_temas.html**
- **Rota**: `/` (http://localhost:3000)
- **Função**: Página inicial para seleção de temas
- **Recursos**: 
  - Grid de temas visuais
  - Navegação entre páginas
  - Design responsivo
  - Integração com API

### 📊 **stats_dashboard.html**  
- **Rota**: `/stats` (http://localhost:3000/stats)
- **Função**: Dashboard de estatísticas em tempo real
- **Recursos**:
  - Gráficos interativos
  - Auto-refresh (30s)
  - Métricas por tema
  - Monitoramento de erros

### 📡 **api_documentation.html**
- **Rota**: `/api-docs` (http://localhost:3000/api-docs)  
- **Função**: Documentação completa da API
- **Recursos**:
  - Endpoints detalhados
  - Exemplos de código
  - Download Postman Collection
  - Códigos de status HTTP

## 🎨 Design System

Todas as páginas seguem o mesmo design system:

- **Cores**: Gradiente roxo/azul (`#667eea` → `#764ba2`)
- **Fonte**: Segoe UI, sistema padrão
- **Efeitos**: Glassmorphism, sombras suaves
- **Responsivo**: Mobile-first design
- **Navegação**: Menu unificado entre páginas

## 🔧 Tecnologias

- **HTML5** - Estrutura semântica
- **CSS3** - Estilos modernos (Grid, Flexbox, Gradients)
- **JavaScript** - Interatividade e API calls
- **Chart.js** - Gráficos interativos (dashboard)
- **Fetch API** - Comunicação com backend

## 🚀 Servidor

As páginas são servidas pelo `api_server.js` através das rotas:

```javascript
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'web', 'interface_selecao_temas.html'));
});

app.get('/stats', (req, res) => {
    res.sendFile(path.join(__dirname, 'web', 'stats_dashboard.html'));
});

app.get('/api-docs', (req, res) => {
    res.sendFile(path.join(__dirname, 'web', 'api_documentation.html'));
});
```

## 📱 Responsividade

Todas as páginas são otimizadas para:
- 📱 **Mobile** (320px+)
- 📺 **Tablet** (768px+)  
- 🖥️ **Desktop** (1024px+)
- 🖥️ **Large Desktop** (1400px+)

## 🔗 Navegação

Menu unificado presente em todas as páginas:
- 🏠 **Início** → `/`
- 📊 **Dashboard** → `/stats`
- 📡 **API Docs** → `/api-docs`  
- ⚙️ **n8n** → `http://localhost:5678` (nova aba)

---

**Interface moderna e profissional para o YouTube Automation System!** ✨
