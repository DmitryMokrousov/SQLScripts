-- -------------------------------
-- Dynamic Data Masking (DDM)
-- -------------------------------
CREATE DATABASE DdmDb
GO

USE DdmDb
GO

CREATE TABLE Membership(
	MemberID int IDENTITY PRIMARY KEY,
	FirstName varchar(100) MASKED WITH (FUNCTION = 'partial(2, "...", 2)') NULL,
	LastName varchar(100) NOT NULL,
	Phone varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,
	Email varchar(100) MASKED WITH (FUNCTION = 'email()') NULL)

-- информация   Dynamic Data Masking
SELECT
	t.name AS TableName,
	mc.name AS ColumnName,
	mc.masking_function AS MaskingFunction
FROM
	sys.masked_columns AS mc
	INNER JOIN sys.tables AS t ON mc.[object_id] = t.[object_id]

-- заполняем данными
INSERT INTO Membership (FirstName, LastName, Phone, Email) VALUES 
 ('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com'),
 ('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co'),
 ('Dan', 'Mu', '555.123.4569', 'ZMu@contoso.net'),
 ('Jane', 'Smith', '454.222.5920', 'Jane.Smith@hotmail.com'),
 ('Danny', 'Jones', '674.295.7950', 'Danny.Jones@hotmail.com')

-- У пользователя dbo есть разрешение UNMASK
SELECT * FROM Membership

-- Создаем пользоватебя без разрешения UNMASK 
CREATE USER TestUser WITHOUT LOGIN
GRANT SELECT ON Membership TO TestUser

-- As TestUser, the data is masked
EXECUTE AS USER = 'TestUser'
SELECT * FROM Membership
REVERT
GO

-- Даем разрешение UNMASK
GRANT UNMASK TO TestUser
EXECUTE AS USER = 'TestUser'
SELECT * FROM Membership
REVERT 
GO

-- Убираем UNMASK 
REVOKE UNMASK FROM TestUser
EXECUTE AS USER = 'TestUser'
SELECT * FROM Membership
REVERT 
GO

-- drop
DROP USER TestUser
DROP TABLE Membership

