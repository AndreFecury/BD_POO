-- =====================================================================
-- SCRIPT COMPLETO DE DEMONSTRAÇÃO - PostgreSQL
-- Mini sistema acadêmico: alunos, cursos, professores, matrículas
-- =====================================================================

-- ===========================================
-- 0. LIMPEZA (garante execução limpa, sem erros de "já existe")
-- ===========================================
DROP TABLE IF EXISTS log_notas CASCADE;
DROP TABLE IF EXISTS matriculas CASCADE;
DROP TABLE IF EXISTS alunos CASCADE;
DROP TABLE IF EXISTS cursos CASCADE;
DROP TABLE IF EXISTS professores CASCADE;
DROP FUNCTION IF EXISTS media_aluno(INT);
DROP FUNCTION IF EXISTS registrar_alteracao_nota();

-- ===========================================
-- 1. CRIAÇÃO DAS TABELAS
-- ===========================================
CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    titulacao VARCHAR(50)
);

CREATE TABLE cursos (
    id SERIAL PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    carga_horaria INT,
    professor_id INT REFERENCES professores(id)
);

CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    email VARCHAR(150) UNIQUE
);

CREATE TABLE matriculas (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES alunos(id) ON DELETE CASCADE,
    curso_id INT REFERENCES cursos(id) ON DELETE CASCADE,
    nota NUMERIC(4,2) CHECK (nota >= 0 AND nota <= 10),
    data_matricula DATE DEFAULT CURRENT_DATE
);

-- ===========================================
-- 2. POPULANDO PROFESSORES
-- ===========================================
INSERT INTO professores (nome, titulacao) VALUES
('Carlos Mendes', 'Doutor'),
('Ana Ferreira', 'Mestre'),
('Roberto Lima', 'Doutor');

-- ===========================================
-- 3. POPULANDO CURSOS
-- ===========================================
INSERT INTO cursos (nome_curso, carga_horaria, professor_id) VALUES
('Banco de Dados', 80, 1),
('Engenharia de Software', 60, 2),
('Redes de Computadores', 40, 3),
('Inteligência Artificial', 100, 1);

-- ===========================================
-- 4. POPULANDO ALUNOS
-- ===========================================
INSERT INTO alunos (nome, idade, email) VALUES
('Maria Silva', 22, 'maria@email.com'),
('João Souza', 25, 'joao@email.com'),
('Pedro Alves', 19, 'pedro@email.com'),
('Ana Beatriz', 21, 'anabeatriz@email.com'),
('Lucas Costa', 23, 'lucas@email.com');

-- ===========================================
-- 5. POPULANDO MATRÍCULAS (com notas)
-- ===========================================
INSERT INTO matriculas (aluno_id, curso_id, nota) VALUES
(1, 1, 8.5),
(1, 2, 7.0),
(2, 1, 6.5),
(2, 3, 9.0),
(3, 2, 5.5),
(3, 4, 8.0),
(4, 1, 9.5),
(4, 4, 7.5),
(5, 3, 4.0),
(5, 2, 6.0);

-- ===========================================
-- 6. CONSULTA: alunos, cursos e professores (JOIN triplo)
-- ===========================================
SELECT a.nome AS aluno, c.nome_curso AS curso, p.nome AS professor, m.nota
FROM matriculas m
JOIN alunos a ON m.aluno_id = a.id
JOIN cursos c ON m.curso_id = c.id
JOIN professores p ON c.professor_id = p.id
ORDER BY a.nome, c.nome_curso;

-- ===========================================
-- 7. MÉDIA DE NOTAS POR ALUNO
-- ===========================================
SELECT a.nome, ROUND(AVG(m.nota), 2) AS media_geral
FROM alunos a
JOIN matriculas m ON a.id = m.aluno_id
GROUP BY a.nome
ORDER BY media_geral DESC;

-- ===========================================
-- 8. MÉDIA DE NOTAS POR CURSO
-- ===========================================
SELECT c.nome_curso, ROUND(AVG(m.nota), 2) AS media_curso, COUNT(m.id) AS total_alunos
FROM cursos c
LEFT JOIN matriculas m ON c.id = m.curso_id
GROUP BY c.nome_curso
ORDER BY media_curso DESC NULLS LAST;

-- ===========================================
-- 9. ALUNOS APROVADOS (nota >= 6) COM STATUS (CASE)
-- ===========================================
SELECT a.nome, c.nome_curso, m.nota,
    CASE
        WHEN m.nota >= 6 THEN 'Aprovado'
        ELSE 'Reprovado'
    END AS status
FROM matriculas m
JOIN alunos a ON m.aluno_id = a.id
JOIN cursos c ON m.curso_id = c.id
ORDER BY status, a.nome;

-- ===========================================
-- 10. SUBCONSULTA: alunos com média acima da média geral da turma
-- ===========================================
SELECT a.nome, ROUND(AVG(m.nota), 2) AS media
FROM alunos a
JOIN matriculas m ON a.id = m.aluno_id
GROUP BY a.nome
HAVING AVG(m.nota) > (SELECT AVG(nota) FROM matriculas);

-- ===========================================
-- 11. VIEW: painel resumido de desempenho por curso
-- ===========================================
CREATE OR REPLACE VIEW painel_cursos AS
SELECT c.nome_curso, p.nome AS professor, COUNT(m.id) AS total_matriculas,
    ROUND(AVG(m.nota), 2) AS media_notas
FROM cursos c
JOIN professores p ON c.professor_id = p.id
LEFT JOIN matriculas m ON c.id = m.curso_id
GROUP BY c.nome_curso, p.nome;

SELECT * FROM painel_cursos ORDER BY media_notas DESC NULLS LAST;

-- ===========================================
-- 12. FUNÇÃO: calcula a média de notas de um aluno específico
-- ===========================================
CREATE OR REPLACE FUNCTION media_aluno(aluno_id_param INT)
RETURNS NUMERIC AS $$
DECLARE
    media_calculada NUMERIC;
BEGIN
    SELECT ROUND(AVG(nota), 2) INTO media_calculada
    FROM matriculas
    WHERE aluno_id = aluno_id_param;

    RETURN media_calculada;
END;
$$ LANGUAGE plpgsql;

-- Testando a função:
SELECT nome, media_aluno(id) AS media
FROM alunos
ORDER BY media DESC;

-- ===========================================
-- 13. TABELA DE LOG (para o trigger registrar mudanças)
-- ===========================================
CREATE TABLE log_notas (
    id SERIAL PRIMARY KEY,
    matricula_id INT,
    nota_antiga NUMERIC(4,2),
    nota_nova NUMERIC(4,2),
    alterado_em TIMESTAMP DEFAULT NOW()
);

-- ===========================================
-- 14. FUNÇÃO DE TRIGGER: registra toda alteração de nota
-- ===========================================
CREATE OR REPLACE FUNCTION registrar_alteracao_nota()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nota IS DISTINCT FROM OLD.nota THEN
        INSERT INTO log_notas (matricula_id, nota_antiga, nota_nova)
        VALUES (OLD.id, OLD.nota, NEW.nota);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- 15. TRIGGER: dispara a função acima sempre que uma nota é atualizada
-- ===========================================
CREATE TRIGGER trigger_log_notas
AFTER UPDATE ON matriculas
FOR EACH ROW
EXECUTE FUNCTION registrar_alteracao_nota();

-- Testando o trigger: vamos alterar a nota da Maria no curso 1
UPDATE matriculas SET nota = 9.8 WHERE aluno_id = 1 AND curso_id = 1;

-- Conferindo se o log registrou a mudança:
SELECT * FROM log_notas;

-- ===========================================
-- 16. ÍNDICE: acelera buscas por aluno_id na tabela de matrículas
-- ===========================================
CREATE INDEX idx_matriculas_aluno ON matriculas(aluno_id);

-- Mostrando que o índice foi criado:
SELECT indexname, tablename FROM pg_indexes WHERE tablename = 'matriculas';

-- Demonstrando o plano de execução usando o índice:
EXPLAIN SELECT * FROM matriculas WHERE aluno_id = 1;
