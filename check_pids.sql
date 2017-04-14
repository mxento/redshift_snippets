-- currently running sql jobs 
select pid, trim(user_name), starttime, query
from stv_recents
where status = 'Running'
order by starttime ASC; 


-- Currently executing and recently executed queries with status, duration, database, etc.
SELECT
  r.pid,
  TRIM(status) AS status,
  TRIM(db_name) AS db,
  TRIM(user_name) AS "user",
  TRIM(label) AS query_group,
  r.starttime AS start_time,
  r.duration,
  r.query AS sql
FROM stv_recents r LEFT JOIN stv_inflight i ON r.pid = i.pid;


select * from STL_WLM_QUERY where userid = 441 ;
 

-- recents queries
select query, trim(querytxt) as sqlquery
from stl_query
order by query desc limit 5;

-- recents pids by starttime
select pid, user_name, starttime, query, status
from stv_recents
order by starttime desc 
;

-- recents by user
select user_name, count(*) ct
from stv_recents 
group by 1 order by ct desc
; 