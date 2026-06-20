-- #####################################################################
-- (d) MODIFICACOES (UPDATE em 5 tabelas + 1 UPDATE aninhado)
-- #####################################################################

-- UPDATE 1 (Plano): reajuste de 10% no valor do plano Mensal.
UPDATE Plano SET valor = valor * 1.10 WHERE idPlano = 1;

-- UPDATE 2 (Instrutor): aumento fixo de R$200 no salario de um instrutor.
UPDATE Instrutor SET salario = salario + 200 WHERE cpf = '44444444444';

-- UPDATE 3 (Turma): troca a sala da turma 2.
UPDATE Turma SET sala = 'Sala 5' WHERE idTurma = 2;

-- UPDATE 4 (Modalidade): renomeia uma modalidade.
UPDATE Modalidade SET nomeModalidade = 'Musculacao e Forca' WHERE idModalidade = 1;

-- UPDATE 5 (Aluno) - ANINHADO, ENVOLVENDO MAIS DE UMA TABELA:
-- estende por 12 meses a data de termino dos alunos que contrataram o
-- plano 'Anual'. A subconsulta busca o idPlano na tabela Plano.
UPDATE Aluno
   SET dataTermino = DATE_ADD(dataAdesao, INTERVAL 12 MONTH)
 WHERE idPlano IN (SELECT idPlano FROM Plano WHERE nomePlano = 'Anual');

