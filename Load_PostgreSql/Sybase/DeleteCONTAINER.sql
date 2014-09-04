DO $$
BEGIN

update ContainerLinkObject set  descId = zc_ContainerLinkObject_PartionGoods()
where descId = 6
and ObjectId = 0
and ContainerId in (
select ContainerId 
from ContainerLinkObject
join Object on Object.Id = ObjectId 
group by ContainerId, ContainerLinkObject.descId having count (*) >1);


update ContainerLinkObject set  descId = zc_ContainerLinkObject_PartionGoods()
from Object where Object.Id = ObjectId and Object.DescId = 48
and ContainerLinkObject.descId = 6
and ContainerId in (
select ContainerId 
from ContainerLinkObject
join Object on Object.Id = ObjectId 
group by ContainerId, ContainerLinkObject.descId having count (*) >1);


update Container set KeyValue = tmp.KeyValue
from (
SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
 || case count(*) when 1 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 3 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 5 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 7 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 9 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 11 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 13 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 15 then ';0,0;0,0;0,0;0,0;0,0;0,0'
                  when 17 then ';0,0;0,0;0,0;0,0;0,0'
                  when 19 then ';0,0;0,0;0,0;0,0'
                  when 21 then ';0,0;0,0;0,0'
                  when 23 then ';0,0;0,0'
                  when 25 then ';0,0'
                          else ''
    end 
    as KeyValue


, tmp.ContainerId, count(*) as co
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                              , tmp.ContainerId
                         FROM     (SELECT DescId AS Value, 0 AS myOrder1, -1 AS myOrder2, Id as ContainerId FROM Container
                         UNION ALL SELECT COALESCE (ParentId, 0)                AS Value, 0 AS myOrder1, -2 AS myOrder2, Id as ContainerId FROM Container
                         UNION ALL SELECT COALESCE (ObjectId, 0)                AS Value, 0 AS myOrder1, -3 AS myOrder2, Id as ContainerId FROM Container
                         UNION ALL SELECT COALESCE (DescId, 0)                  AS Value, 0 AS myOrder1, DescId AS myOrder2, ContainerId FROM ContainerLinkObject
                         UNION ALL SELECT COALESCE (ObjectId, 0)                AS Value, 1 AS myOrder1, DescId AS myOrder2, ContainerId FROM ContainerLinkObject

                         UNION ALL SELECT zc_ContainerLinkObject_JuridicalBasis() AS Value, 0 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2, Container.Id FROM Container where DescId in (zc_Container_Count(), zc_Container_CountSupplier())
                         UNION ALL SELECT 0                                       AS Value, 1 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2, Container.Id FROM Container where DescId in (zc_Container_Count(), zc_Container_CountSupplier())
                         UNION ALL SELECT zc_ContainerLinkObject_Business()       AS Value, 0 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2, Container.Id FROM Container where DescId in (zc_Container_Count(), zc_Container_CountSupplier())
                         UNION ALL SELECT 0                                       AS Value, 1 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2, Container.Id FROM Container where DescId in (zc_Container_Count(), zc_Container_CountSupplier())

                                  ) AS tmp
                         ORDER BY ContainerId, tmp.myOrder2, tmp.myOrder1
                        ) as tmp
group by tmp.ContainerId
) as tmp
 where Container.Id = tmp.ContainerId 
   and Container.KeyValue <> tmp.KeyValue;

if exists (select KeyValue from Container join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Container.Id group by KeyValue having count (*) > 1) 
then RAISE EXCEPTION ' %  % %',  (select max (Id) from Container where KeyValue in (select KeyValue from Container group by KeyValue having count (*) > 1)) 
                              , (select min (Id) from Container where KeyValue in (select KeyValue from Container where id in (select max (Id) from Container where KeyValue in (select KeyValue from Container group by KeyValue having count (*) > 1)))) 
                              , (select KeyValue from Container where id in (select max (Id) from Container where KeyValue in (select KeyValue from Container group by KeyValue having count (*) > 1)));
end if;


delete from reportcontainerlink where ContainerId in
(select Id from Container  join (select KeyValue from Container group by KeyValue having count (*) > 1) as a  on a.KeyValue = Container.KeyValue left join (select ContainerId from MovementItemContainer group by ContainerId) as b on b.ContainerId  = Container.Id where  b.ContainerId is null)
;

delete from ChildReportContainerLink where ContainerId in
(select Id from Container  join (select KeyValue from Container group by KeyValue having count (*) > 1) as a  on a.KeyValue = Container.KeyValue left join (select ContainerId from MovementItemContainer group by ContainerId) as b on b.ContainerId  = Container.Id where  b.ContainerId is null)
;


delete from ContainerLinkObject where ContainerId in
(select Id from Container  join (select KeyValue from Container group by KeyValue having count (*) > 1) as a  on a.KeyValue = Container.KeyValue left join (select ContainerId from MovementItemContainer group by ContainerId) as b on b.ContainerId  = Container.Id where  b.ContainerId is null)
;

delete from Container where Id in
(select Id from Container  join (select KeyValue from Container group by KeyValue having count (*) > 1) as a  on a.KeyValue = Container.KeyValue left join (select ContainerId from MovementItemContainer group by ContainerId) as b on b.ContainerId  = Container.Id where  b.ContainerId is null)
;

if exists (select KeyValue from Container group by KeyValue having count (*) > 1) 
then RAISE EXCEPTION ' 2';
end if;

update Container set MasterKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 1 FOR 8)), ChildKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 9 FOR 8));

if exists (select MasterKeyValue, ChildKeyValue from Container group by MasterKeyValue, ChildKeyValue having count (*) > 1) 
then RAISE EXCEPTION ' 3';
end if;


/*
select ContainerId , ContainerLinkObject.descId, count (*), min (Object.DescId), max (Object.DescId)
from ContainerLinkObject
join Object on Object.Id = ObjectId 
group by ContainerId, ContainerLinkObject.descId having count (*) >1
-- order by 3
*/


END $$;

/*
-- select * from Container where id in ( 109693, 28702  )  or KeyValue = 
delete from containerobjectcost;

delete from HistoryCostContainerLink where MasterContainerId_Count in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;
delete from HistoryCostContainerLink where ChildContainerId_Count in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;
delete from HistoryCostContainerLink where MasterContainerId_Summ in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;
delete from HistoryCostContainerLink where ChildContainerId_Summ in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;

delete from HistoryCost where ContainerId in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;

delete from reportcontainerlink where ContainerId in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;

delete from ChildReportContainerLink where ContainerId in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;


delete from ContainerLinkObject where ContainerId in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;

delete from Container where 
parentid >0 and id in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
;
delete from Container where Id in
(select Id from Container left join (select ContainerId from MovementItemContainer group by ContainerId) as a on ContainerId = Id where ContainerId is null)
*/