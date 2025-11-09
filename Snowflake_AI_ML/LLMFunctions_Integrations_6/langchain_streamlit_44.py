# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
import os
from langchain_community.utilities import SQLDatabase
from langchain_openai import OpenAI
from langchain.chains import create_sql_query_chain


# Get the current credentials


@st.cache_resource(show_spinner="Connecting ...")
def getSession():
    session = get_active_session()
    url="snowflake://ritishadhikari:Eklavya@05072024@DLCTVSW-DW86981/test/public?warehouse=compute_wh&role=accountadmin"
    db=SQLDatabase.from_uri(url)
    openai_key=None
    llm=OpenAI(openai_api_key=openai_key)
    chain=create_sql_query_chain(llm, db)
    return session, db, chain

st.title("SQL Query Generator")
st.write("Returns and runs queries from questions in natural language")

session, db, chain=getSession()

question=st.sidebar.text_area("Ask a question:", value="Show me the total number of entries in the first table")

sql=chain.invoke({"question":question}).rstrip(';')

tabQuery,tabData, tabLog=st.tabs(['Query',"Data",'Log'])

tabQuery.code(sql,language='sql')
tabdata.dataframe(session.sql(sql))
tabLog.code(db.table_info, language='sql')