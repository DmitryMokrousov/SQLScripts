-----------------------------------
-- SMK - SERVICE MASTER KEY
-----------------------------------

-- backup SMK
BACKUP SERVICE MASTER KEY TO FILE = 'D:\otus\mssql\smk.key' 
ENCRYPTION BY PASSWORD = 'P@ssw0rd';

-- restore SMK
RESTORE SERVICE MASTER KEY FROM FILE = 'D:\otus\mssql\smk.key' 
DECRYPTION BY PASSWORD = 'P@ssw0rd';

-----------------------------------
-- DMK - DATABASE MASTER KEY 
-----------------------------------
USE WideWorldImporters;

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'P@ssw0rd';

DROP MASTER KEY;

-- �������������

OPEN MASTER KEY 
DECRYPTION BY PASSWORD = 'P@ssw0rd';
-- do something here
CLOSE MASTER KEY;

-- ����� DMK ����������� SMK
SELECT name, is_master_key_encrypted_by_server
FROM sys.databases
ORDER BY name;

-- � ����� �� ���� DMK
SELECT * 
FROM sys.symmetric_keys 
WHERE symmetric_key_id = 101;

-----------------------------------
-- TDE - ���������� ����������
-----------------------------------
-- ����� ������� DMK � ���������� � master
USE master;

DROP MASTER KEY;

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'MasterP@ssw0rd';

-- ����� �����
--BACKUP MASTER KEY TO FILE = 'D:\otus\mssql\SQL2012_master.dmk' 
--ENCRYPTION BY PASSWORD = 'P@ssw0rd';

CREATE CERTIFICATE DemoTdeCertificate 
WITH SUBJECT = 'DemoTdeCertificate';

CREATE DATABASE EncryptedDB;
GO

USE EncryptedDB;
GO

-- ���� ��� ��
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_192
ENCRYPTION BY SERVER CERTIFICATE DemoTdeCertificate;

-- �������� ����������
ALTER DATABASE EncryptedDB
SET ENCRYPTION ON;

-- metadata 
SELECT name 
FROM sys.databases
WHERE is_encrypted = 1;

SELECT *
FROM sys.dm_database_encryption_keys;

-- ��� �������������� �� ������ �������
-- -- ������� ����� �����
BACKUP CERTIFICATE DemoTdeCertificate TO FILE = 'd:\otus\mssql\EncryptedDB.cer' 
	WITH PRIVATE KEY ( 
		FILE  = 'd:\otus\mssql\EncryptedDB.pvk', 
		ENCRYPTION BY PASSWORD = 'P@ssw0rd' 
);
GO

-- -- � ������������ �� ������ �������
USE master;
CREATE CERTIFICATE DemoTdeCertificate FROM FILE = 'd:\otus\mssql\EncryptedDB.cer' 
	WITH PRIVATE KEY ( 
		FILE  = 'd:\otus\mssql\EncryptedDB.pvk', 
		DECRYPTION BY PASSWORD = 'P@ssw0rd'
);

-- ------------------------
-- ���������� ������
-- ------------------------

USE master;

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Pa$$word';

BACKUP DATABASE EncryptedDB 
TO DISK = 'd:\otus\mssql\EncryptedDB.bak'
WITH ENCRYPTION 
  (ALGORITHM = AES_256, SERVER CERTIFICATE = DemoTdeCertificate), FORMAT;


-----------------------------------
-- HASH
-----------------------------------
USE EncryptedDB;
GO

CREATE TABLE dbo.LoginPassword ( 
	Login NVARCHAR(50) NOT NULL PRIMARY KEY, 
	Password BINARY(64) NOT NULL 
); 
GO

INSERT INTO dbo.LoginPassword 
VALUES ('User1', HASHBYTES('SHA2_512', N'123456'));
GO

SELECT * FROM dbo.LoginPassword

SELECT * 
FROM dbo.LoginPassword 
WHERE Login = 'User1' 
AND Password = HASHBYTES('SHA2_512', N'123456') 
