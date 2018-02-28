-- check user password
select * from pg_user where usename = 'testuser';

-- reset  user password
ALTER USER testuser PASSWORD 'thepassword' VALID UNTIL 'infinity';

-- add user to user_group
ALTER GROUP system_readsonly_ro ADD USER testuser;

-- check if user in group 
select * from public.v_get_users_in_group where usename = 'testuser';

-- get schema privledges for user
select * from public.v_get_schema_priv_by_user where usename = 'testuser'; 
 
