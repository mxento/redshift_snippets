-- dump to s3 example 

unload ('select * from public.report_table_name') to 's3://s3bucketname/report_table_name.txt' parallel off
CREDENTIALS 'aws_access_key_id=[your_iam_keyid];aws_secret_access_key=[your_iam_key]'
delimiter as '\t' ;