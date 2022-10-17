SELECT *
FROM dbo.heart$

-- For starters, we are going to perform EDA
-- 1. Data cleaning

SELECT caa
FROM dbo.heart$
WHERE caa>3
-- caa range is from 0-3 so we are going to set them to 0 as they are not causing the disease. (correspoding THal and cp show normal)
Update dbo.heart$
SET caa=0
where caa>3

-- Removing duplicates
WITH rownumCTE AS ( 
    SELECT *, ROW_NUMBER() OVER ( PARTITION by  age, sex, cp, caa, thall, output ORDER BY age) rownum
    FROM dbo.heart$
	)
	DELETE
	FROM rownumCTE
	WHERE rownum>1

--VISUALIZATION and ANALYSIS
-- Diseases vs Non-diseases in heart disease class
SELECT dbo.heart$.output
FROM dbo.heart$ 
	 
--Age distribution
SELECT dbo.heart$.age
FROM dbo.heart$ 
ORDER BY age

-- sex distribution according to target output
SELECT COUNT(sex), sex, dbo.heart$.output 
FROM dbo.heart$ 
GROUP BY sex, dbo.heart$.output

-- chest pain distribution according to target
SELECT COUNT(cp), cp ,dbo.heart$.output 
from dbo.heart$
GROUP BY cp, dbo.heart$.output 
ORDER BY cp
-- fbs cannot be used as a indicating paramter between a diseased and non diseased heart patient as there are a higher no of heart diseases without dbs
SELECT COUNT(fbs), fbs ,dbo.heart$.output 
from dbo.heart$
GROUP BY fbs, dbo.heart$.output 
ORDER BY fbs

--slope distritbution wrt target output
SELECT COUNT(slp),slp, dbo.heart$.output
FROM dbo.heart$
GROUP BY slp, dbo.heart$.output
--