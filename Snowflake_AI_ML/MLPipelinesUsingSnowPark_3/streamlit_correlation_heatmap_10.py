# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
import matplotlib.pyplot as plt
import seaborn as sns


# Get the current credentials
session = get_active_session()

df=get_active_session().table(name='housing').to_pandas()
st.dataframe(data=df)

fig,ax=plt.subplots()
sns.heatmap(df.corr(),ax=ax)
st.write(fig)