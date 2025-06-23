select * from Container where KeyValue IN (select KeyValue from Container group by KeyValue having COUNT(*) > 1) order by KeyValue, Id

select MasterKeyValue, ChildKeyValue from Container group by MasterKeyValue, ChildKeyValue having COUNT(*) > 1

select * from Container where MasterKeyValue = 2328152950 and ChildKeyValue  = 1112162164

-- update Container set KeyValue = KeyValue || 'err' , MasterKeyValue = 2328151234 where Id= 11559645