-- 🎬 Exemplos Adicionais de Temas para YouTube Automation
-- Execute este arquivo após o setup_mysql.sql para adicionar mais temas

USE youtube_automation;

-- Inserir temas adicionais populares
INSERT INTO youtube_temas (nome, descricao, prompt_roteiro, prompt_imagens, tags_sugeridas, categoria_youtube, cor_hex, icone, ordem_exibicao) VALUES

-- Temas de Entretenimento
('Contos de Terror Urbano',
 'Lendas urbanas e histórias de terror da cidade',
 'Crie um roteiro de terror urbano de 2-3 minutos baseado em lendas urbanas brasileiras. A história deve ser ambientada em um local urbano real (metrô, prédio abandonado, cemitério, etc.). Use elementos do folclore urbano moderno, crie suspense crescente e termine com um final impactante. A narrativa deve soar realista e próxima da realidade dos espectadores.',
 'urban legend, creepy city night, abandoned building, subway horror, cemetery mystery, urban folklore',
 '["terror", "urbano", "lenda", "misterio", "assombrado", "cidade", "medo"]',
 '22', '#800020', 'building', 8),

('Vida Selvagem Extrema',
 'Animais perigosos e fenômenos da natureza',
 'Crie um roteiro sobre vida selvagem extrema de 2-3 minutos. Aborde animais perigosos, comportamentos inusitados da fauna, ou fenômenos naturais impressionantes. Use dados científicos reais, apresente de forma educativa mas emocionante. Inclua curiosidades que surpreendam o espectador.',
 'dangerous wildlife, extreme nature, predator animals, natural phenomena, wildlife documentary style',
 '["animais", "selvagem", "natureza", "perigoso", "selvagem", "documentario"]',
 '27', '#228B22', 'leaf', 9),

-- Temas Educativos
('Experimentos Científicos',
 'Ciência de forma divertida e experimental',
 'Crie um roteiro sobre um experimento científico interessante de 2-3 minutos. Explique a ciência por trás de forma simples, mostre aplicações práticas e desperte curiosidade. O experimento deve ser seguro e idealmente reproduzível. Use linguagem acessível e entusiasta.',
 'science experiment, laboratory setup, chemical reactions, physics demonstration, educational content',
 '["ciencia", "experimento", "educativo", "fisica", "quimica", "aprendizado"]',
 '27', '#4169E1', 'flask', 10),

('Tecnologia do Futuro',
 'Inovações que vão mudar o mundo',
 'Crie um roteiro sobre uma tecnologia futurista de 2-3 minutos. Explique como ela funciona, suas possíveis aplicações e impacto na sociedade. Base-se em pesquisas reais e projeções científicas. Apresente de forma otimista mas realista sobre o futuro da humanidade.',
 'futuristic technology, AI concepts, robotics, space technology, innovation lab, digital transformation',
 '["tecnologia", "futuro", "inovacao", "ia", "robotica", "digital"]',
 '28', '#00CED1', 'cpu', 11),

-- Temas de Lifestyle
('Psicologia do Sucesso',
 'Mentalidade e estratégias de pessoas bem-sucedidas',
 'Crie um roteiro sobre psicologia do sucesso de 2-3 minutos. Aborde mindset, hábitos mentais, superação de obstáculos ou estratégias psicológicas de pessoas de sucesso. Base-se em estudos psicológicos reais e ofereça insights práticos aplicáveis na vida cotidiana.',
 'success mindset, psychology concepts, mental health, personal development, achievement goals',
 '["psicologia", "sucesso", "mindset", "mentalidade", "crescimento", "motivacao"]',
 '26', '#FF6347', 'brain', 12),

('Mistérios do Espaço',
 'Fenômenos cósmicos e descobertas espaciais',
 'Crie um roteiro sobre mistérios do espaço de 2-3 minutos. Aborde buracos negros, exoplanetas, fenômenos cósmicos inexplicados ou descobertas recentes da astronomia. Use dados científicos reais da NASA e outras agências espaciais. Desperte a curiosidade sobre o cosmos.',
 'space mysteries, cosmic phenomena, black holes, exoplanets, space exploration, astronomical discoveries',
 '["espaco", "astronomia", "cosmos", "planetas", "universo", "nasa"]',
 '27', '#4B0082', 'star', 13),

-- Temas de Curiosidades
('Civilizações Perdidas',
 'Culturas antigas e seus mistérios',
 'Crie um roteiro sobre uma civilização perdida de 2-3 minutos. Explore culturas antigas, suas conquistas, mistérios não resolvidos e teorias sobre seu desaparecimento. Use evidências arqueológicas reais e apresente diferentes teorias científicas. Mantenha o tom educativo mas envolvente.',
 'ancient civilizations, archaeological ruins, lost cultures, historical mysteries, ancient artifacts',
 '["civilizacao", "antiga", "arqueologia", "historia", "perdida", "misterio"]',
 '27', '#CD853F', 'monument', 14),

('Fenômenos Paranormais',
 'Investigação de eventos inexplicados',
 'Crie um roteiro sobre um fenômeno paranormal de 2-3 minutos. Apresente casos reais investigados, evidências disponíveis e diferentes explicações (científicas e paranormais). Mantenha o ceticismo científico enquanto explora o mistério. Deixe o espectador formar sua própria opinião.',
 'paranormal investigation, unexplained phenomena, ghost encounters, supernatural events, mystery investigation',
 '["paranormal", "misterio", "fantasma", "sobrenatural", "inexplicado", "investigacao"]',
 '22', '#483D8B', 'ghost', 15),

-- Temas de Saúde e Bem-estar
('Neurociência Aplicada',
 'Como o cérebro funciona no dia a dia',
 'Crie um roteiro sobre neurociência aplicada de 2-3 minutos. Explique como o cérebro funciona em situações cotidianas, hábitos neurológicos, plasticidade cerebral ou descobertas recentes. Use linguagem acessível e ofereça insights práticos sobre como otimizar o funcionamento mental.',
 'brain science, neuroscience research, cognitive function, neural networks, brain health',
 '["neurociencia", "cerebro", "mente", "cognicao", "neurologia", "saude"]',
 '27', '#FF1493', 'brain-circuit', 16),

('Longevidade e Saúde',
 'Segredos para uma vida longa e saudável',
 'Crie um roteiro sobre longevidade e saúde de 2-3 minutos. Aborde hábitos de populações centenárias, descobertas científicas sobre envelhecimento, ou práticas comprovadas para aumentar a longevidade. Base-se em estudos científicos reais e ofereça dicas práticas aplicáveis.',
 'healthy aging, longevity research, wellness lifestyle, health science, nutrition science',
 '["longevidade", "saude", "envelhecimento", "wellness", "habitos", "vida"]',
 '26', '#32CD32', 'heart', 17);

-- Adicionar alguns exemplos de projetos para cada tema
INSERT INTO youtube_projects (project_id, title, description, status, tema_id) VALUES
('exemplo_terror_urbano', 'A MULHER DE BRANCO DO METRÔ...', 'Uma lenda urbana aterrorizante que acontece nas estações de metrô. Você já viu algo estranho no transporte público?', 'exemplo', 
 (SELECT tema_id FROM youtube_temas WHERE nome = 'Contos de Terror Urbano')),

('exemplo_vida_selvagem', 'O PREDADOR MAIS MORTAL DA AMAZÔNIA...', 'Conheça o animal mais perigoso da floresta amazônica e como ele caça suas presas de forma surpreendente.', 'exemplo',
 (SELECT tema_id FROM youtube_temas WHERE nome = 'Vida Selvagem Extrema')),

('exemplo_experimento', 'EXPERIÊNCIA QUE DESAFIA A GRAVIDADE...', 'Um experimento simples que vai fazer você questionar tudo que sabe sobre física!', 'exemplo',
 (SELECT tema_id FROM youtube_temas WHERE nome = 'Experimentos Científicos'));

-- Mostrar estatísticas dos temas inseridos
SELECT 
    COUNT(*) as 'Total de Temas',
    AVG(LENGTH(prompt_roteiro)) as 'Tamanho Médio do Prompt',
    COUNT(DISTINCT categoria_youtube) as 'Categorias Diferentes'
FROM youtube_temas;

SELECT 'Temas adicionais inseridos com sucesso!' as status;
