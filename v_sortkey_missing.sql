CREATE OR REPLACE VIEW v_sortkey_missing
(
  database,
  table_id,
  schema,
  "table",
  size,
  num_qs
)
AS 
 SELECT t."database", t.table_id, t."schema", t."table", t.size, COALESCE(s.num_qs, 0::bigint) AS num_qs
   FROM svv_table_info t
   LEFT JOIN ( SELECT s.tbl, count(DISTINCT s.query) AS num_qs
           FROM stl_scan s
          WHERE s.userid > 1 AND s.perm_table_name <> 'Internal Worktable'::bpchar AND s.perm_table_name <> 'S3'::bpchar
          GROUP BY s.tbl) s ON s.tbl::oid = t.table_id
  WHERE t.sortkey1 IS NULL
  ORDER BY t.size DESC;

 