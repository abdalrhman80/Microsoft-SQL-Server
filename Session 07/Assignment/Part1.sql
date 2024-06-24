--------------------------- Part 1 --------------------------- 

/* 
   1. Create a trigger to prevent anyone from inserting a new record in the Department table
      (Display a message for user to tell him that he can’t insert a new record in that table)
*/
Use MyCompany

GO
Create Trigger TRI_BlockInserOperation
On Departments
Instead Of Insert
As
  Print 'You can''t insert a new record in this table'
GO

Insert Into Departments(Dnum,Dname)
Values(1000,'DP1000')

/* 
   2. Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 

      Create a trigger on student table after insert to add Row in StudentAudit table 
        - The Name of User Has Inserted the New Student  
        - Date
        - Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name]

*/
Use ITI

GO
Create Table StudentAudit
(  
  Server_User_Name Varchar(max),
  Date DateTime,
  Note Varchar(max)
)
GO

GO
Create OR Alter Trigger TRI_InsertIntoStudentAuditAfterInsert
On Student
After Insert
As
  Insert Into StudentAudit
  Select SUSER_NAME(), GETDATE(),
         CONCAT_WS(' ', SUSER_NAME() , 'Insert New Row with Key = ', St_Id, 'In Student Table')
  From inserted
GO

Insert Into Student(St_Id, St_Fname, St_Lname)
Values (9000,'Abdo', 'Ali')


/* 
  3. Create a trigger on student table instead of delete to add Row in StudentAudit table 
    (The Name of User Has Inserted the New Student, Date, and note that will be like 
	 “try to delete Row with id = [Student Id]” )
*/
GO
Create Or Alter Trigger TRI_InsertIntoStudentAuditInstedOfDelete
On Student 
Instead Of Delete
As 
 Insert Into StudentAudit
 Select  'New Student', GETDATE(), CONCAT_WS(' ', 'Try to delete Row with id', St_Id)
 From deleted
GO

Delete From Student
Where St_Id = 7000