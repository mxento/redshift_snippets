-- creates a redshift adminuser with all power on schema public

create user adminuser createuser password 'admin123';
alter user adminuser createuser;

grant all on schema public to adminuser;