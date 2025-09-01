CREATE OR REPLACE STAGE 
    MANAGE_DB.external_stages.aws_stage_errorex
    url='s3://bucketsnowflakes4';

LIST @MANAGE_DB.external_stages.aws_stage_errorex;

CREATE OR REPLACE TABLE 
    our_first_db.public.orders_ex  (
    order_id VARCHAR(30),
    amount INT,
    profit INT,
    quantity INT,
    category VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
    );

SELECT 
    *
FROM 
    our_first_db.public.orders_ex;

-- Demonstrating Error Message
COPY INTO 
    our_first_db.public.orders_ex
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    files=('OrderDetails_error.csv');

-- Validating Table is empty
SELECT
    *
FROM 
    our_first_db.public.orders_ex;

--  Error handling using the on-error option
COPY INTO 
    our_first_db.public.orders_ex
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    FILES=('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR='Continue';  -- default is 'Abort_Statement'

-- Validating Table is parsed with eligible rows
SELECT
    *
FROM 
    our_first_db.public.orders_ex;

-- Only skip the files which has an error but load other files. Using the default abort_statement, both files' loading would fail even if there was error on only one of them

TRUNCATE TABLE
    our_first_db.public.orders_ex;

COPY INTO 
    our_first_db.public.orders_ex
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    FILES=('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR='Skip_file'; 

TRUNCATE TABLE
    our_first_db.public.orders_ex; 

COPY INTO 
    our_first_db.public.orders_ex
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    FILES=('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR='Skip_File_3'; -- Skip the files if there are errors in 3 or more files, else continue to partially load the files having errors

TRUNCATE TABLE
    our_first_db.public.orders_ex; 

COPY INTO 
    our_first_db.public.orders_ex
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    FILE_FORMAT=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    )
    FILES=('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR='Skip_File_3%'; -- Skip the files if there are errors in more than 3% of the records in the files, else continue to partially load the files having errors