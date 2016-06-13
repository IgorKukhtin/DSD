-- update ObjectHistory set StartDate =  DATE_TRUNC ('DAY', StartDate) where StartDate = DATE_TRUNC ('DAY', StartDate) + interval '1 hour'
-- update ObjectHistory set EndDate =  DATE_TRUNC ('DAY', EndDate) where EndDate = DATE_TRUNC ('DAY', EndDate) + interval '1 hour'
-- update MovementItemContainer set OperDate =  DATE_TRUNC ('DAY', OperDate) where OperDate = DATE_TRUNC ('DAY', OperDate) + interval '1 hour'
-- update Movement  set OperDate =  DATE_TRUNC ('DAY', OperDate) where OperDate = DATE_TRUNC ('DAY', OperDate) + interval '1 hour'
-- update Movement  set OperDate =  DATE_TRUNC ('DAY', OperDate) where DescId = zc_Movement_PriceList() AND OperDate <> DATE_TRUNC ('DAY', OperDate)
-- update MovementDate  set ValueData =  DATE_TRUNC ('DAY', ValueData) where ValueData = DATE_TRUNC ('DAY', ValueData) + interval '1 hour'
-- update MovementItemDate  set ValueData =  DATE_TRUNC ('DAY', ValueData) where ValueData = DATE_TRUNC ('DAY', ValueData) + interval '1 hour'
-- update ObjectDate  set ValueData =  DATE_TRUNC ('DAY', ValueData) where ValueData = DATE_TRUNC ('DAY', ValueData) + interval '1 hour'


-- 1.1. Movement
select MovementDesc.Code, count (*), min (Movement.OperDate), max (Movement.OperDate)
from Movement 
     join MovementDesc on MovementDEsc.Id = Movement.DescId
-- where Movement.OperDate =  DATE_TRUNC ('DAY', Movement.OperDate) + interval '1 hour'
where Movement.OperDate <>  DATE_TRUNC ('DAY', Movement.OperDate)
group by MovementDesc.Code
order by 4 desc
-- limit 100

-- 1.2. MovementDate
select MovementDesc.Code, count (*), min (MovementDate.ValueData), max (MovementDate.ValueData)
from Movement 
     join MovementDesc on MovementDEsc.Id = Movement.DescId
     join MovementDate on MovementDate.MovementId = Movement.Id
-- where MovementDate.ValueData =  DATE_TRUNC ('DAY', MovementDate.ValueData) + interval '1 hour'
 where MovementDate.ValueData <>  DATE_TRUNC ('DAY', MovementDate.ValueData)
group by MovementDesc.Code
order by 4 desc
-- limit 100

-- 1.3. MovementItemDate
select MovementDesc.Code, count (*), min (MovementItemDate.ValueData), max (MovementItemDate.ValueData)
from Movement 
     join MovementDesc on MovementDEsc.Id = Movement.DescId
     join MovementItem on MovementItem.MovementId = Movement.Id
     join MovementItemDate on MovementItemDate.MovementItemId = MovementItem.Id
-- where MovementItemDate.ValueData =  DATE_TRUNC ('DAY', MovementItemDate.ValueData) + interval '1 hour'
 where MovementItemDate.ValueData <>  DATE_TRUNC ('DAY', MovementItemDate.ValueData)
group by MovementDesc.Code
order by 4 desc
-- limit 100

-- 1.4. ObjectDate
select ObjectDesc.Code, count (*), min (ObjectDate.ValueData), max (ObjectDate.ValueData)
from Object
     join ObjectDesc on ObjectDEsc.Id = Object.DescId
     join ObjectDate on ObjectDate.ObjectId = Object.Id
-- where ObjectDate.ValueData =  DATE_TRUNC ('DAY', ObjectDate.ValueData) + interval '1 hour'
 where ObjectDate.ValueData <>  DATE_TRUNC ('DAY', ObjectDate.ValueData)
group by ObjectDesc.Code
order by 4 desc
-- limit 100

-- 2.1. MovementItemContainer
select MovementDesc.Code, count (*), min (MovementItemContainer.OperDate), max (MovementItemContainer.OperDate)
from Movement 
     join MovementDesc on MovementDEsc.Id = Movement.DescId
     join MovementItemContainer on MovementItemContainer.MovementId = Movement.Id
-- where MovementItemContainer.OperDate =  DATE_TRUNC ('DAY', MovementItemContainer.OperDate) + interval '1 hour'
 where MovementItemContainer.OperDate <>  DATE_TRUNC ('DAY', MovementItemContainer.OperDate)
group by MovementDesc.Code
order by 4 desc


-- 3.1. ObjectHistory
select ObjectHistoryDesc.Code, count (*), min (ObjectHistory.StartDate), max (ObjectHistory.StartDate)
from ObjectHistory
     join ObjectHistoryDesc on ObjectHistoryDEsc.Id = ObjectHistory.DescId
-- where ObjectHistory.StartDate = DATE_TRUNC ('DAY', ObjectHistory.StartDate)  + interval '1 hour' --  and ObjectHistory.EndDate = DATE_TRUNC ('DAY', ObjectHistory.EndDate)  + interval '1 hour'
-- where ObjectHistory.StartDate <> DATE_TRUNC ('DAY', ObjectHistory.StartDate)
group by ObjectHistoryDesc.Code

