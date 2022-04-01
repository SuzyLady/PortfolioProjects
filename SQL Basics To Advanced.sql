/*ORDER BY colname or coln in the list*/  /*orders a col asc or desc*/
/*OFFSET n ROWS*/  /*truncate the top n rows*/
/*FETCH NEXT n ROWS ONLY*/ /*FETCH FIRST n ROWS ONLY*/

SELECT *
FROM PortfolioProject..healthy_lifestyle_city_2021
ORDER BY City
OFFSET 1 ROW
FETCH NEXT 7 ROWS ONLY 

/*WHERE colname  operation/expression  value*/ /*operations- < > = , expressions BETWEEN, LIKE, IN */
/*WHERE NOT colname operator value*/

/*Data Types*/ /*DATEADD(interval, n, date) - interval: year,month,day,hour..*/
SELECT  GETDATE() AS today_date,
		CURRENT_TIMESTAMP AS current_time_stamp,
		SYSDATETIME() AS systems_date,
		DATEADD(day, 2, '2020-01-23') AS date_add,
		DATEDIFF(yyyy, '2020-01-23', '2010-01-23') AS date_diff,
		DATEFROMPARTS(2020,01,03) AS meshed_date,
		DATENAME(DAY,'2020-01-23') AS retrieve_date_intervals, --returns a char,
		DATEPART(DAY,'2020-01-23') AS retrieve_date_intervals,--returns an int,
		--DAY,MONTH or YEAR('2020-01-23')
		ISDATE('2020-01-23') AS is_this_a_date_or_partofdate
/*Other Datatypes - numeric*/		
/*CASE*/ /*select case [colname](when..then....else..end)*/
SELECT City,[Rank],
CASE City
	WHEN 'm%' THEN 'City sounds fun'
	ELSE 'These are no fun'
END
FROM PortfolioProject..healthy_lifestyle_city_2021
--or
SELECT City,[Rank],
CASE 
	WHEN city LIKE 'm%' THEN 'City sounds fun'
	ELSE 'These are no fun'
END
FROM PortfolioProject..healthy_lifestyle_city_2021

/*GROUP BY*/ /*when using group by, the only elements in the select list will have to be the
col being grouped and aggregate functions of any cols */
SELECT OwnerSplitCity, MAX(TotalValue) AS max_total_value, COUNT(*) AS num_owners_in_each_city
FROM PortfolioProject..HousingData
WHERE OwnerName LIKE '%am%'
GROUP BY OwnerSplitCity
--HAVING count(*) < 5 --if we want to use the aggs as a condition
	
/*AGGREGATE FUNCTIONS*/ /*grouping funcs
COUNT(), SUM(), MAX, MIN , COUNT (DISTINCT __)*/ /* used for either * or a grouped table
used as filter with 'having' instead of 'where'*/

/*SUBQUERY*/ /*query within a query*/ /* goes in select, from, or where */ 
/*used with select, insert, update, delete */
/*You cannot order in subqueries*/
/*		syntax: select, insert, delete, update
SELECT column_name
FROM table_name
WHERE column_name like, in , > , or = 
    ( SELECT COLUMN_NAME  from TABLE_NAME   WHERE ... );

INSERT INTO Student1  (SELECT * FROM Student2) 

DELETE FROM Student2 
WHERE roll_no IN ( SELECT roll_no 
                   FROM Student1 
                   WHERE LOCATION = ’chennai’);

UPDATE Student2 
SET NAME=’geeks’ 
WHERE LOCATION IN ( SELECT LOCATION 
                    FROM Student1 
                    WHERE NAME IN (‘Raju’,’Ravi’));
*/

/*SELECT DISTINCT __*/ /*AGGREGATE (DISTINCT ___)*/

/*STRING FUNCS*/
/*LTRIM, TRIM, LEFT, LEN, CHARINDEX, SUBSTRING, UPPER, CONCAT, REPLACE, STRING_AGG*/
SELECT CONCAT('hello', ' there')
SELECT REPLACE('hey Simi', 'Simi', 'Tayo') AS other_bro

	CREATE TABLE teams(team_name varchar(20), team_member varchar(20))
		INSERT INTO teams
		VALUES ('Real Tuff', 'Ronnie'), ('Real Tuff', 'Jessie'), ('Savage', 'Mark')
			SELECT *
			FROM teams
SELECT team_name , STRING_AGG(team_member, ' & ')
FROM teams
GROUP BY team_name

/*TABLES*/
/*CREATE TABLE*/ /*create table  tabname(colname datatype [constraints])*/
/*INSERT INTO*/ /*inserts a row of values into the table*/
/*UPDATE*/ /*update tabname SET column1 = value1, column2 = value2,...WHERE condition
update - where picks out the row we want to update - set sets the values in each of the cols to the new vals we want*/
/*ALTER TABLE*/ /*alter table  tabname  add colname datatype*/ /*adds a new col to a table*//*alter table  tabname drop column colname*/ 
/*DELETE FROM */ /*with or without requirements aka where clause*/ /*delete from  tabname  where __*/ /*delete [*] from tabname*/
/*TRUNCATE TABLE*/ /*truncate table  tabname*/
/*DROP TABLE*/
/*RENAME table, col*/ /*exec sp_rename tabname, newtabname*/ /*exec sp_rename tabname.col, tabname.newcol*/ 
/*duplicate table*/ /*select *  into  newtab  from  orgtab*/--arranged /*select * -- from orgtab--(place) into newtab*/
/*JOIN*/
/*INNER, LEFT, RIGHT JOIN*/ /*SELECT tabs.cols FROM tab1 INNER JOIN tab2 ON tab1.alikecol = tab2.alikecol*/
/*FULL JOIN*/ /*selects everything in the selected like col*/
/*self join*/ /*SELECT A.cols, B.cols FROM tab A , tab B WHERE conditions that affirm uniqueness*/
/*UNION*/ /*INTERSECT*/ /*query 1 UNION query 2*/
/*constraints*/ /*during/after table is cre8d - create/alter 
NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT - sets default value for a column */ 
	/*1 PRIMARY KEY-unique identifier for the table*/ 
	/*creating foreign key: Create table __ (...PersonID int FOREIGN KEY REFERENCES Persons(PersonID))*/
	/* CHECK (Age>=18) */ /*DEFAULT 'Sandnes' or ADD CONSTRAINT df_age DEFAULT 24 FOR age*/

/*DATABASE*/
/*CREATE/DROP DATABASE*/ /*create/drop database dbname*/
/*BACKUP DATABASE*/ /*backup database   to disk = 'filepath_add' [with differential]-if it's been prev backed up]*/
/*CREATE/DROP INDEX*/ /*u create an index on a col queried often, cuz it makes queries faster*/ 
	/*create index index_name on tabnam(colname[s])*/ /*drop index tabname.colname*/
/*VIEW*/ /*is a virtual table*/
	/*CREATE VIEW view_name AS SELECT tab1.col1, tab2.col2..FROM tab1, [tab2] WHERE condition to select rows*/


