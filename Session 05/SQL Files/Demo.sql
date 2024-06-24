--=====================================================================
----------------------- 03 Union Family -------------------------------
-- Union Family (union | union all | intersect | except)
-- Have 2 Conditions:
-- 1- The Same Datatype
-- 2- The Same Number Of Selected Columns

-- Union Without Repetition
Select St_Id, St_FName from Student
Union 
Select Ins_Id, Ins_Name from Instructor

-- Union ALL With Repetition
Select St_Id, St_FName from Student
Union all
Select Ins_Id, Ins_Name from Instructor

-- Get Common Data 
Select St_Id, St_FName from Student
Intersect 
Select Ins_Id, Ins_Name from Instructor

-- Get Data that Exists in First Result Set And Not in Second Result Set  
Select St_Id, St_FName from Student
except 
Select Ins_Id, Ins_Name from Instructor

--===========================================================================
--------------- 04 Select Into , Insert Based On Select ---------------------
-- DDL [Create, Alter, Drop, Select Into]    

-- Create Copy of Table

Select * into NewEmployees
From MyCompany.Dbo.Employee


-- Create Just The Structure Without Data
Select * into NewProjects
From MyCompany.Dbo.Project
Where 1 = 2


-- Take Just The Data Without Table Structure, 
-- but 2 tables must have same structure (Insert Based On Select)

Insert Into NewProjects
Select * from MyCompany.Dbo.Project


--=========================================================
-----------------------------------------------------------
----------------  05 User Defined Function -----------------

-- Any User Defined Function must return value
-- Specify Type Of User Defined Function That U Want Based On The Type Of Return
-- User Defined Function Consist Of
--- 1. Signature (Name, Parameters, ReturnType)
--- 2. Body
-- Body Of Function Must be Select Statement Or Insert Based On Select
-- May Take Parameters Or Not

----------------------------------------------------------------------------------
-------------- 5.1 Scalar Functions (Return One Value)-----------------------------
----------------------------------------------------------------------------------

Create Function GetStudentNameByStudentId(@StId int)
returns varchar(20) -- Function Signature
begin
	declare @StudentName varchar(20)
	Select @StudentName = St_FName
	from Student
	where St_Id = @StId
	return @StudentName
end
     
Select	Dbo.GetStudentNameByStudentId(8)
-----------------------------------------------------


Create Function GetDepartmentManagerNameByDepartmentName(@DeptName varchar(20))
Returns varchar(20) -- Function Signature
begin
	declare @MangerName varchar(20)
	Select @MangerName = E.FName
	From Employee E, Departments D
	where E.SSN = D.MGRSSN and D.DName =  @DeptName
	return @MangerName
end

Select	Dbo.GetDepartmentManagerNameByDepartmentName('DP2')



----------------------------------------------------------------------------------
-------------- 5.2. Inline Table Functions (Return Table)--------------------------
----------------------------------------------------------------------------------

Create Function GetDepartmenInstructorsByDepartmentId(@DeptId int)
Returns Table  -- Function Signature
as
	Return
	(
		Select Ins_Id, Ins_Name, Dept_Id
		from Instructor
		Where Dept_Id = @DeptId
	)

	Select * from dbo.GetDepartmenInstructorsByDepartmentId(20)

----------------------------------------------------------------------------------
-------------- 5.3. Multistatment Table Functions (Return Table)--------------------
----------------------------------------------------------------------------------
-- Return Table With Logic [Declare, If, While] Inside Its Body

Create Function GetStudentDataBasedPassedFormat(@Format varchar(20))
Returns @t table
		(
			StdId int,
			StdName varchar(20)
		)
as
	Begin
		if @format = 'first'
			Insert Into @t
			Select St_Id, St_FName
			from Student
		else if @format = 'last'
			Insert Into @t
			Select St_Id, St_LName
			from Student
		else if @format = 'full'
			Insert Into @t
			Select St_Id, Concat(St_FName, ' ', St_LName)
			from Student
		
		return 
	End

select * from dbo.GetStudentDataBasedPassedFormat('fullname')
select * from dbo.GetStudentDataBasedPassedFormat	('FIRST')


--=====================================================================================
----------------------  06 Views ------------------------
---------------------------------------------------------
Select *
from Student

---------------- 6.1 Standard View (Contains Just Only One Select Statement)-----------

Create View StudentsView
as
	Select *
	from Student

Select * from StudentsView

Create View AlexStudentsView
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Alex'

Select * from AlexStudentsView

Create View CairoStudentsView(id , name , Address)
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Cairo'

Select * from CairoStudentsView



---------------------------------------------------------------
-- 2. Partitioned View (Contains More Than One Select Statement)

-- Students In Cairo and Alex
Create View CairoAlexStudentsView
as
	Select * from CairoStudentsView
	Union
	Select * from AlexStudentsView

Select * from CairoAlexStudentsView

-- Hierarchy Of Database?
/*
 Server Level	=> Databases
 Database Level	=> Schemas
 Schema Level	=> Database Objects (Table, View, SP, and etc)
 Table Level	=> Columns, Constraints
*/

Alter Schema Dbo
Transfer Sales.CairoAlexStudentsView

Select * from CairoAlexStudentsView -- Invalid
Select * from Sales.CairoAlexStudentsView -- valid

-- View to Display Student and Department 

Create View StudentDepartmentDataView(StdId, StdName, DeptId, DeptName)
With Encryption
as
	Select St_Id, St_FName, D.Dept_Id, D.Dept_Name
	from Student S inner join Department D
	on D.Dept_Id = S.Dept_Id

Select * from StudentDepartmentDataView

SP_HelpText 'StudentDepartmentDataView'

-- View to display Student's Grade that their Address is Cairo or Alex

Create View CairoAndAlexStudentsGradesView
with encryption
as 
   Select S.St_Fname , C.Crs_Name , SC.Grade , S.St_Address
   from Student S , Course C , Stud_Course SC
   where S.St_Id = Sc.St_Id and C.Crs_Id = Sc.Crs_Id 
          and S.St_Address in ('Cairo' , 'Alex')


Select * from CairoAndAlexStudentsGradesView

--------------------------------------------------------------------
-- View + DMl 
-- View =>  One Table

Select * from CairoStudentsView

insert into CairoStudentsView
Values(1010 , 'aliaa' , 'Cairo' )

Update CairoStudentsView
set name = 'Omar'
where id = 1010

Delete from CairoStudentsView
where id = 1010

-- View =>  Multi Table
-------------------------

Select * from StudentDepartmentDataView

--insert

insert into StudentDepartmentDataView
Values (101010 , 'Ali' , 100,'PL') -- Invalid(because the modification affects multiple base tables)

insert into StudentDepartmentDataView
Values (101010 , 'Ali') --Invalid

insert into StudentDepartmentDataView(StdId , StdName)
Values (101010 , 'Ali') --valid

insert into StudentDepartmentDataView(DeptId , DeptName)
Values (100 , 'PL') --valid

-- Update 
Update StudentDepartmentDataView
set StdName = 'Omar'
where StdId = 1

Delete from StudentDepartmentDataView -- Invalid(because the modification affects multiple base tables)
where StdId = 1

--------------------------------------------------
Select * from CairoStudentsView

alter View CairoStudentsView(id , name , Address)
with encryption
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Cairo'
	with check option

insert into CairoStudentsView
Values(1010 , 'amr' , 'Alex' ) -- Invalid


