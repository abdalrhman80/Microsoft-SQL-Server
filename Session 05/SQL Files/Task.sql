
-- Use ITI Database
-- 1.Create a scalar function that takes date and returns Month Name of that date.

create function GetMonthNameOfDate(@date date)
returns varchar(max)
begin
declare @monthName varchar(max)
select  @monthName= FORMAT(@date,'MMMM')
return @monthName

end

select dbo.GetMonthNameOfDate(getdate())

--=====================================================================================
-- 2. Create a view that will display the Department Name and the number of Students

--on it.

create view DepartmentStudents
with encryption 
as 
select d.Dept_Name , count(s.St_Id) as studentCount
from student s , Department d
where d.Dept_Id = s.Dept_Id 
group by d.Dept_Name

select * from DepartmentStudents

--=====================================================================================
-- 3. Create a Function to Get Student First Name and Age By His/Her Id 

create function GetStudentFirstNameAndAgeByStudentId(@studId int)
returns table 
as
return 
(
select St_Fname, St_Age
from Student
where St_Id= @studId
)

select * from dbo.GetStudentFirstNameAndAgeByStudentId(2)
--=====================================================================================



