CREATE OR REPLACE VIEW v_schema_tables
(
  table_id,
  db_name,
  schema_name,
  table_name
)
AS 
 SELECT DISTINCT stv_tbl_perm.id AS table_id, btrim(pg_database.datname::character varying::text) AS db_name, btrim(pg_namespace.nspname::character varying::text) AS schema_name, btrim(pg_class.relname::character varying::text) AS table_name
   FROM stv_tbl_perm
   JOIN pg_class ON pg_class.oid = stv_tbl_perm.id::oid
   JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
   JOIN pg_database ON pg_database.oid = stv_tbl_perm.db_id::oid;

 