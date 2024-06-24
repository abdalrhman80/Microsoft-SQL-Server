--------------------------- Part 1 ---------------------------

/* 1. Select max two salaries in the instructor table */

Select Top(2) *
From Instructor
Order by Salary Desc


/* 2. Write a query to select the highest two salaries in Each Department for instructors who have salaries.
      “using one of Ranking Functions” 
*/

Select * 
From (
       Select *,  
	   ROW_NUMBER() Over (Partition By Dept_id Order By salary Desc) as RowRank
	   From Instructor 
	   Where Salary Is Not Null and Dept_Id  Is Not Null
	   ) as RankedTable
Where RowRank = 1


/* 3. Write a query to select a random student from each department.
      “using one of Ranking Functions”
*/

--Select Top(1)* , NEWID() as GUD
--From Student
--Order By NEWID()

Select St_Fname, Dept_Id
From (
       Select  *, NEWID() as GUD,
	   ROW_NUMBER() Over (Partition By Dept_id Order By NEWID()) as RowRank
	   From Student 
	   Where Dept_Id Is Not Null
	   ) as RankedTable
Where RowRank = 1
