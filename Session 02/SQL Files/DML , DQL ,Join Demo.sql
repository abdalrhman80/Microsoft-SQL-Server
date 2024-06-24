

--==================================================--

---------- Data Manipulation Language(DML) -------------

-- 1. insert
--------------------
--1.1 Simple Insert(Add Just Only One Row)
Insert into Employees
Values('Mahaa' ,'Ahmed' ,'F' ,'02-22-1990' , null , null,2000)

Insert into Employees(fname , gender)
Values('Mohsen' ,'M')

-- 1. Identity Constraint
-- 2. Default Value
-- 3. Allow Null

--1.2 Row Constructor Insert (Add More Than One Row)
Insert into Employees
Values('Ali' ,'Amr' ,'M' ,'12-25-1998' , null , 1,2500),
('Omar' ,'Alaa' ,'M' ,'04-02-2000' , null , 1,3000),
('Mona' ,'Ahmed' ,'F' ,'02-02-2002' , null , 1,4000),
('Aya' ,'Ali' ,'F' ,'6-25-2002' , null , 1,6000)


-- 2. Update
--------------------
Update Employees
	Set Super_SSN = 2
	where SSN = 5

Update Employees
	Set Fname = 'Soha', LName = 'Ali'
	where SSN = 2

Update Employees
	Set Salary += Salary * .1
	where Salary <= 5000 and Gender = 'F'


-- 3. Delete
--------------------

-- Delete all Data
Delete From Employees

--Delete a Specific Data 
Delete From Employees
	Where Id = 5


--==================================================--

---------- Data Query Language(DQL) -------------

-- Select => Just For Display 
------------------------------
Use ITI

-- Display all Data of Students
select *
from Student

--Display specific Columns of data of student
select St_Fname +' '+ St_Lname FullName --alias name
from Student

-- Display First name and Last name concatenation 
select St_Fname +' '+ St_Lname  [Full Name]
from Student

select [Full Name] = St_Fname +' '+ St_Lname  
from Student


-- Display Students With Age Less than 23
select * 
from Student
where St_Age > 23


-- Display Students With Age in Range 21 to 25
select * 
from Student
where St_Age >= 21 and St_Age <= 25

select * 
from Student
where St_Age between 21 and 25


-- Display Students who live in alex , Mansoura , Cairo

select *
from Student
where St_Address = 'Alex' or St_Address = 'Mansoura' or St_Address ='Cairo'

select *
from Student
where St_Address in ('Alex', 'Mansoura', 'Cairo')

-- Display Students who don't live in alex , Mansoura , Cairo
select *
from Student
where St_Address not in ('Alex', 'Mansoura', 'Cairo')


-- Display Students who has no Supervisor
Select * 
from Student
where St_super is Null

-- Student's Name With Second Char 'a'
select *
from Student
where St_Fname like '_A%' -- Na Fady Kamel Hassan Nada Nadia 

--------------------------
-- like With Some Patterns
/*
Reserved Char
-------------
_ => one Char
% => Zero or More Chars 

*/ 

/*
Ex:
'a%h'     => ah axxxxh
'%a_'     => ak xxah
'[ahm]%'  => amr hassan mohamed a h m
'[^ahm]%' => omar Essam Tarek
'[a-h]%'  => ali bassem 
'[^a-h]%' => zeyad mohamed
'[346]%'  => 3mr 6x
'%[%]'    => ahmed%
'%[_]%'   => Ahmed_Ali _
'[_]%[_]' => _Ahmed_
*/

-- Student's Name which end with %
select *
from Student
where St_Fname like '%[%]' -- Na Fady Kamel Hassan Nada Nadia 

-- Student Name Without Duplication
Select distinct St_Fname 
from Student


-- Order Student by Their Name 
select St_Fname , St_Lname
from Student
order by St_Fname , St_Lname -- Ascending

select St_Fname , St_Lname
from Student
order by St_Fname desc -- descending

select St_Fname , St_Lname
from Student
order by 1 , 2 -- Order by St_Fname , St_Lname Ascending

select *
from Student
order by 5 -- Order by Age Ascending


--=======================================================--
--------------------------- Joins -------------------------

-- 1. Cross join (Cartesian Product)
------------------------------------
select S.St_Fname, D.Dept_Name
from Student S, Department D -- ANSI (Cartesian Product)


select S.St_Fname,  D.Dept_Name
from Student S Cross Join Department D -- Microsoft (Cross Join)

-----------------------------------------------------------------

-- 2. Inner Join 
-----------------

-- Equi Join Syntax (ANSI)

select S.St_Fname,  D.Dept_Name
from Student S, Department D
where D.Dept_Id = S.Dept_Id 

select S.St_Fname , D.*
from Student S, Department D
where D.Dept_Id = S.Dept_Id 

-- Inner Join Syntax (Microsoft)
select S.St_Fname, D.Dept_Name
from Student S inner join Department D
on D.Dept_Id = S.Dept_Id

-----------------------------------------------------------------
-- 3. Outer Join
------------------

-- 3.1 Left Outer Join
-------------------------
select S.St_Fname, D.Dept_Name
from Student S left outer join Department D
on D.Dept_Id= S.Dept_Id


select S.St_Fname, D.Dept_Name
from Department D left outer join Student S
on D.Dept_Id= S.Dept_Id


-- 3.2 Right Outer Join
-------------------------

select S.St_Fname, D.Dept_Name
from Student S right outer join Department D
on D.Dept_Id= S.Dept_Id

-- 3.3 Full Outer Join
-------------------------

select S.St_Fname, D.Dept_Name
from Student S full outer join Department D
on D.Dept_Id = S.Dept_Id

-----------------------------------------------------------------

-- 4. Self Join
-------------------------
-- Equi Join (ANSI) 
select  S.* , Super.St_Fname [Supervisor Name]
from Student S , Student Super
where Super.St_Id = S.St_Super 

-- Inner Join Syntax (Microsoft)

select  S.* , Super.St_Fname [Supervisor Name]
from Student S inner join Student Super
on  Super.St_Id = S.St_Super 
-----------------------------------------------------------------

-- Multi Table Join
-------------------------

-- Inner Join Syntax (ANSI)
select S.St_Fname, C.Crs_Name, SC.Grade
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id

-- Inner Join Syntax (Microsoft)
select S.St_Fname, C.Crs_Name, SC.Grade
from Student s 
inner join Stud_Course SC
on S.St_Id = SC.St_Id 
inner join Course C
on C.Crs_Id = SC.Crs_Id

----------------------------------
----------------------------------
-- Join + DML
-------------
-- 1.Update 

-- Updates Grades Of Student Who 're Living in Cairo
update SC
set grade += 10
from Student S inner join Stud_Course SC
on  S.St_Id = SC.St_Id and St_Address = 'cairo'

-- 2.Delete(Self-Study) 
-- 3.Insert (Self-Study)
