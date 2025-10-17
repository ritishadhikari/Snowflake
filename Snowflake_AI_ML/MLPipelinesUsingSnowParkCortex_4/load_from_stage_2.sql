CREATE OR REPLACE PROCEDURE 
    test.public.load_excel(file_path string)
    RETURNS VARIANT
    LANGUAGE PYTHON
    RUNTIME_VERSION='3.10'
    PACKAGES=('snowflake-snowpark-python','pandas','openpyxl')
    HANDLER='main'
AS $$
from snowflake.snowpark.files import SnowflakeFile
from openpyxl import load_workbook
import pandas as pd


def main(session, file_path):
    with SnowflakeFile.open(file_path,'rb') as f:
        data=load_workbook(f).active.values
        df=pd.DataSELECT 
    *
FROM 
    excel_tests;Frame(data,columns=next(data)[0:])
        df=session.create_dataframe(df)
        df.write.mode("overwrite").save_as_table("excel_tests")
    return True
$$;

-- Had already uploaded it in stage
CALL load_excel(build_scoped_file_url(@INT_STAGE,'test.xlsx'));

