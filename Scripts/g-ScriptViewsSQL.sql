-- #####################################################################
-- (g) VISOES (Views) - 3 views + exemplo de uso de cada
-- #####################################################################

-- View 1: alunos com os dados do plano contratado.
DROP VIEW IF EXISTS vw_aluno_plano;
CREATE VIEW vw_aluno_plano AS
  SELECT p.cpf, p.nomePessoa, pl.nomePlano, pl.valor,
         a.dataAdesao, a.dataTermino
    FROM Aluno a
    JOIN Pessoa p ON a.cpf = p.cpf
    JOIN Plano  pl ON a.idPlano = pl.idPlano;
-- Uso da View 1: alunos cujo plano custa mais de R$200.
SELECT * FROM vw_aluno_plano WHERE valor > 200;

-- View 2: detalhe das turmas (modalidade + instrutor).
DROP VIEW IF EXISTS vw_turma_detalhe;
CREATE VIEW vw_turma_detalhe AS
  SELECT t.idTurma, t.horarioInicio, t.sala,
         m.nomeModalidade, pe.nomePessoa AS instrutor
    FROM Turma t
    JOIN Modalidade m ON t.idModalidade = m.idModalidade
    JOIN Instrutor  i ON t.cpfInstrutor = i.cpf
    JOIN Pessoa    pe ON i.cpf = pe.cpf;
-- Uso da View 2: todas as turmas ordenadas por horario.
SELECT * FROM vw_turma_detalhe ORDER BY horarioInicio;

-- View 3: ocupacao das turmas (quantos alunos matriculados em cada uma).
DROP VIEW IF EXISTS vw_ocupacao_turma;
CREATE VIEW vw_ocupacao_turma AS
  SELECT t.idTurma, m.nomeModalidade, COUNT(mt.cpfAluno) AS matriculados
    FROM Turma t
    JOIN Modalidade m ON t.idModalidade = m.idModalidade
    LEFT JOIN Matricula mt ON mt.idTurma = t.idTurma
    GROUP BY t.idTurma, m.nomeModalidade;
-- Uso da View 3: turmas que tem pelo menos um aluno matriculado.
SELECT * FROM vw_ocupacao_turma WHERE matriculados >= 1;
