------------------------------------ Part 2 ------------------------------------

/* 1. Create a stored procedure that calculates the sum of a given range of numbers */
GO
Create Or Alter Procedure SP_SumOfRange @StarNumber Int, @EndNumber Int
With Encryption
As
  IF @StarNumber > @EndNumber
  Begin
    Select 'Start value cannot be greater than End value' [Message]
  End

 Else
 Begin
   Declare @SumOfNumbers Int = 0
   Declare @CurrentNumber Int 
   Set @CurrentNumber = @StarNumber
  
   While @CurrentNumber <= @EndNumber
   Begin
     Set @SumOfNumbers += @CurrentNumber
	 Set @CurrentNumber += 1
   End
  
   Select @SumOfNumbers [SumOfRange]
 End
GO

Exec SP_SumOfRange 3,1



/* 2. Create a stored procedure that calculates the area of a circle given its radius */
GO
Create OR ALter Procedure SP_CalaCircleAre @R Float, @Area Float Output
With Encryption
As
  Select @Area = 3.14 * @R * @R
GO

Declare @Radius Float = 14.123, @Area Float
Exec SP_CalaCircleAre @Radius, @Area Output
Select @Area [Circle_Area]



/* 3. Create a stored procedure that calculates the age category based on a person's age 
     (Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult 
	   otherwise Category is Senior) 
*/
GO
Create Or Alter Procedure SP_GetAgeCategoryBasedOnAge @Age Int, @Category varchar(max) Output
With Encryption
As
  If @Age < 18
  Begin
    Set @Category = 'Child' 
  End

  Else If @Age >= 18 And @Age < 60
  Begin
    Set @Category = 'Adult' 
  End

  Else 
  Begin
    Set @Category = 'Senior' 
  End
GO

Declare @AgeCategory varchar(max)
Exec SP_GetAgeCategoryBasedOnAge 23, @AgeCategory Output
Select @AgeCategory [AgeCategory]



/* 4. Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers 
      (Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
*/
