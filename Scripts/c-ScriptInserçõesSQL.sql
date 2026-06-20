-- #####################################################################
-- (c) INSERCOES (pelo menos 5 por tabela)
--     Insercoes feitas com lista de colunas explicita, respeitando a
--     ordem das chaves estrangeiras.
-- #####################################################################

-- Pessoa (16 registros: 5 viram instrutores, 11 viram alunos)
INSERT INTO Pessoa (cpf, nomePessoa, dataNasc) VALUES
 ('11111111111','Ana Souza',       '1985-03-12'),
 ('22222222222','Bruno Lima',      '1990-07-25'),
 ('33333333333','Carla Mendes',    '1988-11-02'),
 ('44444444444','Diego Rocha',     '1992-01-30'),
 ('55555555555','Eduarda Pinto',   '1983-06-18'),
 ('60000000001','Felipe Alves',    '2000-02-14'),
 ('60000000002','Gabriela Dias',   '1999-09-09'),
 ('60000000003','Henrique Costa',  '2001-12-05'),
 ('60000000004','Isabela Nunes',   '1997-04-21'),
 ('60000000005','Joao Pereira',    '1995-08-17'),
 ('60000000006','Karina Santos',   '2002-03-03'),
 ('60000000007','Lucas Martins',   '1998-10-28'),
 ('60000000008','Mariana Oliveira','2000-05-11'),
 ('60000000009','Nicolas Ferreira','1996-07-07'),
 ('60000000010','Olivia Ramos',    '2003-01-22'),
 ('60000000011','Paulo Henrique',  '1994-12-12');

-- Plano (5 registros)
INSERT INTO Plano (idPlano, nomePlano, valor) VALUES
 (1,'Mensal',     99.90),
 (2,'Trimestral',269.90),
 (3,'Semestral', 499.90),
 (4,'Anual',     899.90),
 (5,'Estudante',  79.90);

-- Modalidade (6 registros). idModalidade e auto_increment; passamos os
-- valores explicitos para casar com as FKs abaixo.
INSERT INTO Modalidade (idModalidade, nomeModalidade) VALUES
 (1,'Musculacao'),
 (2,'Crossfit'),
 (3,'Pilates'),
 (4,'Spinning'),
 (5,'Natacao'),
 (6,'Funcional');

-- Instrutor (5 registros). Insercao com lista de colunas (cpf, salario)
-- por causa da coluna dataContratacao adicionada no item (b).
INSERT INTO Instrutor (cpf, salario) VALUES
 ('11111111111',3500.00),
 ('22222222222',3200.00),
 ('33333333333',4100.00),
 ('44444444444',2900.00),
 ('55555555555',4500.00);

-- Aluno (11 registros). Note os bairros NULL (Gabriela, Joao, Nicolas).
INSERT INTO Aluno (cpf, logradouro, numero, bairro, cidade, estado, cep, idPlano, dataAdesao, dataTermino) VALUES
 ('60000000001','Rua A',  100,'Centro',   'Lavras', 'MG','37200000',1,'2025-01-10','2025-02-10'),
 ('60000000002','Rua B',  200, NULL,      'Lavras', 'MG','37200001',2,'2025-02-01','2025-05-01'),
 ('60000000003','Av C',   300,'Jardim',   'Lavras', 'MG','37200002',3,'2025-03-15','2025-09-15'),
 ('60000000004','Rua D',   45,'Centro',   'Lavras', 'MG','37200003',4,'2025-01-20','2026-01-20'),
 ('60000000005','Rua E', 1200, NULL,      'Ijaci',  'MG','37205000',5,'2025-04-01','2025-05-01'),
 ('60000000007','Av G',   999,'Centro',   'Perdoes','MG','37260000',2,'2025-02-20','2025-05-20'),
 ('60000000008','Rua H',   12,'Aeroporto','Lavras', 'MG','37200005',3,'2025-06-01','2025-12-01'),
 ('60000000009','Rua I',  350, NULL,      'Lavras', 'MG','37200006',4,'2024-12-01','2025-12-01'),
 ('60000000010','Rua J',   64,'Centro',   'Lavras', 'MG','37200007',5,'2025-03-01','2025-04-01'),
 ('60000000011','Rua K',   88,'Jardim',   'Lavras', 'MG','37200008',1,'2025-07-01','2025-08-01');

-- Insercao que OMITE cidade e estado para demonstrar os valores DEFAULT
-- ('Lavras' e 'MG' sao preenchidos automaticamente).
INSERT INTO Aluno (cpf, logradouro, numero, bairro, cep, idPlano, dataAdesao, dataTermino) VALUES
 ('60000000006','Rua F', 78,'Vila Nova','37200004',1,'2025-05-10','2025-06-10');

-- Turma (6 registros). Cada turma referencia uma modalidade e um instrutor.
INSERT INTO Turma (idTurma, horarioInicio, sala, idModalidade, cpfInstrutor) VALUES
 (1,'07:00:00','Sala 1', 1,'11111111111'),
 (2,'08:00:00','Sala 2', 2,'22222222222'),
 (3,'09:00:00','Sala 3', 3,'33333333333'),
 (4,'18:00:00','Sala 1', 4,'44444444444'),
 (5,'19:00:00','Piscina',5,'55555555555'),
 (6,'06:00:00','Sala 2', 6,'11111111111');

-- Equipamento (8 registros).
INSERT INTO Equipamento (numSerie, nomeEquipamento, idModalidade) VALUES
 ('EQ001','Esteira',         1),
 ('EQ002','Leg Press',       1),
 ('EQ003','Barra Olimpica',  2),
 ('EQ004','Bola Suica',      3),
 ('EQ005','Bike Spinning',   4),
 ('EQ006','Prancha Natacao', 5),
 ('EQ007','Kettlebell',      6),
 ('EQ008','Anilha 10kg',     1);

-- Matricula (13 registros: aluno x turma).
INSERT INTO Matricula (cpfAluno, idTurma, dataMatricula) VALUES
 ('60000000001',1,'2025-01-11'),
 ('60000000001',6,'2025-01-12'),
 ('60000000002',2,'2025-02-02'),
 ('60000000003',3,'2025-03-16'),
 ('60000000004',1,'2025-01-21'),
 ('60000000004',4,'2025-01-22'),
 ('60000000005',5,'2025-04-02'),
 ('60000000006',2,'2025-05-11'),
 ('60000000007',3,'2025-02-21'),
 ('60000000008',6,'2025-06-02'),
 ('60000000009',4,'2025-12-02'),
 ('60000000010',5,'2025-03-02'),
 ('60000000011',1,'2025-07-02');
