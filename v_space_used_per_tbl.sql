CREATE OR REPLACE VIEW v_space_used_per_tbl
(
  dbase_name,
  schemaname,
  tablename,
  tbl_oid,
  megabytes,
  rowcount,
  unsorted_rowcount,
  pct_unsorted,
  recommendation
)
AS 
 SELECT btrim(pgdb.datname::character varying::text) AS dbase_name, btrim(pgn.nspname::character varying::text) AS schemaname, btrim(a.name::character varying::text) AS tablename, a.id AS tbl_oid, b.mbytes AS megabytes, a."rows" AS rowcount, a.unsorted_rows AS unsorted_rowcount, 
        CASE
            WHEN a."rows" = 0 THEN 0::double precision
            ELSE round(a.unsorted_rows::double precision / a."rows"::double precision * 100::double precision, 5::numeric::numeric(18,0))
        END AS pct_unsorted, 
        CASE
            WHEN a."rows" = 0 THEN 'n/a'::character varying
            WHEN (a.unsorted_rows::double precision / a."rows"::double precision * 100::double precision) >= 20::double precision THEN 'VACUUM SORT recommended'::character varying
            ELSE 'n/a'::character varying
        END AS recommendation
   FROM ( SELECT stv_tbl_perm.db_id, stv_tbl_perm.id, stv_tbl_perm.name, sum(stv_tbl_perm."rows") AS "rows", sum(stv_tbl_perm."rows") - sum(stv_tbl_perm.sorted_rows) AS unsorted_rows
           FROM stv_tbl_perm
          GROUP BY stv_tbl_perm.db_id, stv_tbl_perm.id, stv_tbl_perm.name) a
   JOIN pg_class pgc ON pgc.oid = a.id::oid
   JOIN pg_namespace pgn ON pgn.oid = pgc.relnamespace
   JOIN pg_database pgdb ON pgdb.oid = a.db_id::oid
   LEFT JOIN ( SELECT stv_blocklist.tbl, count(*) AS mbytes
   FROM stv_blocklist
  GROUP BY stv_blocklist.tbl) b ON a.id = b.tbl
  WHERE pgc.relowner > 1
  ORDER BY btrim(pgdb.datname::character varying::text), btrim(a.name::character varying::text), btrim(pgn.nspname::character varying::text);


COMMIT;