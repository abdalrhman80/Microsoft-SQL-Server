------------------------------- Part2 -------------------------------
use MyCompany

--------------- 1 ---------------
Select * 
From Employee

--------------- 2 ---------------
Select Fname, Lname, Salary, Dno
From Employee

--------------- 3 ---------------
Select Pname, Plocation, Dnum
From Project

--------------- 4 ---------------
Select Fname + ' ' + Lname  as FullName , (Salary*12)* 10/100 as [ANNUAL COMMISSION] 
From Employee

--------------- 5 ---------------
Select Fname + ' ' + Lname  as FullName , SSN
From Employee
Where Salary > 1000

--------------- 6 ---------------
Select Fname + ' ' + Lname  as FullName , SSN , Salary*12 as [Annual Salary]
From Employee
Where Salary*12	 > 10000 

--------------- 7 ---------------
Select Fname + ' ' + Lname  as FullName , SSN 
From Employee
Where Sex ='F'

--------------- 8 ---------------
Select Dname, Dnum
From Departments
Where MGRSSN = 968574

---------------9 ---------------
Select Pname, Pnumber, Plocation
From Project 
Where Dnum = 10