
------------------------------- Functions -------------------------------

/*
  Function=> DB Object عبارة عن 
            (DRY) بستخدمها لو عندي كود مش عايزه يتكرر  
*/

------------------- 1- Built-In Functions -------------------

---------- 1.1 Aggregate Functions ----------

/*
  Scalar Functions => واحده بس Value بترجع
  Return Value That Not Existed In Database

  Type-> (Count, Sum, Avg, Max, Min) 

  Syntax-> Select Agg_Fun(<Column>) -- (Sum, Avg, Max, Min) -> Numaric Column بدلهم  
           From <Table>
*/

Use MyCompany

Select count(*)
From Employee

Select count(Salary) -- مش هيتحسب Null لو في 
From Employee

Select Sum(Salary) -- مش هيتحسب Null لو في 
From Employee

Select Avg(Salary) -- مش هيتحسب Null لو في 
From Employee

Select Max(Salary) 
From Employee

Select Min(Salary) -- Value مش Null مش هيتحسب لان ال  Null لو في 
From Employee

/*
  Group By-> معين Group بناء علي Select لو عايز اعمل 
             Group بمعني اني بقله اللي متشابهين حطهم في 
             1- You Can't Group By With * or PK
             2- We Grouping With Repeated Value Column
                 (واحد Group عشان اعرف الاقي قيم متشابه واحطهم في)
            
			 3- If You Select Columns With Aggregate Functions, 
			    You Must Group By With The Same Columns 
*/

----- Department بتاع كل AVG Salary هنا انا عايز اجيب ال 

Select Dno, AVG(Salary) [AVG Salary]
From Employee
Where Dno Is Not Null
Group By Dno  

Select Fname, Dno, AVG(Salary) [AVG Salary] -- Errorهيطلع هنا 
From Employee
Where Dno Is Not Null
Group By Dno  
-----
Select Dno, Fname, SSN, AVG(Salary) [AVG Salary]
From Employee
Where Dno Is Not Null
Group By Dno ,Fname, SSN
Order By Dno


/*
   ** DB لانها بترجع قيمه مش  موجوده في ال Agg_Fun بناء علي condition مع Where مينفعش استخدم  **

   Having -> Agg_Fun بناء علي  condition استخدمها عشان لو عايز احط 
*/

Use ITI

-----  Department هنا عايز اجيب عدد الطلاب في كل 

Select Dept_Id, COUNT(*) [Students_Count]
From Student
Where Dept_Id Is Not Null
Group By Dept_Id
having COUNT(*) > 2

----- Department وعدد الطلاب في كل  Department هنا انا عايز اجيب اسم ال

Select Department.Dept_Id, Department.Dept_Name, COUNT(*) [Students_Count]
From Student, Department
where Student.Dept_Id= Department.Dept_Id 
Group By Department.Dept_Id, Department.Dept_Name
having COUNT(*) > 2

Select SUM(Salary)
From Instructor
having COUNT(Ins_Id) < 16

-----  اللي عدد الموظفين فيها اكبر من واحد Department في كل  Instructors عايز اجيب عدد ال 

Select Dept_Id, SUM(Salary) [Sum_Salary] ,COUNT(Ins_Id) [Instructor_Count]
From Instructor
Where Dept_Id Is Not Null
Group By Dept_Id
having COUNT(Ins_Id) > 1

-----  عليهم Supervise وعدد الطلاب اللي ب  Superviser عايز اجيب اسم ال 

Select Super.St_Id [Super_Id], Super.St_Fname [Super_Name], COUNT(*) [Student_Count]
From Student S, Student Super
Where Super.St_Id = S.St_super
Group By Super.St_Id, Super.St_Fname


---------- 1.2 Null Functions ----------

/*
  1- IsNull(<Column>, <Replacment Value>) 
                       Datatype لازم تكون من نفس ال 
*/

Select St_Fname, ISNULL(St_Address, 'Bnie-Suif')  
From Student 

Select St_Id, ISNULL(St_Address, ISNULL(St_Lname, ISNULL(St_Fname,'No Name'))) 
From Student 

/*
  2- Coalesce (<Column>, <Replac Value/ Anthor Column>, <Replac Value/ Anthor Column> ,...)
*/

Select St_Id, Coalesce(St_Address, St_Lname, 'No Name') 
From Student 


---------- 1.3 Casting Functions ----------

/*
  1- Convert : للتانية DataType بستخدمها عشان احول من  
  
        Syntax-> CONVERT (<Target_Type>, <Expersion>, Date_Style_Formate)
*/

Select St_Fname + ' ' + St_Age  --- مختلفة Datatyps بين Conctenat عشان انا هنا بعمل Error هيطلع
From Student

Select St_Fname + ' ' + CONVERT(nvarchar(10), St_Age) 
From Student -- كله هيبقي Null Row ال Value لان لو اي  Null هتطلع Records في 

Select St_Fname + ' ' + CONVERT(nvarchar(10), Coalesce(St_Age, St_Id)) 
From Student


/*
  2- CAST : Syntax كل الاختلاف في ال  CONVART زي ال 
               ** String الي DateTime في اختلاف تاني هيظهر لو بحول من  **

        Syntax-> CAST (<Expersion> as <Target_Type> )
*/

Select St_Fname + ' ' + CAST(St_Age as nvarchar(10)) 
From Student
----

Select CAST(GETDATE() as nvarchar(20)) 

Select CONVERT(nvarchar(20),GETDATE(),100) 
Select CONVERT(nvarchar(20),GETDATE(),101)
Select CONVERT(nvarchar(20),GETDATE(),102)
Select CONVERT(nvarchar(20),GETDATE(),110)
Select CONVERT(nvarchar(20),GETDATE(),111)  ----- المعين Formateل ال  DBالارقام دي محجوزه في ال  


/*
  3- CONCAT : Concatenat بتاعتها و بتعمل Datatype بغض النظر عن ال  String الي Value بتحول اي 
               ** Empty String هيحط بدلها NULL اللي  Records ال **

        Syntax-> CONCAT (<Expersion>, <Expersion>, ....)
*/

Select  CONCAT(St_Fname, ' ' , St_Age, ', ID ' , St_Id) 
From Student


/*
  4.1- Parse : Number او Datetime الي String Value بتحول  
          
        Syntax-> PARSE ('...' as datetime/<Numaric-type>)

  4.2- TRY_Parse : Error مينفعش يتحول مش بتطلع  String ولو ال  Number او Datetime الي String Value بتحول  
               
        Syntax-> TRY_Parse ('...' as datetime/<Numaric-type>)
*/

select Parse('06-16-2001' as datetime)
select Parse('Abdalrhman' as datetime)

select TRY_Parse('06-16-2001' as datetime)
select TRY_Parse('Abdalrhman' as datetime) -- NULL هيطلع 


---------- 1.4 DataTime Functions ----------

/*
  1- GETDATE : بتاع الجهاز Date بتجيب ال 
        Syntax-> GETDATE()

  2- GETUTCDATE : بالتوقيت العالمي Date بتجيب ال 
        Syntax-> GETUTCDATE()

  3- DAY :  بترجع اليوم 
        Syntax-> DAY(<DateTime_Exprssion>)

  4- MONTH :  بترجع الشهر 
        Syntax-> MONTH(<DateTime_Exprssion>)

  5- YEAR :  بترجع السنة 
        Syntax-> YEAR(<DateTime_Exprssion>)

  5- DATEPART :   
        Syntax-> DATEPART(<Interval>, <DateTime_Exprssion>)

  6- EOMONTH :  بترجع اخر يوم في الشهر 
        Syntax-> EOMONTH(<DateTime_Exprssion>)

  7- ISDATE : 🙂  من اسمها باينه 
        Syntax-> ISDATE(<Exprssion>)

  8- DATEDIFF : اللي هوا الفرق هيبقي ايام ولا شهور ولا سنين Interval بترجع الفرق مابين تارخين بناء علي ال   
        Syntax-> DATEDIFF(<Interval>, <Starting_DateTime>, <Ending_DateTime>)

*/

Select GETDATE()
Select GETUTCDATE()

Select DAY('06-16-2001')
Select DAY(GETDATE())

Select MONTH('06-16-2001')
Select MONTH(GETDATE())

Select YEAR('06-16-2001')
Select YEAR(GETDATE())

Select DATEPART(DAY, GETDATE())
Select DATEPART(MONTH, GETDATE())
Select DATEPART(YEAR, GETDATE())

Select EOMONTH(GetDATE())

Select ISDATE('ABC')

Select DATEDIFF(YEAR, '06-16-2001', GETDATE())