-- #####################################################################
-- (b) ALTER TABLE (3 exemplos diversos) E DROP TABLE
-- #####################################################################

-- ALTER 1 - ADICIONAR COLUNA: registra a data de contratacao do instrutor.
ALTER TABLE Instrutor ADD COLUMN dataContratacao DATE NULL;

-- ALTER 2 - MODIFICAR COLUNA: aumenta o tamanho do nome do plano.
ALTER TABLE Plano MODIFY nomePlano VARCHAR(40) NOT NULL;

-- ALTER 3 - ADICIONAR RESTRICAO: nome do equipamento passa a ser unico.
ALTER TABLE Equipamento ADD CONSTRAINT uk_equip_nome UNIQUE (nomeEquipamento);

-- DROP TABLE: cria uma tabela ficticia so para exemplificar e a apaga.
CREATE TABLE TabelaTeste (
    id        INT          NOT NULL PRIMARY KEY,
    descricao VARCHAR(50)
);
DROP TABLE TabelaTeste;   -- remove a tabela ficticia criada acima.