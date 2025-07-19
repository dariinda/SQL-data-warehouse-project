/*
----------------------------------------------------------------------------------
--------------------- Create the Databases for each layer ------------------------
----------------------------------------------------------------------------------
This script creates the databases for each of the layer 
- bronze
- silver
- gold

Warnings 
Do not drop the databases.
Proper backup needs to taken of this stage.
----------------------------------------------------------------------------------

*/
create schema bronze;
create schema silver;
create schema gold;
