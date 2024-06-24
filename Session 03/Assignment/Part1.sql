------------------------------ Part1 ------------------------------
Use ITI

------ 1. Retrieve a number of students who have a value in their age. ------

Select COUNT(*) [Students_Count]
From Student
Where St_Age IS Not Null

------ 2. Display number of courses for each topic name ------

Select T.Top_Name, COUNT(*) [Courses_Count]
From Course C, Topic T
Where C.Top_Id = T.Top_Id
Group By T.Top_Name

------ 3. Select Student first name and the data of his supervisor ------

Select St.St_Fname , Sv.* 
From Student St, Student SV
Where SV.St_Id = St.St_super

------ 4. Display student with the following Format (use isNull function) ------

--Select St_Id [Student ID],
--       CONCAT(St_Fname, ' ', St_Lname) [Student Full Name], D.Dept_Name [Department Name]
--From Student S Join Department D
--On S.Dept_Id = D.Dept_Id

Select ISNULL(St_Id, 0) [Student ID], 
       ISNULL(St_Fname + ' '+  St_Lname ,'No-Student') [Student Full Name],
	   ISNULL(D.Dept_Name,'No_Department') [Department Name]
From Student S Full Outer Join Department D
On S.Dept_Id = D.Dept_Id

------ 5. Select instructor name and his salary but if there is no salary display value '0000'. ------

Select Ins_Name, ISNULL(Salary,'0000')
From Instructor

------ 6. Select Supervisor first name and the count of students who supervises on them ------

Select Sv.St_Id [Superviser ID], Sv.St_Fname [Superviser Fname], Count(*) [Students Count]
From Student St, Student Sv
Where Sv.St_Id = St.St_super
Group By Sv.St_Id, Sv.St_Fname

------ 7. Display max and min salary for instructors ------

Select MIN(Salary) [Min Salary], MAX(Salary) [Max Salary]
From Instructor

------ 8. Select Average Salary for instructors  ------

Select AVG(Salary) [AVG Salary]
From Instructor
