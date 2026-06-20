-- #####################################################################
-- (j) TRIGGERS (3) - um para INSERT, um para UPDATE, um para DELETE
--     Usam uma tabela de auditoria para registrar os eventos.
-- #####################################################################

-- Tabela de log usada pelos triggers.
CREATE TABLE IF NOT EXISTS LogAuditoria (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    evento    VARCHAR(20),
    tabela    VARCHAR(30),
    detalhe   VARCHAR(200),
    dataHora  DATETIME
);

-- TRIGGER 1 (INSERT): registra no log toda nova matricula.
DROP TRIGGER IF EXISTS trg_matricula_insert;
DELIMITER $$
CREATE TRIGGER trg_matricula_insert
AFTER INSERT ON Matricula
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria (evento, tabela, detalhe, dataHora)
    VALUES ('INSERT','Matricula',
            CONCAT('Aluno ', NEW.cpfAluno, ' matriculado na turma ', NEW.idTurma),
            NOW());
END$$
DELIMITER ;

-- TRIGGER 2 (UPDATE): registra mudancas de salario de instrutor.
DROP TRIGGER IF EXISTS trg_instrutor_update;
DELIMITER $$
CREATE TRIGGER trg_instrutor_update
AFTER UPDATE ON Instrutor
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria (evento, tabela, detalhe, dataHora)
    VALUES ('UPDATE','Instrutor',
            CONCAT('Instrutor ', NEW.cpf, ': salario de ', OLD.salario, ' para ', NEW.salario),
            NOW());
END$$
DELIMITER ;

-- TRIGGER 3 (DELETE): registra a exclusao de um aluno.
DROP TRIGGER IF EXISTS trg_aluno_delete;
DELIMITER $$
CREATE TRIGGER trg_aluno_delete
AFTER DELETE ON Aluno
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria (evento, tabela, detalhe, dataHora)
    VALUES ('DELETE','Aluno',
            CONCAT('Aluno removido: ', OLD.cpf),
            NOW());
END$$
DELIMITER ;

-- ----- TESTES DOS TRIGGERS -----

-- Trigger 1 DISPARA: nova matricula gera registro no log.
INSERT INTO Matricula (cpfAluno, idTurma, dataMatricula) VALUES ('60000000002', 1, '2025-08-01');
SELECT * FROM LogAuditoria WHERE tabela = 'Matricula';
-- Trigger 1 NAO DISPARA: um UPDATE em Matricula nao aciona o trigger de INSERT.
UPDATE Matricula SET dataMatricula = '2025-08-02' WHERE cpfAluno = '60000000002' AND idTurma = 1;
-- (a consulta acima ao log continua mostrando apenas o INSERT registrado)

-- Trigger 2 DISPARA: alterar o salario gera registro no log.
UPDATE Instrutor SET salario = salario + 100 WHERE cpf = '11111111111';
SELECT * FROM LogAuditoria WHERE tabela = 'Instrutor';
-- Trigger 2 NAO DISPARA: alterar outra tabela (Plano) nao mexe no log de Instrutor.
UPDATE Plano SET valor = valor WHERE idPlano = 1;

-- Trigger 3 DISPARA: excluir um aluno gera registro no log.
DELETE FROM Aluno WHERE cpf = '60000000007';
SELECT * FROM LogAuditoria WHERE tabela = 'Aluno';
-- Trigger 3 NAO DISPARA: delete que nao casa nenhuma linha (cpf inexistente).
DELETE FROM Aluno WHERE cpf = '00000000000';

-- Visao geral de todos os eventos registrados pelos triggers.
SELECT * FROM LogAuditoria ORDER BY id;