
------------------------------- DML -------------------------------
use company

-------------- 1- Insert --------------

---- 1.1- Simple Insert -> Add Just 1 row
/*
	1.1.1- Insert into <Table-Name> 
           Values (Value1,....)
	     -- NULL بنفس الترتيب ولو في حاجة مش عايز احطلها قيمة هكتب values لازم ادخل ال  

    1.2.2- Insert into <Table-Name> (Column1,....)
           Values (Value1,....)
	       - لازم تكون بتحقق حاجة من 3 Insert اللي مش هعملها columns هنا ال  
	           1- Identity Column 
		       2- Defult Value
		       3- Allow NULL
*/
--insert into Employees 
--values ('Ali','Gamal','M','9/23/1998',10,1) 
--وانا لسه مضفعتش حاجة هناك Departmnetلل  FK ولان هوا  Dnum لل  value عشان انا ضفت  Error هيطلع

--insert into Employees (Fname,Lname,Gender,DOB)
--values ('Yasmina','Gamal','F','9/23/1998')


---- 1.2- Row Constructor Insert -> Insert More Than One Row
/*
	1.2.1- Insert into <Table-Name> 
           Values (Value1,....), 
		   (Value1,....),
		   (Value1,....), ....
	       -- NULL بنفس الترتيب ولو في حاجة مش عايز احطلها قيمة هكتب values لازم ادخل ال  

    1.2.2- Insert into <Table-Name> (Column1,....)
           Values (Value1,....), (Value1,....), ....
	       -- لازم تكون بتحقق حاجة من 3 Insert اللي مش هعملها columns هنا ال  
	            1- Identity Column 
		        2- Defult Value
		        3- Allow NULL
*/
--insert into Employees (Fname,Lname,Gender)
--values ('Maha','Ahmed','F'), ('Mohamed','Emad','M')

-------------- 2- Update (Update Existing Records) --------------
/*
  Update <table-nam>
  Set <column-name> = <new-value>
  Where <condition> -- ده Columnلازم احط شرط عشان لو محطتوش هيعدل علي كل القيمة في ال 
*/
--update Employees
--set Fname='Gamal'
--where Fname='Mohamed'

--update Employees
--set Fname='Hatem'
--where Gender='M' and id=8

-------------- 3- Delete (Delete Rows) --------------
/*
  Delete from <table-nam>
  Where <condition> -- columns لازم احط شرط عشان لو محطتوش هيمسح كل ال 
*/
--delete from Employees
--where Fname='maha'

------------------------------- DQL -------------------------------

-------------- Select (Display data) --------------
/*
  Select <Attr-list>
  From <Table-name>
  Where <Condition>
*/
Select *
from Employees

Select Fname,Id
from Employees

Select  Fname +' '+ Lname as [Full Name] , Gender --As -> Aliase
from Employees
where id>1 and id<=4 --And -> More than one condation

Select  Fname +' '+ Lname as [Full Name] , Gender
from Employees
where id Between 2 and 4 -- Between-> For range

Select *
from Employees
where id=1 or id=3 or id =8  -- Or -> 

Select *
from Employees
where id In (1,3,8) -- In (val,..) 

Select *
from Employees
where id Not In (1,3,8) -- Not In (val,..) 

Select *
from Employees
where SuperId IS NULL -- IS NULL -> SuperId = NULL 
                      -- (SuperId = NULL) مينفعش اقول value مش  NULL لان ال  

Select *
from Employees
where SuperId IS NOT NULL -- IS NOT NULL -> SuperId != NULL 

Select *
from Employees
--where Fname LIKE '_a%'      -- LIKE <Pattren>
                              -- _ -> One Character
                              -- % -> Zero Or Moer
--where Fname LIKE '[Abd]%' -> [A or b or d] يبدا ب 
--where Fname LIKE '[^Abd]%' -> [A or b or d] يبدا ب اي حاجة الا دول 
--where Fname LIKE '%[%]' -> % لازم ينتهي ب ال  
--where Fname LIKE '%[_]' -> _ لازم ينتهي ب ال

Select DISTINCT  Fname -- DISTINCT -> تمنع التكرار
from Employees

use ITI

Select St_Fname, St_Lname, St_Age
From Student
Where St_Age IS Not Null
Order By St_Age -- Order By <Attr> ->  By Defult الترتيب تصاعدي  
--Order By St_Age Desc  -- Order By <Attr> Desc ->  تنازلي  
--Order By St_Fname, St_Lname -- St_Lname ولو في اتنين نفس القيمة هيرتب ب  St_Fname هيرتب الاول ب 
--Order By 1,2 -- Select الي عملها Columns الارقام هنا بتشير لترتيب ال 


-------------- JOIN (Table من اكتر من Select لو عايز اعمل  ) --------------
use MyCompany

/*
  1.Cross Join (Cartesian Product) : هيضربها في بعض Columns كل ال 
     -- Old Syntaxp ->  Select T(n).<Atts>,...
                        From <Table1> T1 , <Table2> T2,
   
     -- New Syntaxp ->  Select T(n).<Atts>,...
                        From <Table1> T1 Cross Join <Table2> T2
*/

Select E.Fname , D.Dname
From Employee E , Departments D

Select E.Fname , D.Dname
From Employee E Cross Join Departments D

/*
  2.Inner Join (Equi Join) : هيطلع اللي موجود في الاتنين
     -- Old Syntaxp ->  Select T(n).<Atts>,...
                        From <Table1> T1 , <Table2> T2
						Where <Join-Condition> -> (T(n).Pk = T(n).Fk)
   
     -- New Syntaxp ->  Select T(n).<Atts>,...
                        From <Table1> T1 Inner Join <Table2> T2
						On <Join-Condition> -> (T(n).Pk = T(n).Fk)
*/

Select E.Fname , D.Dname
From Employee E , Departments D
Where E.SSN = D.MGRSSN

Select E.Fname , D.Dname
From Employee E Inner Join Departments D
On E.SSN = D.MGRSSN

---------- 3. Outer Join : 
/*
    3.1 Left Outer Join : Join المهم اللي علي الشمال ال 
	                      بمعني هيطلع كل اللي علي الشمال حتا لو مش موجود علي اليمن ,

    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 Left Outer Join <Table2> T2
		      On <Join-Condition> 
*/

Select E.Fname , D.Dname
From Employee E Left Outer Join Departments D
On E.SSN = D.MGRSSN  -- هيطلع كل الموظفين حتا لو مش موجودين في قسم

Select E.Fname , D.Dname
From  Departments D Left Outer Join Employee E 
On E.SSN = D.MGRSSN  -- هيطلع كل الاقسام حتا لو مش موجود فيها موظفين

/*
    3.2 Righ Outer Join :Join المهم اللي علي يمين ال 
	                      بمعني هيطلع كل اللي علي اليمين حتا لو مش موجود علي الشمال ,

    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 Right Outer Join <Table2> T2
		      On <Join-Condition> 
*/

Select E.Fname , D.Dname
From  Departments D Right Outer Join Employee E 
On E.SSN = D.MGRSSN -- هيطلع كل الموظفين حتا لو مش موجودين في قسم

Select E.Fname , D.Dname
From Employee E Right Outer Join  Departments D 
On E.SSN = D.MGRSSN -- هيطلع كل الاقسام حتا لو مش موجود فيها موظفين

/*
    3.3 Full Outer Join : NUll هيطلع الاتنين حتا لو    

    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 Full Outer Join <Table2> T2
		      On <Join-Condition> 
*/

Select E.Fname , D.Dname
From Employee E Full Outer Join  Departments D 
On E.SSN = D.MGRSSN 

/*
    4. Self Join : Joinمجرد تكنيك جديد من ال  
	               Recursive Relationship لو عندي
				   واحد بس Table من  Select كل الاختلاف عن الانواع التانية اني هنا ب  
				   Table الواحد كا 2  Table الفكره اني بتخل ال 

    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 , <Table1> T2

			  OR
			  
			  Select T(n).<Atts>,...
              From <Table1> T1 , <Table1> T2
		      Where <Join-Condition>  

			  OR

			  Select T(n).<Atts>,...
              From <Table1> T1 (Inner, {Left, Right, Full} Outer) Join <Table1> T2
		      On <Join-Condition>

*/

Use MyCompany

Select Emp.Fname + ' ' + Emp.Lname as [Emp_Name], Emp.SSN ,
       Manegar.Fname + ' ' + Manegar.Lname as [Manger_Name], Manegar.SSN
from Employee Emp, Employee Manegar
Where Emp.Superssn = Manegar.SSN


Use ITI

Select Stu.St_Fname + ' ' + Stu.St_Lname as [Student_Name],
      Supervisor.St_Fname + ' ' + Supervisor.St_Lname as [Supervisor_Name]
From Student Stu join Student Supervisor
on Supervisor.St_Id = Stu.St_super


/*
    5. Multi Table Join : 2 Table ما بين اكتر من  Join لو عايز اعمل 
	                     M-M Relation تمثبل لل 
						 1-M من كل طرف
    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 , <Table2> T2, <Table3> T3
		      Where <Join-Condition1> And <Join-Condition2> 

    Syntax->  Select T(n).<Atts>,...
              From <Table1> T1 Inner Join <Table2> T2
		      On <Join-Condition1> 
			  Inner Join <Table3> T3
			  On <Join-Condition2> 
*/

Use MyCompany
Select Emp.Fname + ' ' + Emp.Lname as [Emp_Name],
       Proj.Pname as [Project_Name], Hours
From Employee Emp, Project Proj, Works_for Wo
Where Emp.SSN = Wo.ESSn and Proj.Pnumber = Wo.Pno

Use ITI
Select Student.St_Fname + ' ' + Student.St_Lname as [Student_Name],
      Course.Crs_Name as [Course_Name], Grade
From Student, Course, Stud_Course StCo
Where Student.St_Id = StCo.St_Id and Course.Crs_Id = StCo.Crs_Id 

Select Student.St_Fname + ' ' + Student.St_Lname as [Student_Name],
      Course.Crs_Name as [Course_Name], Grade
From Student  Inner Join  Stud_Course StCr
On Student.St_Id = StCr.St_Id
Inner Join Course
On Course.Crs_Id = StCr.Crs_Id 