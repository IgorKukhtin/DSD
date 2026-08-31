with a as (select Movement.*, MovementItem.isErased, MovementItem.Id as MovementItemId, MIBoolean_MasterFuel.ValueData  as MasterFuel
           FROM Movement
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()

                 JOIN MovementItem as MI_2 ON MI_2.MovementId = Movement.Id
                                  AND MI_2.DescId     = zc_MI_Child()
                                  AND MI_2.isErased   = FALSE
                 JOIN MovementItemBoolean AS MIBoolean_MasterFuel
                                               ON MIBoolean_MasterFuel.MovementItemId = MI_2.Id
                                              AND MIBoolean_MasterFuel.DescId = zc_MIBoolean_MasterFuel()

           WHERE Movement.OperDate between '01.08.2026' and '31.08.2026'
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
             AND Movement.DescId = zc_Movement_Transport()
)

select a.Id, a.InvNumber, a.OperDate
from a join
a as a2 on a2.Id = a.Id and a2.isErased = true
where a.isErased = false
and a. MasterFuel = true
group by a.Id, a.InvNumber, a.OperDate
-- having count(*) > 1