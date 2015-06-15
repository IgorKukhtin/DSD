with tmp as (select Movement.DescId, MovementFloat_MedocCode.ValueData, Movement.Id, Movement.StatusId, MovementLinkObject.ObjectId  as BranchId, Object.ValueData as BranchName, MovementString.ValueData as InvNumberPartner
       FROM  Movement 
            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            left JOIN MovementFloat AS MovementFloat_MedocCode
                               ON MovementFloat_MedocCode.MovementId =  Movement.Id
                              AND MovementFloat_MedocCode.DescId = zc_MovementFloat_MedocCode()
            LEFT JOIN MovementLinkObject on MovementLinkObject.MovementId = Movement.Id and MovementLinkObject.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN Object on Object.Id = MovementLinkObject.ObjectId
            LEFT JOIN MovementString on MovementString.MovementId = Movement.Id and MovementString.DescId = zc_MovementString_InvNumberPartner()
     
          WHERE (Movement.StatusId <> zc_Enum_Status_Erased()) AND Movement.DescId in (zc_Movement_Tax(), zc_Movement_TaxCorrective()) -- zc_Movement_Tax(), 
                 AND Movement.OperDate between '01.03.2015' and '31.03.2015'
and (Object.ValueData = 'филиал Харьков'
or Object.ValueData = 'филиал Николаев (Херсон)'
or Object.ValueData = 'филиал Киев'
or Object.ValueData = 'филиал Кр.Рог'
or Object.ValueData = 'филиал Черкассы (Кировоград)')

-- and MovementFloat_MedocCode.MovementId > 0 
)

, tmp2 as (select ValueData, max(tmp.Id) as Id
FROM  tmp
group by ValueData
having count(*) > 1)

-- select * from tmp2

, tmp23 as (select DescId, InvNumberPartner, BranchId, max(tmp.Id) as Id
FROM  tmp
group by DescId, InvNumberPartner, BranchId
having count(*) > 1)


-- select lpSetErased_Movement (Id, 5) from tmp  


-- select * from tmp  where ValueData is null

 /*select tmp.BranchName from tmp2 join tmp on tmp.InvNumberPartner = tmp2.InvNumberPartner
                   and tmp.BranchId = tmp2.BranchId 
                   and tmp.DescId = tmp2.DescId group by tmp.BranchName*/
-- select tmp.DescId from tmp2 join tmp on tmp.ValueData = tmp2.ValueData group by tmp.DescId

select *
from tmp2 join tmp on tmp.ValueData = tmp2.ValueData
                   and tmp.DescId = tmp2.DescId 
-- and tmp.Id not in (select tmp22.Id from tmp2 as tmp22)
order by tmp.BranchId

select *
from tmp2 join tmp on tmp.InvNumberPartner = tmp2.InvNumberPartner
                   and tmp.BranchId = tmp2.BranchId
                   and tmp.DescId = tmp2.DescId 
-- and tmp.Id not in (select tmp22.Id from tmp2 as tmp22)
order by tmp.BranchId
