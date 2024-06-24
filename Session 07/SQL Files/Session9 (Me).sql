------------------------ 01 Triggers -----------------------------
/*
   ---- Types of SP :
   ------------------
   --- 1. User defined
   	    SP_GetStudentNameAndAgeById   
   
   --- 2. Built-In SP
   	    Sp_helptext'object_name'    Sp_Rename 'object_name' , 'new_name' ,'object_type'
   	  
   --- 3. Trigger (Special Stored Procedure)
       -- Event Listener -> (Fire when a certain action occurs)
	   -- Trigger is Database Object -> [DDL]
       -- Can't Call
       -- Can't take parameters

   
   --- Types of Triggers 
      -- 1. DML Triggers -> [Table | View] 
	       -- Invoked automatically in response to INSERT, UPDATE, and DELETE events 
		   -- واحد بس Trigger الواحد بيكون عليه Eventال Tableعلي ال
		   
	  -- 2. DDL Triggers -> [DB | Server]
	      -- Fire in response to CREATE, ALTER, and DROP statements

	  -- 3. Logon Triggers -> [Logon Events]
	      -- Fire in response to LOGON events

*/


-------------------- 02 DML Trigger (After, Before, Instead Of, Disable, Enable) --------------------
/*
   Creation -> CREATE TRIGGER <schema_name>.<Trigger_Name>
               ON <schema_name>.<Table_Name>
               [ 
			     After <Event -> {Insert, Update, Delete}> 
				   -- Event هيتنقذ بعد ال Trigger ال
				 OR
				 Before <Event -> {Insert, Update, Delete}> 
				   -- Event هيتنقذ قبل ال Trigger ال
				 OR
				 Instead Of <Event -> {Insert, Update, Delete}> 
				   -- نفسه Event هيتنقذ بدل ال Trigger ال
			   ]
               AS
                 <Trigger_Body>
*/

---- EX 1 -> 'Welcome Student' يطلع Insert in Student table كل ما اعمل Trigger عايز اعمل
GO
Create Or Alter Trigger TRG_HelloStMessagAfterInsert
On Student
After Insert
As
  Print 'Hello Student'
GO

GO
Insert into Student(St_Id, St_Fname)
Values (6000, 'Ali')
GO

----- EX 2 -> Updateاللي عمل ال User يطلع الوقت وال Update on Student table لما اعمل Trigger عايز اعمل
GO
Create Or Alter Trigger TRI_GetTimeAndUserAfterUpdateStudentTable
On Student
After Update
As
  Select SUSER_NAME() [User_Name], GETDATE() [Update_Date]
GO

GO
Update Student
Set St_Fname = 'Alaa'
Where St_Id = 6000
GO

----- EX 3 -> Student Table يمنع اني امسح من ال Trigger عايز اعمل
GO
Create Trigger TRI_BlockDeleteOnStudentTable
On Student
Instead Of Delete
As
  Print 'You Can''t Delete From This Table'
Go
  -- Instead Of Delete / Update Triggre مش هينفع اكريت Table علي ال Cascade Rule لو انا عامل 

GO
Delete From Student
Where St_Id = 6000
GO

Go
--Alter Schema Sales
--Transfer Student
--GO

--GO
--Create Or Alter Trigger Sales.TRI_BlockDeleteOnStudentTable
--On Sales.Student
--Instead Of Delete
--As
--  Print 'You Can''t Delete From This Table'
--GO

--Drop Trigger Sales.TRI_BlockDeleteOnStudentTable

--GO
--Alter Schema dbo
--Transfer Sales.Student
GO

----- EX 4 -> Error Message ويطلع Department Table علي Inser, Update, Deleteيمنع ال Trigger عايز اعمل
GO
Create Trigger TRI_BlockDMLOperations
On Department
Instead Of Insert, Update, Delete
As
   RaisError('You Cant''t Do any DML Operations on this Table', 16, 1)
GO

GO
Update Department
Set Dept_Name = 'HR'
Where Dept_Id = 80
GO

---------- Disable / Enable ----------
/*
  -- Disable / Enable اقدر استخدم DML Operations عشان اقدر اعمل Drop Trigger بدل ما اروح اعمل

  Sytax -> Alter Table <Table_Name>
           {Disable | Enable} Trigger <Trigger_Name>
*/ 

GO
Alter Table Department
Disable Trigger TRI_BlockDMLOperations
GO


-------------------- 03 Inserted-Deleted Tables With Triggers --------------------

/*
   -- 2 Tables: Inserted & Deleted Will Be Created With Each Fire Of Trigger (During Runtime)
   -- In Case Of Delete: Deleted Table Will Contain Deleted Values & Inserted Contain no Values
   -- In Case Of Insert: Inserted Table Will Contain Inserted Values & Deleted Contain no Values
   -- In Case Of Update: Deleted Table Will Contain Old Values
   --					 Inserted Table Will Contain New Values		
*/

/*
  Select * From Deleted  =|
                          | => يشتغل Trigger مش موجدين غير لما ال 
  Select * From Inserted =|
*/

GO
Create Trigger TRI_ShowDeletedInsertedTablesOnUpdate
On Course
After Update
As
  Select * From deleted
  Select * From inserted
GO

GO
Update Course
Set Crs_Name = 'Angular'
Where Crs_Id = 1200
GO

---- Ex 5 -> 'You Can't Delet [Course_Name] Corse' يطلع Trigger عايز اعمل 
GO
Create Or Alter Trigger TRI_ShowMessageContainCrsNameWhenDelete
On Course
Instead Of Delete
As
  Select CONCAT_WS(' ', 'You Can''t Delete', (Select Crs_Name From  deleted),'Corse' )[ErrorMSG]
GO

GO
Delete From Course
Where Crs_Id = 1200
GO

---- Ex 5 -> Thursday يوم Student Table يمنع اني امسح من ال Trigger عايز اعمل 
GO
/*
  SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate;
  SELECT FORMAT(GETDATE(), 'dddd') AS DayName;
  SELECT FORMAT(GETDATE(), 'MMMM') AS MonthName;
  SELECT FORMAT(GETDATE(), 'yyyy') AS Year; 
*/
GO

GO
Create OR Alter Trigger TRI_BlockDelteOnThursday
On Student
Instead Of Delete
As
  IF FORMAT(GETDATE(), 'dddd') != 'Thursday'
    Begin
      Delete From Student
	   Where St_Id In (Select St_Id From deleted)
    End
  Else
    Begin
      RaisError('You Can''t Delete on Thursday', 16, 1)
    End
GO

GO
Delete From Student
Where St_Id = 6000
GO


------------------------ 04 Index -----------------------------

/*
   --- وكمان بيتسئل كتير في الانترفيوز Performaceمن اهم الحجات اللي بتفرق في ال
   --- Indexes are special data structures associated with tables or views that help speed up the query. 
   --- Index is Database Object -> [DDL]


   --- 4.1 Clusterd Index :

        -- A clustered index determines the physical order of data in a table.
		   -- هتترتب بالترتيب اللي انا دخلتها بي Data فا ال PK من غير Table لو انا عامل
		   -- PK هتترتب بال Data وبالتالي ال Clusterd Index فا هيبقي في PK لاكن لو في 

        -- When creating a table with a primary key, SQL Server automatically creates 
		   a clustered index based on the primary key columns.
		   -- clustered index فا هوا علي طول بيروح يعمل PK ده وضفت Table وعدلت ال PK من غير Table لو في 
		
		-- A clustered index organizes data using a special structured Binary-Tree (or Balanced tree) 
		   -- Top node of the Binary-Tree is called the root node.
		   -- The nodes at the bottom level are called the leaf nodes (Data)
		
		-- A table has only one clustered index.


	    -- Creathion (PK في حاله لو مفيش) -> Create Index IX_<index_name>
                                              ON <table_name>(<column_list>) 

   -----------------------------------------------------------------------------------

   --- 4.2 Non-Clusterd Index :

      -- A Nonclustered index sorts and stores data separately from the data rows in the table.	

	  -- It is a copy of selected columns of data from a table with the links to the associated table.
	     -- Heap وبيتخزن في ال Nonclustered index اللي هعمل عليه Column هو بيروح يرتب الداتا بناء علي ال
		 -- Tableاللي في ال Dataبيشاور علي ال Pointer نفسها دي مجرد Dataمش بتبقي ال nodes Leaf فا ال
		 -- [ Log(n) + 1 ] <- في Data فا هنا انا بوصل لل
	   
	  -- A Nonclustered index uses the Binary-tree to organize its data.

	  -- A table may have one or more nonclustered indexes (1-999).

	  -- Tableفي ال Columnsعلي كل ال Nonclustered index مينفعش اعمل 
	      -- Memory لانه بياخد مكان في ال
		  -- Nonclustered index لانه هيروح يمشي علي كل ال Insert وكمان هيكون فيه مشكله في ال
		     بطئ جدا Performance اللي ضفته تريبه فين وكدا هيبفي ال row ويشوف الل


	  -- Slower Than Clustered Index.

	 
	 -- Creathion -> Create Nonclustered Index IX_<index_name>
                      ON <table_name>(<column_list>)

 --------------------------------------------------------------------------------------------

  --- Two Types of Search :
      -- Linear Search [(n)Steps ] -> [Index ولا معمول عليه PKبيه مش ال Search اللي ب Column لو ال]
      -- Binary Search [Log(n) Steps] -> [Index او معمول عليه PKبيه هوا ال Search اللي ب Column لو ال]
   
     --- 8 Rows بالشكل ده وجواه Tabel هفترض اني عندي 
	      Create Table Test2 ( X Int Primary Key, Y Varchar(max) )
	       -- Binary-Tree فا الداتا متخزنه علي شكل Clusered Index هنا في 
       
      (1) Select *
          From Test2
          Where X = 8 
		    -- Binary Search فا كدا هوا شغال PK وهوا ال X ب Search هنا انا بعمل  
			-- هنا بيروح يشوف ال8 دي اكبر من ال 4 لو اه فا كدا لغيت الجزء اللي علي الشمال وفاضل من 5-8
			-- وبعدين بيروح يشوف ال8 دي اكبر من ال 6 لو اه فا كدا لغيت الجزء اللي علي الشمال وفاضل من 7-8
			-- اخر حاجة بيشوف ال 8 دي اكبر من ال 7 ولو اه بيروح للجزء التاني اللي هوا الناتج 
			-- [Log(8)] <- فا كدا انا وصلت للناتج في 3 خطوات 
        
      (2) Select *
          From Test2
          Where Y = 'Ahmed'  
            -- Index فا انا محتاج اشوف هل هوا معمول عليه PK ودا مش ال Y ب Search هنا انا بعمل  
            -- Alphabetic فا الترتيب هنا , Y بناء علي ال B-Tree وهيروح يعمل Binary Search لو اه فا كدا هوا شغال

*/
GO

------------------------ 5 Unique Constrain - Non-Clustered Index (Unique-non unique) -----------------------------

/*
	-- A Nonclustered index has Two Types :
	   -- Unique Nonclustered index -> [مينفعش ننكرر Indexاللي عامل عليه ال Colاللي في ال Values ال]
       -- NonUnique Nonclustered index -> [تقدر تتكرر Indexاللي عامل عليه ال Colاللي في ال Values ال]
	
	-- Nonclustered index تلقائي بتعمل عليها  Unique Constrain ال

	-- Creathion -> Create Unique Nonclustered Index IX_<index_name>
                     ON <table_name>(<column_list>)
	   -- لازم الداتا فيها متكونش متكرره Unique Nonclustered index الي بعمل عليها Columns ال
*/

Create Table Test3 
(
  X Int Primary Key, 
  Y Int Unique,
  Z Int Unique
  -- Clustered Index(X) ده هيبقي في Table هنا ال
  -- Unique Constrain بسبب ال NonClustered Index(Z) وهيبقي فيه 
)

--- How Can I Select The Columns To Make Indexes On It?
/*
  -- Analysis
  -- Testing (Using SQL Server Profiler and Tuning Advisor)

*/
GO

------------------------ 6 SchemaBinding -----------------------------

/*
  -- SchemaBinding -> منها Select اللي ب Tablesبال Viewبتربط ال View بستخدمها وانا بكريت ا Keyword عباره عن 
                     
  -- When a database object is schema-bound, it ensures that the underlying tables cannot be Altered or Droped
     in a way that would affect the schema-bound object. 

  -- View من ال Selectلان لما بروح ا Performance ليه ميزه كمان في ال
     ولا لا Valid هيا Select ب View اللي ال Data قبلها بيروح يشوف هل ال 
	 مش هتتغير Table بتاعت ال MetaData مش هيعمل الخطوة دي لان ال With SchemaBinding بس لو استخدمت 
*/
Go

Create View Test3View
With Encryption, SchemaBinding
As
  Select X, Y
  From dbo.Test3
GO

Drop Table Test3 -- Cannot DROP TABLE 'Test3' because it is being referenced by object 'Test3View'.
GO

------------------------ 7 Indexed View -----------------------------

/*
  -- Index وانا بروح اعمل عليه Standerd View عباره عن 
  -- With SchemaBinding لازم اكون مستخدم Indexed View عشان اعمل
  -- Viewلل Unique Clustered Index لازم اعمل Nonclustered Index ل Create قبل ما اعمل 
  -- Search Binary لان هنا ب Standered View عن ال Performance هيفرق في ال

  -- Creathion -> Create [Unique Clustered] Index IX_<index_name>
                  ON <View_name>(<column_list>)
*/

GO
Create Index IX_Test3NonCl
On Test3View (Y) -- Cannot create index on view 'Test3View'. It does not have a unique clustered index.
GO

GO
Create Unique Clustered Index IX_Test3Cl
On Test3View (X)
GO


------------------------ 8 Transaction Control Language (TCL) -----------------------------
/*
  -- Transaction -> [Insert, Update, Delete]
  -- TCL -> Transaction بتتحكم في 

  ---- 8.1 Implicit Transaction 
	  -- DML Query [Insert, Update, Delete]
	  -- Transaction مش محتاج اكتب كلمه 
      -- واحده Query بتتكون من 
	  
	                Insert Into Student(St_Id, St_Fname)
                    Values (100, 'Ahmed'), (101, 'Amr')
	                
                    Update Student
	                 set St_Age = 30 
	                 where St_Age = 20

   ------------------------------------------------------------

  ---- 8.2 Explicit Transaction
	  -- Set Of Implicit Transactions
	  -- Syntax ->  Begin Transaction 
                     <Set of Implicit Transactions (Batch)>
                    Commit (Transactionهينفذ ال) || Rollback (Error اللي عملها لو في Transaction هيرجع في ال)
*/

Create table Parent
(
ParentId int primary key
)

Insert into Parent 
values(1) ,(2) ,(3) 
GO

Create table Child
(
ChildId int primary key,
FK_ParentId int references Parent(ParentId)
)
GO

Insert Into Child
Values (1,1), (2,100), (3,3)  -- كدا مفيش حاجة هتتضاف Insert لو عملت

------------------------------------------------------------

Insert Into Child Values(1, 1) -- Inserted
Insert Into Child Values(2, 100) -- Error (Logical Error -> ال100 مش موجود)
Insert Into Child Values(3, 3) -- Inserted
GO


Begin Transaction
  Insert Into Child Values(4, 1)
  Insert Into Child Values(5, 100)
  Insert Into Child Values(6, 3)
Commit -- مش هيضفها وهيضيف الباقي Error هنا لو في حاجة طلعت  
GO


Begin Transaction
  Insert Into Child Values(7, 1)
  Insert Into Child Values(8, 100)
  Insert Into Child Values(9, 3)
Rollback -- مش هيضيف كله Error هنا لو في حاجة طلعت  
         -- بس مش هيضيف حاجة (one row affected) هيطلع
GO
	  

---- ؟ Rollback ولا Commit اللي عايزها تتنفذ استخدم معاها Transaction هعرف منين ال
	  -- TRY CATCH جوا ال Transactions هحط ال 
      
BEGIN TRY
  Begin Transaction
    Insert Into Child Values(10, 1)
    Insert Into Child Values(11, 100)
    Insert Into Child Values(12, 3)
  Commit
  -- CATCH هينزل في ال Error هنا اول ما يلاقي  
END TRY
BEGIN CATCH
END CATCH
 -- ومفهاش حاجة جواها CATCH هيروح ينفذ ال TRY في ال Error هنا مش هيضيف حاجة لان اول ما يلاقي
Go

BEGIN TRY
  Begin Transaction
    Insert Into Child Values(13, 1)
    Insert Into Child Values(16, 2)

	Save Transaction P1 -- Error لو طلع في Rollback ميعملعاش Transaction لو عايز 
	
    Insert Into Child Values(14, 100)
    Insert Into Child Values(15, 3)
  Commit
END TRY
BEGIN CATCH
  Rollback Transaction P1
END CATCH
Go

------------------------ 9 Data Control Language (DCL) -----------------------------

/*  
  DCL -> -- Securty and Permissions خاصة بال 
         -- Tablesفي ال Data او مين يقدر يتعامل مع ال Tablesاو ال DB ال Access مين يقدر 
		 -- code مش Wizard في الاغلب بنتاعمل 
  
  
    1- [Login]         Server (Abdo)
    2- [User]          DB Route (Omar)
    3- [Schema]        Sales   [Department, Instructor]
    4- Permissions     Grant [select,insert] ,   Deny [delete Update]
*/

----------- 1- Create Login -----------
GO
Create Login Test1 
With Password = '123';
GO

----------- 2- Create User -----------
GO
Use ITI
Create User Test1_User
For Login Test1
GO

----------- 3- Schema -----------

---- 3.1- StCrs Schema 
GO
Create Schema StCrs
GO

---- 3.2- Transfer Student To StCrs Schema
GO
Alter Schema StCrs
Transfer Student
GO

---- 3.3- Transfer Course To StCrs Schema
GO
Alter Schema StCrs
Transfer Course
GO

----------- 4- Permissions -----------

---- 4.1 - GRANT Select, Insert 
GO
GRANT Select, Insert
ON Schema::StCrs 
TO Test1_User;
GO

---- 4.2 - Deny SelectDelete, Update 
Deny Delete, Update
ON Schema::StCrs 
TO Test1_User;