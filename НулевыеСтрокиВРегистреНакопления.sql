SELECT �����,
       ����������,
	   ������������,
	   CAST(������������ AS DECIMAL(10,2))/CAST(���������� AS DECIMAL(10,2)) AS �������������������
  FROM (SELECT _Period AS �����,
	           COUNT(*) AS ����������,
	           SUM(CASE WHEN _Fld26680 = 0 AND _Fld26681 = 0 THEN 1 ELSE 0 END) AS ������������
          FROM _AccumRgT26690
         GROUP BY _Period) AS �������������
 ORDER BY ����� DESC