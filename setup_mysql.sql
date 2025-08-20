-- Script de configuração inicial para YouTube Automation com MySQL
-- Execute este script antes de usar o workflow otimizado

-- 1. Criar banco de dados (se não existir)
CREATE DATABASE IF NOT EXISTS youtube_automation 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE youtube_automation;

-- 2. Criar tabela de temas e prompts
CREATE TABLE IF NOT EXISTS youtube_temas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nome do tema (ex: Horror, Comédia, Educativo)',
    descricao TEXT COMMENT 'Descrição do tema',
    prompt_roteiro TEXT NOT NULL COMMENT 'Prompt personalizado para geração do roteiro',
    prompt_imagens TEXT COMMENT 'Prompt base para geração de imagens',
    tags_sugeridas JSON COMMENT 'Tags sugeridas para o YouTube',
    categoria_youtube VARCHAR(20) DEFAULT '22' COMMENT 'Categoria padrão no YouTube',
    ativo BOOLEAN DEFAULT TRUE COMMENT 'Se o tema está ativo para seleção',
    cor_hex VARCHAR(7) DEFAULT '#3498db' COMMENT 'Cor para exibição na interface',
    icone VARCHAR(50) COMMENT 'Nome do ícone para exibição',
    ordem_exibicao INT DEFAULT 0 COMMENT 'Ordem de exibição na lista',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_ativo_ordem (ativo, ordem_exibicao),
    INDEX idx_nome (nome)
) ENGINE=InnoDB 
COMMENT='Temas disponíveis para criação de vídeos com prompts personalizados';

-- 3. Criar tabela principal para armazenamento de arquivos
CREATE TABLE IF NOT EXISTS youtube_files (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id VARCHAR(255) NOT NULL COMMENT 'ID único do projeto/vídeo',
    file_type ENUM(
        'audio_narracao', 
        'imagem', 
        'legenda', 
        'musica', 
        'video_sem_legenda', 
        'video_com_legenda', 
        'video_final', 
        'thumbnail'
    ) NOT NULL COMMENT 'Tipo do arquivo',
    file_name VARCHAR(255) NOT NULL COMMENT 'Nome original do arquivo',
    file_data LONGTEXT NOT NULL COMMENT 'Dados do arquivo em base64',
    mime_type VARCHAR(100) NOT NULL COMMENT 'Tipo MIME do arquivo',
    file_size INT DEFAULT 0 COMMENT 'Tamanho do arquivo em bytes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices para performance
    INDEX idx_project_type (project_id, file_type),
    INDEX idx_project_created (project_id, created_at),
    INDEX idx_file_type (file_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB 
COMMENT='Armazenamento de arquivos do processo de criação de vídeos YouTube';

-- 4. Criar tabela de metadados dos projetos
CREATE TABLE IF NOT EXISTS youtube_projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id VARCHAR(255) UNIQUE NOT NULL,
    tema_id INT COMMENT 'ID do tema selecionado',
    title VARCHAR(500) DEFAULT NULL COMMENT 'Título do vídeo',
    description TEXT DEFAULT NULL COMMENT 'Descrição do vídeo',
    tags JSON DEFAULT NULL COMMENT 'Tags do vídeo',
    status ENUM('iniciado', 'processando', 'concluido', 'erro', 'publicado') DEFAULT 'iniciado',
    youtube_video_id VARCHAR(100) DEFAULT NULL COMMENT 'ID do vídeo no YouTube após upload',
    error_message TEXT DEFAULT NULL COMMENT 'Mensagem de erro se houver',
    processing_time INT DEFAULT 0 COMMENT 'Tempo total de processamento em segundos',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_youtube_id (youtube_video_id),
    INDEX idx_tema (tema_id),
    FOREIGN KEY (tema_id) REFERENCES youtube_temas(id) ON DELETE SET NULL
) ENGINE=InnoDB 
COMMENT='Metadados e controle dos projetos de vídeo';

-- 4. Criar tabela de logs do processo
CREATE TABLE IF NOT EXISTS youtube_process_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id VARCHAR(255) NOT NULL,
    step_name VARCHAR(100) NOT NULL COMMENT 'Nome da etapa do processo',
    status ENUM('iniciado', 'concluido', 'erro') NOT NULL,
    message TEXT DEFAULT NULL COMMENT 'Mensagem ou detalhes do passo',
    execution_time DECIMAL(10,3) DEFAULT NULL COMMENT 'Tempo de execução em segundos',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_project_step (project_id, step_name),
    INDEX idx_project_created (project_id, created_at),
    INDEX idx_status (status),
    FOREIGN KEY (project_id) REFERENCES youtube_projects(project_id) ON DELETE CASCADE
) ENGINE=InnoDB 
COMMENT='Logs detalhados do processo de criação';

-- 5. Criar view para estatísticas rápidas
CREATE OR REPLACE VIEW youtube_stats AS
SELECT 
    DATE(created_at) as data,
    COUNT(*) as total_projetos,
    SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) as concluidos,
    SUM(CASE WHEN status = 'erro' THEN 1 ELSE 0 END) as com_erro,
    SUM(CASE WHEN status = 'publicado' THEN 1 ELSE 0 END) as publicados,
    AVG(processing_time) as tempo_medio_processamento
FROM youtube_projects 
GROUP BY DATE(created_at)
ORDER BY data DESC;

-- 6. Criar procedimento para limpeza automática
DELIMITER $$

CREATE PROCEDURE CleanOldFiles(IN days_old INT DEFAULT 7)
BEGIN
    DECLARE deleted_count INT DEFAULT 0;
    
    -- Conta arquivos que serão deletados
    SELECT COUNT(*) INTO deleted_count
    FROM youtube_files 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL days_old DAY);
    
    -- Remove arquivos antigos
    DELETE FROM youtube_files 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL days_old DAY);
    
    -- Remove projetos órfãos (sem arquivos)
    DELETE p FROM youtube_projects p
    LEFT JOIN youtube_files f ON p.project_id = f.project_id
    WHERE f.project_id IS NULL 
    AND p.created_at < DATE_SUB(NOW(), INTERVAL days_old DAY);
    
    -- Log da limpeza
    INSERT INTO youtube_process_logs (project_id, step_name, status, message)
    VALUES ('SYSTEM', 'cleanup', 'concluido', CONCAT('Removidos ', deleted_count, ' arquivos com mais de ', days_old, ' dias'));
    
END$$

DELIMITER ;

-- 7. Criar evento para limpeza automática (executa diariamente às 02:00)
CREATE EVENT IF NOT EXISTS daily_cleanup
ON SCHEDULE EVERY 1 DAY STARTS '2025-01-01 02:00:00'
DO CALL CleanOldFiles(7);

-- 8. Configurações recomendadas do MySQL
SET GLOBAL max_allowed_packet = 1073741824; -- 1GB
SET GLOBAL innodb_buffer_pool_size = 2147483648; -- 2GB (ajuste conforme sua RAM)
SET GLOBAL innodb_log_file_size = 268435456; -- 256MB

-- 9. Criar usuário específico para o sistema
CREATE USER 'rodriketu'@'%' IDENTIFIED BY 'Overcome2020k';
GRANT ALL PRIVILEGES ON youtube_automation.* TO 'rodriketu'@'%';
FLUSH PRIVILEGES;

-- Também criar usuário para n8n (compatibilidade)
CREATE USER 'n8n_youtube'@'%' IDENTIFIED BY 'Overcome2020k';
GRANT SELECT, INSERT, UPDATE, DELETE ON youtube_automation.* TO 'n8n_youtube'@'%';
FLUSH PRIVILEGES;

-- 10. Inserir temas padrão
INSERT INTO youtube_temas (nome, descricao, prompt_roteiro, prompt_imagens, tags_sugeridas, categoria_youtube, cor_hex, icone, ordem_exibicao) VALUES
('Horror Extraterrestre', 
 'Histórias de terror envolvendo alienígenas e abdução', 
 'Crie um roteiro de horror extraterrestre de 2-3 minutos. A história deve ser envolvente, assustadora e incluir elementos como: avistamentos UFO, abdução alienígena, experimentos extraterrestres, ou invasão. Use linguagem narrativa cativante, crie suspense crescente e termine com um clímax impactante. O roteiro deve ser adequado para narração em vídeo.',
 'alien horror, UFO sighting, extraterrestrial encounter, dark sci-fi, mysterious lights in sky, alien abduction scene',
 '["horror", "extraterrestre", "alien", "ufo", "terror", "misterio", "abdução"]',
 '22', '#8B0000', 'alien', 1),

('Mistérios Históricos', 
 'Enigmas e segredos não resolvidos da história',
 'Crie um roteiro sobre um mistério histórico fascinante de 2-3 minutos. Escolha um enigma real não resolvido (pirâmides, civilizações perdidas, artefatos misteriosos, etc.). Apresente os fatos conhecidos, teorias principais e deixe o espectador intrigado. Use linguagem educativa mas envolvente, cite fontes quando relevante.',
 'ancient mysteries, historical artifacts, archaeological discoveries, ancient civilizations, mysterious ruins',
 '["historia", "misterio", "arqueologia", "civilizacao", "enigma", "descoberta"]',
 '27', '#DAA520', 'scroll', 2),

('Ciência e Tecnologia',
 'Descobertas científicas e avanços tecnológicos',
 'Crie um roteiro educativo sobre ciência ou tecnologia de 2-3 minutos. Explique um conceito científico complexo de forma simples, uma descoberta recente, ou uma tecnologia emergente. Use analogias e exemplos práticos. O conteúdo deve ser preciso, atual e acessível ao público geral.',
 'futuristic technology, scientific laboratory, space exploration, AI concepts, molecular structures, innovation',
 '["ciencia", "tecnologia", "descoberta", "inovacao", "pesquisa", "futuro"]',
 '28', '#4169E1', 'atom', 3),

('Biografias Inspiradoras',
 'Histórias de vida de pessoas extraordinárias',
 'Crie um roteiro biográfico inspirador de 2-3 minutos sobre uma personalidade histórica ou contemporânea. Foque nos desafios superados, conquistas importantes e lições de vida. A narrativa deve motivar e inspirar o espectador, destacando momentos decisivos da trajetória da pessoa.',
 'inspirational portrait, historical figure, success story, overcoming challenges, achievement moment',
 '["biografia", "inspiracao", "sucesso", "superacao", "historia", "motivacao"]',
 '22', '#228B22', 'user-circle', 4),

('Curiosidades do Mundo',
 'Fatos interessantes e curiosos sobre nosso planeta',
 'Crie um roteiro sobre curiosidades fascinantes do mundo de 2-3 minutos. Inclua fatos surpreendentes sobre geografia, natureza, culturas, animais ou fenômenos naturais. Use dados verificados e apresente de forma divertida e educativa.',
 'amazing nature phenomena, world landmarks, exotic animals, cultural diversity, natural wonders',
 '["curiosidades", "mundo", "fatos", "natureza", "geografia", "interessante"]',
 '27', '#FF6347', 'globe', 5),

('Desenvolvimento Pessoal',
 'Dicas e estratégias para crescimento pessoal',
 'Crie um roteiro motivacional sobre desenvolvimento pessoal de 2-3 minutos. Aborde temas como produtividade, mindset, hábitos, metas ou autoconhecimento. Ofereça dicas práticas e acionáveis. O conteúdo deve ser inspirador e útil para a vida do espectador.',
 'personal growth, motivation concepts, success mindset, goal achievement, self-improvement',
 '["desenvolvimento", "motivacao", "produtividade", "habitos", "sucesso", "crescimento"]',
 '26', '#9370DB', 'trending-up', 6),

('Assombração Alienígena',
 'Terror cósmico com encontros extraterrestres brasileiros',
 'Crie um roteiro de horror cósmico baseado em um encontro alienígena de 2-3 minutos. A história deve ser arrepiante e envolvente, com elementos como: avistamentos UFO, experimentos extraterrestres, ou fenômenos inexplicáveis em locais reais do Brasil. Use tensão atmosférica crescente, foque no terror psicológico e termine com um clímax perturbador. O roteiro deve ter entre 2300-2400 caracteres.',
 'alien horror Brazil, UFO encounter, cosmic terror, extraterrestrial mystery, Brazilian UFO sightings, paranormal activity',
 '["alien", "ufo", "terror", "misterio", "assombracao", "horror", "extraterrestre", "suspense", "brasil"]',
 '22', '#4B0082', 'alien', 7);

-- 11. Inserir dados de exemplo/teste
INSERT INTO youtube_projects (project_id, title, description, status) VALUES
('teste_projeto_' || UNIX_TIMESTAMP(), 'Vídeo de Teste', 'Descrição do vídeo de teste', 'iniciado'),
('assombracao_alien_exemplo', 'ASSOMBRAÇÃO ALIEN: O MISTÉRIO DO FAROL NA ILHA DO MEL...', 'Você acredita em vida extraterrestre? Esta é uma história real de um encontro arrepiante que transformou a Ilha do Mel em um palco de puro terror. Testemunhas ficaram sem palavras diante do inexplicável. Este realmente aconteceu... Prepare-se para o mistério e a assombração que vem do desconhecido.', 'exemplo');

-- Verificar se tudo foi criado corretamente
SHOW TABLES;
SELECT 'Setup concluído com sucesso!' as status;

-- Mostrar estatísticas das tabelas criadas
SELECT 
    TABLE_NAME as 'Tabela',
    TABLE_ROWS as 'Linhas',
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) as 'Tamanho (MB)',
    TABLE_COMMENT as 'Descrição'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'youtube_automation' 
AND TABLE_TYPE = 'BASE TABLE';
