CREATE OR REPLACE WAREHOUSE
    second_warehouse
WITH 
    WAREHOUSE_SIZE=XSMALL
    MIN_CLUSTER_COUNT=1
    MAX_CLUSTER_COUNT=3
    SCALING_POLICY="Economy"  -- Default is "Standard"
    INITIALLY_SUSPENDED=TRUE
    AUTO_SUSPEND=300
    COMMENT="This is our second warehouse";

    