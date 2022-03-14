---------------------------------------------------------------------------------------------
-- INTRODUCE THE PROJECT
-- BREAK THE PROJECT INTO WORKABLE SEGMENTS
-- FOLLOW ALONG TILL YOU NEED TO JOT FROM YOUR MEMORY
-- LOOK FOR ALT IN EACH TECHNIQUE PRESENTED 
-- TAKE DOWN NOTES AND CODE SYNTAXES
---------------------------------------------------------------------------------------------

/*
PROJECT:
Clean the Housing data for all Nahville houses registered in the government records
*/

/*
BREAKDOWN:
I. Standardize Date Format on SaleDate Column
II. Populate PropertyAddress to remove all null values
III,IV. Split Address into Individual Columns (Address, City, State)
V. Change Y and N to Yes and No in Sold As Vacant column
VI. Remove duplicates
VII. Remove unused columns
*/


/*
FORMULA INDEX AND SYNTAX
1.tip: Ctrl + E - execute

2. ALTER TABLE - used to add, delete, or modify columns in an existing table
ALTER TABLE table_name
ADD column_name datatype
or
ALTER TABLE table_name
DROP COLUMN column_name
or
ALTER TABLE table_name
ALTER COLUMN column_name datatype

3.INNER JOIN - selects records that have matching values in both tables.
SELECT column_name(s)
FROM table_name1
INNER JOIN table_name2
ON table_name1.column_name=table_name2.column_name

4.tip: Alt + arrow keys would move the line your cursor is on

5. ISNULL- returns a specified value if the expression is NULL.
ISNULL(expression, value)
memory tip- ISNULL(expression)=value

6. UPDATE is used to modify the existing records in a table.
UPDATE [tablename]
SET [col1] = [col2],
   [col2] = [col1]

7. SUBSTRING() function extracts some characters from a string and leaves the rest
SUBSTRING(string, start, length)
	string: The string to extract from
	start: The start position. The first position in string is 1
	length: The number of characters to extract. Must be a positive number

8. CHARINDEX() function searches for a substring in a string, and returns the position or 0 if the substring is not found.
CHARINDEX(substring, string, opt:start)
	substring: The substring to search for
	string: The string to be searched
	start: Optional.The position where the search will start (if you do not want to start at the beginning of string). The first position in string is 1
e.g. SELECT CHARINDEX('t', 'Customer') 

9.tip: Use Datatype Nvarchar(255) when the string you want to create may be large. This is the largest number in SQL for CHARs.

10. PARSENAME() Function examines any object(esp strings) and breaks it into its component parts by delimiter '.' Note, it does this in a backwards fashion
PARSENAME ('object_name' , object_piece )
e.g SELECT PARSENAME('Adventure.dbo.DimCustomer', 1) ;  ans: DimCustomer
	SELECT PARSENAME('Adventure.dbo.DimCustomer', 3) ;  ans: Adventure
	SELECT PARSENAME('Adventure.dbo.DimCustomer', 4) ;  ans: Null

11. REPLACE() function replaces all occurrences of a substring within a string, with a new substring
REPLACE(string, old_string, new_string)

12. CASE goes through the conditions like an if..else..then statement
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;

13. ROW NUMBER returns the sequential number of a row within a partition of a result set, starting at 1 for the first row in each partition.
	ROW_NUMBER ( )   
    OVER ( [ PARTITION BY column_name , ... [ n ] ] order_by_clause ) 
		Partition by: Divides the result set into partitions to which the ROW_NUMBER function is applied. 
		Order by: defines the logical order of the rows within each partition.

14. WITH common_table_expression (aka CTE)
Define the CTE expression name and column list.  
WITH CTE expression name (opt col1 col2 ,...)
AS 
(
-- Define the CTE query (usually the cols will be derived from our original database col)
)
-- Define the outer query referencing the CTE name (only accepts SELECT, INSERT, UPDATE, DELETE or MERGE statements)

	
-- e.g.
WITH Sales_CTE (SalesPersonID, NumberOfOrders)  
AS  
(  
    SELECT SalesPersonID, COUNT(*)  
    FROM Sales.SalesOrderHeader   
)  
SELECT AVG(NumberOfOrders) 
FROM Sales_CTE;  




*/

---------------------------------------------------------------------------------------------
-- I. Standardize Date Format on SaleDate Column
---------------------------------------------------------------------------------------------
-- i. Observe the SaleDate Column
SELECT SaleDate
FROM PortfolioProject..HousingData
-- ii. Change the date format to exclude the time
-- Soln : ALTER the SaleDate column to time
ALTER TABLE PortfolioProject..HousingData
ALTER COLUMN SaleDate date

---------------------------------------------------------------------------------------------
-- II. Populate PropertyAddress to remove all null values
---------------------------------------------------------------------------------------------
--i. Observe the PropertyAddress Column 
SELECT PropertyAddress
FROM PortfolioProject..HousingData
--ii. Observe the null PropertyAddress Columns - 29 rows
SELECT *
FROM PortfolioProject..HousingData
WHERE PropertyAddress is NULL
--iii. Insight: ParcelID is the identification code assigned to a property. So if there is a repeat ParcelID, it's referring to the same Property
--iv. INNER JOIN the table to compare the ParcelIDs and match PropertyAddresses
SELECT T1.ParcelID , T1.PropertyAddress, T2.ParcelID , T2.PropertyAddress
FROM PortfolioProject..HousingData T1
INNER JOIN PortfolioProject..HousingData T2
ON T1.ParcelID = T2.ParcelID
--v. INNER JOIN the table and use IS NULL to replace null Property addresses in T2
SELECT T1.ParcelID , T1.PropertyAddress, T2.ParcelID , T2.PropertyAddress, ISNULL(T1.PropertyAddress, T2.PropertyAddress) AS CleanedPropertyAddress
FROM PortfolioProject..HousingData T1
INNER JOIN PortfolioProject..HousingData T2
ON T1.ParcelID = T2.ParcelID
WHERE T1.[UniqueID ]<>T2.[UniqueID ]
AND T2.PropertyAddress is NULL

--vi. SET PropertyAddress column to CleanedPropertyAddress
UPDATE T1
SET [PropertyAddress] = ISNULL(T1.PropertyAddress, T2.PropertyAddress)
FROM PortfolioProject..HousingData T1
INNER JOIN PortfolioProject..HousingData T2
ON T1.ParcelID = T2.ParcelID
WHERE T1.[UniqueID ]<>T2.[UniqueID ]
AND T2.PropertyAddress is NULL

---------------------------------------------------------------------------------------------
-- III. Split Address into Individual Columns (Address, State) 
---------------------------------------------------------------------------------------------
--i. Observe the PropertyAddress Column 
SELECT PropertyAddress
FROM PortfolioProject..HousingData
--ORDER BY PropertyAddress DESC
--ii. Get the address SUBSTRING out of the string PropertyAddress
--syn 7. SUBSTRING(string, start, length)
--syn 8. CHARINDEX(substring, string, opt:start)
--		length: up to ',' use CHARINDEX	to find index vlaue for ','
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) AS PropertySplitAddress
FROM PortfolioProject..HousingData
--iii. Get the city SUBSTRING out of the string PropertyAddress
SELECT SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress) ) AS PropertySplitCity
FROM PortfolioProject..HousingData
ORDER BY PropertySplitCity 
--iv. ADD the PropertySplitAddress and PropertySplitCity columns
--syn 2. ALTER TABLE table_name; ADD column_name datatype
--tip 9. Use Datatype Nvarchar(255) when the string you want to create may be large.
--syn 6. UPDATE [tablename]; SET [col1] = [col2], [col2] = [col1]

ALTER TABLE PortfolioProject..HousingData
ADD PropertySplitAddress Nvarchar(255)

ALTER TABLE PortfolioProject..HousingData
ADD PropertySplitCity Nvarchar(255)

UPDATE PortfolioProject..HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 )

UPDATE PortfolioProject..HousingData
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress) )

--v. Observe the Outcome
SELECT *
FROM PortfolioProject..HousingData

---------------------------------------------------------------------------------------------
-- III. Split Address into Individual Columns (Address, City, State) 
---------------------------------------------------------------------------------------------
--i. Observe the OwnerAddress Column 
SELECT OwnerAddress
FROM PortfolioProject..HousingData
--ii. Split the address with the PARSENAME() into (Address, City, State) 
-- caution: PARSENAME only works when the string delimiter is a '.', ours is a ','
--syn 9.PARSENAME ('object_name' , object_piece )
--syn 10.REPLACE(string, old_string, new_string)

SELECT 
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) AS OwnerSplitAddress, 
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) AS OwnerSplitCity,
	PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) AS OwnerSplitState
FROM PortfolioProject..HousingData
--iii. ADD the OwnerSplitAddress and OwnerSplitCity columns to the table
--syn 2. ALTER TABLE tablename; ADD columnname datatype
--syn. UPDATE tablename; SET col1 = col2 , col2 = col1 
ALTER TABLE PortfolioProject..HousingData
ADD OwnerSplitAddress Nvarchar(255)

ALTER TABLE PortfolioProject..HousingData
ADD OwnerSplitCity Nvarchar(255)

ALTER TABLE PortfolioProject..HousingData
ADD OwnerSplitState Nvarchar(255)

UPDATE PortfolioProject..HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

UPDATE PortfolioProject..HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

UPDATE PortfolioProject..HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

--v. Observe the Outcome
SELECT *
FROM PortfolioProject..HousingData

---------------------------------------------------------------------------------------------
-- V. Change Y and N to Yes and No in SoldAsVacant column
---------------------------------------------------------------------------------------------
--i. observe the SoldAsVacant
SELECT SoldAsVacant
FROM PortfolioProject..HousingData

SELECT COUNT(SoldAsVacant)
FROM PortfolioProject..HousingData

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..HousingData
GROUP BY SoldAsVacant
ORDER BY 2
--ii. change Y and N using the CASE ...WHEN...THEN...ELSE...THEN statement
--syn 11. CASE ; WHEN condition1 THEN result1 ; WHEN conditionN THEN resultN; ELSE result;END
SELECT
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..HousingData
--iii. UPDATE the table to reflect change to SoldAsVacant column
--syn. UPDATE tablename ; SET col1 = col2 , col2 = col1
UPDATE PortfolioProject..HousingData
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
--iv. Observe the Outcome
SELECT *
FROM PortfolioProject..HousingData

---------------------------------------------------------------------------------------------
-- V. Remove Duplicates
---------------------------------------------------------------------------------------------
--i. highlight the duplicate rows using ROWNUMBER 
--syn.ROW_NUMBER ( ); OVER ( [ PARTITION BY column_name , ... [ n ] ] order_by_clause ) 
--			Partition by: Divides the result set into partitions to which the ROW_NUMBER function is applied. 
--			Order by: Defines the logical order of the rows within each partition.

SELECT ROW_NUMBER()
OVER (
PARTITION BY ParcelID, SaleDate, SalePrice, LegalReference
ORDER BY UniqueID
)
FROM PortfolioProject..HousingData
--iii. Remove the duplicates using CTE
--syn. WITH CTE_name (opt col1 col2 ,...) AS (inner CTE query that draws on original table); outer query referencing our CTE_name (only SELECT, DELETE, INSERT, UPDATE, MERGE)
WITH RowNumCTE AS (
SELECT *, 
ROW_NUMBER() OVER (
	PARTITION BY ParcelID,SaleDate, SalePrice, LegalReference
	ORDER BY UniqueID
) row_num
FROM PortfolioProject..HousingData
)

-- SELECT * (just checking before deleting)
DELETE
FROM RowNumCTE
WHERE row_num = 2

---------------------------------------------------------------------------------------------
-- VI. Remove unused columns (OwnerAddress, PropertyAddress, TaxDistrict)
---------------------------------------------------------------------------------------------
--syn. ALTER TABLE table_name; DROP COLUMN column_name

ALTER TABLE PortfolioProject..HousingData
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict
--v. Observe the Outcome
SELECT *
FROM PortfolioProject..HousingData
