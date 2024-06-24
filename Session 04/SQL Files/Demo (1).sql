
--==============================================================
------------------------ Sub Query -----------------------------
----------------------------------------------------------------

-- Output Of Sub Query[Inner] As Input To Another Query[Outer]
-- SubQuery Is Very Slow (Not Recommended Except Some Cases)

/* 
select *
from student
where st_age>avg(st_age) => Not Valid
*/

select *
from student
where st_age>(select avg(st_age) from student) --26 just value

/*
select *, count(st_id)
from student => Not Valid
*/

select *,(select count(st_id) from student) --14
from student

-- SubQuery Vs Join

-- Get Departments Names That Have Students

select distinct D.Dept_Name
from Department D inner join Student S
on D.Dept_Id = S.Dept_Id

select dept_name
from Department
where Dept_Id in (	select distinct(Dept_Id)
					from Student
					where Dept_Id is not null
				)

-- SubQuery With DML
--------- SubQuery With Delete

--Delete Students Grades Who Are Living in Cairo
delete from Stud_Course
where St_Id in (
				Select St_Id from Student 
				where St_Address = 'Cairo'
				)
delete SC
from Student S inner join Stud_Course SC
on S.St_Id = SC.St_Id 
where S.St_Address = 'Cairo'


--==================================================
---------------------- Top -------------------------
----------------------------------------------------
-- First 5 Students From Table
------------------------------

select top(5)*
from  student

select top(5)st_fname
from  student

-- Last 5 Students From Table
------------------------------

select top(5)*
from  student
order by st_id desc

-- Get The Maximum 2 Salaries From Instructors Table
-----------------------------------------------------

select Max(Salary)
from Instructor

select Max(Salary)
from Instructor
where Salary <> (Select Max(Salary) from Instructor)

select top(2)salary
from Instructor
order by Salary desc


-- Top With Ties, Must Used With Order by

-- Get Top 5 student Age 
select top(7) st_age
from student 
order by st_age desc

select top(8) with ties st_age
from student
order by st_age  desc


-- Randomly Select
select newid()   -- Return GUID Value (Global Universal ID)

select St_Fname, newid()
from Student

Select top(3)*
from Student

-- Get 3 Random Students 

select top(3)*
from student
order by newid()

--============================================================
------------------- Ranking Function -------------------------
--------------------------------------------------------------



-- 1. Row_Number()
-- 2. Dense_Rank()
-- 3. Rank()

select Ins_Name, Salary,
	Row_Number() over (Order by Salary desc) as RNumber,
	Dense_Rank() over (Order by Salary desc) as DRank,
	Rank()       over (Order by Salary desc) as R
from Instructor


-- Get The 2 Older Students at Students Table

-- Using Ranking 
select *
from (select St_Fname, St_Age, Dept_Id,
		Row_number() over(order by St_Age desc) as RN
	from Student) as newtable
where RN <= 2

-- Using Top(Recommended)
Select top(2) St_Fname, St_Age, Dept_Id
from Student
Order By St_Age Desc

-- Get The 5th Younger Student 

-- Using Ranking (Recommended)
select * from 
(select St_Fname, St_Age, Dept_Id,
		row_number() over(order by St_age desc) as RN
from Student) as newtable
where RN = 5

-- Using Top
select top(1)* from
(select top(5)*
from Student
order by St_Age desc) as newTable
order by St_Age

--  Get The Younger Student At Each Department
-----------------------------------------------
-- Using Ranking Only
select * from 
(select Dept_Id, St_Fname, St_Age, 
		row_number() over(partition by Dept_id order by St_age desc) as RN
        from Student
        Where St_Age is not null and Dept_Id is not null) as newtable
where RN = 1



-- 4.NTile
------------

select count(*)
from Instructor -- 15 

-- We Have 15 Instructors, and We Need to Get The 5 Instructors Who Takes the lowest salary
---------------------------------------------------------------------------------------------
-- Using Ranking
---------------
select *
from
(
select Ins_Name, Salary, Ntile(3) over(order by Salary) as G
from Instructor
where Salary is not null
) as newTable
where G = 1


-- Using Top
-------------
select top(5) Ins_Name , Salary
from Instructor
where Salary is not null
order by Salary

---------------------------------------------------------
------------------ 01 Execution Order -------------------
---------------------------------------------------------

Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Where FullName = 'Ahmed Hassan' -- Not Valid


Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Where CONCAT(St_FName, ' ', St_Lname) = 'Ahmed Hassan'

Select *
from  (Select CONCAT(St_FName, ' ', St_Lname) as FullName
	   from Student) as Newtable
Where FullName = 'Ahmed Hassan'

Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Order By FullName


--execution order
--1 from
--2 join / on 
--3 where 
--4 group by
--5 having
--6 select
--7 order by
--8 top

--=========================================================
------------------------- 02 Schema -----------------------
-----------------------------------------------------------

-- Schema Solved 3 Problems:
-- 1.You Can't Create Object With The Same Name
--	[Table, View, Index, Trigger, Stored Procedure, Rule]
-- 2. There Is No Logical Meaning (Logical Name)
-- 3. Permissions

select *
from Student

-- DBO [Default Schema] => Database Owner

select *
from ServerName.DBName.SchemaName.objectName

Select @@serverName

select *
from  [DESKTOP-JSGKNDA].iti.dbo.student

select *
from MyCompany.dbo.Project

-- Create New Schema
Create Schema Sales

-- Transfer Table to specific Schema
Alter Schema Sales 
Transfer student

select * from Student  -- not valid

select * from Sales.Student -- valid

-- Create new table in sales Schema

Create Table Department 
(id int Primary key) -- Invalid Because there is a existing table With this Name in ITI Database

Create Table Sales.Department 
(id int Primary key) -- Valid


-- Delete Schema

Drop Schema Sales -- Schema Must Contain no tables to dropped 









