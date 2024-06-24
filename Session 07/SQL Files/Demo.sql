------------------------------------------------------------------
------------------------ 1. Triggers -----------------------------
------------------------------------------------------------------

-- Types of SP :
----------------
-- 1. User defined
	  SP_GetStudentNameAndAgeById   SP_Getdata   SP_SumNumber

-- 2. Built-In SP
	  Sp_helptext'object_name'    Sp_Rename 'object_name' , 'new_name' ,'object_type'
	  
-- 3. Trigger (Special Stored Procedure)
--    Can't Call
--    Can't take parameters

-- Types of Triggers (Through Its Level)
-- 1. Server Level
-- 2. DB Level
-- 3. Table Level (Our Interest)
--    Actions In Table?(Insert   Update   Delete) [Events]
--    (Select Truncate) Not Logged In Log File

--------------------------------------------------------------------------------------
-- Examples of Triggers :
-------------------------

-- Ex01:
--------
Create Trigger Tri_WelcomeTrigger	
on Student
after insert
as
	print 'Welcome To Route'


Insert Into Student(St_Id, St_FName)
Values(1010, 'Amr')

Alter Schema HR
Transfer Student 

Insert Into HR.Student(St_Id, St_FName)
Values(101010, 'Omar')

-- Ex02:
--------

Create Or Alter Trigger HR.Tri_UpdateStudent
on HR.Student
after Update
as
	Select GetDate() as DateTime


Update HR.Student
	Set St_Address = 'Cairo'
	Where St_Id = 23723


-- Ex03:
--------

Create Trigger Tri_PreventDeleteStudent
On HR.Student
Instead of Delete
as
	Print 'You Can Not Delete From This Table'

Delete From HR.Student
Where St_Id = 23723


-- Ex04:
--------

Create Trigger Tri_LockDepartmentTable
on Department
instead of Delete, Insert, Update
as
	Select  Suser_name() +' Can Not Do Any Operation On This Table' 

Insert into Department(Dept_Id, Dept_Name)
Values(8232, 'Test')

Update Department
Set Dept_Name = 'SD'
Where Dept_Id = 40

Delete from department 
where Dept_id = 10



-- Drop | Disable | Enable Trigger
----------------------------------

Drop Trigger Tri_LockDepartmentTable

Alter Table Department
Disable Trigger Tri_LockDepartmentTable

----------------------------------------------------
-- Notes:
--------
-- When You Write Trigger, You Must Write Its Schema (Except Default [dbo])
-- Trigger Take By Default The Schema Of Its Table In Creation
-- When You Change The Schema Of Table, All Its Triggers Will Follow

-- The Most Important Point Of Trigger:
----------------------------------------
-- 2 Tables: Inserted & Deleted Will Be Created With Each Fire Of Trigger
-- In Case Of Delete:  Deleted Table Will Contain Deleted Values
-- In Case Of Insert:  Inserted Table Will Contain Inserted Values
-- In Case Of Update:  Deleted Table Will Contain Old Values
--					   Inserted Table Will Contain New Values		

-- Error (Have No Meaning Without Trigger): Just Created at RunTime 
Select * from inserted
select * from deleted

-- Ex05:
--------
-- With Trigger
create trigger tri05
on course
after update
as
	Select * from inserted
	select * from deleted


update course
	set Crs_Name='Cloud'
	where crs_id=200


-- Ex06:
--------

Create Or Alter Trigger Tri06
on Course 
Instead OF Delete
as
	Select ' You Can Not Delete Course '+ (Select Crs_Name from deleted)+ ' From This Table.' 

Delete From Course	
	Where Crs_Id = 100



Create Table UpdatedTopics
(Top_id int primary key,
Top_Name Varchar(20)
)

-- Ex07:
--------

create Or ALter trigger tri_UpdateTopic
on Topic
after update
as
	insert into UpdatedTopics
	Select Top_Id , Top_Name from Deleted

Update Topic
Set Top_Name = 'Design'
where Top_Id = 5


-- Ex08:
--------

Create Or Alter Trigger Tri_PreventDeleteStudent
on HR.Student
Instead OF Delete
as
	if Format( GETDATE(), 'dddd') = 'monday'
		Delete From HR.Student
			Where St_Id in (Select St_Id from deleted)

			
Delete from HR.Student
	Where St_Id = 3242


--================================================================
--------------------------- 02 Index -----------------------------
------------------------------------------------------------------

-- 3.1 Clusterd Index 
----------------------
create clustered index IX_Myindex
on student(st_fname) -- Not Valid [Table already has a clustered index on PK]

-- 3.2 NonClusterd Index 
----------------------
create nonclustered index myindex
on student(st_fname)

create nonclustered index myindex2
on student(dept_id)

create table test
(
 X int primary key,
 Y int unique,
 Z int unique
)

-- Primary Key   ---Constraint   ---> Clustered Index

-- Unique Key    ---Constraint   ---> Nonclustered Index

create unique index IX_03
on student(st_age)

-- Will Make 2 Things If There is No Repeated Values
-- 1. Make Unique Constraint On St_Age 
-- 2. Make Non-Clustered Index On St_Age


Select * from Student
Select * from production.product

--=======================================================================================
----------------------------------- 03 Indexed View ---------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

Create  Or ALter View  StudentDepartmentView
With Encryption , SchemaBinding
as
    Select S.St_Id , S.St_Fname , D.Dept_Name
	From dbo.Student S , dbo.Department D
	Where D.Dept_Id = S.Dept_Id

Select * from StudentDepartmentView


--Indexed View : Put Index On The View
-----------------------------------------

Create Unique CLustered Index IX_03
On StudentDepartmentView(St_id)


Select * 
from StudentDepartmentView
Where St_Id = 2

--======================================================================================
------------------------ 04 Transaction (TCL)-------------------------
-----------------------------------------------------------------

-- 2.1 Implicit Transaction (DML Query [Insert, Update, Delete])
-----------------------------------------------------------------
Insert Into Student(St_Id, St_Fname)
Values (100, 'Ahmed'), (101, 'Amr')

Update Student
	set St_Age = 30 
	where St_Age = 20


-- 2.2 Explicit Transaction (Set Of Implicit Transactions)
------------------------------------------------------------

Begin Transaction 
-- Set of Implicit Transactions
Commit Tran || Rollback Tran
---------------------------------

create table Parent
(
ParentId int primary key
)
create table Child
(
ChildId int primary key,
FK_ParentId int references Parent(ParentId) on delete Cascade
)

insert into Parent 
values(1) ,(2) ,(3) 


insert into Child values(1, 1)
insert into Child values(2, 20) -- Error (Logical Error)
insert into Child values(3, 3)

begin transaction
      insert into Child values(4, 1)
      insert into Child values(5, 20) -- Error (Logical Error)
      insert into Child values(6, 3)
commit tran

begin transaction
insert into Child values(7, 1)
insert into Child values(8, 2)
insert into Child values(9, 3)
rollback tran


begin try
	begin transaction
		insert into Child values(10, 1)
		save transaction p01
		insert into Child values(11, 2)
		insert into Child values(12, 10)
		insert into Child values(13, 3)
	commit tran
end try
begin catch
	rollback tran p01
end catch




--=======================================================================================
------------------------------------- 05 DCL ---------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- [Login]          Server (Omar)
-- [User]           DB Route (Omar)
-- [Schema]         Sales   [Department, Instructor]
-- Permissions      Grant [select,insert]    Deny [delete Update]

Create Schema Sales

alter schema Sales
transfer [dbo].[Instructor]

alter schema Sales
transfer Department