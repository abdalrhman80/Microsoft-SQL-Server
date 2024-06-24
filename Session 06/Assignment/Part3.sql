------------------------------------ Part 3 ------------------------------------
Use RouteCompany

/* 1.Create the following tables with all the required information and load the required data as 
   specified in each table using insert statements[at least two rows]
*/
Create Table Department
( 
 DeptNo Int Primary Key,
 DeptName Varchar(max),
 Location Varchar(max),
)

Create Table Employee
(
 EmpNo Int Primary Key,
 Emp_Fname varchar(max) Not NULL,
 Emp_Lname varchar(max) Not NULL,
 Dept_No Int references Department(DeptNo),
 Salary Int Unique
)

Create Table Project
(
 ProjectNo Int Primary Key,
 ProjectName varchar(max) Not NULL,
 Budget Int 
)


Insert Into Department
Values (1,'Research','NY'), 
       (2,'Accounting','DS'),
	   (3,'Marketing','KW')

Insert Into Employee
Values (18316,'John','Barrymore', 1, 2400), 
       (29346,'James','James', 2, 2800),
	   (10102,'Ann','Jones', 3, 3000)

Insert Into Project
Values (1,'Apollo', 120000), 
       (2,'Gemini', 95000),
	   (3, 'Mercury', 185600)

Insert Into Works_For
Values (18316, 1 ,'Analyst', '10-1-2006'), 
       (29346, 2 ,NULL, '5-12-2006'),
	   (10102, 3 ,'Manager', '1-1-2012'),
	   (29346, 1 ,'Clerk', '1-4-2007')

----------- Testing Referential Integrity -----------
-- 1. Add new employee with EmpNo =11111 In the works_on table ) 
  -- conflicted with the FOREIGN KEY constraint "FK_Works_For_Employee"

-- 2. Change the employee number 10102 to 11111  in the works on table 
  -- conflicted with the FOREIGN KEY constraint "FK_Works_For_Employee"

-- 3. Modify the employee number 10102 in the employee table to 22222 
  -- conflicted with the FOREIGN KEY constraint "FK_Works_For_Employee"

-- 4. Delete the employee with id 10102 
  -- conflicted with the REFERENCE constraint "FK_Works_For_Employee".

----------- Table Modification -----------
-- 1. Add TelephoneNumber column to the employee table
Alter Table Employee
Add TelephoneNumber Int

-- 2. drop this column
Alter Table Employee
Drop Column TelephoneNumber

-- 3. Build A diagram to show Relations between tables


/* 2. Create the following schema and transfer the following tables to it
      a. Company Schema 
         i.	Department table 
         ii. Project table 

      b. Human Resource Schema
         i. Employee table 
*/
GO
Create Schema Company
GO

Alter Schema Company
Transfer Department

Alter Schema Company
Transfer Project

GO
Create Schema Human_Resource
GO

Alter Schema Human_Resource
Transfer Employee


/* 3. Increase the budget of the project where the manager number is 10102 by 10%. */
Go
Select P.Budget + (P.Budget * 10) / 100 [Budget_Increas_10%]
From Company.Project P, Human_Resource.Employee E, Works_For Wo
Where E.EmpNo = Wo.EmpNo And P.ProjectNo = Wo.ProjectNo And E.EmpNo= 10102
Go


/* 4. Change the name of the department for which the employee named James works.
      The new department name is Sales.
*/

Update Company.Department
Set DeptName = 'Sales'
Where DeptName = (
                  Select D.DeptName
                  From Human_Resource.Employee E, Company.Department D
                  Where D.DeptNo = E.Dept_No And E.Emp_Fname = 'James'
				  )


/*
  5. Change the enter date for the projects for those employees who work in project p1 
     and belong to department ‘Sales’. The new date is 12.12.2007.
*/

Update Works_For
Set Enter_Date = '12-12-2007'
Where ProjectNo = 1 and  EmpNo = ( 
                                   Select E.EmpNo
						           From Company.Department D, Human_Resource.Employee E
						           Where D.DeptNo = E.Dept_No  AND D.DeptName = 'Sales'
								 )


/* 6. Delete the information in the works_on table for all employees who work 
      for the department located in KW.
*/

Delete Works_For
From Company.Department D, Human_Resource.Employee E, Works_For Wo
Where E.EmpNo = Wo.EmpNo And D.DeptNo = E.Dept_No And D.Location = 'KW'