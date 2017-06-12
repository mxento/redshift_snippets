CREATE OR REPLACE VIEW v_get_schema_priv_by_user
(
  schemaname,
  usename,
  cre,
  usg
)
AS 
 SELECT derived_table1.schemaname, derived_table1.usename, derived_table1.cre, derived_table1.usg
   FROM ( SELECT objs.schemaname, usrs.usename, has_schema_privilege(usrs.usename, objs.schemaname::character varying::text, 'create'::character varying::text) AS cre, has_schema_privilege(usrs.usename, objs.schemaname::character varying::text, 'usage'::character varying::text) AS usg
           FROM ( SELECT pg_namespace.nspname AS schemaname
                   FROM pg_namespace) objs
      JOIN ( SELECT pg_user.usename, pg_user.usesysid, pg_user.usecreatedb, pg_user.usesuper, pg_user.usecatupd, pg_user.passwd, pg_user.valuntil, pg_user.useconfig
                   FROM pg_user) usrs ON 1 = 1
     ORDER BY objs.schemaname) derived_table1
  WHERE derived_table1.cre = true OR derived_table1.usg = true;

 