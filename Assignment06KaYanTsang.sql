-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

Create View vCategories
With SchemaBinding
As 
    Select CategoryID, CategoryName
        From dbo.Categories;
GO
Create View vProducts
With SchemaBinding
As 
    Select ProductID, ProductName, CategoryID, UnitPrice
        From dbo.Products;
GO
Create View vEmployees
With SchemaBinding
As 
    Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
        From dbo.Employees;
GO
Create View vInventories
With SchemaBinding
As 
    Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
        From dbo.Inventories;
GO

-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
Deny Select On Categories To Public;
Deny Select On Products To Public;
Deny Select On Employees To Public;
Deny Select On Inventories To Public;
GO

Grant Select On vCategories To Public;
Grant Select On vProducts To Public;
Grant Select On vEmployees To Public;
Grant Select On vInventories To Public;
GO

-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00

Create View vProductsByCategories
As 
    Select Top 1000000
    vCategories.CategoryName, 
    vProducts.ProductName,
    vProducts.UnitPrice
    From vCategories
        Inner Join vProducts
            On vCategories.CategoryID = vProducts.CategoryID
    Order by 1,2,3; 
Go 


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83

Create View vInventoryCountByProductByDate
As 
    Select Top 1000000
    vProducts.ProductName,
    vInventories.InventoryDate,
    vInventories.[Count]
    From vInventories
        Inner Join vProducts
            On vInventories.ProductID = vProducts.ProductID
    Order by 1,2,3; 
Go 


-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth

Create View vEmployeeByDate
As 
    Select Top 1000000 
    vInventories.InventoryDate,
    vEmployees.EmployeeFirstName + ' '+ vEmployees.EmployeeLastName as EmployeeName
    From vInventories
        Inner Join vEmployees
            On vInventories.EmployeeID = vEmployees.EmployeeID
    Order by 1,2; 
Go 


-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54

Create View vInventoriesByProductsByCategories
As
    Select Top 1000000
    vCategories.CategoryName,
    vProducts.ProductName,
    vInventories.InventoryDate,
    vInventories.[Count]
    From vProducts
        Inner Join vCategories
            On vCategories.CategoryID = vProducts.CategoryID
        Inner Join vInventories
            On vProducts.ProductID = vInventories.InventoryID
    Order by 1,2,3,4;
Go


-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan

Create View vInventoriesByProductsByEmployees
As
    Select Top 1000000
    vCategories.CategoryName,
    vProducts.ProductName,
    vInventories.InventoryDate,
    vInventories.[Count],
    vEmployees.EmployeeFirstName + ''+ vEmployees.EmployeeLastName as EmployeeName
    From vProducts
        Inner Join vCategories
            On vCategories.CategoryID = vProducts.CategoryID
        Inner Join vInventories
            On vProducts.ProductID = vInventories.InventoryID
        Inner Join vEmployees
            On vEmployees.EmployeeID = vInventories.EmployeeID
    Order by 3,1,2,5;
GO


-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King

Create View vInventoriesForChaiChangByEmployees
As
    Select Top 10000000
    vCategories.CategoryName,
    vProducts.ProductName,
    vInventories.InventoryDate,
    vInventories.[Count],
    vEmployees.EmployeeFirstName + ''+ vEmployees.EmployeeLastName as EmployeeName
    From vProducts
        Inner Join vCategories
            On vCategories.CategoryID = vProducts.CategoryID
        Inner Join vInventories
            On vProducts.ProductID = vInventories.InventoryID
        Inner Join vEmployees
            On vEmployees.EmployeeID = vInventories.EmployeeID
    Where vProducts.ProductName = 'Chai' Or vProducts.ProductName = 'Chang'
    Order by 1,2,3,4,5;
Go



-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan

Create View vEmployeesManager
As
    Select Top 1000000
    M.EmployeeFirstName + ''+ M.EmployeeLastName as Manager,
    E.EmployeeFirstName + ''+ E.EmployeeLastName as Employee
    From vEmployees as E
        Inner Join vEmployees as M
            On E.ManagerID = M.EmployeeID
    Order by 1,2;
GO


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan

Create View vInventoriesByProductsByCategoriesByEmployees
AS
    Select Top 1000000
        C.CategoryID,
        C.CategoryName,
        P.ProductID,
        P.ProductName,
        P.UnitPrice,
        I.InventoryID,
        I.InventoryDate,
        I.[Count],
        E.EmployeeID,
        E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee,
        M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager
        From vCategories as C
        Inner Join vProducts as P
            On P.CategoryID = C.CategoryID
        Inner Join vInventories as I
            On P.ProductID = I.ProductID
        Inner Join vEmployees as E
            On I.EmployeeID = E.EmployeeID
        Inner Join vEmployees as M
            On E.ManagerID = M.EmployeeID
    Order By 1,3,6,9


-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoryCountByProductByDate]
Select * From [dbo].[vEmployeeByDate]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiChangByEmployees]
Select * From [dbo].[vEmployeesManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]
/***************************************************************************************/