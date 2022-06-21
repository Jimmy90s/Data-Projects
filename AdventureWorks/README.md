This data is based on Microsoft's AdventureWorks database. Access version: [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver1)

Customer(CustomerID, FirstName, MiddleName, LastName, CompanyName, EmailAddress)

CustomerAddress(CustomerID, AddressID, AddressType)

Address(AddressID, AddressLine1, AddressLine2, City, StateProvince, CountyRegion, PostalCode)

SalesOrderHeader(SalesOrderID, RevisionNumber, OrderDate, CustomerID, BillToAddressID, ShipToAddressID, ShipMethod, SubTotal, TaxAmt, Freight)

SalesOrderDetail(SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)

Product(ProductID, Name, Color, ListPrice, Size, Weight, ProductModelID, ProductCategoryID)

ProductModel(ProductModelID, Name)

ProductCategory(ProductCategoryID, ParentProductCategoryID, Name)

ProductModelProductDescription(ProductModelID, ProductDescriptionID, Culture)

ProductDescription(ProductDescriptionID, Description)

![image](https://user-images.githubusercontent.com/103063112/174716179-b84f95cc-6ee6-49da-a584-048d2284e150.png)
