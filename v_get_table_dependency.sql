CREATE OR REPLACE VIEW v_get_table_dependency
(
  tbloid,
  schemaname,
  tablename,
  refbyschemaname,
  refbyname,
  viewoid
)
AS 
 SELECT DISTINCT c_p.oid AS tbloid, n_p.nspname AS schemaname, c_p.relname AS tablename, n_c.nspname AS refbyschemaname, c_c.relname AS refbyname, c_c.oid AS viewoid
   FROM pg_class c_p
   JOIN pg_depend d_p ON c_p.relfilenode = d_p.refobjid
   JOIN pg_depend d_c ON d_p.objid = d_c.objid
   JOIN pg_class c_c ON d_c.refobjid = c_c.relfilenode
   LEFT JOIN pg_namespace n_p ON c_p.relnamespace = n_p.oid
   LEFT JOIN pg_namespace n_c ON c_c.relnamespace = n_c.oid
  WHERE d_c.deptype = 'i'::"char" AND c_c.relkind = 'v'::"char"
  ORDER BY c_p.relname;

 