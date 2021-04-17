-- ------------------------
-- ������
-- ------------------------

-- windows-��������������
CREATE LOGIN "spw-pc\spv" FROM WINDOWS;

-- SQL Server ��������������
-- DROP LOGIN user1
CREATE LOGIN user1 WITH PASSWORD = '123';

-- ������� ������ �������
SELECT * FROM sys.server_principals

-- ����������/��������� ������������
ALTER LOGIN user1 DISABLE;
ALTER LOGIN user1 ENABLE;

-- ��������� �����������
DENY CONNECT SQL TO user1

-- ��������� �����������
GRANT CONNECT SQL TO user1

-- ���������� � ����
ALTER SERVER ROLE diskadmin ADD MEMBER user1;  

-- ��� ������ � ����
exec sp_helpsrvrolemember 

-- �������� �� ����
ALTER SERVER ROLE diskadmin DROP MEMBER user1;  

exec sp_helpsrvrolemember 

-- ������ �����
exec sp_helpsrvrole 

-- ���������� �����
exec sp_srvrolepermission 

select * from sys.server_role_members

-- �������� �������� � ����
select IS_SRVROLEMEMBER('sysadmin', 'sa')

-- ������� ��� ��� ��� �������� � SSMS

-- ------------------------
-- ������������
-- ------------------------

USE WideWorldImporters

-- �������� ������������ ��� ������
-- DROP USER user1 
CREATE USER user1 FOR LOGIN user1

-- ���������� ����
EXEC sp_addrolemember 'db_datawriter', user1

-- �������� ����
-- DROP ROLE CustomRole
CREATE ROLE CustomRole;
GRANT CREATE TABLE TO CustomRole;

-- ��������� � ����
EXEC sp_addrolemember 'CustomRole', user1;

-- sp_change_users_login 
EXEC sp_change_users_login @Action='Report';
EXEC sp_change_users_login 'Update_One', 'user', 'login';
EXEC sp_change_users_login 'Auto_Fix', 'user1'

-- 
select * from sys.database_principals
select * from sys.database_permissions
select * from sys.database_role_members



-- ������� ��� ��� ��� �������� � SSMS

