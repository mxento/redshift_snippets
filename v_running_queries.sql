CREATE OR REPLACE VIEW v_running_queries
(
  user_name,
  db_name,
  pid,
  query,
  duration_seconds
)
AS 
 SELECT stv_recents.user_name, stv_recents.db_name, stv_recents.pid, stv_recents.query, stv_recents.duration::double precision / (10::double precision ^ 6::double precision) AS duration_seconds
   FROM stv_recents
  WHERE stv_recents.status = 'Running'::bpchar;


COMMIT;