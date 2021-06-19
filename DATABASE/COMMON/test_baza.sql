

 update Object set valuedata = 'http://project-vds.vds.colocall.com/projectReal/index.php' where Id = zc_Enum_GlobalConst_ConnectParam();
 update Object set valuedata = 'http://project-vds.vds.colocall.com/projectReal/index.php' where Id = zc_Enum_GlobalConst_ConnectParam();
--
 update Object set valuedata = 'http://project-vds.vds.colocall.com/projectReal/index.php' where Id = zc_Enum_GlobalConst_ConnectReportParam();
 update Object set valuedata = 'http://project-vds.vds.colocall.com/projectReal/index.php' where Id = zc_Enum_GlobalConst_ConnectReportParam();

 update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectParam();
 update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectParam();
--
 update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam();
 update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam();


select * from _replica.settings


Load FillSoldTable
C:\Project\Bin\Load_PostgreSql.exe alan_dp_ua autoFillSoldTable ++

Load FillSoldTable_curr
C:\Project\Bin\Load_PostgreSql.exe alan_dp_ua autoFillSoldTable_curr

Load_All_0
C:\Project\Bin\Load_PostgreSql.exe alan_dp_ua autoALL 11 - br-0 next- VAC_5

Load_All_1
C:\Project\Bin\Load_All_\Load_All_1\Load_PostgreSql.exe alan_dp_ua autoALL 10 - br-1 next-

Load_All_2
C:\Project\Bin\Load_All_\Load_All_2\Load_PostgreSql.exe alan_dp_ua autoALL 10 - br-2 next-


C:\Project\Bin\Load_PostgreSql.exe alan_dp_ua
C:\Project\Bin\EDIOrdersLoader.exe -interval 3



SELECT count(*) FROM _replica.table_update_data AS tmp order by id desc limit 100
-- 6572221719
SELECT * FROM _replica.table_update_data_two AS tmp order by id desc limit 100

insert into _replica.table_update_data_two
SELECT * from _replica.table_update_data ;
truncate table _replica.table_update_data 




-- delete from _replica.settings
select * from _replica.errors

select * from _replica.settings
insert into _replica.settings
-- select 1, 'client_id', '4654820590183185827', ''
select  2, 'last_id', '6572221719', ''


SELECT *  FROM _replica.table_update_data where pk_values in ('204411907', '20141866') and Id in (6573216862 , 6573237325) order by id
