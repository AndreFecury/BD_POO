INSERT INTO professores (nome, titulacao) VALUES
('Carlos Mendes', 'Doutor'),
('Ana Ferreira', 'Mestre'),
('Roberto Lima', 'Doutor');

INSERT INTO cursos (nome_curso, carga_horaria, professor_id) VALUES
('Banco de Dados', 80, 1),
('Engenharia de Software', 60, 2),
('Redes de Computadores', 40, 3),
('Inteligência Artificial', 100, 1);

INSERT INTO alunos (nome, idade, email) VALUES
('Maria Silva', 22, 'maria@email.com'),
('João Souza', 25, 'joao@email.com'),
('Pedro Alves', 19, 'pedro@email.com'),
('Ana Beatriz', 21, 'anabeatriz@email.com'),
('Lucas Costa', 23, 'lucas@email.com');

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
