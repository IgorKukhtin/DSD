s

with 
tmpMovement as ( select distinct Movement.*
from Movement
    join MovementProtocol on MovementProtocol.MovementId = Movement.Id
          JOIN MovementLinkObject AS MovementLinkObject_from
                                       ON MovementLinkObject_from.MovementId = Movement.Id
                                      AND MovementLinkObject_from.DescId = zc_MovementLinkObject_from()
                                      AND MovementLinkObject_from.ObjectId = 8459 
where MovementProtocol.OperDate between '29.09.2023' and '30.09.2023'
 -- and Movement.DescId = zc_Movement_Send()
--  and Movement.DescId = zc_Movement_ReturnIn()
 and Movement.DescId = zc_Movement_Sale()
 --and Movement.DescId = zc_Movement_SendOnPrice()
 and Movement.Id <> 26319675 
-- limit 500
)
--           select * from MovementDateDesc 

, tmpall as (
 select  REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата документа"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate_f
-- select   REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата накладной у контрагента"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate_f
, REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS stat_name
           -- № п/п
, MovementProtocol.OperDate as  OperDate_prot
         , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementProtocol.OperDate desc, MovementProtocol.Id DESC) AS Ord
, Movement.*
from tmpMovement as Movement
    join MovementProtocol on MovementProtocol.MovementId = Movement.Id
-- where REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата документа"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   is not null
 where REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   is not null
)

 -- select * from  tmpall order by Ord

select tmpall_old.OperDate_f  as OperDate_old, tmpall.OperDate_f  as OperDate_new, tmpall.OperDate, tmpall_old.OperDate_prot  as prot_old, tmpall.OperDate_prot as prot_new
      , tmpall_old.stat_name  as stat_name_old, tmpall.stat_name as stat_name_new
      , tmpall.Id, tmpall.InvNumber, tmpall_old.Ord as Ord_old,  tmpall .Ord as Ord_new
from tmpall
  left join tmpall as tmpall_old on tmpall_old.Id      = tmpall .Id 
                                and tmpall_old.Ord - 1 = tmpall .Ord
-- where tmpall_old.OperDate_f <> tmpall.OperDate_f
 where tmpall_old.stat_name ilike 'Удален' or tmpall.stat_name ilike 'Удален' 
