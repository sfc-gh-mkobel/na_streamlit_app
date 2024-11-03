-- ==========================================
-- This script runs when the app is installed 
-- ==========================================

-- Create Application Role and Schema
create application role if not exists app_instance_role;
create or alter versioned schema app_instance_schema;

-- Share data
create or replace view app_instance_schema.row_access_policy_test_vw as select * from shared_data.row_access_policy_test_vw;

-- Create Streamlit app
create or replace streamlit app_instance_schema.streamlit from '/' main_file='streamlit.py';

CREATE OR REPLACE ROW ACCESS POLICY app_instance_schema.row_access_policy
AS (the_owner VARCHAR) RETURNS BOOLEAN ->
    the_owner = CURRENT_USER();


ALTER VIEW app_instance_schema.row_access_policy_test_vw ADD ROW ACCESS POLICY app_instance_schema.row_access_policy ON (the_owner);

create or replace procedure app_instance_schema.update_reference(ref_name string, operation string, ref_or_alias string)
returns string
language sql
as $$
begin
  case (operation)
    when 'ADD' then
       select system$set_reference(:ref_name, :ref_or_alias);
    when 'REMOVE' then
       select system$remove_reference(:ref_name, :ref_or_alias);
    when 'CLEAR' then
       select system$remove_all_references();
    else
       return 'Unknown operation: ' || operation;
  end case;
  return 'Success';
end;
$$;

-- Grant usage and permissions on objects
grant usage on schema app_instance_schema to application role app_instance_role;

grant SELECT on view app_instance_schema.row_access_policy_test_vw to application role app_instance_role;
grant usage on streamlit app_instance_schema.streamlit to application role app_instance_role;
grant usage on procedure app_instance_schema.update_reference(string, string, string) to application role app_instance_role;


