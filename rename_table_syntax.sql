
set search_path to public;

-- simple rename
alter table report_table rename to report_table_bk;


-- example swap restore from another table:  report_table_bk to report_table 
alter table report_table rename to   report_table_bad ;
alter table report_table_bk rename to  report_table;
 
drop table if exists report_table_bad;