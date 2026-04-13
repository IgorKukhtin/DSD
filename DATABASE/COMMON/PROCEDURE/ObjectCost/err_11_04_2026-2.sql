select 1, id, amount  from Container where Id in ( 13792328, 14385401)
union
select 2, ContainerId, sum (Amount) from MovementItemContainer where ContainerId  in ( 13792328, 14385401) group by ContainerId
order by 2, 1


select 1, id, amount  from Container where Id in ( 13792334, 14385405)
union
select 2, ContainerId, sum (Amount) from MovementItemContainer where ContainerId  in ( 13792334, 14385405) group by ContainerId
order by 2, 1


13792334;17051.5296
14385405

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792334 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -17051.5296 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385405 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 17051.5296 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 17051.5296 where Id = 13792334;
update Container set Amount = Amount + 17051.5296 where Id = 14385405;




13792332;14724.3600
14385398

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792332 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -14724.3600 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385398 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 14724.3600 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 14724.3600 where Id = 13792332;
update Container set Amount = Amount + 14724.3600 where Id = 14385398;


13792330;13532.9040
14385400

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792330 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -13532.9040 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385400 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 13532.9040 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 13532.9040 where Id = 13792330;
update Container set Amount = Amount + 13532.9040 where Id = 14385400;


13792331;2860.8048
14385394

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792331 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -2860.8048 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385394 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 2860.8048 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 2860.8048 where Id = 13792331;
update Container set Amount = Amount + 2860.8048 where Id = 14385394;


13792329;1927.0944
13466779

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792329 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -1927.0944 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13466779 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 1927.0944 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 1927.0944 where Id = 13792329;
update Container set Amount = Amount + 1927.0944 where Id = 13466779;


13792327;258.8544
14385401

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792327 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -258.8544 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385401 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 258.8544 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 258.8544 where Id = 13792327;
update Container set Amount = Amount + 258.8544 where Id = 14385401;



13792335;50.2992
14385401

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792335 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -50.2992 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385401 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 50.2992 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 50.2992 where Id = 13792335;
update Container set Amount = Amount + 50.2992 where Id = 14385401;



13792333;27.2160
14385401

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792333 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -27.2160 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385401 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 27.2160 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 27.2160 where Id = 13792333;
update Container set Amount = Amount + 27.2160 where Id = 14385401;


13792328;7.7616
14385401

INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 13792328 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , -7.7616 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
union
select DescId, MovementDescId, MovementId, MovementItemId, ParentId
     , 14385401 as ContainerId
     , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
     , 7.7616 AS Amount
     , OperDate, IsActive
from MovementItemContainer where Id = 39142985087 and MovementId = 33364811
;

update Container set Amount = Amount - 7.7616 where Id = 13792328;
update Container set Amount = Amount + 7.7616 where Id = 14385401;
