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
url='s3://snowflakebucket-copyoption/returnfailed/';

-- List files in stage
LIST 
    @copy_db.public.aws_stage_copy;

-- Load Data using Copy Command
COPY INTO 
    copy_db.public.orders
FROM 
    @copy_db.public.aws_stage_copy
FILE_FORMAT=(
    type='csv',
    field_delimiter=',',
    skip_header=1
)
PATTERN='.*Order.*'
ON_ERROR='Continue'  -- Use with on_error=continue
RETURN_FAILED_ONLY=TRUE; -- Lets you focus on files that has some errors and not the files which has been loaded successfully