Declare @maxId DATE = '4021-01-05 17:00:00.000',
        @minId DATE = '4012-08-01 00:00:00.000';

WITH GenId (Id) AS 
(	SELECT @minId 
	UNION ALL
	SELECT DATEADD (month, 1, GenId.Id)
	FROM GenId 
	WHERE GenId.Id <= @maxId
)
 SELECT N._Description,
        CASE
		   WHEN SUM(RT._Fld17886) IS NULL THEN 0
		   ELSE SUM(RT._Fld17886)
	    END AS Сумма,
	    CASE
		   WHEN SUM(RT._Fld17870) IS NULL THEN 0
		   ELSE SUM(RT._Fld17870)
	    END AS КолВо,
	    YEAR(g.Id) AS Год,
	    EOMONTH(g.Id) AS ВсеМесяцы,
 	    MIN(R._Date_Time) AS МинДата
   FROM GenId g
        LEFT JOIN _Document654 AS R
	    ON EOMONTH(g.Id) = EOMONTH(R._Date_Time)
	    LEFT JOIN _Document654_VT17864 RT
	    ON RT._Document654_IDRRef = R._IDRRef
	    LEFT JOIN _Reference211 N
	    ON RT._Fld17873RRef = N._IDRRef
  GROUP BY YEAR(g.Id), EOMONTH(g.Id), N._Description
 HAVING CASE
		   WHEN SUM(RT._Fld17870) IS NULL THEN 0
		   ELSE SUM(RT._Fld17870)
 	    END < 50
  ORDER BY EOMONTH(g.Id)
 OPTION (MAXRECURSION 1000);

