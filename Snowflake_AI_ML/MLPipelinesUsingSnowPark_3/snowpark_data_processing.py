# The Snowpark package is required for Python Worksheets. 
# You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

# Will be significantly faster than a pandas dataframe
def main(session: snowpark.Session): 
    tableName='SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM'
    df=session.table(name=tableName)
    session.query_tag='snowpark-in-worksheet'
    # dfp=df.to_pandas()
    df=df.dropDuplicates()
    # df=session.write_pandas(
    #     df=dfp,
    #     table_name='test.public.lineitem_pandas',
    #     auto_create_table=True,
    #     overwrite=True
    # )
    df.write.mode(save_mode="overwrite").\
        save_as_table(table_name="test.public.lineitem_snowpark")
    return df