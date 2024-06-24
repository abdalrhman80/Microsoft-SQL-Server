------------------------------- Part1 -------------------------------
Use ITI_Demo

--------------- 1 ---------------

insert into Students
Values ('Ahmed','Emad',25,'Cairo',NUll)

insert into Students
Values ('Ali','Mohamed',23,'Cairo',NUll)

-------- 1.1 --------

insert into Instructors
Values ('Ahmed','Cairo', 2000 , 8000 , 40 ,NUll)

insert into Instructors
Values ('Emade','Cairo', 1500 , 7000 , 42 ,NUll)

-------- 1.2 --------

insert into Courses
Values ('Frontend', 100.000 , 'Frontend-Course', Null)

insert into Courses 
Values ('Backend', 100.000 , 'Backend-Course', Null)

-------- 1.3 --------

insert into Departments 
Values ('Dep1', '8-5-2010' , 1)

insert into Departments 
Values ('Dep2', '10-25-2010' , 2)

-------- 1.4 --------

insert into Topics 
Values ('Top1')

insert into Topics 
Values ('Top2')

-------- 1.5 --------

insert into Stu_Course 
Values (2, 1, 80.00)

insert into Stu_Course 
Values (3, 1, 90.00)

-------- 1.6 --------

insert into Course_Instructor 
Values (1,1,'Good')

insert into Course_Instructor 
Values (2,2,'Good')

-----------

Update Students
Set Dep_Id = 10

Update Instructors
Set Dep_Id = 20
where id =2

Update Courses
Set Top_Id = 2
where id = 2

--------------- 2 ---------------

-------- 2.1 --------
insert into Departments 
Values ('Dep3', '6-4-2011' , 1)

insert into Students
Values ('Abdalrhman','Gamal',23,'Beni-Suif', 30)

-------- 2.2 --------
insert into Instructors
Values ('Zyad','Beni-Suif', Null, 4000 , 30 ,30)

-------- 2.3 --------

Update Instructors
Set Salary = Salary + (Salary*20/100)
