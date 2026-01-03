CREATE OR REPLACE PROCEDURE test.public.load_excel(file_path string)
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
    # SnowflakeFile.open is the correct way to stream from a stage
    with SnowflakeFile.open(file_path, 'rb') as f:
        # Load the workbook and get the active sheet
        wb = load_workbook(f, data_only=True)
        sheet = wb.active
        data = sheet.values
        
        # Extract headers from the first row
        columns = next(data)
        
        # Create Pandas DataFrame from the remaining generator values
        df_pandas = pd.DataFrame(data, columns=columns)
        
        # Convert to Snowpark DataFrame and write to table
        df_snowpark = session.create_dataframe(df_pandas)
        df_snowpark.write.mode("overwrite").save_as_table("excel_tests")
        
    return True
$$;

-- Had already uploaded it in stage
CALL load_excel(build_scoped_file_url(@INT_STAGE,'test.xlsx'));

