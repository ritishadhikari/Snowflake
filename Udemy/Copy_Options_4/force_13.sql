-- Specifies to load all files, regardless of whether they have been loaded previously and have not changed since they were loaded. This option reloads files, potentially duplicating data in a table

USE DATABASE 
    copy_db;

CREATE OR REPLACE TABLE
    copy_db.public.orders (
    order_id VARCHAR(30),
    amount VARCHAR(30),
    profit INT,
    quantity INT,
    category VARCHAR(30), 
    subcategory VARCHAR(30)
    );

-- Prepare stage object
CREATE OR REPLACE STAGE 
    copy_db.public.aws_stage_copy
url='s3://snowflakebucket-copyoption/size/';

LIST @copy_db.public.aws_stage_copy;

-- Load data using copy command for the first time. Loads properly.
COPY INTO 
    copy_db.public.orders
FROM 
    @copy_db.public.aws_stage_copy
FILE_FORMAT=(
    type='csv',
    field_delimiter=',',
    skip_header=1
)
PATTERN='.*Orders.*';

SELECT 
    COUNT(*)
FROM 
    copy_db.public.orders;

-- Load data using copy command. This time it does not loads since we have already loaded it.
COPY INTO 
    copy_db.public.orders
FROM 
    @copy_db.public.aws_stage_copy
FILE_FORMAT=(
    type='csv',
    field_delimiter=',',
    skip_header=1
)
PATTERN='.*Orders.*';

SELECT 
    COUNT(*)
FROM 
    copy_db.public.orders;

-- Load data using copy command. This time it does loads since we are using force.
COPY INTO 
    copy_db.public.orders
FROM 
    @copy_db.public.aws_stage_copy
FILE_FORMAT=(
    type='csv',
    field_delimiter=',',
    skip_header=1
)
PATTERN='.*Orders.*'
FORCE=true;

--  Number of records gets doubled and duplicated
SELECT 
    COUNT(*)
FROM 
    copy_db.public.orders;


    
