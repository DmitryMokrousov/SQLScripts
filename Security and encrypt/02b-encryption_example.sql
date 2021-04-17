-----------------------------------
-- SYMMETRIC KEY
-----------------------------------
USE AdventureWorks2016CTP3;
GO

SELECT p.FirstName, p.LastName, e.BirthDate
FROM Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY p.LastName, p.FirstName;
GO

CREATE SYMMETRIC KEY EmployeeSKey 
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'P@ssw0rd';

SELECT *
FROM sys.symmetric_keys;

OPEN SYMMETRIC KEY EmployeeSKey 
DECRYPTION BY PASSWORD = 'P@ssw0rd';

SELECT * FROM sys.openkeys;

SELECT p.FirstName, p.LastName, 
	ENCRYPTBYKEY(KEY_GUID('EmployeeSKey'), CAST(e.BirthDate as NVARCHAR(20))) as WhoKnows
FROM Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY p.LastName, p.FirstName;
GO

CLOSE SYMMETRIC KEY EmployeeSKey;

-- если ключ закрыт
SELECT * FROM sys.openkeys;
GO

SELECT p.FirstName, p.LastName, 
	ENCRYPTBYKEY(KEY_GUID('EmployeeSKey'), CAST(e.BirthDate as NVARCHAR(20))) as WhoKnows
FROM Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY p.LastName, p.FirstName;
GO

-- можно указать несколько паролей
CREATE SYMMETRIC KEY UserSKey 
WITH ALGORITHM = AES_256 
ENCRYPTION BY PASSWORD = 'P@ssw0rd 111', 
PASSWORD = 'P@ssw0rd 222'; 

OPEN SYMMETRIC KEY UserSKey 
DECRYPTION BY PASSWORD = 'P@ssw0rd 111';

ALTER SYMMETRIC KEY UserSKey 
DROP ENCRYPTION BY PASSWORD = 'P@ssw0rd 222'

CLOSE SYMMETRIC KEY UserSKey 

-----------------------------------
-- ASYMMETRIC KEY
-----------------------------------
USE AdventureWorks2016CTP3;
GO
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'P@ssw0rd';

DROP SYMMETRIC KEY EmployeeSKey;
DROP ASYMMETRIC KEY EmployeeASKey;

CREATE ASYMMETRIC KEY EmployeeASKey 
WITH ALGORITHM = RSA_2048;

CREATE SYMMETRIC KEY EmployeeSKey 
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY EmployeeASKey;

OPEN SYMMETRIC KEY EmployeeSKey 
DECRYPTION BY ASYMMETRIC KEY EmployeeASKey;

SELECT * FROM sys.openkeys;

SELECT p.FirstName, p.LastName, 
	ENCRYPTBYKEY(KEY_GUID('EmployeeSKey'), CAST(e.BirthDate as NVARCHAR(20))) as WhoKnows
FROM Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY p.LastName, p.FirstName;
GO

CLOSE SYMMETRIC KEY EmployeeSKey;

-- cleaning
DROP SYMMETRIC KEY EmployeeSKey;
DROP ASYMMETRIC KEY EmployeeASKey;