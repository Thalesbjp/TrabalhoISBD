-- #####################################################################
-- (f) CONSULTAS (12 obrigatorias F1-F12 + extras)
--     Cada consulta tem a descricao do que recupera.
-- #####################################################################

-- F1 - INNER JOIN: nome do aluno e o plano que ele contratou (com valor).
SELECT p.nomePessoa, pl.nomePlano, pl.valor
  FROM Aluno a
  INNER JOIN Pessoa p ON a.cpf = p.cpf
  INNER JOIN Plano  pl ON a.idPlano = pl.idPlano;

-- F2 - OUTER JOIN: todos os alunos e o id das turmas em que estao
-- matriculados, incluindo os alunos sem nenhuma matricula (idTurma NULL).
SELECT p.nomePessoa, m.idTurma
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
  LEFT OUTER JOIN Matricula m ON m.cpfAluno = a.cpf
  ORDER BY p.nomePessoa, m.idTurma;

-- F3 - ORDER BY: alunos ordenados da adesao mais recente para a mais antiga.
SELECT p.nomePessoa, a.dataAdesao
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
  ORDER BY a.dataAdesao DESC, p.nomePessoa ASC;

-- F4 - GROUP BY: quantidade de alunos em cada plano.
SELECT pl.nomePlano, COUNT(*) AS qtdAlunos
  FROM Aluno a
  JOIN Plano pl ON a.idPlano = pl.idPlano
  GROUP BY pl.idPlano, pl.nomePlano
  ORDER BY qtdAlunos DESC;

-- F5 - HAVING: planos que possuem mais de 1 aluno.
SELECT pl.nomePlano, COUNT(*) AS qtdAlunos
  FROM Aluno a
  JOIN Plano pl ON a.idPlano = pl.idPlano
  GROUP BY pl.idPlano, pl.nomePlano
  HAVING COUNT(*) > 1;

-- F6 - UNION: lista unica de pessoas indicando o papel (Aluno/Instrutor).
SELECT nomePessoa, 'Aluno' AS papel
  FROM Pessoa WHERE cpf IN (SELECT cpf FROM Aluno)
UNION
SELECT nomePessoa, 'Instrutor' AS papel
  FROM Pessoa WHERE cpf IN (SELECT cpf FROM Instrutor)
ORDER BY nomePessoa;

-- F7 - IN: alunos cujo plano e 'Mensal' ou 'Anual'.
SELECT p.nomePessoa
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
 WHERE a.idPlano IN (SELECT idPlano FROM Plano WHERE nomePlano IN ('Mensal','Anual'));

-- F8 - LIKE: equipamentos cujo nome comeca com a letra 'B'.
SELECT numSerie, nomeEquipamento
  FROM Equipamento
 WHERE nomeEquipamento LIKE 'B%';

-- F9 - IS NULL: alunos que nao tem bairro cadastrado.
SELECT p.nomePessoa, a.cidade
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
 WHERE a.bairro IS NULL;

-- F10 - ANY/SOME: planos cujo valor e maior que o de ALGUM dos planos
-- basicos (Estudante ou Mensal). Equivale a "mais caro que o mais barato".
SELECT nomePlano, valor
  FROM Plano
 WHERE valor > ANY (SELECT valor FROM Plano WHERE nomePlano IN ('Estudante','Mensal'));

-- F11 - ALL: o(s) plano(s) mais caro(s) - valor maior ou igual a TODOS.
SELECT nomePlano, valor
  FROM Plano
 WHERE valor >= ALL (SELECT valor FROM Plano);

-- F12 - EXISTS: alunos que possuem pelo menos uma matricula.
SELECT p.nomePessoa
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
 WHERE EXISTS (SELECT 1 FROM Matricula m WHERE m.cpfAluno = a.cpf);

-- F13 (extra - AND / OR): alunos de Lavras com plano Anual OU Semestral.
SELECT p.nomePessoa, a.cidade, pl.nomePlano
  FROM Aluno a
  JOIN Pessoa p ON a.cpf = p.cpf
  JOIN Plano pl ON a.idPlano = pl.idPlano
 WHERE a.cidade = 'Lavras'
   AND (pl.nomePlano = 'Anual' OR pl.nomePlano = 'Semestral');

-- F14 (extra - BETWEEN): turmas que comecam entre 06:00 e 09:00.
SELECT idTurma, horarioInicio, sala
  FROM Turma
 WHERE horarioInicio BETWEEN '06:00:00' AND '09:00:00'
 ORDER BY horarioInicio;

-- F15 (extra - NOT IN + LIKE): equipamentos que NAO sao de Musculacao.
SELECT nomeEquipamento
  FROM Equipamento
 WHERE idModalidade NOT IN (SELECT idModalidade FROM Modalidade WHERE nomeModalidade LIKE 'Musculacao%');

-- F16 (extra - LEFT JOIN + GROUP BY + agregada): receita potencial por
-- plano (soma do valor dos alunos de cada plano), incluindo planos sem aluno.
SELECT pl.nomePlano, COUNT(a.cpf) AS alunos, pl.valor,
       SUM(pl.valor) AS receitaPotencial
  FROM Plano pl
  LEFT JOIN Aluno a ON a.idPlano = pl.idPlano
  GROUP BY pl.idPlano, pl.nomePlano, pl.valor
  ORDER BY receitaPotencial DESC;