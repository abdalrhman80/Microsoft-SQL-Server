-------------------------------- Part 1 --------------------------------

/* 1. Create a scalar function that takes a date and returns the Month name of that date. */
Use ITI

GO
Create Or Alter Function GetMonthName(@Date date)
Returns varchar(max)
Begin 
 Declare @MonthName varchar(max)
  Select @MonthName = DATENAME(MONTH, @Date)
 Return @MonthName
End
GO

Select dbo.GetMonthName(GETDATE())


/*2. Create a multi-statements table-valued function that takes 2 integers 
     and returns the values between them. */
Use ITI

GO
CREATE FUNCTION GetValuesBetweenTwoIntgers (@IntOne Int, @IntTwo Int)
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


/* 3. Create a table-valued function that takes Student No 
      and returns Department Name with Student full name. */
Use ITI

GO
Create Or Alter Function GetDeptNameAndStuFullNameBasedOnStuNum(@Stu_Num Int)
Returns Table
As
 Return 
 (
  Select CONCAT(S.St_Fname,' ', S.St_Lname) [St_FullName], D.Dept_Name
  From Student S, Department D
  Where D.Dept_Id = S.Dept_Id And S.St_Id = @Stu_Num
 )
GO

Select *
From dbo.GetDeptNameAndStuFullNameBasedOnStuNum(1)



/* 4.Create a scalar function that takes Student ID and returns a message to user 
     a.	If first name and Last name are null then display 'First name & last name are null'
     b.	If First name is null then display 'first name is null'
     c.	If Last name is null then display 'last name is null'
     d.	Else display 'First name & last name are not null'
*/
Use ITI

GO
Create Or Alter Function DisplayNullMessageBasedOnFirstAndLastName(@St_Id Int)
Returns varchar(max)
Begin
    Declare @FirstName varchar(max)
    Declare @LastName varchar(max)
    Declare @Message varchar(max) 

   Select  @FirstName = St_Fname,
           @LastName = St_Lname
   From Student 
   Where St_Id = @St_Id

   If @FirstName Is Null and @LastName Is Null
     Set @Message = 'First name & last name are null'
  
  Else If @FirstName Is Null  
     Set @Message = 'First name is null'
  
  Else If @LastName Is Null  
     Set @Message = 'Last name is null'
  
  Else 
	 Set @Message = 'First name & last name are not null'
  Return @Message
End
GO

Select dbo.DisplayNullMessageBasedOnFirstAndLastName(206)


/* 5.Create a function that takes an integer which represents the format of the Manager hiring date
     and displays department name, Manager Name and hiring date with this format
*/
Use MyCompany

GO
Create Or Alter Function DislpayDeptNameAndMgrNameAndMgrHiringDate(@DateFormate Int)
Returns Table
As
Return
(
 Select D.Dname, E.Fname, CONVERT(varchar(max),D.[MGRStart Date], @DateFormate) [MgrHiringDateBasedOnFormate]
 From Employee E, Departments D
 Where D.Dnum = E.Dno 
)
GO

Select *
From dbo.DislpayDeptNameAndMgrNameAndMgrHiringDate(102)


/* 6. Create multi-statement table-valued function that takes a string
      a. If string = 'first name' returns student first name
      b. If string = 'last name' returns student last name 
      c. If string = 'full name' returns Full Name from student table (Note: Use “ISNULL” function)

*/
Use ITI

GO
Create Or Alter Function GetStudentNameBasedOnFormate(@Formate varchar(max))
Returns @T Table (St_Name varchar(max))
As
Begin
  If @Formate = 'First Name'
   Insert Into @T
   Select ISNULL(St_Fname, 'No_Fname')
   From Student
  Else If @Formate = 'Last Name'
   Insert Into @T
   Select ISNULL(St_Lname,'No_Lname')
   From Student
  Else If @Formate = 'Full Name'
   Insert Into @T
   Select CONCAT(ISNULL(St_Fname, 'No_Fname'), ' ', ISNULL(St_Lname,'No_Lname'))
   From Student
 Return
End
GO

Select * 
From dbo.GetStudentNameBasedOnFormate('First Name')

Select * 
From dbo.GetStudentNameBasedOnFormate('Last Name')

Select * 
From dbo.GetStudentNameBasedOnFormate('Full Name')


/* 7. Create function that takes project number and display all employees in this project 
      (Use MyCompany DB)
*/
Use MyCompany

GO
Create Or Alter Function GetEmployeesWorksOnProject(@Pro_Num Int)
Returns Table
As
Return
(  
  Select Distinct E.*
  From Employee E, Works_for WO, Project P
  Where E.SSN = WO.ESSn and P.Pnumber=WO.Pno and P.Pnumber = @Pro_Num
)
Go

Select *
From dbo.GetEmployeesWorksOnProject(500)