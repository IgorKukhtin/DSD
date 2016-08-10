CREATE TEMP TABLE T(T_ID Int) ON COMMIT DROP;

Insert Into T(T_ID)
Select M.ID --, MLO.ObjectId, M.OperDate, M.OperDate - Interval '11 day'
from Movement M 
  Inner Join MovementLinkObject MLO ON M.ID = MLO.MovementID AND MLO.DescId = zc_MovementLinkObject_Unit()
Where M.OperDate >= '20160813' and M.OperDate <= '20160817'
  AND M.DescId = zc_Movement_Check()
  AND MLO.ObjectId = 472116;


Select gpUpdate_Status_Check(T_ID, zc_Enum_StatusCode_UnComplete(), '3')
from T;

Update Movement SET 
  OperDate = OperDate - Interval '11 day'
WHERE ID in (Select T_ID from T);
  
Select gpUpdate_Status_Check(T_ID, zc_Enum_StatusCode_Complete(), '3')
from T;
