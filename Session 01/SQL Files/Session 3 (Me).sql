----Global Variables
print @@Version
print @@SErverNamE -- SQL not case sensitve 

----Local Variables
declare @name nvarchar(10)
set @name = 'Abdalrhman'
print @name

----Nameing notation
 --camelCase
 --PascalCase    
 
-------------------------------------  DDL ------------------------------------- 

-------------------- Create --------------------
create database company
use company -- دي Databaseعشان اقدر اشتغل علي ال 
create table Employees -- دايما بتكون جمع Tablesاسماء ال
(
  --name      datatype         constaines
  Id          int              primary key Identity(1,1),
  --Identity-> ده Columnهوا اللي هيدخل ال SQLبمعني اني لما ادخل بيانات الموظف ال
  Fname       nvarchar(10)     not null,  --required
  Lname       nvarchar(10), --optional
  Gender      char(1),
  DOB         date,
  Dnum        int, --Foreign key to Dnum in Department ->  Departmentمش هعمله دلوقتي لاني لسه مكرتش ال
  SuperId     int              references Employees(Id) , --Foreign key
  --Foreign key ->  Datatypeبس لازم يكون نفس ال PKمش لازم يكون نفس الاسم بتاع ال
)

create table Departments 
(
  Dnum int primary key identity(10,10),
  Dname varchar(20),
  MangerId int references Employees(Id),
  HiringDate date,
)
alter table Departments 
  alter column Dname varchar(20) not null

create table Department_Locations
(
  Dnum int references Departments(Dnum),
  DLocation varchar(20),
  primary key(Dnum,DLocation)
)

create table Projects 
(
  Pnum int primary key identity,
  Pname varchar(20) not null,
  PLocation varchar(10) default 'Beni-Suif',
  City varchar(10),
  Dnum int references Departments(Dnum)
)

create table Dependents 
(
  Dep_Name varchar(10) not null,
  Birthdate date,
  Gender char(1),
  EmpId int references Employees(Id),
  primary key(Dep_Name,EmpId)
)

create table Employee_Projects
(
   EmpId int references Employees(Id),
   Pnum int references Projects(Pnum),
   NumOfHours int,
   primary key(EmpId,Pnum)
)

-------------------- Alter (Update Table Structure) --------------------
----Add New Column
  /*Alter table <Table_Name>
    Add <Column-Name> <Datatype>*/
Alter table Employees
Add Test int

----Update Excesting Column
  /*Alter table <Table_Name>
    Alter column <Column-Name> <Datatype>*/
Alter table Employees
Alter column test bigint not null

----Delete Column
  /*Alter table <Table_Name>
    Drop column <Column-Name>*/
Alter table Employees
Drop column test

Alter table Employees
Add Foreign key (Dnum) references Departments(Dnum)

-------------------- Drop (Delete DB or Table) --------------------
----Drop Database company
----Drop Table Employees