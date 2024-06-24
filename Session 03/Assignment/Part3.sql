------------------------------ Part3 ------------------------------
Use MyCompany

--- 1. Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.---

Select CONCAT(Emp.Fname, ' ', Emp.Lname) [Emp_Name]
From Employee Emp  inner Join Works_for Wo
On Emp.SSN = Wo.ESSn
Inner Join Project Pr
On Pr.Pnumber = Wo.Pno
Where Emp.Dno = 10 and  Wo.Hours >= 10 and Pr.Pname = 'AL Rabwah'

--- 2. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name ---

Select CONCAT(Emp.Fname, ' ', Emp.Lname) [Emp_Name] , Pr.Pname
From Employee Emp  inner Join Works_for Wo
On Emp.SSN = Wo.ESSn
Inner Join Project Pr
On Pr.Pnumber = Wo.Pno
Order By Pr.Pname

--- 3. For each project located in Cairo City, find the project number, the controlling department name, the department manager last name, address and birthdate. ---

Select Pr.Pnumber,
       Dept.Dname,
	   Emp.Lname [Manager_Lname],
	   Emp.Address [Manager_Address],
	   Emp.Bdate [Manager_Bdate]
From Employee Emp  inner Join Departments Dept
On Emp.SSN = Dept.MGRSSN
Inner Join Project Pr
On Dept.Dnum = Pr.Dnum
Where Pr.City='Cairo'

--- 4. Display the data of the department which has the smallest employee ID over all employees'ID.---

--Select MIN(SSN) [MIN SSN], Dno
--From Employee Emp, Departments Dept
--Where Dept.Dnum = Emp.Dno
--Group By Dno

SELECT d.*
FROM Departments d
INNER JOIN Employee e 
ON d.Dnum = e.Dno
WHERE e.SSN = (
    SELECT MIN(SSN)
    FROM employee
);


--- 5. List the last name of all managers who have no dependents ---

--Select Emp.Lname [Manger_Lname] 
--From Employee Ma Inner Join Employee Emp
--on Ma.SSN = Emp.Superssn
--Left outer join Dependent Depn
--on Emp.SSN = Depn.ESSN 
--Where Depn.Dependent_name is null

Select Emp.Lname [Manger_Lname] 
From Employee Emp Left outer join Dependent Depn
on Emp.Superssn = Depn.ESSN 
Where Depn.Dependent_name is null