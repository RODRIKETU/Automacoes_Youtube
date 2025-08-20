# Queries Úteis - YouTube Automation MySQL

## Monitoramento e Estatísticas

### 1. **Verificar Status dos Projetos**
```sql
-- Projetos em andamento
SELECT project_id, title, status, created_at, updated_at
FROM youtube_projects 
WHERE status IN ('iniciado', 'processando')
ORDER BY created_at DESC;

-- Estatísticas gerais
SELECT 
    status,
    COUNT(*) as quantidade,
    AVG(processing_time) as tempo_medio_seg
FROM youtube_projects 
GROUP BY status;
```

### 2. **Analisar Uso de Armazenamento**
```sql
-- Tamanho total por tipo de arquivo
SELECT 
    file_type,
    COUNT(*) as quantidade_arquivos,
    SUM(LENGTH(file_data) * 3/4) as tamanho_bytes_aprox,
    ROUND(SUM(LENGTH(file_data) * 3/4) / 1024 / 1024, 2) as tamanho_mb
FROM youtube_files 
GROUP BY file_type
ORDER BY tamanho_bytes_aprox DESC;

-- Projetos que mais consomem espaço
SELECT 
    f.project_id,
    p.title,
    COUNT(f.id) as total_arquivos,
    ROUND(SUM(LENGTH(f.file_data) * 3/4) / 1024 / 1024, 2) as tamanho_mb
FROM youtube_files f
LEFT JOIN youtube_projects p ON f.project_id = p.project_id
GROUP BY f.project_id, p.title
ORDER BY tamanho_mb DESC
LIMIT 10;
```

### 3. **Monitorar Performance**
```sql
-- Tempos de processamento por etapa
SELECT 
    step_name,
    COUNT(*) as execucoes,
    AVG(execution_time) as tempo_medio,
    MIN(execution_time) as tempo_minimo,
    MAX(execution_time) as tempo_maximo
FROM youtube_process_logs 
WHERE status = 'concluido'
GROUP BY step_name
ORDER BY tempo_medio DESC;

-- Projetos com problemas
SELECT 
    l.project_id,
    p.title,
    l.step_name,
    l.message,
    l.created_at
FROM youtube_process_logs l
LEFT JOIN youtube_projects p ON l.project_id = p.project_id
WHERE l.status = 'erro'
ORDER BY l.created_at DESC
LIMIT 20;
```

### 4. **Limpeza e Manutenção**
```sql
-- Verificar arquivos órfãos (sem projeto)
SELECT 
    f.project_id,
    COUNT(*) as arquivos_orfaos
FROM youtube_files f
LEFT JOIN youtube_projects p ON f.project_id = p.project_id
WHERE p.project_id IS NULL
GROUP BY f.project_id;

-- Remover arquivos órfãos antigos
DELETE f FROM youtube_files f
LEFT JOIN youtube_projects p ON f.project_id = p.project_id
WHERE p.project_id IS NULL 
AND f.created_at < DATE_SUB(NOW(), INTERVAL 1 DAY);

-- Verificar projetos incompletos (iniciados há mais de 2 horas)
SELECT 
    project_id,
    title,
    status,
    created_at,
    TIMESTAMPDIFF(MINUTE, created_at, NOW()) as minutos_desde_inicio
FROM youtube_projects 
WHERE status IN ('iniciado', 'processando')
AND created_at < DATE_SUB(NOW(), INTERVAL 2 HOUR);
```

### 5. **Relatórios de Produtividade**
```sql
-- Vídeos criados por dia (últimos 30 dias)
SELECT 
    DATE(created_at) as data,
    COUNT(*) as videos_criados,
    SUM(CASE WHEN status = 'publicado' THEN 1 ELSE 0 END) as videos_publicados
FROM youtube_projects 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY data DESC;

-- Estatísticas por hora do dia
SELECT 
    HOUR(created_at) as hora,
    COUNT(*) as projetos_iniciados,
    AVG(processing_time) as tempo_medio_processamento
FROM youtube_projects 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY HOUR(created_at)
ORDER BY hora;
```

### 6. **Backup e Recuperação**
```sql
-- Backup de um projeto específico
SELECT 
    'youtube_files' as tabela,
    f.*
FROM youtube_files f
WHERE f.project_id = 'SEU_PROJECT_ID'
UNION ALL
SELECT 
    'youtube_projects' as tabela,
    p.id, p.project_id, p.title, p.description, p.tags, 
    p.status, p.youtube_video_id, p.error_message, 
    p.processing_time, p.created_at, p.updated_at
FROM youtube_projects p
WHERE p.project_id = 'SEU_PROJECT_ID';

-- Recuperar arquivo específico em base64
SELECT file_data 
FROM youtube_files 
WHERE project_id = 'SEU_PROJECT_ID' 
AND file_type = 'video_final' 
LIMIT 1;
```

### 7. **Otimização e Índices**
```sql
-- Verificar uso dos índices
EXPLAIN SELECT * FROM youtube_files 
WHERE project_id = 'teste' AND file_type = 'video_final';

-- Analisar fragmentação das tabelas
SELECT 
    TABLE_NAME,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) as 'Tamanho_MB',
    TABLE_ROWS,
    ROUND((DATA_FREE / 1024 / 1024), 2) as 'Espaco_Livre_MB'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'youtube_automation';

-- Otimizar tabelas (execute esporadicamente)
OPTIMIZE TABLE youtube_files, youtube_projects, youtube_process_logs;
```

### 8. **Alertas e Monitoramento**
```sql
-- Projetos travados (iniciados há mais de 6 horas)
SELECT 
    project_id,
    title,
    status,
    TIMESTAMPDIFF(HOUR, created_at, NOW()) as horas_travado
FROM youtube_projects 
WHERE status IN ('iniciado', 'processando')
AND created_at < DATE_SUB(NOW(), INTERVAL 6 HOUR);

-- Crescimento do banco nos últimos 7 dias
SELECT 
    DATE(created_at) as data,
    COUNT(*) as novos_arquivos,
    ROUND(SUM(LENGTH(file_data) * 3/4) / 1024 / 1024, 2) as mb_adicionados
FROM youtube_files 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY DATE(created_at)
ORDER BY data DESC;

-- Taxa de sucesso por dia
SELECT 
    DATE(created_at) as data,
    COUNT(*) as total_projetos,
    SUM(CASE WHEN status = 'publicado' THEN 1 ELSE 0 END) as publicados,
    ROUND((SUM(CASE WHEN status = 'publicado' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as taxa_sucesso_pct
FROM youtube_projects 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY data DESC;
```

## Procedures Úteis

### **Procedure para Status Completo de um Projeto**
```sql
DELIMITER $$

CREATE PROCEDURE GetProjectStatus(IN proj_id VARCHAR(255))
BEGIN
    -- Informações do projeto
    SELECT 'PROJETO' as tipo, p.*
    FROM youtube_projects p
    WHERE p.project_id = proj_id;
    
    -- Arquivos do projeto
    SELECT 'ARQUIVOS' as tipo, 
           file_type, 
           file_name, 
           ROUND(LENGTH(file_data) * 3/4 / 1024, 2) as tamanho_kb,
           created_at
    FROM youtube_files 
    WHERE project_id = proj_id
    ORDER BY created_at;
    
    -- Logs do projeto
    SELECT 'LOGS' as tipo, 
           step_name, 
           status, 
           message, 
           execution_time,
           created_at
    FROM youtube_process_logs 
    WHERE project_id = proj_id
    ORDER BY created_at;
END$$

DELIMITER ;

-- Uso: CALL GetProjectStatus('seu_project_id');
```

### **Procedure para Limpeza Inteligente**
```sql
DELIMITER $$

CREATE PROCEDURE SmartCleanup()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE proj_id VARCHAR(255);
    DECLARE proj_status VARCHAR(50);
    DECLARE proj_age_hours INT;
    
    DECLARE cleanup_cursor CURSOR FOR
        SELECT project_id, status, TIMESTAMPDIFF(HOUR, created_at, NOW()) as age_hours
        FROM youtube_projects
        WHERE (status = 'erro' AND created_at < DATE_SUB(NOW(), INTERVAL 1 DAY))
           OR (status IN ('iniciado', 'processando') AND created_at < DATE_SUB(NOW(), INTERVAL 6 HOUR))
           OR (status = 'publicado' AND created_at < DATE_SUB(NOW(), INTERVAL 30 DAY));
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cleanup_cursor;
    
    cleanup_loop: LOOP
        FETCH cleanup_cursor INTO proj_id, proj_status, proj_age_hours;
        
        IF done THEN
            LEAVE cleanup_loop;
        END IF;
        
        -- Remove arquivos do projeto
        DELETE FROM youtube_files WHERE project_id = proj_id;
        
        -- Atualiza status do projeto para limpeza
        UPDATE youtube_projects 
        SET status = 'removido', 
            error_message = CONCAT('Limpeza automática - ', proj_status, ' por ', proj_age_hours, ' horas')
        WHERE project_id = proj_id;
        
    END LOOP;
    
    CLOSE cleanup_cursor;
    
    -- Log da operação
    INSERT INTO youtube_process_logs (project_id, step_name, status, message)
    VALUES ('SYSTEM', 'smart_cleanup', 'concluido', 'Limpeza inteligente executada');
    
END$$

DELIMITER ;

-- Uso: CALL SmartCleanup();
```

Estas queries te ajudarão a monitorar, otimizar e manter o sistema funcionando de forma eficiente!
