--------------------------- Part 2 --------------------------- 

/*
  1. Create a trigger that prevents the insertion Process for Employee table in March.
*/
Use MyCompany 

GO
Create Or Alter Trigger TRI_PreventInsertOnMarch
On Employee
Instead Of Insert
As
  If (Select FORMAT(GETDATE(),'MMMM')) = 'March'
    Begin
      RaisError('You Can''t Insert In March', 16, 1)
    End
  Else
    Begin
     Insert Into Employee
	 Select Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno
	 From inserted
   End
Go

Insert Into Employee(Fname,SSN)
Values ('Alaa' ,998579)

/* 
  1. Create an Audit table with the following structure 

           ProjectNo	UserName 	ModifiedDate     Budget_Old    Budget_New 
              p2	      Dbo        2008-01-31	       95000        200000

   This table will be used to audit the update trials on the Budget column (Project table, Company DB)
   If a user updated the budget column then the project number, username that made that update, 
   the date of the modification and the value of the old and the new budget will be inserted into the Audit table
   (Note: This process will take place only if the user updated the budget column)
*/
Use [SD32-Company]

Go
Create Table AuditTable2
(
  ProjectNo Int,
  UserName Varchar(Max),
  ModifiedDate Date,
  Budget_Old Int,
  Budget_New Int
)
GO

GO
Create Trigger TRI_InsertIntoAuditTable2AfterUpdate
On [HR].[Project]
After Update
As 
  Insert Into AuditTable2(ProjectNo, UserName, ModifiedDate, Budget_Old)
  Select ProjectNo, SUSER_NAME(), FORMAT(GETDATE(),'yyyy-MM-dd'), Budget
  From deleted

  Insert Into AuditTable2 (Budget_New)
  Select Budget From inserted
Go

Update HR.Project
Set Budget = 10001
Where ProjectNo = 3