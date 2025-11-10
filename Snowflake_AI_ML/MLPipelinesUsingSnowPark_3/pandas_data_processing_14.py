# The Snowpark package is required for Python Worksheets. 
# You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

# will take considerably more time than a snowpark dataframe
def main(session: snowpark.Session): 
    tableName='SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM'
    df=session.table(name=tableName)
    session.query_tag='pandas-in-worksheet'
    dfp=df.to_pandas()
    dfp=dfp.drop_duplicates()
    # the df being returned is a snowpark dataframe
    df=session.write_pandas(
        df=dfp,
        table_name='test.public.lineitem_pandas',
        auto_create_table=True,
        overwrite=True
    )
    return df