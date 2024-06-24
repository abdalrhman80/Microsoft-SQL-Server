--------------------------------- Part 3 ---------------------------------
Use ITI

/* 
  1. Create an index on column (Hiredate) that allows you to cluster the data in table Department. 
      What will happen?
*/

GO
Create Index IX_HireDate
On Department (Manager_hiredate) -- NonUnique NonClustered Index Will Be Creat 
GO

/* 
  2. Create an index that allows you to enter unique ages in the student table. 
      What will happen?
*/

GO
Create Unique Index IX_StAge
On Student (St_Age) -- The Unique Index Will Not Create because a duplicate key was found 
GO