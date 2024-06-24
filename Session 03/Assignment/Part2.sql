------------------------------ Part2 ------------------------------
Use MyCompany

--- 1. For each project, list the project name and the total hours per week (for all employees) spent on that project. ----

--Select Emp.SSN, Pr.Pname, Wo.Hours 
--From Project Pr inner Join Works_for Wo
--On Pr.Pnumber = Wo.Pno
--Inner Join Employee Emp
--On Emp.SSN = Wo.ESSn
--Group By Emp.SSN, Pr.Pname, Wo.Hours
--Order By Pr.Pname

Select Pr.Pname, Wo.Hours 
From Project Pr inner Join Works_for Wo
On Pr.Pnumber = Wo.Pno
Inner Join Employee Emp
On Emp.SSN = Wo.ESSn
Group By Pr.Pname, Wo.Hours
Order By Pr.Pname

--- 2. For each department, retrieve the department name and the maximum, minimum and average salary of its employees. ----

Select Dept.Dname, MIN(Emp.Salary) [Min Salary], 
                   MAX(Emp.Salary) [Max Salary], 
				   AVG(Emp.Salary) [Avrage Salary]
From Departments Dept, Employee Emp
Where Dept.Dnum = Emp.Dno
Group By Dept.Dname

--- 3. Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name. ---

Select Emp.*, Pr.*
From Project Pr inner Join Works_for Wo
On Pr.Pnumber = Wo.Pno
Inner Join Employee Emp
On Emp.SSN = Wo.ESSn
Inner Join Departments Dept
on Dept.Dnum = Emp.Dno
Order By Emp.Dno, Dept.Dname

--- 4. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%  ----

Select Salary+(Salary *30)/100  [Salary * 30%]
From Project Pr inner Join Works_for Wo
On Pr.Pnumber = Wo.Pno
Inner Join Employee Emp
On Emp.SSN = Wo.ESSn
Where Pr.Pname = 'Al Rabwah'

-------- DML 1. --------

Insert into Departments
Values('DEPT IT', 100, 112233, '1-11-2006')

-------- DML 2. --------

---- a ----
Update Departments
Set MGRSSN = 968574
Where Dnum = 100

Update Employee
Set Dno = 100
Where SSN = 968574

---- b ----
Update Departments
Set MGRSSN = 141618
Where Dnum = 20

------ c ----
Update Employee
Set Superssn = 141618
Where SSN = 102660

Update Employee
Set Dno = 20
Where SSN = 102660

-------- DML 3. --------

Delete From Employee
Where SSN = 223344

--Select Depn.*
--From Employee Emp , Dependent Depn
--Where Emp.SSN = Depn.ESSN and Depn.ESSN = 223344

Delete From Dependent
Where ESSN = 223344

--Select Emp.Fname [Emp Fname], Emp.SSN [Emp SSN], Sv.SSN [Super SSN]
--From Employee Emp , Employee Sv
--Where Sv.SSN = Emp.Superssn and Sv.SSN = 223344

--Select Emp.Fname [Emp Fname], Emp.SSN [Emp SSN], Sv.SSN [Super SSN]
--From Employee Emp , Employee Sv
--Where Sv.SSN = Emp.Superssn and Sv.SSN = 141618

Update Employee
Set Superssn = 141618
Where Superssn = 223344

--Select Dept.*
--From Employee Emp , Departments Dept
--Where Dept.Dnum = Emp.Dno and Emp.SSN = 223344

Update Departments
Set MGRSSN = 141618
Where MGRSSN = 223344

--Select WO.*
--From Project Pr inner Join Works_for Wo
--On Pr.Pnumber = Wo.Pno
--Inner Join Employee Emp
--On Emp.SSN = Wo.ESSn
--Where Wo.ESSn = 223344

Update Works_for 
Set ESSn = 141618
Where ESSn = 223344
