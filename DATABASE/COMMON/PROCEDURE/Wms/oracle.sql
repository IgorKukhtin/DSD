 select * from from_host_header_message where type in ('sku_group', 'sku_depends')  order by id desc FETCH NEXT 20 ROWS ONLY
-- select * from from_host_detail_message where type = 'order_detail' order by id desc FETCH NEXT 100 ROWS ONLY
-- select * from to_host_header_message order by id desc FETCH NEXT 10 ROWS ONLY 
-- select * from to_host_detail_message order by id desc FETCH NEXT 10 ROWS ONLY 
 
-- select * from from_host_header_message where message like '%15313500%' order by id desc FETCH NEXT 1000 ROWS ONLY
-- select * from from_host_detail_message where message like '%38391802%' order by id desc FETCH NEXT 100 ROWS ONLY

