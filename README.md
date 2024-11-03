## Step 1 Create Objects


```sql
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS nastreamlit_role;
GRANT ROLE nastreamlit_role TO ROLE accountadmin;

GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE nastreamlit_role;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE nastreamlit_role;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE nastreamlit_role;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE nastreamlit_role;
GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE nastreamlit_role;
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE nastreamlit_role;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE nastreamlit_role;

GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE nastreamlit_role;

CREATE WAREHOUSE IF NOT EXISTS wh_nap WITH WAREHOUSE_SIZE='XSMALL';
GRANT ALL ON WAREHOUSE wh_nap TO ROLE nastreamlit_role;

USE ROLE nastreamlit_role;
CREATE DATABASE IF NOT EXISTS streamlit_app;
CREATE SCHEMA IF NOT EXISTS streamlit_app.napp;

```


## Create Share Data


```sql

CREATE SCHEMA IF NOT EXISTS streamlit_app.share;

CREATE TABLE streamlit_app.share.row_access_policy_test_table (
    id INT,
    some_data VARCHAR(100),
    the_owner VARCHAR(50)
);

INSERT INTO streamlit_app.share.row_access_policy_test_table (id, some_data, the_owner)
VALUES
    (4, 'Some information 4', 'ALICE'),
    (5, 'Some information 5', 'FRANK'),
    (6, 'Some information 6', 'ALICE');

```



#### Setup for Testing on the Provider Side
We can test our Native App on the Provider by mimicking what it would look like on the 
Consumer side (a benefit/feature of the Snowflake Native App Framework).

To do this, run below SQL commands . This will create the role, 
virtual warehouse for install, database, schema and permissions necessary to configure the Native App. The ROLE you will use for this is `NAC`.

```sql
USE ROLE ACCOUNTADMIN;
-- (Mock) Consumer role
CREATE ROLE IF NOT EXISTS nac;
GRANT ROLE nac TO ROLE ACCOUNTADMIN;
CREATE WAREHOUSE IF NOT EXISTS wh_nac WITH WAREHOUSE_SIZE='XSMALL';
GRANT USAGE ON WAREHOUSE wh_nac TO ROLE nac WITH GRANT OPTION;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE nac;
```


#### Testing on the Provider Side
First, let's install the Native App.

```sql
-- For Provider-side Testing
USE ROLE nastreamlit_role;
GRANT INSTALL, DEVELOP ON APPLICATION PACKAGE na_streamlit_pkg TO ROLE nac;
USE ROLE ACCOUNTADMIN;
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE nac;

USE ROLE nastreamlit_role;


-- FOLLOW THE consumer_setup.sql TO SET UP THE TEST ON THE PROVIDER
USE ROLE nac;
USE WAREHOUSE wh_nac;

-- Create the APPLICATION
DROP APPLICATION IF EXISTS na_streamlit_app CASCADE;
CREATE APPLICATION na_streamlit_app FROM APPLICATION PACKAGE na_streamlit_pkg USING VERSION v1;

--CURRENT_USER and CURRENT_SESSION return NULL when invoked from Streamlit in Snowflake within a Snowflake Native App unless permission is granted to the app with GRANT READ SESSION ON ACCOUNT TO APPLICATION.
USE ROLE ACCOUNTADMIN;
GRANT READ SESSION ON ACCOUNT TO APPLICATION na_streamlit_app;

```

Next we need to configure the Native App. We can do this via Snowsight by
visiting the Apps tab.
![Data Apps](img/data-apps.png)

* Click on our Native App `na_streamlit_app`.
* Select warehouse "WH_NAC" to proceed

NA streamlit should be activate and running
