 select *
-- update Movement set OperDate = '21.04.2020'
-- , StatusId = zc_Enum_Status_Erased()
from (
  SELECT Movement.*
 -- SELECT DISTINCT Movement.StatusId 
         , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementProtocol .OperDate aSC) AS Ord
, MovementProtocol .OperDate as OperDate_prot
FROM 
 Movement 
inner JOIN MovementProtocol on MovementProtocol. MovementId = Movement.Id
            inner JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                      ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
and MovementBoolean_SUN_v2.ValueData = true
where Movement.OperDate = '01.01.2020'
   AND Movement.DescId = zc_Movement_Send() 
    AND Movement.StatusId = zc_Enum_Status_Erased()
) as tmp

 where tmp.Ord = 1
  and DATE_TRUNC ('day', OperDate_prot) = '21.04.2020'
-- and Movement .Id =  tmp.Id
 order by OperDate_prot
