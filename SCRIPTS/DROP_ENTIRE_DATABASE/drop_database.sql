/* 
1. Rerun this code if neeed to DELETE the entire database from the SQL server 
2. This script will stop  the database: RUN when need to delete the entire database
*/
USE master;
GO

-- Terminate all connections immediately
ALTER DATABASE bicycledata
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE;
GO

-- Drop the database
DROP DATABASE  bicycledata;
GO
