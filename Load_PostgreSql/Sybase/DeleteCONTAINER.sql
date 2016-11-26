DO $$
BEGIN

update ContainerLinkObject set  descId = zc_ContainerLinkObject_PartionGoods()
where descId = 6
and ObjectId = 0
and ContainerId in (
select ContainerId 
from ContainerLinkObject
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
   and Container.KeyValue <> tmp.KeyValue
-- join Container on Container.Id = tmp.ContainerId 
--               and Container.KeyValue <> tmp.KeyValue

;


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
DO $$
BEGIN

     CREATE TEMP TABLE _tmpContainer (ContainerId Integer) ON COMMIT DROP;
     INSERT INTO _tmpContainer (ContainerId)
      select Container.Id from Container left join MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id where MovementItemContainer.ContainerId is null order by id desc limit 100 ;

     -- INSERT INTO _tmpContainer (ContainerId)
     --  select Container.Id from Container join _tmpContainer ON _tmpContainer.ContainerId = Container.ParentId;

-- select * from Container where id in ( 109693, 28702  )  or KeyValue = 
-- delete from containerobjectcost;

delete from HistoryCostContainerLink where MasterContainerId_Count in (select ContainerId from _tmpContainer);
delete from HistoryCostContainerLink where ChildContainerId_Count in (select ContainerId from _tmpContainer);
delete from HistoryCostContainerLink where MasterContainerId_Summ in (select ContainerId from _tmpContainer);
delete from HistoryCostContainerLink where ChildContainerId_Summ in (select ContainerId from _tmpContainer);

delete from HistoryCost              where ContainerId in (select ContainerId from _tmpContainer);

delete from reportcontainerlink      where ContainerId in (select ContainerId from _tmpContainer);
delete from ChildReportContainerLink where ContainerId in (select ContainerId from _tmpContainer);

delete from ContainerLinkObject      where ContainerId in (select ContainerId from _tmpContainer);

delete from Container        where parentid > 0 and Id in (select ContainerId from _tmpContainer);
delete from Container                         where Id in (select ContainerId from _tmpContainer);

END $$;

*/



-- update Container set ParentId = tmp.ParentId from  (
-- update MovementItemContainer set ContainerId = tmp.ContainerId_to from  (
with tmpAll as  (select Container.*
                      , ROW_NUMBER() OVER (PARTITION BY Container.ObjectId ORDER BY Container.Id desc) as ORD
                      , CLO.ObjectId AS UnitId
                 from Container 
                      join ContainerLinkObject as CLO on CLO.ContainerId = Container.Id
                                              and CLO.DescId = zc_ContainerLinkObject_Member()
                                              and CLO.ObjectId = 239655
                 where Container.DescId = 1
--                and  Container.Id in (1082615 , 1178340)
                )
--  select * from tmpAll join Container as Container_summ_from on Container_summ_from.ParentId = tmpAll.Id where ORD > 1

, tmp_count as (select tmpAll_to.Id As ContainerId_to, tmpAll_From.Id AS ContainerId_from
                     , MAX (coalesce (Container_summ_to.Id, Container_summ_from.Id)) AS ContainerId_summ_to
                from tmpAll as tmpAll_to
                     left join Container as Container_summ_to on Container_summ_to.ParentId = tmpAll_to.Id
                     left join tmpAll as tmpAll_From on tmpAll_From.ord > 1 AND tmpAll_From.ObjectId = tmpAll_to.ObjectId
                                                                            AND tmpAll_From.UnitId   = tmpAll_to.UnitId
                     left join Container as Container_summ_from on Container_summ_from.ParentId = tmpAll_From.Id
                     --  join MovementItemContainer on MovementItemContainer.ContainerId = tmpAll_From.Id
                where tmpAll_to.ord = 1
                GROUP BY tmpAll_to.Id , tmpAll_From.Id 
               )
-- select * from tmp_count

, tmp_summ as (select tmp_count.ContainerId_to, tmp_count.ContainerId_from
               , tmp_count.ContainerId_summ_to
               , Container_summ_From.Id AS ContainerId_summ_from
               , Container_find.ParentId AS ParentId_from
          from tmp_count
              left join Container as Container_summ_From on Container_summ_From.ParentId = tmp_count.ContainerId_to
              inner join Container as Container_find on Container_find.Id = tmp_count.ContainerId_summ_to
         )
-- select * from tmp_summ


, tmp_all as (select ContainerId_from, ContainerId_to,  1 as Descid, null as ParentId, null as ParentId_from from tmp_count
           union 
             select ContainerId_summ_from, ContainerId_summ_to,  2 as Descid, ContainerId_to as ParentId, ParentId_from from tmp_summ -- where ContainerId_summ_from <>  ContainerId_summ_to
             )

-- select * from tmp_all   where ParentId <>  ParentId_from and DescId = 2
   select * from tmp_all   where ContainerId_from <> ContainerId_to

-- ) as tmp  where tmp.Descid = 2 and tmp.ContainerId_to = Container.Id
--  ) as tmp  where tmp.ContainerId_from = MovementItemContainer.ContainerId


-- update Container set Amount = OperAmount from  (
                    SELECT 
                        containerCount.Amount ,
                        COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , containerCount.Id , containerCount.DescId 
                      -- , containerCount.ObjectID 
                    FROM (select Container.*
                          from Container 
                          join ContainerLinkObject as CLO on CLO.ContainerId = Container.Id
                                                  and CLO.DescId = zc_ContainerLinkObject_Member()
                                                  and CLO.ObjectId = 12573
                         )AS containerCount
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = containerCount.Id
                    GROUP BY containerCount.Id, containerCount.DescId , containerCount.ObjectID, containerCount.Amount
                    having containerCount.Amount <> COALESCE(SUM(MIContainer.Amount), 0) 
-- ) as tmp where tmp.Id = Container.Id


select count(*), goodsId, ObjectId
from 
(select distinct Container.ObjectId as goodsId, CLO.ObjectId, Container.Id
from Container 
join ContainerLinkObject as CLO on CLO.ContainerId = Container.Id
                        and CLO.DescId = zc_ContainerLinkObject_Member()
                        and CLO.ObjectId > 0
where Container.DescId = 1
) as tmp
group by goodsId, ObjectId
having count(*) >1