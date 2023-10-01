with 
tmpObject as ( select distinct Object.*
from Object
    join ObjectProtocol on ObjectProtocol.ObjectId = Object.Id
where ObjectProtocol.OperDate between '29.09.2023' and '30.09.2023'
 -- and Movement.DescId = zc_Movement_Send()
--  and Movement.DescId = zc_Movement_ReturnIn()
 and Object.DescId = zc_Object_GoodsGroup()
 
)
--           select * from MovementDateDesc 

, tmpall as (
 select  null  AS OperDate_f
-- select   REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата накладной у контрагента"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate_f
, REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Группа"] /@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS stat_name
           -- № п/п
, ObjectProtocol.OperDate as  OperDate_prot
         , ROW_NUMBER() OVER (PARTITION BY Object.Id ORDER BY ObjectProtocol.OperDate desc, Object.Id DESC) AS Ord
, Object.*
from tmpObject as Object
    join ObjectProtocol on ObjectProtocol.ObjectId = Object.Id
)

 -- select * from  tmpall order by Ord

select tmpall_old.OperDate_f  as OperDate_old, tmpall.OperDate_f  as OperDate_new, tmpall.*, tmpall_old.OperDate_prot  as prot_old, tmpall.OperDate_prot as prot_new
      , tmpall_old.stat_name  as stat_name_old, tmpall.stat_name as stat_name_new
      , tmpall.Id, tmpall_old.Ord as Ord_old,  tmpall .Ord as Ord_new
from tmpall
  left join tmpall as tmpall_old on tmpall_old.Id      = tmpall .Id 
                                and tmpall_old.Ord - 1 = tmpall .Ord
-- where tmpall_old.OperDate_f <> tmpall.OperDate_f
--  where tmpall_old.stat_name ilike 'Удален' or tmpall.stat_name ilike 'Удален' 
