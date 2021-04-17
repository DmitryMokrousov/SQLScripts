-- -------------------------------
-- Row-Level Security (RLS) 
-- -------------------------------
CREATE DATABASE RlsDB;
GO 

USE RlsDB
GO

CREATE TABLE Sales(
    OrderID int,
    SalesUsername varchar(50),
    Product varchar(10),
    Qty int
)

INSERT Sales VALUES 
	(1, 'SalesUser1', 'Valve', 5), 
	(2, 'SalesUser1', 'Wheel', 2), 
	(3, 'SalesUser1', 'Valve', 4),
	(4, 'SalesUser2', 'Bracket', 2), 
	(5, 'SalesUser2', 'Wheel', 5), 
	(6, 'SalesUser2', 'Seat', 5)

-- Что там есть
SELECT * FROM Sales

-- Создане пользователей
CREATE USER ManagerUser WITHOUT LOGIN
CREATE USER SalesUser1 WITHOUT LOGIN
CREATE USER SalesUser2 WITHOUT LOGIN

-- Предоставляем права
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO ManagerUser
GRANT SELECT ON Sales TO SalesUser1
GRANT SELECT ON Sales TO SalesUser2
GO

-- Схема для предикатов
CREATE SCHEMA sec
GO

-- predicate-функция
CREATE FUNCTION sec.fn_securitypredicate(@Username AS varchar(50))
    RETURNS TABLE
	WITH SCHEMABINDING
AS
    RETURN
		SELECT
			1 AS fn_securitypredicate_result 
		WHERE
			DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID(@Username) OR
			DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID('ManagerUser')
GO

-- Создаем SECURITY POLICY
CREATE SECURITY POLICY sec.SalesPolicyFilter
	ADD FILTER PREDICATE sec.fn_securitypredicate(SalesUsername) 
	ON dbo.Sales
	WITH (STATE = ON)

-- Для пользователя dbo должно быть пусто
-- (нет строк, где SalesUsername = 'dbo')
SELECT * FROM Sales 
SELECT COUNT(*) FROM Sales

EXECUTE AS USER = 'SalesUser1'
SELECT * FROM Sales 
SELECT COUNT(*) FROM Sales
REVERT

EXECUTE AS USER = 'SalesUser2'
SELECT * FROM Sales 
SELECT COUNT(*) FROM Sales
REVERT

EXECUTE AS USER = 'ManagerUser'
SELECT * FROM Sales 
REVERT

-- нельзя insert/update/delete
EXECUTE AS USER = 'SalesUser1'
INSERT Sales VALUES (7, 'SalesUser1', 'Valve', 2)
UPDATE Sales SET Product = 'Screw' WHERE OrderId = 3
DELETE Sales WHERE OrderId = 2
REVERT

-- Можно все
EXECUTE AS USER = 'ManagerUser'
INSERT Sales VALUES (7, 'SalesUser2', 'Valve', 1)		-- New item for order id 7 (SalesUser2)
UPDATE Sales SET Product = 'Screw' WHERE OrderId = 3	-- Changed product name for order id 3 (SalesUser1)
UPDATE Sales SET SalesUsername = 'SalesUser1' WHERE SalesUsername = 'SalesUser2' AND Qty > 3	-- reassign SalesUser1 items with Qty > 3 (order ids 5 & 6) to SalesUser2
DELETE Sales WHERE OrderId = 2							-- Delete item for order id 2 (SalesUser1)
SELECT * FROM Sales
REVERT

EXECUTE AS USER = 'SalesUser1'
SELECT * FROM Sales	
SELECT COUNT(*) FROM Sales
REVERT

EXECUTE AS USER = 'SalesUser2'
SELECT * FROM Sales
SELECT COUNT(*) FROM Sales
REVERT

-- Вкл/выкл  SECURITY POLICY
SELECT * FROM Sales

ALTER SECURITY POLICY sec.SalesPolicyFilter WITH (STATE = OFF)
SELECT * FROM Sales

ALTER SECURITY POLICY sec.SalesPolicyFilter WITH (STATE = ON)

-- drop
DROP SECURITY POLICY sec.SalesPolicyFilter
DROP FUNCTION sec.fn_securitypredicate
DROP SCHEMA sec
DROP USER ManagerUser
DROP USER SalesUser1
DROP USER SalesUser2
DROP TABLE Sales

