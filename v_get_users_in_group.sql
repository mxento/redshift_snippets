

CREATE OR REPLACE VIEW v_get_users_in_group
(
  groupname,
  usename
)
AS 
 SELECT pg_group.groname AS groupname, pg_user.usename
   FROM pg_group, pg_user
  WHERE pg_user.usesysid = ANY (pg_group.grolist)
  ORDER BY pg_group.groname, pg_user.usename;
 

 select * from dcose_stg.temp_dim_tickes_sla_miss_update limit 100;

select * from dcose.dim_cluster order by 1 desc limit 100;

select * from infrabi_admin.v_get_users_in_group where usename = 'dcose_reporting';
select * from infrabi_admin.v_get_users_in_group where usename = 'reporting_ro';
