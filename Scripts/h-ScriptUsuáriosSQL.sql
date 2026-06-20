-- #####################################################################
-- (h) USUARIOS, GRANT E REVOKE
-- #####################################################################

-- Cria dois usuarios (IF NOT EXISTS deixa o script re-executavel).
CREATE USER IF NOT EXISTS 'recepcao'@'localhost' IDENTIFIED BY 'senha123';
CREATE USER IF NOT EXISTS 'gerente'@'localhost'  IDENTIFIED BY 'senha456';

-- Concede a recepcao permissao de consultar/inserir/atualizar alunos
-- e de consultar a view de alunos x plano.
GRANT SELECT, INSERT, UPDATE ON academia.Aluno         TO 'recepcao'@'localhost';
GRANT SELECT                 ON academia.vw_aluno_plano TO 'recepcao'@'localhost';

-- Concede ao gerente todos os privilegios sobre o banco academia.
GRANT ALL PRIVILEGES ON academia.* TO 'gerente'@'localhost';

-- Revoga da recepcao a permissao de alterar dados de alunos.
REVOKE UPDATE ON academia.Aluno FROM 'recepcao'@'localhost';

-- Aplica as alteracoes de privilegios.
FLUSH PRIVILEGES;

-- Consulta para conferir as permissoes atuais da recepcao.
SHOW GRANTS FOR 'recepcao'@'localhost';
