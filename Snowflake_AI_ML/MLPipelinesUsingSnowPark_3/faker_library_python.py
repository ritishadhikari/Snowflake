import random
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import StructType, StructField, StringType, IntegerType
from faker import Faker

def main(session: snowpark.Session):
    f=Faker()
    output=[ 
            [
                f.name(),
                f.country(),
                f.city(),
                f.state(),
                random.randrange(start=100,stop=10000)
            ] for _ in range(10000)
           ]

    schema=StructType(
        [
            StructField(column_identifier="NAME",datatype=StringType(),nullable=False),
            StructField(column_identifier="COUNTRY",datatype=StringType(),nullable=False),
            StructField(column_identifier="CITY",datatype=StringType(),nullable=False),
            StructField(column_identifier="STATE",datatype=StringType(),nullable=False),
            StructField(column_identifier="SALES",datatype=IntegerType(),nullable=False),
        ]
    )
    df=session.create_dataframe(data=output,schema=schema)
    df.write.mode(save_mode="overwrite").saveAsTable(table_name="test.public.customers_fake")
    df.show()
    return df