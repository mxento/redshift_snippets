CREATE OR REPLACE VIEW v_top_queries
(
  db,
  n_qry,
  qrytext,
  min,
  max,
  avg,
  total,
  max_query_id,
  last_run,
  aborted,
  event
)
AS 
 SELECT btrim(derived_table1."database") AS db, count(derived_table1.query) AS n_qry, "max"("substring"(derived_table1.qrytext, 1, 300)) AS qrytext, min(derived_table1.run_minutes) AS min, "max"(derived_table1.run_minutes) AS "max", avg(derived_table1.run_minutes) AS avg, sum(derived_table1.run_minutes) AS total, "max"(derived_table1.query) AS max_query_id, "max"(derived_table1.starttime)::date AS last_run, derived_table1.aborted, derived_table1.event
   FROM ( SELECT stl_query.userid, stl_query."label", stl_query.query, btrim(stl_query."database"::character varying::text) AS "database", btrim(stl_query.querytxt::character varying::text) AS qrytext, md5(btrim(stl_query.querytxt::character varying::text)) AS qry_md5, stl_query.starttime, stl_query.endtime, date_diff('seconds'::character varying::text, stl_query.starttime, stl_query.endtime)::numeric::numeric(18,0)::numeric(12,2) AS run_minutes, stl_query.aborted, 
                CASE
                    WHEN alrt.event = 'Very selective query filter'::character varying::text OR alrt.event IS NULL AND 'Very selective query filter' IS NULL THEN 'Filter'::character varying::text
                    WHEN alrt.event = 'Scanned a large number of deleted rows'::character varying::text OR alrt.event IS NULL AND 'Scanned a large number of deleted rows' IS NULL THEN 'Deleted'::character varying::text
                    WHEN alrt.event = 'Nested Loop Join in the query plan'::character varying::text OR alrt.event IS NULL AND 'Nested Loop Join in the query plan' IS NULL THEN 'Nested Loop'::character varying::text
                    WHEN alrt.event = 'Distributed a large number of rows across the network'::character varying::text OR alrt.event IS NULL AND 'Distributed a large number of rows across the network' IS NULL THEN 'Distributed'::character varying::text
                    WHEN alrt.event = 'Broadcasted a large number of rows across the network'::character varying::text OR alrt.event IS NULL AND 'Broadcasted a large number of rows across the network' IS NULL THEN 'Broadcast'::character varying::text
                    WHEN alrt.event = 'Missing query planner statistics'::character varying::text OR alrt.event IS NULL AND 'Missing query planner statistics' IS NULL THEN 'Stats'::character varying::text
                    ELSE alrt.event
                END AS event
           FROM stl_query
      LEFT JOIN ( SELECT stl_alert_event_log.query, btrim(split_part(stl_alert_event_log.event::character varying::text, ':'::character varying::text, 1)) AS event
                   FROM stl_alert_event_log
                  WHERE stl_alert_event_log.event_time >= date_add('day'::character varying::text, - 2::bigint, 'now'::character varying::date::timestamp without time zone)
                  GROUP BY stl_alert_event_log.query, btrim(split_part(stl_alert_event_log.event::character varying::text, ':'::character varying::text, 1))) alrt ON alrt.query = stl_query.query
     WHERE stl_query.userid <> 1 AND stl_query.starttime >= date_add('day'::character varying::text, - 2::bigint, 'now'::character varying::date::timestamp without time zone)) derived_table1
  GROUP BY derived_table1."database", derived_table1."label", derived_table1.qry_md5, derived_table1.aborted, derived_table1.event
  ORDER BY sum(derived_table1.run_minutes) DESC
 LIMIT 50;


COMMIT;