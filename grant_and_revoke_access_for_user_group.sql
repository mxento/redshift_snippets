-- grant and revoke example
grant select on dcose.report_table to group user_group_name_here;
revoke select on dcose.report_table from group user_group_name_here;

select * from v_get_tables_in_group where groupname like '%dcose%'; 

-- get groupname users
select * from v_get_users_in_group where groupname = 'user_group_name_here';
select * from v_get_users_in_group where groupname = 'user_group_name_two';

-- get tables in group 
select * from v_get_tables_in_group where groupname ='user_group_name_here';
select * from v_get_tables_in_group where groupname = 'user_group_name_two';

-- check user in groups
select * from v_get_users_in_group where usename = 'testuser';
select * from v_get_users_in_group where usename = 'testuser2';


-- grant examples
grant select on dcose.report_table_to_do to group user_group_name_here;
grant select on dcose.report_table_to_do to group user_group_name_two;

