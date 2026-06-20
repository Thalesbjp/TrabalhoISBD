-- #####################################################################
-- (i) PROCEDIMENTOS E FUNCOES (3) - com IF, CASE WHEN, WHILE, variaveis
-- #####################################################################

-- FUNCAO 1: classifica um valor de plano em faixa (usa CASE WHEN).
DROP FUNCTION IF EXISTS fn_faixa_valor;
DELIMITER $$
CREATE FUNCTION fn_faixa_valor(p_valor DECIMAL(7,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_faixa VARCHAR(10);          -- declaracao de variavel
    CASE
        WHEN p_valor < 100 THEN SET v_faixa = 'Baixo';
        WHEN p_valor < 500 THEN SET v_faixa = 'Medio';
        ELSE                    SET v_faixa = 'Alto';
    END CASE;
    RETURN v_faixa;
END$$
DELIMITER ;
-- Teste da Funcao 1: mostra a faixa de cada plano.
SELECT nomePlano, valor, fn_faixa_valor(valor) AS faixa FROM Plano;

-- PROCEDIMENTO 2: total de matriculas de um aluno (parametro de SAIDA).
-- Usa IF para tratar aluno inexistente e a funcao agregada COUNT.
DROP PROCEDURE IF EXISTS sp_total_matriculas_aluno;
DELIMITER $$
CREATE PROCEDURE sp_total_matriculas_aluno(IN p_cpf CHAR(11), OUT p_total INT)
BEGIN
    DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe FROM Aluno WHERE cpf = p_cpf;
    IF v_existe = 0 THEN
        SET p_total = -1;     -- -1 sinaliza que o aluno nao existe
    ELSE
        SELECT COUNT(*) INTO p_total FROM Matricula WHERE cpfAluno = p_cpf;
    END IF;
END$$
DELIMITER ;
-- Teste do Procedimento 2: conta as matriculas do aluno 60000000001.
CALL sp_total_matriculas_aluno('60000000001', @total);
SELECT @total AS total_matriculas;

-- PROCEDIMENTO 3: aplica um reajuste percentual a um plano, repetido
-- p_vezes (usa IF para validar, WHILE para repetir e variavel contador).
DROP PROCEDURE IF EXISTS sp_reajuste_iterativo;
DELIMITER $$
CREATE PROCEDURE sp_reajuste_iterativo(IN p_idPlano INT, IN p_percentual DECIMAL(5,2), IN p_vezes INT)
BEGIN
    DECLARE v_contador INT DEFAULT 0;     -- variavel de controle do laco
    DECLARE v_existe   INT;
    SELECT COUNT(*) INTO v_existe FROM Plano WHERE idPlano = p_idPlano;
    IF v_existe = 0 OR p_percentual <= 0 OR p_vezes <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Parametros invalidos ou plano inexistente';
    ELSE
        WHILE v_contador < p_vezes DO
            UPDATE Plano
               SET valor = valor * (1 + p_percentual/100)
             WHERE idPlano = p_idPlano;
            SET v_contador = v_contador + 1;
        END WHILE;
    END IF;
END$$
DELIMITER ;
-- Teste do Procedimento 3: valor antes, aplica 5% tres vezes, valor depois.
SELECT valor AS valor_antes FROM Plano WHERE idPlano = 2;
CALL sp_reajuste_iterativo(2, 5, 3);
SELECT valor AS valor_depois FROM Plano WHERE idPlano = 2;