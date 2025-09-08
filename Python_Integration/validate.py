import snowflake.connector
from dotenv import load_dotenv
import os

load_dotenv()
username=os.getenv(key='snowflake_username')
password=os.getenv(key='SNOWSQL_PWD')
accountName=os.getenv(key='account')

# Gets the version
ctx = snowflake.connector.connect(
    user=username,
    password=password,
    account=accountName
    )
cs = ctx.cursor()
try:
    cs.execute("SELECT current_version()")
    one_row = cs.fetchone()
    print(one_row[0])
finally:
    cs.close()
ctx.close()