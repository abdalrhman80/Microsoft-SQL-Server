--=======================================================
--------------------- Built-in Functions --------------
--=======================================================
------------------- 1. Aggregate Functions ---------------
----------------------------------------------------------
--  Return Value That Not Existed In Database
--	[ Count, Sum, Avg, Max, Min] 

select count(*)
from student

--The Count of Students That have Ages (Not Null)
select count(st_age) 
from student

select count(*) , count(st_id), count(st_lname), count(st_age)
from Student

select sum(salary)
from instructor


select avg(salary)
from Instructor

select sum(salary)/COUNT(*)
from Instructor

select sum(salary)/COUNT(Salary)
from Instructor


select Max(Salary) [Max Salary], Min(Salary) [Min Salary]
from Instructor


--------------------------------------------------------------
------------------------ Group By ----------------------------

-- Minimum Salary For Each Department
----------------------------------------
select Dept_Id, Min(Salary) [Mininmum Salary]
from Instructor 
Group By Dept_Id


Select Dept_Id, St_Address, Count(St_Id) [Number Of Students]
From Student
Group By Dept_Id, St_Address  -- Will Group Here With Which Column?

-- If You Select Columns With Aggregate Functions, 
-- You Must Group By With The Same Columns 


-- Get Number Of Student For Each Department [that has more than 3 students]
-------------------------------------------------------------------------------
/*
select S.Dept_Id, D.Dept_Name, Count(St_Id) [Number Of Students]
from Student S, Department D
where D.Dept_Id = S.Dept_Id and Count(St_Id) > 3 
group by S.Dept_Id , D.Dept_Name
*/

-- You Can't Use Agg Functions Inside Where Clause (Not Valid)
-- Because Aggreagate Generate Groups That 'Having' Works With it
-- Where Works With Rows => in order to Make Filteration

select S.Dept_Id, D.Dept_Name, Count(St_Id) [Number Of Students]
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id , D.Dept_Name
having Count(St_Id) > 3 


-- Get Number Of Student For Each Department [Need Join?]
------------------------------------------------------------
select Dept_id, Count(St_Id) [Number Of Students]
from Student
where dept_id is not null
group by Dept_Id

select S.Dept_id, Count(S.St_Id) [Number Of Students]
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id

-- Get Sum of Salary of Instructors For Each Department [Which has more than 1 Instructors]
-------------------------------------------------------------------------------------------
select Dept_Id, Count(Ins_Id)[Count Of instructor] ,Sum(Salary) [Sum Of Salary]
from Instructor
group by Dept_Id
having Count(Ins_Id) > 1

-- You Can Use Having Without Group By Only In Case Of Selecting Just Agg Functions
select Sum(Salary)
from Instructor
having count(Ins_Id) < 100 
-----------------------------------------------------------------------------------------------
-- Group By With Self Join
----------------------------

-- Get Sum of Students for each Supervisor 
-------------------------------------------

select Super.St_FName, Count(Stud.St_Id)
from Student Stud, Student Super
where Super.St_Id = Stud.St_Super
group by Super.St_FName


--=======================================================
----------------- 2. Null Functions ---------------------
-- 1. IsNull
---------------
-- ISNULL(expression, value)

select st_Fname
from Student

select st_Fname
from Student
where St_Fname is not null

select isnull(St_lname, '')
from Student

select isnull(St_lname, 'Not Found')
from Student

select isnull(St_lname, st_Fname) [New Name]
from Student
----------------------------------------------------
-- 2. Coalesce
---------------

-- COALESCE(val1, val2, ...., val_n) 

select coalesce(St_Lname, St_Address, 'Not Found')
from Student

--=======================================================
---------------- 3. Casting Functions -------------------

select St_Fname +' '+ St_lname [Student Full Name]
from student

-- Student First name and age  
select St_Fname +' '+ st_age 
from student  -- Invalid

-- 1. Convert [Convert From Any DateType To DateType]
------------------------------------------------------

-- CONVERT(data_type(length), expression, style)

select St_fname +' '+ Convert(varchar(2), St_Age)
from student

-- String + Null = Null 

select IsNull(St_Fname,'')+' '+ Convert(varchar(2), IsNull(St_Age, 0))
from student


select 'Student Name= ' + St_Fname + ' & Age= '+ Convert(varchar(2), St_Age)
from student

-- 2. Concat => Convert All Values To String Even If Null Values (Empty String)
------------------------------------------------------

-- CONCAT(string1, string2, ...., string_n)

select Concat(St_Fname, ' ', St_Age)
from student

---------------------------------------------------------------------------------------------------
-- 3. Cast [Convert From Any DateType To DateType]
---------------------------------------------------

-- CAST(expression AS datatype(length))

select getdate() --returns a datetime data type

select cast(getdate() as varchar(50))

select convert(varchar(50),getdate())

/* 
Convert Take Third Argument If You Casting From Date To String
For Specifying The Date Format You Need
*/

select convert(varchar(50),getdate(),100)
select convert(varchar(50),getdate(),101)
select convert(varchar(50),getdate(),102)
select convert(varchar(50),getdate(),110)
select convert(varchar(50),getdate(),111)


--4. parse [casting from string to DateTime/Number ]
select parse(GETDATE() as datetime)

select parse('Maha Ahmed' as datetime)

select Try_parse('Maha Ahmed' as datetime)



--=======================================================
---------------- 4. DateTime Functions ------------------
---------------------------------------------------------

select getdate()
select day(getdate())
select day('1-6-2000')
select Month(getdate())
select Month('7-23-2022')
select eomonth(getdate())
select eomonth('1/1/2000')
select format(eomonth(getdate()),'dd')
select format(eomonth(getdate()),'dddd')

--=======================================================
---------------- 5. String Functions --------------------
---------------------------------------------------------

select lower(st_fname),upper(st_lname)
from Student

select substring(st_fname,1,3)
from Student

select len(st_fname),st_fname
from Student

------------------------------------------------------------------------------------------
-- Format [Convert From Date or numbers To String]
------------------------------------------

select getdate()

-- FORMAT(value, format, culture)

Select format(123456789 , '##-###-####')
select format(getdate(),'dd-MM-yyyy')
select format(getdate(),'dddd MMMM yyyy')
select format(getdate(),'ddd MMM yy')
select format(getdate(),'hh:mm:ss')
select format(getdate(),'hh tt')
select format(getdate(),'HH')
select format(getdate(),'ddd MMMM yyyy hh:mm:ss tt')
select format(getdate(),'ddd MMMM yyyy hh:mm:ss tt', 'ar')
select format(getdate(),'ddd MMMM yyyy hh:mm:ss tt', 'fr')


--=======================================================
----------------- 6. Math Functions ---------------------
---------------------------------------------------------

select power(2,2) 

Select ABS(-200)

Select pi()

Select rand()

-- log sin cos tan

--=======================================================
---------------- 7. System Functions --------------------
---------------------------------------------------------

select db_name()

select suser_name()
