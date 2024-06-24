	--------------------- 01 Comment ---------------------
	------------------------------------------------------

-- Single Line Comment

/*
MultiLine
Comment
*/

-- Ctrl+K , Ctrl+C => Comment
-- Ctrl+K , Ctrl+U => Uncomment

--==================================================--
-------------------- 02 Data Types -------------------
------------------------------------------------------

----------------- 1.Numeric Data Types -----------------
bit         -- Boolean Value 0[false]: 1[true] 
tinyint		-- 1 Byte => -128:127		| 0:255 [Unsigned]
smallint	-- 2 Byte => -32768:32767	| 0:65555 [Unsigned] 
int			-- 4 Byte 
bigint		-- 8 Byte

---------------- 2.Fractions Data Types ----------------
smallmoney	4B.0000            -- 4 Numbers After Point
money		8B.0000            -- 4 Numbers After Point 
real		8B.0000000         -- 7 Numbers After Point
float		8B.000000000000000 -- 15 Numbers After Point
dec			-- Datatype and Make Valiadtion at The Same Time => Recommended
dec(5,2) 124.22	     XXX 18.1  12.2212  2.1234 XXX

---------------- 3.String Data Types ------------------
char(10)		[Fixed Length Character]	Ahmed 10	Ali 10	
varchar(10)		[Variable Length Character]	Ahmed 5		Ali 3
nchar(10)		[like char(), But With UniCode] على 10
nvarchar(10)	[like varchar(), But With UniCode] على 3
nvarchar(max)	[Up to 2GB]
varchar(max)    [Up to 2GB]

----------------- 4. DateTime Data Types---------------
Date			MM/dd/yyyy
Time			hh:mm:ss.123 -- Defualt=> Time(3)
Time(5)			hh:mm:ss.12345
smalldatetime	MM/dd/yyyy hh:mm:00
datetime		MM/dd/yyyy hh:mm:ss.123
datetime2(4)	MM/dd/yyyy hh:mm:ss.1234
datetimeoffset	11/23/2020 10:30 +2:00 Timezone

---------------- 5.Binary Data Types ------------------
binary [Fixed width binary string] 01110011 11110000
image
varbinary [Variable width binary string]

-------------- 6.Miscellaneous  Data Types -------------
Xml
sql_variant -- Like Var In Javascript

--==================================================--

------------------- 03 Variables ---------------------

-- 1. Global Variables
select @@Version
select @@ServerName
select @@LANGUAGE
select @@CONNECTIONS

-- 2. Local Variables (User-Defind)
declare @name varchar(10) = 'Maha' --5
print @name
set @name = 'Ali' -- 3
print @name


--==================================================--

---------- Data Definition Language(DDL) -------------
-- 1. Create 
-------------

-- To Create Database:
Create Database CompanyC42G01 

-- Select Database:
use CompanyC42G01

-- To Create Table:
Create Table Employees
(
SSN int primary key identity(1, 1),
Fname varchar(15) not null, -- Required
Lname varchar(15), -- Optional
Gender char(1),
Birthdate Date,
Dnum int,
Super_SSN int references Employees(SSN), -- Self Relationship
salary money
)

Create Table Departments
(
Dnum int primary key identity(10,10),
Dname varchar(20) not null ,
Manager_SSN int references Employees(SSN),
Hiring_Date Date 
)

Create Table Department_Locations 
(
DeptNum int references Departments(Dnum),
Location varchar(30) default 'cairo',
primary key (DeptNum , Location) -- Composite Primary Key
)

Create Table Projects
(
PNum int primary key identity, 
PName varchar(20) not null,
Location varchar(20),
City varchar(20),
DeptNum int references Departments(Dnum)
)

Create table Dependants
(
Name varchar(30) not null ,
Birthdate date ,
Gender Char(1),
ESSN int references Employees(SSN)
)

Create table Employee_Projects
(
ESSN int references EMPLoyees(SSN),
PNum int references Projects(Pnum),
NumOfHours tinyint,
primary key (ESSN , PNum)
)

-- 2. Alter (Update)
--------------------
-- Add New Column 
Alter table Employees
add Test int 

-- Alter an existing Column
Alter Table Employees
Alter column test bigint

-- Drop Column
Alter Table Employees
drop column test

-- Add references to column 
Alter Table Employees
add foreign key (Dnum) references Departments(Dnum)
 

-- 3. Drop
--------------------

-- Drop Table 
Drop Table Employees

-- Drop Database
Drop Database CompanyC42G01


