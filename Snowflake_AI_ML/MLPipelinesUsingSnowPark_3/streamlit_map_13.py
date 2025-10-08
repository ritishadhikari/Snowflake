# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

query="""
    SELECT 
        latitude::float AS lat,
        longitude::float AS lon,
        round(median_house_value/1000) AS val
    FROM
        test.public.housing
    ORDER BY 
        val DESC
"""

session=get_active_session()

df=session.sql(query=query).collect()
st.map(data=df,size="val",use_container_width=True)