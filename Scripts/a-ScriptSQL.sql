-- =====================================================================
-- TRABALHO PRATICO - ETAPA 3 - IMPLEMENTACAO EM SQL
-- GCC214 - Introducao a Sistemas de Banco de Dados - UFLA - 2026/1
-- Grupo 07 - Sistema de Gestao de Academia de Ginastica
-- =====================================================================
-- Observacoes:
--   * Script feito para MySQL 8.x (utf8mb4).
--   * Comentarios sem acento de proposito, para evitar problemas de
--     codificacao ao copiar/colar entre editores e o cliente MySQL.
--   * O item (a) recria o banco do zero (DROP DATABASE). Rodar este
--     script apaga e refaz tudo - use-o para preparar o ambiente antes
--     da apresentacao. Os itens de (f) em diante sao os executados ao
--     vivo na frente do professor.
-- =====================================================================


-- #####################################################################
-- (a) CRIACAO DE TABELAS E RESTRICOES DE INTEGRIDADE
--     PK, FK em todas as tabelas + exemplos de UNIQUE e DEFAULT
-- #####################################################################

-- Apaga o banco se existir e cria novamente com charset utf8mb4.
DROP DATABASE IF EXISTS academia;
CREATE DATABASE academia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE academia;

-- Pessoa: superclasse. Guarda os dados comuns a alunos e instrutores.
-- PRIMARY KEY em cpf.
CREATE TABLE Pessoa (
    cpf         CHAR(11)        NOT NULL,
    nomePessoa  VARCHAR(80)     NOT NULL,
    dataNasc    DATE            NOT NULL,
    CONSTRAINT pk_pessoa PRIMARY KEY (cpf)
);

-- Plano: tipos de plano da academia.
-- Exemplo de UNIQUE: dois planos nao podem ter o mesmo nome.
-- CHECK garante id e valor positivos.
CREATE TABLE Plano (
    idPlano     INT             NOT NULL,
    nomePlano   VARCHAR(30)     NOT NULL,
    valor       DECIMAL(7,2)    NOT NULL,
    CONSTRAINT pk_plano       PRIMARY KEY (idPlano),
    CONSTRAINT uk_plano_nome  UNIQUE (nomePlano),          -- EXEMPLO DE UNIQUE
    CONSTRAINT ck_plano_id    CHECK (idPlano > 0),
    CONSTRAINT ck_plano_valor CHECK (valor > 0)
);

-- Modalidade: modalidades oferecidas (musculacao, pilates, etc.).
-- idModalidade AUTO_INCREMENT (gerado pelo MySQL) - usado tambem pela
-- interface Web. Exemplo de UNIQUE no nome da modalidade.
CREATE TABLE Modalidade (
    idModalidade    INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nomeModalidade  VARCHAR(40)     NOT NULL,
    CONSTRAINT uk_modalidade_nome UNIQUE (nomeModalidade) -- EXEMPLO DE UNIQUE
);

-- Aluno: subclasse de Pessoa (heranca 1:1). cpf e PK e FK ao mesmo tempo.
-- Exemplo de DEFAULT: estado assume 'MG' e cidade 'Lavras' quando omitidos.
-- bairro e o unico atributo que aceita NULL.
-- FK para Plano com ON DELETE RESTRICT (nao deixa apagar plano em uso).
CREATE TABLE Aluno (
    cpf         CHAR(11)        NOT NULL,
    logradouro  VARCHAR(50)     NOT NULL,
    numero      INT             NOT NULL,
    bairro      VARCHAR(30)     NULL,
    cidade      VARCHAR(30)     NOT NULL DEFAULT 'Lavras',  -- EXEMPLO DE DEFAULT
    estado      CHAR(2)         NOT NULL DEFAULT 'MG',      -- EXEMPLO DE DEFAULT
    cep         CHAR(8)         NOT NULL,
    idPlano     INT             NOT NULL,
    dataAdesao  DATE            NOT NULL,
    dataTermino DATE            NOT NULL,
    CONSTRAINT pk_aluno        PRIMARY KEY (cpf),
    CONSTRAINT ck_aluno_numero CHECK (numero > 0),
    CONSTRAINT fk_aluno_pessoa FOREIGN KEY (cpf)
        REFERENCES Pessoa(cpf)    
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_aluno_plano  FOREIGN KEY (idPlano)
        REFERENCES Plano(idPlano) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Instrutor: subclasse de Pessoa (heranca 1:1). cpf PK e FK.
CREATE TABLE Instrutor (
    cpf         CHAR(11)        NOT NULL,
    salario     DECIMAL(8,2)    NOT NULL,
    CONSTRAINT pk_instrutor         PRIMARY KEY (cpf),
    CONSTRAINT ck_instrutor_salario CHECK (salario > 0),
    CONSTRAINT fk_instrutor_pessoa  FOREIGN KEY (cpf)
        REFERENCES Pessoa(cpf) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Turma: aula de uma modalidade, ministrada por um instrutor.
-- Duas FKs obrigatorias (modalidade e instrutor), ambas RESTRICT.
CREATE TABLE Turma (
    idTurma         INT             NOT NULL,
    horarioInicio   TIME            NOT NULL,
    sala            VARCHAR(20)     NOT NULL,
    idModalidade    INT             NOT NULL,
    cpfInstrutor    CHAR(11)        NOT NULL,
    CONSTRAINT pk_turma            PRIMARY KEY (idTurma),
    CONSTRAINT ck_turma_id         CHECK (idTurma > 0),
    CONSTRAINT fk_turma_modalidade FOREIGN KEY (idModalidade)
        REFERENCES Modalidade(idModalidade) ON DELETE RESTRICT,
    CONSTRAINT fk_turma_instrutor  FOREIGN KEY (cpfInstrutor)
        REFERENCES Instrutor(cpf)           
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Equipamento: equipamentos vinculados a uma modalidade.
CREATE TABLE Equipamento (
    numSerie        VARCHAR(20)     NOT NULL,
    nomeEquipamento VARCHAR(50)     NOT NULL,
    idModalidade    INT             NOT NULL,
    CONSTRAINT pk_equipamento            PRIMARY KEY (numSerie),
    CONSTRAINT fk_equipamento_modalidade FOREIGN KEY (idModalidade)
        REFERENCES Modalidade(idModalidade) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Matricula: tabela associativa N:M entre Aluno e Turma.
-- PK composta (cpfAluno, idTurma); as duas colunas sao FK (CASCADE).
CREATE TABLE Matricula (
    cpfAluno        CHAR(11)    NOT NULL,
    idTurma         INT         NOT NULL,
    dataMatricula   DATE        NOT NULL,
    CONSTRAINT pk_matricula       PRIMARY KEY (cpfAluno, idTurma),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (cpfAluno)
        REFERENCES Aluno(cpf)     ON DELETE CASCADE,
    CONSTRAINT fk_matricula_turma FOREIGN KEY (idTurma)
        REFERENCES Turma(idTurma) ON DELETE CASCADE
);