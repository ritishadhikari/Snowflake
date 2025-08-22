-- Creating the table
CREATE OR REPLACE TABLE 
    our_first_db.public.orders_ex  (
    order_id VARCHAR(30),
    amount INT,
    profit INT,
    quantity INT,
    category VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
    );

-- Creating schema to keep things organized
CREATE OR REPLACE SCHEMA
    manage_db.file_formats;

-- Creating file format object
CREATE OR REPLACE FILE FORMAT
    manage_db.file_formats.my_file_format;
    
-- See properties of file format object
DESCRIBE FILE FORMAT 
    manage_db.file_formats.my_file_format;

-- Altering file format object
ALTER FILE FORMAT 
    manage_db.file_formats.my_file_format
SET
    SKIP_HEADER=1;

-- Using file format object in Copy Command
COPY INTO 
    our_first_db.public.orders_ex
FROM 
    @MANAGE_DB.external_stages.aws_stage_errorex
FILE_FORMAT=(format_name=manage_db.file_formats.my_file_format)
FILES=('OrderDetails_error.csv')
ON_ERROR='SKIP_FILE_3';

SELECT 
    *
FROM 
    our_first_db.public.orders_ex;

-- Defining Properties on creation of file format
CREATE OR REPLACE file format
    manage_db.file_formats.my_file_format
TYPE='JSON'
TIME_FORMAT='AUTO';

-- See properties of file format object
DESCRIBE FILE FORMAT 
    manage_db.file_formats.my_file_format;

TRUNCATE TABLE 
    our_first_db.public.orders_ex;

-- This time it will fail since the file format is set to json and we are trying to load csv
COPY INTO 
    our_first_db.public.orders_ex
FROM 
    @MANAGE_DB.external_stages.aws_stage_errorex
FILE_FORMAT=(format_name=manage_db.file_formats.my_file_format)
FILES=('OrderDetails_error.csv')
ON_ERROR='SKIP_FILE_3'

-- Altering file format is not possible in Snowflake so we would need to create and replace
CREATE OR REPLACE file format
    manage_db.file_formats.my_file_format
TYPE='CSV'
TIME_FORMAT='AUTO';

-- See properties of file format object
DESCRIBE FILE FORMAT 
    manage_db.file_formats.my_file_format;

-- Now it will pass because the correct file format has been set
COPY INTO 
    our_first_db.public.orders_ex
FROM 
    @MANAGE_DB.external_stages.aws_stage_errorex
FILE_FORMAT=(format_name=manage_db.file_formats.my_file_format)
FILES=('OrderDetails_error.csv')
ON_ERROR='Continue';

-- It will load 1501 rows since it will take the header
SELECT
    *
FROM 
    our_first_db.public.orders_ex;

TRUNCATE TABLE 
    our_first_db.public.orders_ex;

-- To fix the above problem, we will extrinsically add the skip_header keyword
COPY INTO 
    our_first_db.public.orders_ex
FROM 
    @MANAGE_DB.external_stages.aws_stage_errorex
FILE_FORMAT=(
    format_name=manage_db.file_formats.my_file_format,
    field_delimiter=',',
    skip_header=1
    )
FILES=('OrderDetails_error.csv')
ON_ERROR='Continue';