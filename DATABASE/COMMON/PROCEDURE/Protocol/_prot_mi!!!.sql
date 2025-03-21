with tmp_to as 
(select distinct Movement.*, MovementItem.Id AS MovementItemId, MovementItem.DescId, MovementItem.Amount, MovementItem.isErased -- , MovementItemProtocol.OperDate AS OperDate_prot
, REPLACE(REPLACE(XPATH ('/XML/Field[@FieldName = "Значение"]/@FieldValue', MovementItemProtocol.protocolData :: XML) :: Text, '{', ''), '}','') AS X
-- , MovementItemProtocol.protocolData 
-- , RIGHT (MovementItemProtocol.protocolData , 129)
-- <Field FieldName = "Значение" FieldValue = "0.0000"/><Field FieldName = "ParentId" FieldValue = "3151521 (...)"
FROM Movement 
     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
--                      AND MovementItem.isErased = true
                     -- AND MovementItem.Amount = 0
                      -- AND MovementItem.DescId = 1
                      AND MovementItem.ObjectId = 7979
          JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
          JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()

          JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MovementItem.Id
                                             AND MILO.DescId     = zc_MILinkObject_GoodsKind()
                                             AND MILO.ObjectId   = 5808945

join MovementItemProtocol on MovementItemProtocol.MovementItemId = MovementItem.Id
  and MovementItemProtocol.OperDate >= '28.02.2025 21:00'


where Movement.OperDate between '01.02.2025' and '28.02.2025'
AND (MLO_From.ObjectId = zc_Unit_RK() or MLO_To.ObjectId = zc_Unit_RK())
--  AND Movement.DescId not IN (zc_Movement_Inventory()) -- zc_Movement_Inventory()
--  AND Movement.DescId IN (zc_Movement_ProductionUnion()) -- zc_Movement_Inventory()
    AND Movement.StatusId = zc_Enum_Status_Complete()
--    AND Movement.StatusId = zc_Enum_Status_UnComplete()
--    AND Movement.StatusId = zc_Enum_Status_Erased()
)
, tmp_from as
(select Movement.*, MovementItem.Id AS MovementItemId
     , REPLACE(REPLACE(XPATH ('/XML/Field[@FieldName = "Значение"]/@FieldValue', MovementItemProtocol.protocolData :: XML) :: Text, '{', ''), '}','') AS X
     , ROW_NUMBER() OVER (PARTITION BY MovementItem.Id ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
FROM Movement 
     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                      AND MovementItem.ObjectId = 7979
join (select distinct tmp_to.MovementItemId from tmp_to) AS tmp_to ON tmp_to.MovementItemId = MovementItem.Id

join MovementItemProtocol on MovementItemProtocol.MovementItemId = MovementItem.Id
  and MovementItemProtocol.OperDate < '28.02.2025 21:00'


 where Movement.OperDate between '01.02.2025' and '28.02.2025'
)

select tmp_from.x , tmp_to.x, tmp_to .*
from tmp_from 
   join  tmp_to on tmp_to.MovementItemId = tmp_from.MovementItemId
               and tmp_to.x <> tmp_from.x
where ord = 1

--  select  * from tmp_to