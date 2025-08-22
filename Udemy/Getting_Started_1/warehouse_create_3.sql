ALTER DATABASE 
    FIRST_DB 
RENAME TO
    OUR_FIRST_DB;

CREATE TABLE "OUR_FIRST_DB"."PUBLIC"."LOAN_PAYMENT" (
    "Loan_ID" STRING,
    "Loan_status" STRING,
    "Principal" STRING,
    "terms" STRING,
    "effective date" STRING,
    "due_date" STRING,
    "paid_off_time" STRING,
    "past_due_days" STRING,
    "age" STRING, 
    "education" STRING,
    "gender" STRING
);

SELECT 
    *
FROM 
    "OUR_FIRST_DB"."PUBLIC"."LOAN_PAYMENT";

COPY INTO 
    LOAN_PAYMENT
FROM
    s3://bucketsnowflakes3/Loan_payments_data.csv
file_format=(
    type=csv,
    field_delimiter=",",
    skip_header=1
);
