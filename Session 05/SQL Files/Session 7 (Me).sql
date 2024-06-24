----------------------------- 1- Union Family -----------------------------
----- Union Family (union | union all | intersect | except)
----- حاجة ميعنه وانا عايز الناتج يبقي الاتنين مع بعض Selectكل واحد ب two query بستخدمهم لو عندي 
----- لازم يكون في شرطين  Union Family من operator عشان استخدم اي 
    -- 1- The data types of the corresponding columns must be the same.
	-- 2- The number and the order of the columns must be the same in both queries.

/* (DB Or Tables) استخدمها لو عايز داتا من مكانين مختلفين سؤاء 
   Two Request وانا محتاج عشان اجيب الداتا من كل مكان 
    Requests علي حسب انا عايز اعرض ايه عشان اقلل عدد ال Union Operator فا الاحسن استخدم 
*/

 ---- 1. Union ----
    -- Without Repetition 

Select St_FName from Student
Union 
Select Ins_Name from Instructor

Select St_Id, St_FName from Student
Union 
Select Ins_Id, Ins_Name from Instructor

 ---- 2. Union All ----
     -- With Repetition 
	 
Select St_FName from Student
Union All
Select Ins_Name from Instructor

Select St_Id, St_FName from Student
Union All
Select Ins_Id, Ins_Name from Instructor

 ---- 3. Intersect ----
     -- Get Common Data ( two query المشترك ما بين ال )
	 
Select St_FName from Student
Intersect
Select Ins_Name from Instructor

Select St_Id, St_FName from Student
Intersect
Select Ins_Id, Ins_Name from Instructor
 

 ---- 4. Except ----
     -- Get Data that Exists in First Query And Not in Second Query
	   -- (اللي موجود في الاولي ومش موجود في التانيه)
	 
Select St_FName from Student
Except
Select Ins_Name from Instructor

Select St_Id, St_FName from Student
Except
Select Ins_Id, Ins_Name from Instructor
 
----------------------------- 2- Select Into -----------------------------
----- DDL [Create, Alter, Drop, Select Into] 
----- او لا DB موجود عندي سواء في نفس ال table لو عايز اخد نسخه من 
----- Tables Contains 3 Things [Structure, Data, keys]
   ---- Copy -> [Structure, Data]
      -- تانيه فا هتضر اخدهم برضوا tables ما بين relations دي keys لان ال

/* Syntax -> Select <Columns> into <Target_Table>
             From <Selected_Table>
*/

---- ITI اللي في EmployeeCopy واحطه في MyCompany اللي في Employee عايز اخد نسخه من 

Select *  
Into EmployeeCopy
From MyCompany.dbo.Employee
-- MyCompany اللي في Employee من Structure, Data وخد ال ITI جوا ال EmployeeCopy هوا راح كريت 


---- ITI اللي في EmployeeCopySpecificData واحطه في MyCompany اللي في Employee معينه من data عايز اخد  

Select Fname, Lname ,SSN ,Salary into EmployeeCopySpecificData
From MyCompany.dbo.Employee
where Salary > 1200


---- ITI اللي في EmployeeCopyStructure واحطه في MyCompany اللي في Employee من Structureعايز اخد ال

Select *  
Into EmployeeCopyStructure
From MyCompany.dbo.Employee
Where 1 = 2 -- مستحيل انه يتحقق condtion اعمل 

----------------------------- 3- Insert Based On Select -----------------------------
--- تاني Table من Select بناء علي Insert on Table  لو عايز اعمل 
--- But 2 tables must have same structure

insert into EmployeeCopyStructure
Select * From MyCompany.dbo.Employee


----------------------------- 4- User Defined Function -----------------------------

--- Funtion is Database Object -> [DDL]
--- Any User Defined Function must return value
--- Specify Type Of User Defined Function That U Want Based On The Type Of Return
   -- Return Type اللي هستخدمها بناء علي ال User Defined Function هنحدد نوع ال 

--- User Defined Function Consist Of :
   -- 1. Signature (Name, Parameters, ReturnType)
   -- 2. Body
      -- Body Of Function Must be Select Statement Or Insert Based On Select

-- User Defined Function May Take Parameters Or Not
   -- Parameters بتاعت ال Breakets لازم احط ال Syntax بس كا 

-- Schemaعشان استخدمها لازم اكتب قبلها اسم ال User Defined Functionال  


/*
  1. Scalar Functions :
     -- Return One Value
	 -- Body Must be Select Statement

	 -- Syntax -> Creat Function <Function_Name>(@<Parametar><Datatype>) 
	              Returns <Retutned_Datatype> 
				  Begin
				   Declar @<Returned_Variable><Retutned_Datatype>
				    <Select Statment>
				   Return @<Returned_Variable>
				  End

	 -- Usning -> Select [Schema].<Function_Name>


  2. Inline Table Functions :
     -- Return Table
	 -- Body Must be Select Statement

	 -- Syntax -> Creat Function <Function_Name>(@<Parametar><Datatype>) 
	              Returns Table
				  As
				   Return (<Select Statment>) 

	 -- Usning -> Select <Column> From [Schema].<Function_Name>



  3. Multi_Statment Table Functions :
     -- Return Table
	 -- Body Must be Select Statement Or Insert Based On Select and have Logic[If, While]

	 -- Syntax -> Creat Function <Function_Name>(@<Parametar><Datatype>) 
	              Returns @<Returned_Table> Table (Table Sttucture)
				  As
				  Begin
				    Insert Into @<Returned_Table>
				    <Select Statment>
				   Return
				  End

	 -- Usning -> Select <Column> From [Schema].<Function_Name>
*/

------- Scaler Function Examples -------

---- Student_Name وبترجع Student_Id بدلها ال Function عايز اعمل
Use ITI

GO
Create Or Alter Function GetStudentNameBasedOnId(@St_ID int)
Returns Varchar(max)
Begin
  Declare @St_name Varchar(max)
    Select @St_name = CONCAT(St_Fname, ' ' , St_Lname)
    From Student
    Where St_Id = @St_ID
  Return @St_name
End
GO

GO
Select dbo.GetStudentNameBasedOnId(3)
GO

---- Departmentبتاع ال Manger وبترجع ال Department بدلها اسم ال Function عايز اعمل

Use MyCompany

GO
Create Or Alter Function GetMangerNameBasedOnDeptNumber(@Dept_name varchar(max))
Returns varchar(max)
Begin
  Declare @Mgr_Name varchar(max)
    Select @Mgr_Name = CONCAT(E.Fname, ' ', E.Lname)
    From Departments D, Employee E
    Where E.SSN = D.MGRSSN and D.Dname = @Dept_name
  Return @Mgr_Name
End
Go

GO
Select dbo.GetMangerNameBasedOnDeptNumber('Dp1')
GO


------- Inline Table Example -------

--- اللي في القسم ده Instructors وترجع ال Departmen_ID اديها ال Function عايز اعمل 
Use ITI

GO
Create Or Alter Function GetInstructorsBasedOnDeptId(@Dept_Id int)
Returns Table
As
 Return 
  ( 
    Select Ins_Id, Ins_Name, Dept_Id
    From Instructor
    Where Dept_Id = @Dept_Id
  )
GO

GO
Select *
from dbo.GetInstructorsBasedOnDeptId(10)
GO


------- Multi_Statment Table Example -------

--- معين Format بناء علي  Student بترجع اسم ال Function  عايز اعمل 

Use ITI

GO
Create Or Alter Function GetStudentNameBasedOnFormate(@Formate varchar(max))
Returns @T Table (St_Id int, St_Name varchar(max))
As
Begin
  If @Formate = 'First'
   Insert Into @T
   Select St_Id, St_Fname
   From Student
  Else If @Formate = 'Last'
   Insert Into @T
   Select St_Id, St_Lname
   From Student
  Else If @Formate = 'Full'
   Insert Into @T
   Select St_Id, CONCAT(St_Fname, ' ', St_Lname)
   From Student
 Return
End
GO

GO
Select * 
From dbo.GetStudentNameBasedOnFormate('First')

Select * 
From dbo.GetStudentNameBasedOnFormate('Last')

Select * 
From dbo.GetStudentNameBasedOnFormate('Full')
Go

/* Create a multi-statements table-valued function that takes 2 integers 
     and returns the values between them. */
Use ITI

GO
CREATE OR ALTER FUNCTION GetValuesBetweenTwoIntgers (@IntOne Int, @IntTwo Int)
Returns @T Table (Intgers_Between Int)
As
Begin
  Declare @Counter Int = @IntOne + 1
  While @Counter <  @IntTwo
  Begin
     Insert Into @T
     Select @Counter 

 	 Set @Counter = @Counter +1
  End
  Return 
End
GO

Select * From dbo.GetValuesBetweenTwoIntgers(1,10)

----------------------------- 5- Views -----------------------------
/* 
  -- دي Queryوانا عايز احتفظ بال result بنفذها كذا مره وفي كل مره بتطلع نفس ال  Query لو عندي  
  -- دي Queryعشان احتفظ بال DB Catalogموجوده في ال View بيوفر حاجة اسمها Sql Server فا ال 
  -- DB Catalog -> Metadate of DB Objects
  -- View is DB Object -> [DDL]
  -- View is a Select Statement (Virtual Table)
  -- Specify a User View Of Data (Limit Access of Data)
  -- Hide Database Objects (Security)
     -- Eliminate SQL injection
  -- Simplify Construction of Complex Query 


  -- Syntax-> Create View <View_Name>(Columns_Alias_Naming)
              As
			  <Select_Statment>

  -- Using -> Select <Column> Form <View_Name>

  ---- Types Of View

     1- Standard View 
       -- Contains Just Only One Select Statement

     2- Partitioned View 
	   -- Contains More Than One Select Statement
     
     3- Indexed View 

*/


-------------- 5.1 Standard View --------------

GO
Create Or Alter View AlexStudentsView 
AS
Select St_Fname
From Student
Where St_Address = 'Alex'
GO

GO
Select *
From AlexStudentsView
GO


-------------- 5.2 Partitioned View --------------

GO
Create Or Alter View CairoAlexStudentsView
As
Select * 
From Student
Where St_Address = 'Cairo'
Union
Select *
From AlexStudentsView
GO

GO
Select *
From CairoAlexStudentsView 
GO    


-- Hierarchy Of Database?
/*
 Server Level	=> Databases
 Database Level	=> Schemas
 Schema Level	=> Database Objects (Table, View, SP, and etc)
 Table Level	=> Columns, Constraints
*/


-------------- 5.3 View Aliaseing --------------

GO
Create Or Alter View StudentsDepartmentsView(STUDENT_ID, STUDENT_NAME, DEPARTMEN_ID, DEPARTMEN_NAME)
With Encryption --- Encreptions
As
Select S.St_Id, S.St_Fname, D.Dept_Id, D.Dept_Name
From Student S , Department D
Where D.Dept_Id = S.Dept_Id
GO

GO
Select *
From StudentsDepartmentsView
GO

-------------- 5.4 View Encreptions --------------

Exec Sp_HelpText 'StudentsDepartmentsView' 
/* Sp_HelpText -> View or Function or Sp بيكون يا اما  String Paramter بياخد Built_In Stored Procedures عبارة
                  بتاعهم Source Code بيروح يجيب ال
				   Begin او ال As قبل ال  With Encryption <- Option وعشان امنع حاجة زي كدا لازم ازود 
*/

GO
Create View StudentsTakesCoursesView
With Encryption
As
Select S.St_Fname, C.Crs_Name
From Student S, Course C, Stud_Course SC
Where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id
GO

Select * 
From StudentsTakesCoursesView


-------------- 5.5 View With DML --------------
--- Select Statment بتاعه بيكون  Body وال  Virtiual Table هوا عباره عن View بما ان ال 
--- اللي هوا بيعرضه دا Table علي ال  DML فا انا بس هستخدمه عشان اعمل 

------- 5.5.1 View + DML -> (Data From One Table) ------- 

/*  1- Insert -> ( مش لازم Identity لو ) Viewفي ال PK لل Select لازم اكون عامل View من خلال Insert لو بعمل 
                 
 --- ؟ View من خلال Insert ليه اعمل 
    --  Tables اللي ممكن تدخلها في ال Columns في عدد ال  Limit لو عايز اعمل 
*/

GO
Create Or Alter View AlexStudentsView 
AS
Select St_Id, St_Fname, St_Address
From Student
Where St_Address = 'Alex'
GO

---  AlexStudentsView في Columns كل ال Select ده عشان فوق كان ب View عدلت ال 
GO
Create Or Alter View CairoAlexStudentsView
As
Select St_Id, St_Fname, St_Address 
From Student
Where St_Address = 'Cairo'
Union
Select *
From AlexStudentsView
GO

Insert Into AlexStudentsView
Values(28,'Hamada','Alex')

Select * From AlexStudentsView


/*  2- Update -> 

 --- ؟ View من خلال Update ليه اعمل 
    --  Update اللي ممكن تعملها Columns في عدد ال  Limit لو عايز اعمل 
*/

Update AlexStudentsView
Set St_Fname = 'Mohamaden'
Where St_Id = 28

Select * From AlexStudentsView


/*  3- Delete ->  */

Delete From AlexStudentsView
Where St_Id = 28

Select * From AlexStudentsView


------- 5.5.2 View + DML -> (Data From More Than One Table) -------

/* 1- Delete -> Delete مينفعش اعمل معاه Table من اكتر من data بيجيب View لو ال  */

GO
Create Or Alter View StudentsDepartmentsView(STUDENT_ID, STUDENT_NAME, DEPARTMEN_ID, DEPARTMEN_NAME)
With Encryption --- Encreptions
As
Select S.St_Id, S.St_Fname, D.Dept_Id, D.Dept_Name
From Student S , Department D
Where D.Dept_Id = S.Dept_Id
GO   /*
        - Students ال Table بتاعه 10 من id وعايز احذف الطالب اللي Delete هنا انا لو استخدمت ال 
        - Students ال Table  كله اللي حقق الشرط ده بس مش من Row فا هوا هنا هيحذف ال
        - اللي حقق الشرط Row وهيحذف ال View هوا هيمسك الناتج بتاع ال 
        - Dept_Name , Dept_Id وهيحذف برضوا ال Student Table من  St_id , St_name فا كدا هيحذف ال 
     */

/* 2- Insert -> , Table هضيف في اي Insert لازم احدد في ال Table من اكتر من data بيجيب View 
                مع بعض Tablesيعني مينفعش اضيف في كل ال    
*/

Insert Into StudentsDepartmentsView
Values (29, 'Ahmaden', 40, 'MM') -- Error لو عملت كدا هيطلع 

Insert Into StudentsDepartmentsView(STUDENT_ID,STUDENT_NAME)
Values (29, 'Ahmaden') -- بس Student Table كدا هوا ضاف في 


GO                                                            
Create Or Alter View StudentsDepartmentsView(STUDENT_ID, STUDENT_NAME, FK_DEPARTMEN_ID , DEPARTMEN_ID, DEPARTMEN_NAME)
With Encryption 
--Student Table من في  Departments عشان اقدر اضيف ال  FK_DEPARTMEN_ID ضفت ال --
As
Select S.St_Id, S.St_Fname, S.Dept_Id, D.Dept_Id, D.Dept_Name
From Student S , Department D
Where D.Dept_Id = S.Dept_Id
GO
	
Insert Into StudentsDepartmentsView(STUDENT_ID,STUDENT_NAME,FK_DEPARTMEN_ID)
Values (30, 'Alamane', 40) 


/*
  3- Update
*/

Update StudentsDepartmentsView
Set STUDENT_NAME = 'Awadane'
Where STUDENT_ID = 30


-------------- 5.6 View With Check Constraint --------------

Insert Into AlexStudentsView
Values(1000,'Emade','BeniSuif') 
--- اللي انا عامله Condition عشان يضيف ناس عايشه في محافظه تاني وتجاهل ال  View دا كدا غلط لانه كدا استخدم ال

GO
Create Or Alter View AlexStudentsView 
AS
Select St_Id, St_Fname, St_Address
From Student
Where St_Address = 'Alex' With Check option -- With Check option
GO

Insert Into AlexStudentsView
Values(1001,'Hatem','BeniSuif') --- Error كدا هيطلع 

Insert Into AlexStudentsView
Values(1001,'Hatem','Alex')