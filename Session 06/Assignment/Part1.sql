------------------------------------ Part 1 ------------------------------------
/* 1. Create a stored procedure to show the number of students per department.*/
Use ITI

GO
Create Procedure SP_StudentsCountPerDept @Dept_id int
With Encryption
As
  Select COUNT(*) [Number_Of_Students]
  From Student
  Where Dept_Id = @Dept_id
GO

Exec SP_StudentsCountPerDept 60

/* 
  2. Create a stored procedure that will check for the Number of employees in the project 100 
     if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'”
	 if they are less display a message to the user “'The following employees work for the project 100'” 
	 in addition to the first name and last name of each one. 
*/

Use MyCompany

GO
Create Procedure SP_CheckEmployeesInProject100 
With Encryption
As
  Declare @Emp_Count Int
  Select @Emp_Count = COUNT(*)
  From Employee E, Works_for WO, Project P
  Where E.SSN = WO.ESSn AND P.Pnumber = WO.Pno AND P.Pnumber = 100

  If @Emp_Count > 3 
  Begin
    Select 'The number of employees in the project 100 is 3 or more' [Message]
  End

  Else If @Emp_Count < 3
  Begin
    Select CONCAT('The following employee work for the project 100 ', E.Fname, ' ', E.Lname) [Message]
    From Employee E, Works_for WO, Project P
    Where E.SSN = WO.ESSn AND P.Pnumber = WO.Pno AND P.Pnumber = 100
  End
GO

Exec  SP_CheckEmployeesInProject100


/* 
  3. Create a stored procedure that will be used in case an old employee has left the project 
     and a new one becomes his replacement. The procedure should take 
	 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table.
*/

Use MyCompany 

GO
Create Procedure SP_UpdateWorksForTable @OldEmp_Id Int, @NewEmp_Id Int, @Pnum Int
With Encryption
As
  Begin Try
    Update Works_for 
    Set ESSn  = @NewEmp_Id
    Where ESSn = @OldEmp_Id AND Pno = @Pnum
  End Try
  Begin Catch
    Select 'Error Has Been Occured' [Error_Message]
  End Catch
GO

Exec SP_UpdateWorksForTable 141618, 111111, 100