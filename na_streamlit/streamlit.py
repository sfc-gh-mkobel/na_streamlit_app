# Import Python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("CURRENT_USER() + Row Access Policy in SiS Demo :balloon:")
st.write(
        """You can access `CURRENT_USER()` and data from tables with row access policies
        in Streamlit in Snowflake apps
        """)

# Get the current credentials
session = get_active_session()

st.header('Demo')

st.subheader('Credentials')
sql = "SELECT CURRENT_USER();"
df = session.sql(sql).collect()
st.write(df)

st.subheader('Row Access on a Table')
sql = "SELECT * FROM row_access_policy_test_vw;"
df = session.sql(sql).collect()

st.write(df)