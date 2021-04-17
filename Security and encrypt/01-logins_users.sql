-- ------------------------
-- Логины
-- ------------------------

-- windows-аутентификация
CREATE LOGIN "spw-pc\spv" FROM WINDOWS;

-- SQL Server аутентификация
-- DROP LOGIN user1
CREATE LOGIN user1 WITH PASSWORD = '123';

-- смотрим список логинов
SELECT * FROM sys.server_principals

-- отключение/включение пользователя
ALTER LOGIN user1 DISABLE;
ALTER LOGIN user1 ENABLE;

-- запретить подключение
DENY CONNECT SQL TO user1

-- разрешить подключение
GRANT CONNECT SQL TO user1

-- добавление к роли
ALTER SERVER ROLE diskadmin ADD MEMBER user1;  

-- кто входит в роли
exec sp_helpsrvrolemember 

-- удаление из роли
ALTER SERVER ROLE diskadmin DROP MEMBER user1;  

exec sp_helpsrvrolemember 

-- список ролей
exec sp_helpsrvrole 

-- разрешения ролей
exec sp_srvrolepermission 

select * from sys.server_role_members

-- проверка членства в роли
select IS_SRVROLEMEMBER('sysadmin', 'sa')

-- смотрим как это все выглядит в SSMS

-- ------------------------
-- Пользователи
-- ------------------------

USE WideWorldImporters

-- создание пользователя для логина
-- DROP USER user1 
CREATE USER user1 FOR LOGIN user1

-- добавление роли
EXEC sp_addrolemember 'db_datawriter', user1

-- создание роли
-- DROP ROLE CustomRole
CREATE ROLE CustomRole;
GRANT CREATE TABLE TO CustomRole;

-- добавляем к роли
EXEC sp_addrolemember 'CustomRole', user1;

-- sp_change_users_login 
EXEC sp_change_users_login @Action='Report';
EXEC sp_change_users_login 'Update_One', 'user', 'login';
EXEC sp_change_users_login 'Auto_Fix', 'user1'

-- 
select * from sys.database_principals
select * from sys.database_permissions
select * from sys.database_role_members



-- смотрим как это все выглядит в SSMS

