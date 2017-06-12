

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
 