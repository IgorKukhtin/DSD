select 1, id, amount  from Container where Id in ( 4152700, 14476633)
union
select 2, ContainerId, sum (Amount) from MovementItemContainer where ContainerId  in ( 4152702, 14476633) group by ContainerId
order by 2, 1


4152702  -- +2230.5456
14476637 -- -2230.5456

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152702 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 2230.5456 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476637 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -2230.5456 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 2230.5456 where Id = 4152702;
update Container set Amount = Amount - 2230.5456 where Id = 14476637;





4152695  -- +811.6752
14476628 -- -811.6752

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152695 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 811.6752 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476628 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -811.6752 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 811.6752 where Id = 4152695;
update Container set Amount = Amount - 811.6752 where Id = 14476628;



4152700 + -0.9120
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152700 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 0.9120 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -0.9120 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 0.9120 where Id = 4152700;
update Container set Amount = Amount - 0.9120 where Id = 14476633;


4152698 + -5.4384
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152698 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 5.4384 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -5.4384 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 5.4384 where Id = 4152698;
update Container set Amount = Amount - 5.4384 where Id = 14476633;



4152696 + -8.4336
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152696 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 8.4336 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -8.4336 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 8.4336 where Id = 4152696;
update Container set Amount = Amount - 8.4336 where Id = 14476633;



4152697 + -167.9040
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152697 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 167.9040 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -167.9040 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 167.9040 where Id = 4152697;
update Container set Amount = Amount - 167.9040 where Id = 14476633;


4152694  + 84.8256
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152694 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 84.8256 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -84.8256 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 84.8256 where Id = 4152694;
update Container set Amount = Amount - 84.8256 where Id = 14476633;


4152703  + -6.9456
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152703 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 6.9456 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -6.9456 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 6.9456 where Id = 4152703;
update Container set Amount = Amount - 6.9456 where Id = 14476633;


4152701 + -3.9360
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152701 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 3.9360 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -3.9360 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 3.9360 where Id = 4152701;
update Container set Amount = Amount - 3.9360 where Id = 14476633;



4152692 + -16.3104
14476633 -- 

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 4152692 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 16.3104 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14476633 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -16.3104 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 35732043261
;

update Container set Amount = Amount + 16.3104 where Id = 4152692;
update Container set Amount = Amount - 16.3104 where Id = 14476633;
