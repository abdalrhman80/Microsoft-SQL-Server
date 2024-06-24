------------------------------- Part3 -------------------------------
use ITI

--------------- 1 ---------------
Select Distinct Ins_Name 
From Instructor

--------------- 2 ---------------
Select Ins_Name , Dept_Name
From Instructor Left Outer Join Department
On Instructor.Dept_Id = Department.Dept_Id

--------------- 3 ---------------
Select Student.St_Fname + ' ' + Student.St_Lname [Student_Name],
      Course.Crs_Name [Course_Name], Grade
From Student  Inner Join  Stud_Course StCr 
On Student.St_Id = StCr.St_Id
Inner Join Course
On Course.Crs_Id = StCr.Crs_Id 
Where Grade Is Not Null