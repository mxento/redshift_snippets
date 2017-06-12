CREATE OR REPLACE VIEW v_table_info
(
  schema,
  "table",
  tableid,
  distkey,
  skew,
  sortkey,
  "#sks",
  rows,
  mbytes,
  enc,
  pct_of_total,
  pct_stats_off,
  pct_unsorted
)
AS 
 SELECT btrim(pgn.nspname::character varying::text) AS "schema", btrim(a.name::character varying::text) AS "table", a.id AS tableid, 
        CASE
            WHEN pgc.reldiststyle = 0 OR pgc.reldiststyle IS NULL AND 0 IS NULL THEN 'EVEN'::character varying
            WHEN pgc.reldiststyle = 1 OR pgc.reldiststyle IS NULL AND 1 IS NULL THEN det."distkey"::character varying
            WHEN pgc.reldiststyle = 8 OR pgc.reldiststyle IS NULL AND 8 IS NULL THEN 'ALL'::character varying
            ELSE NULL::character varying
        END AS "distkey", 
        CASE
            WHEN pgc.reldiststyle = 8 OR pgc.reldiststyle IS NULL AND 8 IS NULL THEN NULL::numeric::numeric(18,0)
            ELSE dist_ratio.ratio::numeric(10,4)
        END AS skew, det.head_sort AS "sortkey", det.n_sortkeys AS "#sks", a."rows", b.mbytes, 
        CASE
            WHEN det.max_enc = 0 OR det.max_enc IS NULL AND 0 IS NULL THEN 'N'::character varying
            ELSE 'Y'::character varying
        END AS enc, 
        CASE
            WHEN b.mbytes = 0 OR b.mbytes IS NULL AND 0 IS NULL THEN 0::numeric::numeric(18,0)
            ELSE (b.mbytes::numeric::numeric(18,0) / part.total::numeric::numeric(18,0) * 100::numeric::numeric(18,0))::numeric(5,2)
        END AS pct_of_total, 
        CASE
            WHEN a."rows" = 0 THEN NULL::numeric::numeric(18,0)
            ELSE ((a."rows"::double precision - pgc.reltuples)::numeric(19,3) / a."rows"::numeric::numeric(18,0)::numeric(19,3) * 100::numeric::numeric(18,0))::numeric(5,2)
        END AS pct_stats_off, 
        CASE
            WHEN det.n_sortkeys = 0 OR det.n_sortkeys IS NULL AND 0 IS NULL THEN NULL::numeric::numeric(18,0)
            ELSE 
            CASE
                WHEN a."rows" = 0 OR a."rows" IS NULL AND 0 IS NULL THEN 0::numeric::numeric(18,0)
                ELSE a.unsorted_rows::numeric::numeric(18,0)::numeric(32,0) / a."rows"::numeric::numeric(18,0) * 100::numeric::numeric(18,0)
            END
        END::numeric(5,2) AS pct_unsorted
   FROM ( SELECT a.db_id, a.id, a.name, sum(a."rows") AS "rows", sum(a."rows") - sum(a.sorted_rows) AS unsorted_rows
           FROM stv_tbl_perm a
          GROUP BY a.db_id, a.id, a.name) a
   JOIN pg_class pgc ON pgc.oid = a.id::oid
   JOIN pg_namespace pgn ON pgn.oid = pgc.relnamespace
   LEFT JOIN ( SELECT stv_blocklist.tbl, count(*) AS mbytes
   FROM stv_blocklist
  GROUP BY stv_blocklist.tbl) b ON a.id = b.tbl
   JOIN ( SELECT pg_attribute.attrelid, min(
        CASE
            WHEN pg_attribute.attisdistkey = true THEN pg_attribute.attname
            ELSE NULL::name
        END::character varying::text) AS "distkey", min(
        CASE
            WHEN pg_attribute.attsortkeyord = 1 THEN pg_attribute.attname
            ELSE NULL::name
        END::character varying::text) AS head_sort, "max"(pg_attribute.attsortkeyord) AS n_sortkeys, "max"(pg_attribute.attencodingtype) AS max_enc
   FROM pg_attribute
  GROUP BY pg_attribute.attrelid) det ON det.attrelid = a.id::oid
   JOIN ( SELECT derived_table1.tbl, "max"(derived_table1.mbytes)::numeric::numeric(18,0)::numeric(32,0) / min(derived_table1.mbytes)::numeric::numeric(18,0) AS ratio
   FROM ( SELECT svv_diskusage.tbl, btrim(svv_diskusage.name::character varying::text) AS name, svv_diskusage.slice, count(*) AS mbytes
           FROM svv_diskusage
          GROUP BY svv_diskusage.tbl, svv_diskusage.name, svv_diskusage.slice) derived_table1
  GROUP BY derived_table1.tbl, derived_table1.name) dist_ratio ON a.id = dist_ratio.tbl
   JOIN ( SELECT sum(stv_partitions.capacity) AS total
   FROM stv_partitions
  WHERE stv_partitions.part_begin = 0) part ON 1 = 1
  WHERE b.mbytes IS NOT NULL AND pgc.relowner > 1
  ORDER BY b.mbytes DESC;


COMMIT;