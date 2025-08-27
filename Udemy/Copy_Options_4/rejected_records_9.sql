USE DATABASE 
    copy_db;
    
SELECT
    *
FROM
    TABLE(RESULT_SCAN('01bea682-3201-e62d-000f-66b200025372'));

-- Storing Rejected/Failed results in a table
CREATE OR REPLACE TABLE
    copy_db.public.rejected AS 
        SELECT 
            rejected_record 
        FROM
            TABLE(result_scan(last_query_id()));

LIST @COPY_DB.PUBLIC.aws_stage_copy;

SELECT
    *
FROM
    copy_db.public.orders;

COPY INTO   
    COPY_DB.PUBLIC.ORDERS
FROM
    @COPY_DB.PUBLIC.aws_stage_copy
FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
PATTERN='.*order.*'
ON_ERROR=Continue;