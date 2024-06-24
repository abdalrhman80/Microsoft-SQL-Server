---------------------------- 1 Sub Query ----------------------------

-- Output Of Sub Query[Inner] As Input To Another Query[Outer]
-- SubQuery Is Very Slow (Not Recommended Except Some Cases)
-- Two Query بيتكون من  
    -- Execute دي اول حاجة بيحصلها Inner qeury اول حاجة هيا ال 
	-- Inner qeury وبيكون معتمد علي ال Outer qeury تاني حاجة هيا ال 
	
/*
  1- Aggr_Fun مبني علي condition استخدمها لو في 
*/


Use ITI

----- عايز اعرض الطلاب اللي اكبر من معدل الاعمار

Select St_Age
From Student
Where St_Age > AVG(St_Age) --Aggr_Fun مبني علي conditionعشان ال Error هنا هيطلع

Select St_Age
From Student
Having St_Age > AVG(St_Age) -- Error هيطلع 
-- واحد Group كانه table فا بيتعامل مع ال Aggr_Fun ل select او عامل group by بتسخدمها لو انا عامل havingال 

Select St_Fname, St_Age
From Student
Where St_Age > (Select AVG(St_Age) From Student)

--------

Select St_Id ,COUNT(*)
From Student -- Group by عشان مش عامل Error هيطلع هنا 

Select St_Id , (Select COUNT(*) From Student)
From Student

/*
  2- JOIN Vs SUBQUERY
     -- JOIN ممكن تتعل بالاتنين الافضل اعملها ب Query لو عندي
	 -- Two Query بيعمل SUBQUERY لان في ال  
*/

----- اللي فيها طلبه Departmentعايز اجيب اسماء ال 

-- 1- Join
Select Distinct D.Dept_Name
From Student S, Department D
Where D.Dept_Id = S.Dept_Id

-- 2- Subqurey
Select Dept_Name
From Department D
Where D.Dept_Id In (Select Dept_Id  From Student) --الاول Department مش هيطلع تكرار هنا عشان هوا شغال علي ال 
                                                  --ولا لا Student موجود في Dept بتاع كل id وبعدين يشوف هل ال 

	
/*
  3- SubQuery With DML
*/

-------- 1- SubQuery With Delete

----- Beni-suif انا عايز امسح درجات الطلاب اللي في 

--- 1- JOIN

Select S.St_Id, Grade 
From Stud_Course SC, Student S
where S.St_Id = SC.St_Id and  St_Address ='Beni-suif'

Delete SC -- Two Table من Select لازم احددله هتمسح منين لاني عامل 
From Stud_Course SC, Student S
where S.St_Id = SC.St_Id and  St_Address ='Beni-suif'

--- 2- SubQuery

Select St_Id, Grade 
From Stud_Course
Where St_Id in (
                Select St_Id 
                From Student 
				Where St_Address ='Beni-suif'
				)

Delete From Stud_Course
Where St_Id in (
                Select St_Id 
                From Student 
				Where St_Address ='Beni-suif'
				)



---------------------------- 2 Top ----------------------------
/* 
   Top-> Sql server keyword not function 
         اللي بحددها rows بتسخدمها لو عايز اسلكت اول ال 

	  Syntax-> Select Top(<Num of Rows>)<Columns>
*/


----- عايز اعرض اول خمس طلاب

Select Top(5)*
From  Student


----- عايز اعرض اخر خمس طلاب
-- ( bottom اسمها keyword مفيش )

Select Top(5)*
From Student
Order By St_Id Desc -- هنا قلتله رتبهم من الكبير للصغير وهات اول خمسه 


----- Max Salary عايز اعرض تاني

Select MAX(Salary)
From Instructor
Where Salary != (Select MAX(Salary) From Instructor)
/* 1- Max وجاب ال Inner Queryهنا هوا نفذ الاول ال 
   2- Inner Query تكون مش بتساوي النتيجه بتاعت Outer Queryفي ال Maxاللي هتختار منها ال Salaryوبعدين قلتله ال
   3- Max Salary كدا هوا جاب تاني  
*/

----- Max Salary عايز اعرض الموظف صاحب
Select *
From  Instructor
Where Salary = (Select MAX(Salary) From Instructor)

Select Top(1)*
From Instructor 
Order By Salary Desc


----- 2 Max Salary عايز اعرض الموظف صاحب

Select *
From  Instructor
Where Salary = (
                 Select MAX(Salary)
                 From Instructor
				 Where Salary != 
				                (
								Select MAX(Salary) 
								From Instructor
								)
				 )
				 -- Max Salaryهنا اول حاجة عملها جاب ال 
				 -- Max Salary بعدين جاب ناني  
				 -- Max Salary بتاعته بتساوي ناني Salary بعدين جاب بيانات الموظف اللي ال 

Select Top(1)* 
From (
      Select Top(2)* 
      From Instructor 
	  Order By Salary Desc
	  ) as NewTable
Order By Salary
/*
  1- Salary بيعرض اكبر اتنين من حيث ال Subquery ال
  2- منه اول قيمه Selectو هشقلبه و ه Table كانه Subquery و اتعاملت مع ال
*/

---------------------------- 3 Top with Ties ----------------------------
 /*
    Syntax-> Top(<Column>) With Ties
	-- Selectوظفتها انها بتشوف لو اخر قيمه لو متكرره هتخدها في ال  
    -- Order By لازم استخدمها مع 
 */

select St_Age
from Student 
Where St_Age is not null
order by St_Age desc

select top(7) St_Age
from Student 
Where St_Age is not null
order by St_Age desc

select top(7) with ties St_Age
from Student 
Where St_Age is not null
order by St_Age desc


---------------------------- 4 Random Selection ( GUD ) ----------------------------

/*
  GUD -> Gloubal Univirsal Id 
         -- Unique مكون من 32 حرف وبيكون Sting عباره عن 
		 -- Random Selection لحد دلوقتي بستخدمه في ال 

  NewId() -> Random بشكل Generat New GUD كل مره بنفذها بت Function
*/

Select St_Fname, NEWID()
From Student


----- عايز اظهر اتنين طلاب بشكل عشوائي 

Select top(2) * 
From Student
Order By NEWID() -- كل مره بيتكريت واحد جديد فا لو رتبت بيه الترتيب مش هيكون ثابت كل مره NewId() ال 


---------------------------- 5 Ranking Function ----------------------------

/*
  1. Row_Number() ===|
  2. Dense_Rank()    |=> -- [Rank ويدوله Row بمعني انه بيمسك كل , Row دول بيشتغلوا علي ال] 
  3. Rank()       ===|

  4. NTile() => [Per Group]
*/

------------ 5.1 Row_Number() ------------
  /* Syntax->  Select <Column>,
               Row_Number() Over (Order By <Column>)
               From <Table>
  */ 
  -- مش بتعترف بالتكرار
  -- مختلف Rank لو في قمتين متكررين بتدي لكل واحد  


------------ 5.2 Dense_Rank() ------------
  /* Syntax->  Select <Column>,
               Dense_Rank() Over (Order By <Column>)
               From <Table>
  */ 
  -- بتعترف بالتكرار 
  -- وللي بعدهم هتبداء من 2 Rank 1 لو في اكبر قيمة متكرره 3 مرات هتددي لكل واحد فيهم     


------------ 5.3 Rank() ------------
  /* Syntax->  Select <Column>,
               Rank() Over (Order By <Column>)
               From <Table>
  */ 
  -- Gap بتعترف بالتكرار بس عندها حاجة اسمها 
  -- وللي بعدهم هتبداء من 4 Rank 1 بمعني انه لو في اكبر قيمة متكرره 3 مرات هتددي لكل واحد فيهم     


Select Ins_Name, Salary ,
ROW_NUMBER() Over (Order By Salary Desc) as RowRank,
DENSE_RANK() Over (Order By Salary Desc) as DenseRank,
RANK() Over (Order By Salary Desc) as _Rank
From Instructor


----- عايز اجيب اكبر اتنين طلاب من حيث السن

--- 1- Top
Select Top(2) *
From Student
Order By St_Age Desc

--- 2- Rank

--Select *,
--ROW_NUMBER() Over (Order By St_Age Desc) as RowRank 
--From Student
--Where RowRank <=2 -- ده RowRankفا هوا مش عارف ايه ال Select بتتنفذ قبل ال Where عشان ال <- Error هيطلع 

Select *
From (
      Select *, 
      ROW_NUMBER() Over (Order By St_Age Desc) as RowRank 
	  From Student
	  ) as RankedTable
Where RowRank <= 2

----- عايز اجيب اصغير خامس طالب 

--- 1- Top
Select Top(1) *
From (
      Select Top(5) * 
	  From Student 
	  Where St_Age IS Not Null 
	  Order By St_Age
	  ) as NewTable
Order By St_Age Desc


--- 2- Rank ( هنا دي احسن Performance كا )
Select *
From (
      Select *, 
      ROW_NUMBER() Over(Order By St_Age) as RowRank
	  From Student 
	  Where St_Age IS Not Null 
	  ) as RankedTale
Where RowRank = 5


------------ 5.4 (Partition) ------------ 
-- Group By بستخدمها لو عايز اعمل 

----- عايز اجيب اكبر طالب في كل قسم

-- 1- Agg_Fun
Select Dept_Id, MAX(St_Age) as Max_Age
From Student S
Where Dept_Id Is Not Null
Group By Dept_Id


-- 2- Rank
Select Dept_Id, St_Age
From (
      Select *,
	  ROW_NUMBER() Over (Partition by Dept_Id Order By St_Age Desc) as RowRank 
	  -- Age رتبهم من حيث ال Group و جوا ال Group وحطهم في Dept هنا هوا مسك كل 
	  From Student
	  Where Dept_Id Is Not Null
	  ) as NewTable
Where RowRank = 1


------------ 5.5 NTile() ------------
  /* Syntax->  Select <Column>,
               NTile(<Number_Of_Groups>) Over (Order By <Column>)
               From <Table>
  */ 
  -- Rank كله وتديله Group بمعني انها بتمسك ال , Group بتشتغل علي ال
  -- عليها هيقرب لاقرب رقم يقبل القسمه عليه Tableاللي هقسم ال Groups مش بيقبل القسمه علي عدد اللي Tableاللي في ال Rows لو عدد ال 
  

----- عايز اجيب اغني اتنين موظفين

Select *
From (
       Select Ins_Name, Ins_Id, Salary, 
	   NTILE(4) Over (Order By Salary Desc) as LevelNumber 
	   From Instructor
	   ) as LevelTable
Where LevelNumber = 1
-- بجيب الاول و الاخر بس Top الميزه هنا ان انا ممكن اجيب تالت اول رابع اغني واحد او رابع افقر واحد عكس ال 




---------------------------- 6 Execution order ----------------------------
/*
   1- From
   2- Join / On 
   3- where 
   4- Group By
   5- Having
   6- Select
   7- Distinct
   8- Order by
   9- Top
*/

/* بتاعها Excecution Order وقالي اقراها اقرأها بال  Query اداني Interview لو في ال */

Select St_Id as ID -- 3
From Student -- 1
--Where ID = 1 -- 2  --- هنا مش متشاف لسه ID ال 
--Order By  ID -- 4  --- هنا متشاف ID ال 



---------------------------- 7 Schema ----------------------------

/*
   -- A Schema is a collection of Database Objects - > [DDL]

   -- DBO -> Database Owner (Defult_Schema)
          -> Schema لو انا مش محدد dbo بكريته بيكون جوا ال Database Object اي 
		  -> dbo هوا بيفترض انه في ال Object ل Select نفس الكلام لو انا بعمل 

  ----- Schema Solved 3 Problems:

      -- 1. You Can't Create Object With The Same Name
	        -- مختلفه Schemas بنفس الاسم بس في Object بكدا ممكن يكون عندي اكتر من 
      
      -- 2. There Is No Logical Meaning (Logical Name)
          	-- بيكونوا ليهم علاقه ببعض Schema اللي موجودين جوا ال Objects ال 
      
      -- 3. Permissions
          	-- معينه Tables علي Access معين Userعايز ادي ل
			-- عليها Access واديله ال Schema في Tables لا انا هجمع ال Access واديله ال Tables فا بدل ما امشي علي كل ال 
*/


Select *
From [Abdalrhman-PC\MSSQLSERVER01].   ITI.          dbo          .Student
---        Server_Name                 DB        Schema_Name    Table
/*
   Server_Name -> DB اللي عليه ال Server_Name بنفس ال Login مش محتاج اكتبه عشان انا ببقي عامل 
   DB -> تاني DB من Select الا لو عايز , Use مش محتاج اكتبها عشان انا ببقي عاملها 
   dbo -> Defult_Schema 
*/


------------ 7.1 CREATE SCHEMA ------------

/* 
  -- Syntax -> Create Schema <Schema_Name> 
*/

GO
Create Schema HR
GO


------------ 7.2 ALTER SCHEMA ------------

/* 
  -- Transfer a Object from a schema to another

  -- Syntax -> Alter Schema <Schema_Name> 
             Transfer <Object_Name> 
*/

Alter Schema HR
Transfer dbo.Test

Create Table HR.Test2 (Col_1 int)


------------ 7.3 DROP SCHEMA ------------

/* 
  -- لازم انقلهم الاول او امسحهم objects وهيا فيها Drop Scehma مينفعش اعمل
   
  -- Syntax -> Drop Schema <Schema_Name> 

*/

Drop Table HR.Test2

Alter Schema dbo
Transfer HR.Test

Drop Schema HR