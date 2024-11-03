USE ROLE nastreamlit_role;
USE WAREHOUSE wh_nap;

CREATE OR REPLACE SCHEMA na_streamlit_pkg.shared_data;

grant reference_usage on database streamlit_app to share in application package na_streamlit_pkg;

CREATE OR REPLACE SECURE VIEW na_streamlit_pkg.shared_data.row_access_policy_test_vw AS SELECT * FROM streamlit_app.share.row_access_policy_test_table;
GRANT USAGE ON SCHEMA na_streamlit_pkg.shared_data TO SHARE IN APPLICATION PACKAGE na_streamlit_pkg;
GRANT SELECT ON VIEW na_streamlit_pkg.shared_data.row_access_policy_test_vw TO SHARE IN APPLICATION PACKAGE na_streamlit_pkg;
GRANT USAGE ON SCHEMA na_streamlit_pkg.shared_data TO SHARE IN APPLICATION PACKAGE na_streamlit_pkg;
