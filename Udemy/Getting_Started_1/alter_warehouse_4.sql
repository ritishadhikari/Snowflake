ALTER WAREHOUSE second_warehouse
SET
    WAREHOUSE_SIZE="SMALL" -- alter the warehouse size
    AUTO_SUSPEND=60 -- alter the auto_suspend time;  

DROP WAREHOUSE second_warehouse;