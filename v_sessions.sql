CREATE OR REPLACE VIEW v_sessions
(
  pid,
  query,
  queue,
  s_start,
  conn_mins,
  run_secs,
  user_name,
  db,
  q_start,
  sql
)
AS 
 SELECT s.process AS pid, q.query, q.service_class AS queue, date_trunc('second'::character varying::text, s.starttime) AS s_start, date_diff('minutes'::character varying::text, s.starttime, getdate()) AS conn_mins, q.exec_time / 1000000 AS run_secs, btrim(s.user_name::character varying::text) AS user_name, btrim(s.db_name::character varying::text) AS db, date_trunc('second'::character varying::text, i.starttime) AS q_start, "substring"(btrim(i.query::character varying::text), 1, 120) AS sql
   FROM stv_sessions s
   LEFT JOIN stv_recents i ON s.process = i.pid AND i.status = 'Running'::bpchar
   LEFT JOIN stv_inflight f ON s.process = f.pid
   LEFT JOIN stv_wlm_query_state q ON f.query = q.query
  WHERE s.user_name <> 'rdsdb'::bpchar
  ORDER BY date_diff('minutes'::character varying::text, s.starttime, getdate()) DESC;

; 
