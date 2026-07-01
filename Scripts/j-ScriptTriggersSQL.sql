-- #####################################################################
-- (j) TRIGGERS (3) - um para INSERT, um para UPDATE, um para DELETE
--
--     Cada trigger tem um proposito DIFERENTE, para cobrir os tres usos
--     classicos de gatilhos (e nao apenas gerar log):
--       1. INSERT -> VALIDACAO DE INTEGRIDADE entre tabelas.
--       2. UPDATE -> REGRA DE NEGOCIO sobre a propria linha.
--       3. DELETE -> AUDITORIA do evento.
--
--     O trigger de INSERT tambem cobre a correcao pedida na revisao:
--     a heranca Pessoa -> {Aluno, Instrutor} e uma especializacao
--     DISJUNTA com cardinalidade 1:1 (cada Pessoa e Aluno OU Instrutor,
--     nunca os dois). O modelo relacional puro (PK = FK) garante o "no
--     maximo 1", mas NAO garante a disjuncao; o trigger fecha essa lacuna.
-- #####################################################################

-- Tabela de log usada pelo trigger de auditoria (DELETE).
CREATE TABLE IF NOT EXISTS LogAuditoria (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    evento    VARCHAR(20),
    tabela    VARCHAR(30),
    detalhe   VARCHAR(200),
    dataHora  DATETIME
);

-- ---------------------------------------------------------------------
-- TRIGGER 1 (INSERT) - VALIDACAO DE INTEGRIDADE
-- Antes de inserir um Aluno:
--   (a) garante a especializacao DISJUNTA 1:1 da heranca: o mesmo cpf
--       nao pode ja ser um Instrutor;
--   (b) garante coerencia temporal: dataTermino > dataAdesao.
-- Regras que nem FK nem CHECK conseguem expressar sozinhas.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_aluno_before_insert;
DELIMITER $$
CREATE TRIGGER trg_aluno_before_insert
BEFORE INSERT ON Aluno
FOR EACH ROW
BEGIN
    -- (a) disjuncao da heranca: se o cpf ja e Instrutor, barra o INSERT.
    IF EXISTS (SELECT 1 FROM Instrutor WHERE cpf = NEW.cpf) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Heranca 1:1 disjunta: este cpf ja e Instrutor e nao pode ser Aluno.';
    END IF;

    -- (b) coerencia das datas do plano.
    IF NEW.dataTermino <= NEW.dataAdesao THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'dataTermino deve ser posterior a dataAdesao.';
    END IF;
END$$
DELIMITER ;

-- ---------------------------------------------------------------------
-- TRIGGER 2 (UPDATE) - REGRA DE NEGOCIO
-- O salario de um instrutor nunca pode ser REDUZIDO por um UPDATE.
-- Aumentos sao permitidos; qualquer reducao e bloqueada.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_instrutor_before_update;
DELIMITER $$
CREATE TRIGGER trg_instrutor_before_update
BEFORE UPDATE ON Instrutor
FOR EACH ROW
BEGIN
    IF NEW.salario < OLD.salario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Reducao de salario nao permitida para instrutores.';
    END IF;
END$$
DELIMITER ;

-- ---------------------------------------------------------------------
-- TRIGGER 3 (DELETE) - AUDITORIA
-- Registra no log toda exclusao de aluno, guardando quem foi removido.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_aluno_after_delete;
DELIMITER $$
CREATE TRIGGER trg_aluno_after_delete
AFTER DELETE ON Aluno
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria (evento, tabela, detalhe, dataHora)
    VALUES ('DELETE','Aluno',
            CONCAT('Aluno removido: ', OLD.cpf,
                   ' (plano ', OLD.idPlano, ')'),
            NOW());
END$$
DELIMITER ;

-- ----- TESTES DOS TRIGGERS -----

-- ===== Trigger 1 (INSERT / validacao) =====

-- 1.1 DISPARA e PERMITE: pessoa nova, apenas Aluno, datas coerentes -> OK.
INSERT INTO Pessoa (cpf, nomePessoa, dataNasc)
VALUES ('70000000001','Rafael Teixeira','2000-06-15');
INSERT INTO Aluno (cpf, logradouro, numero, bairro, cep, idPlano, dataAdesao, dataTermino)
VALUES ('70000000001','Rua Nova', 15,'Centro','37200099',1,'2025-09-01','2025-10-01');

-- 1.2 DISPARA e BLOQUEIA (heranca 1:1 disjunta): '11111111111' ja e
--     Instrutor, entao nao pode virar Aluno. Deve gerar erro 45000.
INSERT INTO Aluno (cpf, logradouro, numero, bairro, cep, idPlano, dataAdesao, dataTermino)
VALUES ('11111111111','Rua X', 10,'Centro','37200098',1,'2025-09-01','2025-10-01');

-- 1.3 DISPARA e BLOQUEIA (datas invalidas): termino antes da adesao.
INSERT INTO Pessoa (cpf, nomePessoa, dataNasc)
VALUES ('70000000002','Sofia Ramos','1999-02-02');
INSERT INTO Aluno (cpf, logradouro, numero, bairro, cep, idPlano, dataAdesao, dataTermino)
VALUES ('70000000002','Rua Y', 20,'Centro','37200097',1,'2025-10-01','2025-09-01');

-- ===== Trigger 2 (UPDATE / regra de negocio) =====

-- 2.1 DISPARA e PERMITE: aumento de salario -> OK.
UPDATE Instrutor SET salario = salario + 100 WHERE cpf = '11111111111';
-- 2.2 DISPARA e BLOQUEIA: reducao de salario -> erro 45000.
UPDATE Instrutor SET salario = salario - 500 WHERE cpf = '11111111111';
-- 2.3 NAO DISPARA: alterar outra tabela (Plano) nao aciona este trigger.
UPDATE Plano SET valor = valor WHERE idPlano = 1;

-- ===== Trigger 3 (DELETE / auditoria) =====

-- 3.1 DISPARA: excluir um aluno gera registro no log.
DELETE FROM Aluno WHERE cpf = '60000000007';
SELECT * FROM LogAuditoria WHERE tabela = 'Aluno';
-- 3.2 NAO DISPARA: delete que nao casa nenhuma linha (cpf inexistente).
DELETE FROM Aluno WHERE cpf = '00000000000';

-- Visao geral de todos os eventos registrados pelos triggers.
SELECT * FROM LogAuditoria ORDER BY id;
