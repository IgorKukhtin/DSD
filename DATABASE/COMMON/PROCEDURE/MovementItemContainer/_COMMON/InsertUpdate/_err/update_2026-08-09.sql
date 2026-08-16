-- 3707343
-- 3637872

select * from MovementItemContainer where ContainerId in (3707343, 3637872)
and OperDate between '01.06.2026' and '30.06.2026'  
-- and MovementDescId  = zc_Movement_Sale() 
and Amount < 0
and MovementId = 34433978


-- from
insert into MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , 4.6185 as Amount, OperDate, IsActive
                                      
from MovementItemContainer 
where Id = 39971558675 and  ContainerId in (3707343)

-- update Container set Amount =  Amount + 4.6185 where Id in (3707343)

-- select * from Container  where Id in (3707343)


-- to
insert into MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , -4.6185 AS Amount, OperDate, IsActive
from MovementItemContainer 
where Id = 39971558664 and  ContainerId in (3637872)

-- update Container set Amount =  Amount - 4.6185 where Id in (3637872)

/*
select sum (Amount)
from MovementItemContainer 
where ContainerId in (3637872)
union all
select Amount from Container  where Id in (3637872)

select sum (Amount)
from MovementItemContainer 
where ContainerId in (3707343)
union all
select Amount from Container  where Id in (3707343)
*/