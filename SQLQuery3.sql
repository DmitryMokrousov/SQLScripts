SELECT
	ISNULL(Справочник_НоменклатурныеГруппы._Description, '') AS НоменклатурнаяГруппа,
	Справочник_Номенклатура._Description AS Номенклатура,
	T1.Fld28225Turnover_ AS Количество,
	(T1.Fld28226Turnover_ - T1.Fld28228Turnover_) AS Стоимость,
	T1.Fld28228Turnover_ AS НДС,
	CAST(ISNULL(Цены.Цена, 0)*T1.Fld28225Turnover_ AS NUMERIC(27, 2)) AS Себестоимость,
	T1.Period_ AS Период
FROM (SELECT
		DATETIME2FROMPARTS(DATEPART(YEAR,T2._Period),DATEPART(MONTH,T2._Period),1,0,0,0,0,0) AS Period_,
		T2._Fld28216RRef AS Fld28216RRef,
		CAST(SUM(T2._Fld28226) AS NUMERIC(27, 2)) AS Fld28226Turnover_,
		CAST(SUM(T2._Fld28225) AS NUMERIC(27, 3)) AS Fld28225Turnover_,
		CAST(SUM(T2._Fld28228) AS NUMERIC(27, 2)) AS Fld28228Turnover_
	FROM dbo._AccumRgTn28235 T2 WITH(NOLOCK)
	WHERE ((T2._Fld28223RRef = 0xB776D1BEA10D0FA44D9F7A227FC1CAE2))
	AND (T2._Fld28226 <> 0 OR T2._Fld28225 <> 0 OR T2._Fld28228 <> 0)
	GROUP BY DATETIME2FROMPARTS(DATEPART(YEAR,T2._Period),DATEPART(MONTH,T2._Period),1,0,0,0,0,0),
	T2._Fld28216RRef
	HAVING (CAST(SUM(T2._Fld28226) AS NUMERIC(27, 2))) <> 0.0
	OR (CAST(SUM(T2._Fld28225) AS NUMERIC(27, 3))) <> 0.0
	OR (CAST(SUM(T2._Fld28228) AS NUMERIC(27, 2))) <> 0.0) T1
	LEFT JOIN _Reference211 AS Справочник_Номенклатура
		LEFT JOIN _Reference212 AS Справочник_НоменклатурныеГруппы
			ON  Справочник_Номенклатура._Fld3307RRef = Справочник_НоменклатурныеГруппы._IDRRef
		ON  T1.Fld28216RRef = Справочник_Номенклатура._IDRRef
	LEFT JOIN (SELECT
				T1.Fld26099RRef,
				T1.Fld26102_ AS Цена
				FROM (SELECT
					T4._Fld26099RRef AS Fld26099RRef,
					T4._Fld26102 AS Fld26102_
						FROM (SELECT
								T3._Fld26098RRef AS Fld26098RRef,
								T3._Fld26099RRef AS Fld26099RRef,
								T3._Fld26100RRef AS Fld26100RRef,
								MAX(T3._Period) AS MAXPERIOD_
							FROM dbo._InfoRg26097 T3 WITH(NOLOCK)
							WHERE T3._Active = 0x01 AND ((T3._Fld26098RRef = 0x80630025904F2CAA11E2B0AAFB9CDDC8))
							GROUP BY T3._Fld26098RRef,
								T3._Fld26099RRef,
								T3._Fld26100RRef) T2
					INNER JOIN dbo._InfoRg26097 T4 WITH(NOLOCK)
						ON T2.Fld26098RRef = T4._Fld26098RRef
						AND T2.Fld26099RRef = T4._Fld26099RRef
						AND T2.Fld26100RRef = T4._Fld26100RRef
						AND T2.MAXPERIOD_ = T4._Period) T1) AS Цены
		ON  T1.Fld28216RRef = Цены.Fld26099RRef
