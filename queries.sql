SELECT
    a.id AS aluno_id,
    a.nome AS aluno,
    a.idade,
    a.email,
    c.nome_curso AS curso,
    c.carga_horaria,
    p.nome AS professor,
    p.titulacao,
    m.nota,
    CASE
        WHEN m.nota >= 9 THEN 'Excelente'
        WHEN m.nota >= 7 THEN 'Bom'
        WHEN m.nota >= 6 THEN 'Aprovado'
        ELSE 'Reprovado'
    END AS conceito,
    ROUND(AVG(m.nota) OVER (PARTITION BY a.id), 2) AS media_do_aluno,
    ROUND(AVG(m.nota) OVER (PARTITION BY c.id), 2) AS media_do_curso,
    RANK() OVER (PARTITION BY c.id ORDER BY m.nota DESC) AS posicao_no_curso,
    m.data_matricula
FROM matriculas m
JOIN alunos a ON a.id = m.aluno_id
JOIN cursos c ON c.id = m.curso_id
JOIN professores p ON p.id = c.professor_id
ORDER BY c.nome_curso, posicao_no_curso;

SELECT a.nome, ROUND(AVG(m.nota), 2) AS media_geral
FROM alunos a
JOIN matriculas m ON m.aluno_id = a.id
GROUP BY a.nome
ORDER BY media_geral DESC;

SELECT a.nome, ROUND(AVG(m.nota), 2) AS media
FROM alunos a
JOIN matriculas m ON m.aluno_id = a.id
GROUP BY a.nome
HAVING AVG(m.nota) > (SELECT AVG(nota) FROM matriculas);

SELECT * FROM painel_cursos ORDER BY media_notas DESC NULLS LAST;

SELECT nome, media_aluno(id) AS media
FROM alunos
ORDER BY media DESC;
