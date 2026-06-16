-- -----------------------------------------------------
-- Criação do Banco de Dados para a Academia
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS academia_gestao;
USE academia_gestao;

-- -----------------------------------------------------
-- Tabela: Pessoa
-- -----------------------------------------------------
-- Chave primária: cpf
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Pessoa (
    cpf CHAR(11) NOT NULL,
    nomePessoa VARCHAR(80) NOT NULL,
    dataNasc DATE NOT NULL,
    PRIMARY KEY (cpf)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Plano
-- -----------------------------------------------------
-- Chave primária: idPlano
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Plano (
    idPlano INT NOT NULL,
    nomePlano VARCHAR(30) NOT NULL,
    valor DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (idPlano)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Aluno
-- -----------------------------------------------------
-- Subclasse de Pessoa. 
-- FK idPlano -> Restrict (Bloqueio)
-- FK cpf -> Cascade (Propagação)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Aluno (
    cpf CHAR(11) NOT NULL,
    logradouro VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(30) NULL, -- Único campo que permite nulo conforme dicionário
    cidade VARCHAR(30) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    idPlano INT NOT NULL,
    dataAdesao DATE NOT NULL,
    dataTermino DATE NOT NULL,
    PRIMARY KEY (cpf),
    CONSTRAINT fk_Aluno_Pessoa
        FOREIGN KEY (cpf)
        REFERENCES Pessoa (cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Aluno_Plano
        FOREIGN KEY (idPlano)
        REFERENCES Plano (idPlano)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Instrutor
-- -----------------------------------------------------
-- Subclasse de Pessoa.
-- FK cpf -> Cascade (Propagação)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Instrutor (
    cpf CHAR(11) NOT NULL,
    salario DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (cpf),
    CONSTRAINT fk_Instrutor_Pessoa
        FOREIGN KEY (cpf)
        REFERENCES Pessoa (cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Modalidade
-- -----------------------------------------------------
-- Chave primária: idModalidade
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Modalidade (
    idModalidade INT NOT NULL,
    nomeModalidade VARCHAR(40) NOT NULL,
    PRIMARY KEY (idModalidade)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Turma
-- -----------------------------------------------------
-- FK idModalidade -> Restrict (Bloqueio)
-- FK cpfInstrutor -> Restrict (Bloqueio)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Turma (
    idTurma INT NOT NULL,
    horarioInicio TIME NOT NULL,
    sala VARCHAR(20) NOT NULL,
    idModalidade INT NOT NULL,
    cpfInstrutor CHAR(11) NOT NULL,
    PRIMARY KEY (idTurma),
    CONSTRAINT fk_Turma_Modalidade
        FOREIGN KEY (idModalidade)
        REFERENCES Modalidade (idModalidade)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_Turma_Instrutor
        FOREIGN KEY (cpfInstrutor)
        REFERENCES Instrutor (cpf)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Equipamento
-- -----------------------------------------------------
-- FK idModalidade -> Restrict (Bloqueio)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Equipamento (
    numSerie VARCHAR(20) NOT NULL,
    nomeEquipamento VARCHAR(50) NOT NULL,
    idModalidade INT NOT NULL,
    PRIMARY KEY (numSerie),
    CONSTRAINT fk_Equipamento_Modalidade
        FOREIGN KEY (idModalidade)
        REFERENCES Modalidade (idModalidade)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela: Matricula (Tabela Associativa M:N)
-- -----------------------------------------------------
-- Chave Primária Composta por (cpfAluno, idTurma)
-- Ambas as FKs possuem opção de exclusão CASCADE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Matricula (
    cpfAluno CHAR(11) NOT NULL,
    idTurma INT NOT NULL,
    dataMatricula DATE NOT NULL,
    PRIMARY KEY (cpfAluno, idTurma),
    CONSTRAINT fk_Matricula_Aluno
        FOREIGN KEY (cpfAluno)
        REFERENCES Aluno (cpf)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Matricula_Turma
        FOREIGN KEY (idTurma)
        REFERENCES Turma (idTurma)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;
