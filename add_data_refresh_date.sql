-- add_column_data_refresh_date.sql


describe public.report_table_name;
alter table public.report_table_name add column data_refresh_date date null; 
update public.report_table_name  set data_refresh_date = current_date ; 
