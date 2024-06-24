use MyCompany
-- Use MyCompany Database
---------------------------

-- Q1. Get Count Of Employees
------------------------------
select  count(*)
from Employee

--------------------------------------------------
-- Q2. Get Sum , Average , Min and Max of Salaries
--------------------------------------------------
select Sum(Salary) as SumOfSalary , AVG(Salary) , MIN(Salary) , MAX(Salary)
from Employee 
------------------------------------------------------------------------------------------
-- Q3. Get Number of Employees in each Department 
--------------------------------------------------
select Dno , count(SSN) [Number Of Employees]
from Employee 
where Dno is not null
group by Dno


------------------------------------------------------------------------------------------
-- Q4. Get Sum of Salary of Employees for departments Which has more than One Employee
---------------------------------------------------------------------------------------

select Dno , COUNT(*) , sum(Salary)
from Employee
where dno is not null
group by Dno 
having count(*)>1

