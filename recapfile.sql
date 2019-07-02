--after creating this sql file excecute below command in CL
--snowsql -c example -f Recapfile.sql -o output_format=csv -o header=false -o timing=false -o friendly=false  > RecapSqlFile.csv


--using existing warehouse
use demo_db;

--creating new warehouse/database/table
create or replace warehouse Recap_wh;

create or replace database Recap_db;

create or replace table emp_basic (
  first_name string ,
  last_name string ,
  email string ,
  streetaddress string ,
  city string ,
  start_date date
  );

--copying csv file contents to table 
put file:///Users/sgandham/snowflake-tutorials/dataset/employees01*.csv @recap_db.public.%emp_basic;

copy into emp_basic
  from @%emp_basic
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees01.csv.gz'
  on_error = 'skip_file';

--creating function 
create or replace function empl(first_n varchar)
  returns table (email varchar, city varchar)
  as
  $$
    select email,city from emp_basic where first_name = first_n
  $$
  ;
   select * from table(empl('Avo'));
   


