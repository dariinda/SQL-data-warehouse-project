/*
----------------------------------------------------------------------------------
------------------------------  Database Creation  -------------------------------
----------------------------------------------------------------------------------
This script creates the database and schema for each of the layer :
- bronze
- silver
- gold

Warnings :
- Do not drop the database.
- Proper backup needs to taken of this stage.
----------------------------------------------------------------------------------

*/
USE master;
GO

-- Drop and recreate the database 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
      ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE
      DROP DATABASE DataWarehouse;
END;
GO

-- create the database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO
USE Datawarehouse;
GO

-- Create Schemas 
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
