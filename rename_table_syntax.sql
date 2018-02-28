
set search_path to public;

-- simple rename
alter table report_table rename to report_table_bk;


-- example swap restore from another table:  report_table_bk to report_table 
alter table report_table rename to   report_table_bad ;
alter table report_table_bk rename to  report_table;
 
drop table if exists report_table_bad;
-- 


set search_path = 'dcose';
-- drop table  dcose.fct_setool_log ; 
create table dcose.fct_setool_log2 
(      rowid                   bigINT IDENTITY(1,1),
      run_by varchar(100) null, 
      run_time_string_raw  varchar(50) null, 
      run_time   timestamp null, 
      case_id varchar(15) null, 
      hw_id varchar(50) null, 
      model varchar(50) null, 
      server_type varchar(50) null,   
      workflow_messages varchar(max) null, 
      resolved varchar(50) null, 
      uuid varchar(50) null, 
      site varchar(50) null, 
      dw_loadtime_utc timestamp null
) 
distkey (rowid)
sortkey (case_id, uuid)
; 

insert into dcose.fct_setool_log2 
select * from dcose.fct_setool_log; 

alter table fct_setool_log rename to   fct_setool_log_bad ;
alter table fct_setool_log2 rename to   fct_setool_log ;
drop table if exits fct_setool_log_bad; 

select * from fct_setool_log; 
