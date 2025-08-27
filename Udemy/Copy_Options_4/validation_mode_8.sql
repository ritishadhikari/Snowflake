-- Validation Mode--
-- Prepare Database or Table
CREATE OR REPLACE DATABASE
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

-- Load Data using Copy Command
COPY INTO copy_db.public.orders
    FROM @copy_db.public.aws_stage_copy
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    PATTERN='.*order.*'
    VALIDATION_MODE=RETURN_ERRORS;

SELECT 
    *
FROM 
    copy_db.public.orders;

-- Load Data using Copy Command and return 5 rows
-- Just for the purpose of validation
COPY INTO copy_db.public.orders
    FROM @copy_db.public.aws_stage_copy
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    PATTERN='.*Order.*'
    VALIDATION_MODE=RETURN_5_ROWS;

SELECT 
    *
FROM 
    copy_db.public.orders;

-- Use files with errors
CREATE OR REPLACE STAGE
    copy_db.public.aws_stage_copy
URL="s3://snowflakebucket-copyoption/returnfailed";

LIST @copy_db.public.aws_stage_copy;

-- Try and Load Data using Copy Command
-- For failed records, it will show errors
COPY INTO copy_db.public.orders
    FROM @copy_db.public.aws_stage_copy
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    PATTERN='.*order.*'
    VALIDATION_MODE=return_errors;  -- does not work

COPY INTO copy_db.public.orders
    FROM @copy_db.public.aws_stage_copy
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    PATTERN='.*error.*'
    VALIDATION_MODE=RETURN_5_ROWS;