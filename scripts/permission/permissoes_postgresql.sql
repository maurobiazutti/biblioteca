-- Faz você "logar" como o usuário do sistema chamado 'postgres'  (psql tools)
sudo -i -u postgres

-- Para saber qual o Usuario estou logado
SELECT current_user;

--Ver se você é SUPERUSER:
SELECT rolsuper FROM pg_roles WHERE rolname = current_user;

-- Ver permissões em um banco de dados específico:
SELECT datname, has_database_privilege(current_user, datname, 'CONNECT') AS can_connect,
       has_database_privilege(current_user, datname, 'CREATE') AS can_create
FROM pg_database;

-- Ver suas permissões em todas as tabelas:
SELECT table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = current_user;

-- ######### CRIAR E EXCLUIR USUARIO ######### --

-- Para criar um Usuario
CREATE USER mauro_biazutti WITH PASSWORD '784512mbl';

-- EXCLUINDO USER
-- ANTES DE APAGAR UM USER OU ROLER
-- Verificar se o usuário é dono de algo:
SELECT datname FROM pg_database WHERE datdba = (SELECT oid FROM pg_roles WHERE rolname = 'mauri_bi');

-- Mudar a propriedade dos objetos (se precisar): Se ele for dono de tabelas, bancos, etc.
ALTER DATABASE nome_do_banco OWNER TO novo_usuario;
ALTER TABLE nome_da_tabela OWNER TO novo_usuario;

-- Finalizar a conexão se ele estiver conectado: 
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'nome_do_usuario';

--Depois disso, pode excluir tranquilo:
-- Para Excluir um Usuario
DROP ROLE mauro_bi;

-- ########################################### --

-- ######### Gerenciando Permições ########### --


-- Setando a permissão de leitura para todas as tabelas
GRANT pd_read_all_data TO mauro_biazutti;

-- Removendo a permissão de leitura para todas as tabelas
REVOKE pd_read_all_data TO mauro_biazutti;

-- Consedendo permição de leitura apenas para Duas Tabelas
GRANT SELECT ON TABLE addresses TO mauro_biazutti;
GRANT SELECT ON TABLE books TO mauro_biazutti;

-- Concedendo permissão de escrita em todas as tabelas
GRANT pg_write_all_data TO mauro_biazutti

-- ########################################### --

O que é ROLES
ROLES -> são um conjuntos de permissões que um Usuario pode ter.



