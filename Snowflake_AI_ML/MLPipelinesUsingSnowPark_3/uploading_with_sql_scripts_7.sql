CREATE OR REPLACE FILE FORMAT 
    test.public.csv_header_parse
TYPE='csv'
PARSE_HEADER=TRUE
FIELD_OPTIONALLY_ENCLOSED_BY='"';

CREATE OR REPLACE STAGE
    test.public.int_stage
FILE_FORMAT=test.public.csv_header_parse;

COPY INTO 
    @test.public.int_stage
FROM 
    test.public.titanic;

-- Infer schema
SELECT
    *
FROM 
    TABLE(INFER_SCHEMA(
        LOCATION => '@test.public.int_stage',
        -- FILES => 'titanic.csv',
        FILE_FORMAT => 'test.public.csv_header_parse'
    ));

SELECT 
    *
FROM 
    test.public.titanic;
