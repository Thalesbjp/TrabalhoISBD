
-- #####################################################################
-- (e) EXCLUSOES (DELETE em 5 tabelas + 1 DELETE aninhado)
-- #####################################################################

-- DELETE 1 (Matricula): remove uma matricula especifica.
DELETE FROM Matricula WHERE cpfAluno = '60000000010' AND idTurma = 5;

-- DELETE 2 (Equipamento): remove um equipamento pelo numero de serie.
DELETE FROM Equipamento WHERE numSerie = 'EQ008';

-- DELETE 3 - ANINHADO, ENVOLVENDO MAIS DE UMA TABELA:
-- remove as matriculas das turmas que ocorrem na 'Piscina'.
-- A subconsulta busca os idTurma na tabela Turma.
DELETE FROM Matricula
 WHERE idTurma IN (SELECT idTurma FROM Turma WHERE sala = 'Piscina');

-- DELETE 4 (Turma): apaga a turma 6. Por causa do ON DELETE CASCADE,
-- as matriculas dessa turma sao removidas automaticamente.
DELETE FROM Turma WHERE idTurma = 6;

-- DELETE 5 (Pessoa): apaga uma pessoa. Como Aluno/Instrutor tem FK com
-- ON DELETE CASCADE para Pessoa, o aluno correspondente (e suas
-- matriculas) tambem sao removidos em cascata.
DELETE FROM Pessoa WHERE cpf = '60000000010';
