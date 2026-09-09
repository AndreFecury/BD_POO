DROP TABLE IF EXISTS log_notas CASCADE;
DROP TABLE IF EXISTS matriculas CASCADE;
DROP TABLE IF EXISTS alunos CASCADE;
DROP TABLE IF EXISTS cursos CASCADE;
DROP TABLE IF EXISTS professores CASCADE;
DROP FUNCTION IF EXISTS media_aluno(INT);
DROP FUNCTION IF EXISTS registrar_alteracao_nota();

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
    nota NUMERIC(4,2) CHECK (nota BETWEEN 0 AND 10),
    data_matricula DATE DEFAULT CURRENT_DATE
);

CREATE TABLE log_notas (
    id SERIAL PRIMARY KEY,
    matricula_id INT,
    nota_antiga NUMERIC(4,2),
    nota_nova NUMERIC(4,2),
    alterado_em TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_matriculas_aluno ON matriculas(aluno_id);

CREATE FUNCTION media_aluno(aluno_id_param INT)
RETURNS NUMERIC AS $$
    SELECT ROUND(AVG(nota), 2)
    FROM matriculas
    WHERE aluno_id = aluno_id_param;
$$ LANGUAGE sql;

CREATE FUNCTION registrar_alteracao_nota()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nota IS DISTINCT FROM OLD.nota THEN
        INSERT INTO log_notas (matricula_id, nota_antiga, nota_nova)
        VALUES (OLD.id, OLD.nota, NEW.nota);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_notas
AFTER UPDATE ON matriculas
FOR EACH ROW
EXECUTE FUNCTION registrar_alteracao_nota();

CREATE VIEW painel_cursos AS
SELECT
    c.nome_curso,
    p.nome AS professor,
    COUNT(m.id) AS total_matriculas,
    ROUND(AVG(m.nota), 2) AS media_notas
FROM cursos c
JOIN professores p ON p.id = c.professor_id
LEFT JOIN matriculas m ON m.curso_id = c.id
GROUP BY c.nome_curso, p.nome;
