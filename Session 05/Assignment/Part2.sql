-------------------------------- Part 2 --------------------------------

-------------------- One --------------------
Use ITI

/*1. Create a view that displays the student's full name, 
     course name if the student has a grade more than 50. */

GO
Create Or Alter View GetStFullNameAndCrsNameView
As
Select CONCAT(S.St_Fname, ' ', S.St_Lname )[St_FullName], SC.Grade
From Student S, Stud_Course SC, Course C
Where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id and SC.Grade > 50
GO

Select * From GetStFullNameAndCrsNameView


/*2. Create an Encrypted view that displays manager names and the topics they teach. */

GO
Create Or Alter View InstructorMangerTopicsView(Manger_Name, Topic_Name)
With Encryption
As
Select Ins.Ins_Name, T.Top_Name 
From Department D , Instructor Ins, Ins_Course InsSC, Course C, Topic T
Where Ins.Ins_Id = D.Dept_Manager and
      Ins.Ins_Id = InsSC.Ins_Id and
      C.Crs_Id = InsSC.Crs_Id  and 
	  T.Top_Id = C.Top_Id 
Go

Select * From InstructorMangerTopicsView


/* 3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” 
      and describe what is the meaning of Schema Binding */

/* Schema binding refers to the process of associating a database view to underlying tables
   in order to put indexes directly on the view. */

GO
CREATE VIEW dbo.InstructorDepartment_Sd_Java
With SchemaBinding
AS
Select I.Ins_Name, D.Dept_Name
From dbo.Instructor I, dbo.Department D
Where D.Dept_Id = I.Dept_Id and D.Dept_Name IN ('SD' , 'Java') 
Go

Select * From InstructorDepartment_Sd_Java

/* 4.Create a view that will display the project name and the number of employees working on it.*/

Use MyCompany

GO
Create Or Alter View EmployeeProjectView (Project_Name ,Num_Of_Employees)
As
Select P.Pname, COUNT(E.SSN)
From Employee E, Project P , Works_for WO
Where E.SSN = WO.ESSn and P.Pnumber = WO.Pno
Group By P.Pname
GO

Select * From EmployeeProjectView


-------------------- Two --------------------
Use [SD32-Company]

/* 1. Create a view named “v_clerk” that will display employee Number, project Number,
      the date of hiring of all the jobs of the type 'Clerk'. */
GO
Create Or Alter View v_clerk(Employee_Number, Project_Number, Hiring_Date)
As
Select E.EmpNo , P.ProjectNo, Wo.Enter_Date
From HR.Employee E , Works_on Wo, HR.Project P
Where E.EmpNo = Wo.EmpNo and P.ProjectNo = Wo.ProjectNo and Wo.Job = 'Clerk'
GO

Select * From v_clerk


/* 2. Create view named  “v_without_budget” that will display all the projects data without budget */
GO
Create Or Alter View v_without_budget
As
Select P.ProjectNo, P.ProjectName
From HR.Project P
GO

Select * From v_without_budget


/* 3. Create view named  “v_count “ that will display the project name and the Number of jobs in it */
GO
Create View v_count(Project_Name, Jobs_Count)
As
Select P.ProjectName, COUNT(WO.Job)
From HR.Project P , Works_on WO
Where P.ProjectNo = WO.ProjectNo
Group By P.ProjectName
GO

Select * From v_count


/* 4. Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ .
      (use the previously created view  “v_clerk”) */
GO
Create Or Alter View v_project_p2(Emp#)
As
Select Employee_Number
From v_clerk
Where Project_Number = 2
Go

Select * From v_project_p2


/* 5. modify the view named  “v_without_budget”  to display all DATA in project p1 and p2. */
GO
Alter View v_without_budget
As
Select *
From HR.Project P
Where ProjectNo Between 1 and 2 
GO

Select * From v_without_budget



/* 6. Delete the views  “v_ clerk” and “v_count”*/
Drop View v_clerk
Drop View v_count


/* 7. Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’ */
Go
Create Or Alter View EmployeeDept_2(Emp#, Employee_Last_Name)
As
Select E.EmpNo, E.EmpLname
From HR.Employee E, Department D
Where D.DeptNo = E.DeptNo and E.DeptNo = 2
Go

Select * From EmployeeDept_2


/* 8. Display the employee lastname that contains letter “J” (Use the previous view created in Q#7) */
Select *
From EmployeeDept_2
Where Employee_Last_Name Like '%J%'


/* 9. Create view named “v_dept” that will display the department# and department name*/
Go
Create Or Alter View v_dept(Department#, Department_Name)
As
Select DeptNo, DeptName  
From Department
GO

Select * From v_dept