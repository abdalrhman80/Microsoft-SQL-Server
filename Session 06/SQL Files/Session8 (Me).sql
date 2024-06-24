---------------------- 01 Stored Procedures ---------------------- 
/*
  ---- Phases of Query Processing 
         1. Parse Syntax
    	 2. Optimize metadata (DB موجوده في ال Query يتأكد هل الحاجات اللي في ال)
    	 3. Query Tree (Execution Order)
    	 4. Execution Plan (Front لل Network ويبعتها خلال ال DB من ال Dataبيجيب ال)   
		   
     -- Requst المراحل دي بتم في كل 
     --  Query بيحل الجزء ده انه بيخزن اول 3 مراحل من التنفيذ ال SPال 
	 -- بينفذ ال4 مراحل SP لل Exce مع اول
     -- بيروح ينفذ اخر مرحله بس Exce وبعد كدا مع كل   
  

  ---- SP is Database object
  ---- SP in Creation can take parametars with or without brackets
  ---- SP in Usage pass parametars without brackets
  
  ---- Benefits of SP:
       -- 1. Improved Performance
       -- 2. Stronger Security (Hide Meta Data)
       -- 3. Network Wise (Reduced server/client network traffic) 
		    SPهيكون بيمشي اسم ال Queryبيمشي ال Network بدل ما يكون في ال)
	      (نفسها Queryلانه كا حجم اقل من ال Network Trafficوده هيقلل ال 
       -- 4. Hide Business Rules 
       -- 5. Handle Errors (SP Contain DML)
       -- 6. Accept Input And Out Parameters => Make It More Flexible
     


  ---- Creation -> Create Procedure <SP_Name> @<Paramters> <Datatype>
				   With Encryption
                   As 
				   <SP_Body>


  ---- Usage -> Exec <SP_Name> <Paramters> -> (With another code)
                OR
				<SP_Name> <Paramters> -> (Without another code)
*/              

GO
Create Or Alter Proc SP_GetStudentsByAddress @Address varchar(max)
With Encryption
As
Select St_Id, St_Fname, St_Address
From Student
Where St_Address = @Address
GO

SP_GetStudentsByAddress 'Cairo'

Declare @Addr varchar(max) = 'Cairo'
Exec SP_GetStudentsByAddress @Addr



---------------------- 02 Stored Procedure_Insert Based On Execute ---------------------- 
/*
  ---- SPمن ال Select اللي ب Data بناء علي ال Insert in Table 
  ---- Structure بنفس ال Table لازم يكون ال
*/

Create Table StudentsAddress
(
St_Id int primary key,
St_Name varchar(max),
St_Address varchar(max)
)

Insert into StudentsAddress
Exec SP_GetStudentsByAddress 'Cairo'



---------------------- 03 Stored Procedure - Handle Errors (TRY CATCH)---------------------- 
/*
  --- Tables ومعلومات عن ال PKsوال Tables بيظهر اسم ال Errors في ال
  --- اللي انا عايزها Errorsواظهر ال SPبستخدام ال Handle Error فا انا ممكن 

  --- Syntax -> 
                BEGIN TRY  
                  <statements that may cause exceptions>
                END TRY 
                BEGIN CATCH  
                  <statements that handle exception> 
                END CATCH  
*/			    

Begin Try
   Delete From Department 
   Where Dept_Id = 10
End Try
Begin Catch
   Select  
       ERROR_NUMBER() AS ErrorNumber -- returns the number of the error that occurred.
       ,ERROR_MESSAGE() AS ErrorMessage -- complete text of the generated error message.
       ,ERROR_SEVERITY() AS ErrorSeverity -- the severity level of the error that occurred.
       ,ERROR_STATE() AS ErrorState -- state number of the error that occurred.
       ,ERROR_PROCEDURE() AS ErrorProcedure -- the name of the stored procedure or trigger where the error occurred
       ,ERROR_LINE() AS ErrorLine -- the line number on which the exception occurred.
End Catch

GO
Create Proc SP_DeleteDeptWithId @Dept_Id int
As
 Begin Try
    Delete From Department 
    Where Dept_Id = @Dept_Id
 End Try
 Begin Catch
    Select  'An Error Occurred' 
 End Catch
Go

Exec SP_DeleteDeptWithId 10


---------------------- 04 Stored Procedure - Input Parameters ---------------------- 
GO
Create OR Alter Proc SP_SumData @IntOne Int = 5, @IntTwo varchar(max)
As
  Select @IntOne + @IntTwo
GO

---- Passing By Value
Exec SP_SumData 2, '8' -- Implicit Casting 


---- Passing By Name
Exec SP_SumData @IntTwo = '8', @IntOne = 2

Exec SP_SumData @IntTwo = '8'


----------------------  05 Stored Procedure - Output Parameters & Input-Output Paramters ---------------------- 

/*
  --- Return لازم اكتب كلمه Function مش زي ال Output Parameter عن طريق ال Return ب SPال
  --- Output لازم اكتب حمبه كلمه Output Parameter ان ده  SPعشان اعرف ال 
*/

---- اسمه وسنه Return ب و StIdبياخد ال SP هعمل 
Go
Create OR Alter Proc SP_GetStudentNameAndAgeById @StId Int, @StName varchar(max) Output, @StAge Int Output
With Encryption
As
  Select @StName = CONCAT(St_Fname, ' ' ,St_Lname), @StAge = St_Age
  From Student
  Where St_Id = @StId
GO

/*
  -- Output Parameters هنا انا محتاج متغير احط فيه قيمه ال 
  -- NULL ولو مكتبتش هيطلع Output لازم اكتب جمب المتغير كلمه Output Parameter ان ده  SPعشان اعرف ال 
  -- وبعد كده اعرض المتغيرات دي
*/
Declare @StudentName varchar(max), @StudentAge Int
Exec SP_GetStudentNameAndAgeById 10, @StudentName Output, @StudentAge Output 
Select @StudentName [St_Name], @StudentAge [St_Age]


----  Parameters اللي فات بس هياخد اتنين SP هعمل نفس ال

Go
Create OR Alter Proc SP_GetStudentNameAndAgeByIdWithTwoParameter 
   -- Int نوعهم Paramters بما اني في اتنين Input-Output Paramter هيكون عباره عن Parameter هنا في 
 @StIdAge Int Output, @StName varchar(max) Output
With Encryption
As
  Select @StName = CONCAT(St_Fname, ' ' ,St_Lname), @StIdAge = St_Age
  From Student
  Where St_Id = @StIdAge
GO

/*
  -- IntialValue مديله @StudentIdAge هناال
  -- بتاعه بالقيمه اللي انا باعتها IDهتتنفذ الاول فا هوا راح جاب الطالب اللي ال Where ال SP بتاع ال Bodyو في ال
  -- Input Paramter وكدا هوا  ID في الاول علي انه @StudentIdAge فا كدا انا اتعاملت مع ال
  -- @StNum بالقيمه اللي في @StudentIdAge لل Reassign وهيعمل @StNum في ال Age وهيحط ال Select وبعدها هينفذ ال
  -- Output Paramter @StudentIdAge فا كدا انا اتعاملت مع ال
*/
Declare @StudentIdAge Int = 2023, @StudentName varchar(max)
Exec SP_GetStudentNameAndAgeByIdWithTwoParameter @StudentIdAge Output, @StudentName Output
Select @StudentName [St_Name], @StudentIdAge [St_Age]
