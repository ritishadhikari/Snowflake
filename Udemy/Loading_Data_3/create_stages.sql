// Database to manage stage objects, fileformats, etc
CREATE OR REPLACE DATABASE 
    MANAGE_DB;

CREATE OR REPLACE SCHEMA
    external_stages;

-- Creating external stages
CREATE OR REPLACE STAGE 
    MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(
        aws_key_id='ABCD_DUMMY_ID',
        aws_secret_key='1234abcd_key'
        );
        
-- Description of external stage
DESC STAGE 
    MANAGE_DB.external_stages.aws_stage;

-- Alter external stage
ALTER STAGE 
    aws_stage
SET 
    credentials=(
        aws_key_id='XYZ_DUMMY_ID',
        aws_secret_key='987xyz'
        );

-- Publicly accessible staging area
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

-- List files in stage
LIST @aws_stage;
LIST @MANAGE_DB.external_stages.aws_stage;

--  Creating Orders table
CREATE OR REPLACE TABLE 
    OUR_FIRST_DB.PUBLIC.ORDERS (
        order_id VARCHAR(30),
        amount INT,
        profit INT, 
        quantity INT,
        category VARCHAR(30),
        subcategory VARCHAR(30)
    );

SELECT 
    * 
FROM
    OUR_FIRST_DB.PUBLIC.ORDERS;
    
--  Copy command with specified file(s)
COPY INTO
    OUR_FIRST_DB.PUBLIC.ORDERS
FROM @MANAGE_DB.external_stages.aws_stage
    file_format=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    ),
    files=('OrderDetails.csv')

--  There will be data now
SELECT 
    * 
FROM
    OUR_FIRST_DB.PUBLIC.ORDERS;


--  Copy command with specified file pattern
COPY INTO
    OUR_FIRST_DB.PUBLIC.ORDERS
FROM 
    @MANAGE_DB.external_stages.aws_stage
    file_format=(
        type='csv',
        field_delimiter=',',
        skip_header=1
    ),
    pattern='.*Order.*'

