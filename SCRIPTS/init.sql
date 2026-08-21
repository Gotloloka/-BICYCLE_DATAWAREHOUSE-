USE master; -- Opening the master for the database 
-- CREATING DATABASE TO LOAD DATA
GO

USE master; -- Opening the master for the database 
-- CREATING DATABASE TO LOAD DATA
GO

-- Check if the database exists first
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'bicycledata ')
BEGIN
    -- This block only runs if the database is found
    PRINT 'Database found. Kicking out users and switching to MULTI_USER mode...';
    
    ALTER DATABASE bicycledata 
    SET  MULTI_USER
    WITH ROLLBACK IMMEDIATE;
END
ELSE
BEGIN
    -- This block runs if the database does not exist
    PRINT 'CREATING bicycledata database for this operation';
    CREATE DATABASE bicycledata;
END;
-- CREATING SCHEMAS TO LOAD DATA AND CLEAN 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO

