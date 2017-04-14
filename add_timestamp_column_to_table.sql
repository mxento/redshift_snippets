-- key syntax
select cast(GETDATE() as timestamp) dw_loadtime_utc; 


drop table if exists public.test_tble;

select cast(GETDATE() as timestamp)	dw_loadtime
into  public.test_tble ; 

select * from public.test_tble;


select GETDATE() as dw_loadtime, CURRENT_DATE test_date
into  public.test_tble ;


select now() dw_loadtime, CURRENT_DATE test_date 
into  public.test_tble ; 

    