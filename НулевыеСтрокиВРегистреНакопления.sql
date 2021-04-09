SELECT Месяц,
       КолвоСтрок,
	   НулевыхСтрок,
	   CAST(НулевыхСтрок AS DECIMAL(10,2))/CAST(КолвоСтрок AS DECIMAL(10,2)) AS ПроцентНулевыхСтрок
  FROM (SELECT _Period AS Месяц,
	           COUNT(*) AS КолвоСтрок,
	           SUM(CASE WHEN _Fld26680 = 0 AND _Fld26681 = 0 THEN 1 ELSE 0 END) AS НулевыхСтрок
          FROM _AccumRgT26690
         GROUP BY _Period) AS НулевыеСтроки
 ORDER BY Месяц DESC