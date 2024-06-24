--------------------------- Part 2---------------------------

use AdventureWorks2012

/* 1. Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema)
      to designate SalesOrders that occurred within the period '7/28/2002' and '7/29/2014'
*/

Select SalesOrderID, ShipDate
From Sales.SalesOrderHeader
Where OrderDate Between '7/28/2002' and '7/29/2014'


/* 2. Display only Products(Production schema)
      with a StandardCost below $110.00 (show ProductID, Name only)
*/

Select ProductID, Name
From Production.Product
Where StandardCost < 110.00


/* 3. Display ProductID, Name if its weight is unknown */

Select ProductID
From Production.Product
Where Weight is Null


/* 4. Display all Products with a Silver, Black, or Red Color */

Select *
From Production.Product
Where Color in('Silver', 'Black', 'Red')
Order By Color


/* 5. Display any Product with a Name starting with the letter B */

Select *
From Production.Product
Where Name Like 'B%'


/* 6. Run the following Query 
      (
       UPDATE Production.ProductDescription
       SET Description = 'Chromoly steel_High of defects'
       WHERE ProductDescriptionID = 3
	   )
     Then write a query that displays any Product description with underscore value in its description.
*/

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

Select *
From Production.ProductDescription
Where Description Like '%[_]%'


/* 7. Display the Employees HireDate (note no repeated values are allowed) */

Select Distinct HireDate
From HumanResources.Employee


/* 8. Display the Product Name and its ListPrice within 
      the values of 100 and 120 the list should have the following format 
      "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
*/

Select CONCAT('The ', Name, ' is only! ', ListPrice)
From Production.Product
Where ListPrice Between 100 and 120
Order By ListPrice