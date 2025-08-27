-- Enables you to retrieve the history of data loaded into tables using the COPY INTO <table> command

USE database copy_db;

-- Gives information about the history of the table loads from specific source
SELECT 
    *
FROM 
    COPY_DB.INFORMATION_SCHEMA.LOAD_HISTORY;

-- Gives more detailed information for all the loading that has taken place
SELECT
    *
FROM
    SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY;

