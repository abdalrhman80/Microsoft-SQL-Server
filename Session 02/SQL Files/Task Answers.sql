
-- Use MyCompany Database
---------------------------
-----------------------------------------------------------------------------------------
-- Q1. Get a list of Employee Name and Department Name 
-------------------------------------------------------

Select Emp.Fname , Dep.Dname
From Employee Emp , Departments Dep
Where Dep.Dnum = Emp.Dno

-------------------------------------------------------
-- Q2. Get Employee name and name of his/her Supervisor
-------------------------------------------------------

Select Emp.Fname [Employee Name] , Super.Fname [Supervisor Name]
From Employee Emp , Employee Super
Where Super.SSN = Emp.Superssn

------------------------------------------------------------------
-- Q3. Get Employee data and Name of Project that they works on 
------------------------------------------------------------------

Select Emp.* , Pro.Pname 
From Employee Emp , Project Pro , Works_for WF
where Emp.SSN = WF.ESSn and Pro.Pnumber = WF.Pno

------------------------------------------------------------------
-- Q4. Update Salary of Male Employees with 10% of their salary 
------------------------------------------------------------------

update Employee
Set Salary += 0.1 * Salary
From Employee 
Where Sex = 'M'

