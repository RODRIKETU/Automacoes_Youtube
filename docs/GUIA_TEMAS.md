# 🎨 Guia de Temas - YouTube Automation

## 📋 Sobre os Temas

Os temas são o coração do sistema de automação. Cada tema define:
- **Prompt para roteiro**: Como a IA deve criar o conteúdo
- **Prompt para imagens**: Que tipo de visual gerar
- **Tags sugeridas**: Para otimização SEO no YouTube
- **Categoria do YouTube**: Para classificação automática
- **Aparência**: Cores e ícones da interface

## 🎯 Temas Pré-instalados

### 🎬 **Terror & Mistério**
| Tema | Descrição | Cor |
|------|-----------|-----|
| Horror Extraterrestre | Histórias de terror com alienígenas | ![#8B0000](https://via.placeholder.com/15/8B0000/000000?text=+) Vermelho Escuro |
| Assombração Alienígena | Terror cósmico brasileiro | ![#4B0082](https://via.placeholder.com/15/4B0082/000000?text=+) Índigo |
| Contos de Terror Urbano | Lendas urbanas da cidade | ![#800020](https://via.placeholder.com/15/800020/000000?text=+) Bordô |
| Fenômenos Paranormais | Eventos inexplicados | ![#483D8B](https://via.placeholder.com/15/483D8B/000000?text=+) Azul Escuro |

### 📚 **Educação & Ciência**
| Tema | Descrição | Cor |
|------|-----------|-----|
| Mistérios Históricos | Enigmas do passado | ![#DAA520](https://via.placeholder.com/15/DAA520/000000?text=+) Dourado |
| Ciência e Tecnologia | Descobertas científicas | ![#4169E1](https://via.placeholder.com/15/4169E1/000000?text=+) Azul Real |
| Experimentos Científicos | Ciência experimental | ![#4169E1](https://via.placeholder.com/15/4169E1/000000?text=+) Azul Real |
| Tecnologia do Futuro | Inovações futuristas | ![#00CED1](https://via.placeholder.com/15/00CED1/000000?text=+) Turquesa |
| Mistérios do Espaço | Astronomia e cosmos | ![#4B0082](https://via.placeholder.com/15/4B0082/000000?text=+) Índigo |
| Neurociência Aplicada | Funcionamento do cérebro | ![#FF1493](https://via.placeholder.com/15/FF1493/000000?text=+) Rosa Intenso |
| Civilizações Perdidas | Culturas antigas | ![#CD853F](https://via.placeholder.com/15/CD853F/000000?text=+) Peru |

### 🌟 **Desenvolvimento & Lifestyle**
| Tema | Descrição | Cor |
|------|-----------|-----|
| Biografias Inspiradoras | Histórias de sucesso | ![#228B22](https://via.placeholder.com/15/228B22/000000?text=+) Verde Floresta |
| Desenvolvimento Pessoal | Crescimento pessoal | ![#9370DB](https://via.placeholder.com/15/9370DB/000000?text=+) Violeta |
| Psicologia do Sucesso | Mindset vencedor | ![#FF6347](https://via.placeholder.com/15/FF6347/000000?text=+) Tomate |
| Longevidade e Saúde | Vida saudável | ![#32CD32](https://via.placeholder.com/15/32CD32/000000?text=+) Verde Lima |

### 🌍 **Natureza & Curiosidades**
| Tema | Descrição | Cor |
|------|-----------|-----|
| Curiosidades do Mundo | Fatos interessantes | ![#FF6347](https://via.placeholder.com/15/FF6347/000000?text=+) Tomate |
| Vida Selvagem Extrema | Animais e natureza | ![#228B22](https://via.placeholder.com/15/228B22/000000?text=+) Verde Floresta |

## ➕ Como Adicionar Novos Temas

### 1. **Via Banco de Dados**

```sql
INSERT INTO youtube_temas (
    nome, 
    descricao, 
    prompt_roteiro, 
    prompt_imagens, 
    tags_sugeridas, 
    categoria_youtube, 
    cor_hex, 
    icone, 
    ordem_exibicao
) VALUES (
    'Seu Tema',
    'Descrição do tema',
    'Prompt detalhado para criação do roteiro...',
    'prompt, para, imagens',
    '[\"tag1\", \"tag2\", \"tag3\"]',
    '22',
    '#FF0000',
    'icon-name',
    18
);
```

### 2. **Via Arquivo SQL**

Execute o arquivo `temas_adicionais.sql` para adicionar mais temas:

```bash
mysql -u root -p youtube_automation < temas_adicionais.sql
```

### 3. **Parâmetros Explicados**

| Campo | Descrição | Exemplo |
|-------|-----------|---------|
| `nome` | Nome do tema (máx 100 chars) | "Horror Extraterrestre" |
| `descricao` | Breve descrição (máx 255 chars) | "Histórias de terror com alienígenas" |
| `prompt_roteiro` | Instruções detalhadas para IA | "Crie um roteiro de horror..." |
| `prompt_imagens` | Keywords para geração de imagens | "alien, ufo, dark sci-fi" |
| `tags_sugeridas` | Array JSON de tags | `[\"horror\", \"alien\"]` |
| `categoria_youtube` | ID da categoria do YouTube | `22` (Entretenimento) |
| `cor_hex` | Cor hexadecimal do tema | "#8B0000" |
| `icone` | Nome do ícone (Font Awesome) | "alien" |
| `ordem_exibicao` | Ordem na interface | 1, 2, 3... |

## 🎨 Categorias do YouTube

| ID | Categoria |
|----|-----------|
| 1 | Film & Animation |
| 2 | Autos & Vehicles |
| 10 | Music |
| 15 | Pets & Animals |
| 17 | Sports |
| 19 | Travel & Events |
| 20 | Gaming |
| 22 | People & Blogs |
| 23 | Comedy |
| 24 | Entertainment |
| 25 | News & Politics |
| 26 | Howto & Style |
| 27 | Education |
| 28 | Science & Technology |
| 29 | Nonprofits & Activism |

## 🎭 Ícones Disponíveis

Usando Font Awesome:
- `alien` - 👽 Para temas extraterrestres
- `brain` - 🧠 Para neurociência/psicologia
- `flask` - 🧪 Para experimentos
- `star` - ⭐ Para espaço/astronomia
- `ghost` - 👻 Para paranormal
- `heart` - ❤️ Para saúde
- `globe` - 🌍 Para geografia/mundo
- `user-circle` - 👤 Para biografias
- `trending-up` - 📈 Para desenvolvimento
- `monument` - 🏛️ Para história
- `cpu` - 💻 Para tecnologia
- `leaf` - 🍃 Para natureza

## 📝 Dicas para Prompts Efetivos

### **Prompt de Roteiro**
```
Crie um roteiro [tipo] de 2-3 minutos sobre [tema]. 
A história deve ser [características específicas].
Use [estilo de linguagem] e termine com [tipo de final].
O roteiro deve ter entre 2300-2400 caracteres.
```

### **Prompt de Imagens**
```
[tema principal], [estilo visual], [atmosfera], 
[elementos específicos], [qualidade da imagem]
```

## 🔄 Exemplo Completo

```sql
INSERT INTO youtube_temas (
    nome, descricao, prompt_roteiro, prompt_imagens, 
    tags_sugeridas, categoria_youtube, cor_hex, icone, ordem_exibicao
) VALUES (
    'Gastronomia Molecular',
    'Ciência aplicada à culinária moderna',
    'Crie um roteiro educativo sobre gastronomia molecular de 2-3 minutos. Explique como a ciência transforma ingredientes simples em pratos extraordinários. Use exemplos de técnicas como esferificação, gelificação ou espumas. O conteúdo deve ser educativo mas saboroso, despertando curiosidade gastronômica.',
    'molecular gastronomy, fine dining, culinary science, modern cooking techniques, food art, laboratory kitchen',
    '["gastronomia", "culinaria", "ciencia", "molecular", "chef", "inovacao"]',
    '26',
    '#FF4500',
    'utensils',
    19
);
```

## 🚀 Testando Novos Temas

1. **Adicione o tema no banco**
2. **Reinicie a API** (`npm restart`)
3. **Acesse a interface web**
4. **Teste a geração de conteúdo**
5. **Ajuste o prompt se necessário**

---

*💡 **Dica Pro**: Mantenha prompts entre 150-300 palavras para melhor performance da IA*
