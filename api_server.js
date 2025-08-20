require('dotenv').config();

const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Configuração do banco MySQL
const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'youtube_automation',
    charset: 'utf8mb4'
};

// Pool de conexões
let pool;

async function initDatabase() {
    try {
        pool = mysql.createPool({
            ...dbConfig,
            waitForConnections: true,
            connectionLimit: 10,
            queueLimit: 0
        });
        
        console.log('✅ Conexão com MySQL estabelecida');
        
        // Testa a conexão
        const connection = await pool.getConnection();
        await connection.ping();
        connection.release();
        
    } catch (error) {
        console.error('❌ Erro ao conectar com MySQL:', error);
        process.exit(1);
    }
}

// Rotas da API

// 1. Servir a página inicial
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'interface_selecao_temas.html'));
});

// 2. Buscar todos os temas ativos
app.get('/api/themes', async (req, res) => {
    try {
        const [rows] = await pool.execute(
            'SELECT * FROM youtube_temas WHERE ativo = TRUE ORDER BY ordem_exibicao, nome',
            []
        );
        
        res.json({
            success: true,
            data: rows
        });
        
    } catch (error) {
        console.error('Erro ao buscar temas:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor'
        });
    }
});

// 3. Buscar um tema específico
app.get('/api/themes/:id', async (req, res) => {
    try {
        const themeId = parseInt(req.params.id);
        
        const [rows] = await pool.execute(
            'SELECT * FROM youtube_temas WHERE id = ? AND ativo = TRUE',
            [themeId]
        );
        
        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Tema não encontrado'
            });
        }
        
        res.json({
            success: true,
            data: rows[0]
        });
        
    } catch (error) {
        console.error('Erro ao buscar tema:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor'
        });
    }
});

// 4. Iniciar automação (proxy para n8n webhook)
app.post('/api/start-automation', async (req, res) => {
    try {
        const { tema_id } = req.body;
        
        if (!tema_id) {
            return res.status(400).json({
                success: false,
                error: 'tema_id é obrigatório'
            });
        }
        
        // Verifica se o tema existe
        const [themeRows] = await pool.execute(
            'SELECT id, nome FROM youtube_temas WHERE id = ? AND ativo = TRUE',
            [tema_id]
        );
        
        if (themeRows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Tema não encontrado ou inativo'
            });
        }
        
        // Dados para enviar ao n8n
        const automationData = {
            tema_id: tema_id,
            tema_nome: themeRows[0].nome,
            timestamp: new Date().toISOString(),
            source: 'web_interface'
        };
        
        // URL do webhook n8n (configure conforme necessário)
        const n8nWebhookUrl = process.env.N8N_WEBHOOK_URL || 'http://localhost:5678/webhook/start-youtube-automation';
        
        // Faz a requisição para o n8n
        const fetch = require('node-fetch');
        const n8nResponse = await fetch(n8nWebhookUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(automationData)
        });
        
        if (!n8nResponse.ok) {
            throw new Error(`n8n respondeu com status ${n8nResponse.status}`);
        }
        
        const n8nResult = await n8nResponse.json();
        
        res.json({
            success: true,
            message: 'Automação iniciada com sucesso',
            data: {
                tema: themeRows[0].nome,
                timestamp: automationData.timestamp,
                n8n_response: n8nResult
            }
        });
        
    } catch (error) {
        console.error('Erro ao iniciar automação:', error);
        res.status(500).json({
            success: false,
            error: 'Erro ao iniciar automação: ' + error.message
        });
    }
});

// 5. Buscar status dos projetos
app.get('/api/projects', async (req, res) => {
    try {
        const { status, limit = '20' } = req.query;
        
        let query = `
            SELECT p.*, t.nome as tema_nome, t.cor_hex as tema_cor
            FROM youtube_projects p
            LEFT JOIN youtube_temas t ON p.tema_id = t.id
        `;
        
        const params = [];
        
        if (status) {
            query += ' WHERE p.status = ?';
            params.push(status);
        }
        
        query += ' ORDER BY p.created_at DESC LIMIT ' + parseInt(limit, 10);
        
        const [rows] = await pool.execute(query, params);
        
        res.json({
            success: true,
            data: rows
        });
        
    } catch (error) {
        console.error('Erro ao buscar projetos:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor'
        });
    }
});

// 6. Buscar estatísticas
app.get('/api/stats', async (req, res) => {
    try {
        // Estatísticas gerais
        const [statsRows] = await pool.execute(`
            SELECT 
                COUNT(*) as total_projetos,
                SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) as concluidos,
                SUM(CASE WHEN status = 'erro' THEN 1 ELSE 0 END) as com_erro,
                SUM(CASE WHEN status = 'publicado' THEN 1 ELSE 0 END) as publicados,
                SUM(CASE WHEN status IN ('iniciado', 'processando') THEN 1 ELSE 0 END) as em_andamento,
                AVG(processing_time) as tempo_medio_processamento
            FROM youtube_projects 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        `);
        
        // Estatísticas por tema
        const [themeStatsRows] = await pool.execute(`
            SELECT 
                t.nome as tema,
                t.cor_hex as cor,
                COUNT(p.id) as total_videos,
                SUM(CASE WHEN p.status = 'publicado' THEN 1 ELSE 0 END) as videos_publicados
            FROM youtube_temas t
            LEFT JOIN youtube_projects p ON t.id = p.tema_id 
                AND p.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            WHERE t.ativo = TRUE
            GROUP BY t.id, t.nome, t.cor_hex
            ORDER BY total_videos DESC
        `);
        
        res.json({
            success: true,
            data: {
                geral: statsRows[0],
                por_tema: themeStatsRows
            }
        });
        
    } catch (error) {
        console.error('Erro ao buscar estatísticas:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor'
        });
    }
});

// 7. Criar ou atualizar tema (admin)
app.post('/api/admin/themes', async (req, res) => {
    try {
        const {
            nome, descricao, prompt_roteiro, prompt_imagens,
            tags_sugeridas, categoria_youtube, cor_hex, icone, ordem_exibicao
        } = req.body;
        
        const [result] = await pool.execute(`
            INSERT INTO youtube_temas 
            (nome, descricao, prompt_roteiro, prompt_imagens, tags_sugeridas, categoria_youtube, cor_hex, icone, ordem_exibicao)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            nome, descricao, prompt_roteiro, prompt_imagens,
            JSON.stringify(tags_sugeridas), categoria_youtube, cor_hex, icone, ordem_exibicao
        ]);
        
        res.json({
            success: true,
            message: 'Tema criado com sucesso',
            data: { id: result.insertId }
        });
        
    } catch (error) {
        console.error('Erro ao criar tema:', error);
        res.status(500).json({
            success: false,
            error: 'Erro ao criar tema: ' + error.message
        });
    }
});

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        error: 'Erro interno do servidor'
    });
});

// Middleware para rotas não encontradas
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Rota não encontrada'
    });
});

// Inicializar servidor
async function startServer() {
    try {
        await initDatabase();
        
        app.listen(PORT, () => {
            console.log(`\n🚀 Servidor rodando na porta ${PORT}`);
            console.log(`📱 Interface: http://localhost:${PORT}`);
            console.log(`🔌 API: http://localhost:${PORT}/api`);
            console.log(`📊 Temas: http://localhost:${PORT}/api/themes`);
            console.log(`📈 Stats: http://localhost:${PORT}/api/stats\n`);
        });
        
    } catch (error) {
        console.error('❌ Erro ao iniciar servidor:', error);
        process.exit(1);
    }
}

startServer();

module.exports = app;
