------------------------------- Part4 -------------------------------
use MyCompany

----- 1 -----
Select Dname, Dnum, MGRSSN
From Departments

----- 2 -----
Select Dname, Pname 
From Departments Inner Join Project
On Departments.Dnum = Project.Dnum

----- 3 -----
Select Emp.Fname + ' ' + Emp.Lname  as Emp_Name, Emp_Depnt.* 
From Employee Emp Inner Join Dependent Emp_Depnt
On Emp.SSN = Emp_Depnt.ESSN

----- 4 -----
Select Pname, Pnumber, Plocation, City
From Project
Where City = 'Cairo' or City = 'Alex'

----- 5 -----
Select *
From Project
Where Pname Like 'A%'

----- 6 -----
Select *
From Employee
Where Salary Between 1000 and 2000 and Dno = 30

----- 7 -----
Select Fname + ' ' + Lname  as Emp_Name , Wo.Hours, Proj.Pname
From Employee Emp Inner Join Works_for Wo
On Emp.SSN = Wo.ESSn
Inner Join Project Proj
On Proj.Pnumber = Wo.Pno
Where Dno = 10 and Wo.Hours >= 10 and Proj.Pname='AL Rabwah'

----- 8 -----
Select Fname + ' ' + Lname  as Emp_Name , Proj.Pname
From Employee Emp Inner Join Works_for Wo
On Emp.SSN = Wo.ESSn
Inner Join Project Proj
On Proj.Pnumber = Wo.Pno
Order By Proj.Pname Desc

----- 9 -----
Select Proj.Pnumber, Dep.Dname, Emp.Lname, Emp.Address, Emp.Bdate
From Project Proj Inner Join Departments Dep
On Dep.Dnum = Proj.Dnum
Inner Join Employee Emp
On Dep.MGRSSN = Emp.SSN
Where Proj.City ='Cairo'