  update HistoryCost set Price = coalesce (Price_old, 0) FROM (
-- update HistoryCost set Price = 10 FROM (
 with tmp_1 AS (SELECT Container.*
                FROM Container
                     INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                    ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                                   AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                   AND ContainerLinkObject_Unit.ObjectId IN (zc_Unit_RK(), 8451, 8458, 8450) -- ЦЕХ пакування + Склад База ГП + Дільниця термічної обробки
                                                 --AND ContainerLinkObject_Unit.ObjectId IN (select ObjectId from ObjectLink where DescId = zc_ObjectLink_Unit_Parent() AND ChildObjectId = 8460) -- Возвраты общие
                WHERE Container.DescId = zc_Container_Count()
                  AND Container.ObjectId in (3569176  -- 953
                                           --, 4026174  -- 202
                                           --, 3902     -- 2269
                                           , 4507487  -- 1716
                                           , 10442610 -- 2489
                                            )
               )
/* 235 - первый
   953 - потом
   202 - солянка
   2269 - солянка
   
    1716, 2489
   
   
   19 - гп Львов
   1717 - гп возвраты Львов*/
 
    , tmp_2 AS (SELECT Container.*
                FROM Container
                WHERE Container.DescId = zc_Container_Summ()
                  AND Container.ParentId in (SELECT tmp_1.Id FROM tmp_1)
               )
, tmp_h_old AS (SELECT HistoryCost.*
                FROM tmp_2
                     JOIN HistoryCost ON HistoryCost.ContainerId = tmp_2.Id
                                     AND HistoryCost.StartDate = '01.04.2024'
               )
, tmp_h_next AS (SELECT HistoryCost.*
                 FROM tmp_2
                      JOIN HistoryCost ON HistoryCost.ContainerId = tmp_2.Id
                                      AND HistoryCost.StartDate = '01.05.2024'
                )
                
                
 SELECT tmp_h_next.ContainerId, tmp_h_next.Price AS Price_next, tmp_h_old.Price AS Price_old, tmp_h_next.Id AS Id_next, tmp_h_old.Id AS Id_old, Object_3.ValueData, Object.ObjectCode, Object.ValueData, Object_2.ValueData
-- SELECT distinct  Object.*, Object_2.*, tmp_h_next.Price 
FROM tmp_h_next
     LEFT JOIN tmp_h_old ON tmp_h_old.ContainerId = tmp_h_next.ContainerId
left join ContainerLinkObject AS CLO on CLO.ContainerId = tmp_h_next.ContainerId
                             and CLO.descId = zc_ContainerLinkObject_Goods()
left join Object on Object.Id = CLO.ObjectId

left join ContainerLinkObject AS CLO_2 on CLO_2.ContainerId = tmp_h_next.ContainerId
                             and CLO_2.descId = zc_ContainerLinkObject_Unit()
left join Object as Object_2 on Object_2.Id = CLO_2.ObjectId

left join ContainerLinkObject AS CLO_3 on CLO_3.ContainerId = tmp_h_next.ContainerId
                             and CLO_3.descId = zc_ContainerLinkObject_InfoMoneyDetail()
left join Object as Object_3 on Object_3.Id = CLO_3.ObjectId

WHERE ABS (tmp_h_next.Price) / 2 > COALESCE (ABS (tmp_h_old.Price), 0)
  AND ABS (tmp_h_next.Price) > 1
-- !!!
--  AND tmp_h_old.Price <> 0
  
-- !!!
-- AND ABS (tmp_h_next.Price) > 20 AND COALESCE (tmp_h_old.Price, 0) = 0

 ) as a
 where HistoryCost.Id = a.Id_next


  /*

select * 
from Container 
left join ContainerLinkObject on ContainerId = Container.Id
left join ContainerLinkObjectDesc on ContainerLinkObjectDesc.Id  = ContainerLinkObject.DescId
left join Object on Object.Id = ContainerLinkObject.ObjectId
left join Object as Object_Account on Object_Account.Id = Container.ObjectId
left join ObjectDesc on ObjectDesc.Id = Object.DescId
-- left join ContainerDesc on ContainerDesc.Id = Container.DescId
where Container.Id = 5874555  -- 3324080 -- 4013708

select MovementItemContainer.Amount / MovementItem.Amount,  MovementItemContainer.* from MovementItemContainer join MovementItem on MovementItem.Id = MovementItemId where OperDate between '01.05.2024' and '31.05.2024' and MovementItem.Amount > 0 and ContainerId = 918391 -- 5874555
select *  from Container where Id = 5874555

select *  from MovementItemContainer where ParentId in (select Id  from MovementItemContainer where MovementItemId = 289985241 and descId = 2 order by Amount)
and MovementId = 28204315




-- SELECT * FROM HistoryCost WHERE ContainerId IN (2716232)  AND HistoryCost.StartDate IN ('01.04.2024', '01.05.2024')
-- SELECT * FROM HistoryCost WHERE ContainerId IN (5874555, 6065881, 5880092)  AND HistoryCost.StartDate IN ('01.04.2024', '01.05.2024')
-- SELECT calcSumm/calccount, * FROM _tmpMaster_2024_06_12 WHERE ContainerId IN (5874555)





 SELECT * 
 FROM HistoryCost 
      JOIN ContainerLinkObject AS CLO_2 on CLO_2.ContainerId = HistoryCost.ContainerId
                                       and CLO_2.DescId      = zc_ContainerLinkObject_Unit()
                                       and CLO_2.ObjectId    IN (zc_Unit_RK(), 8451, 8458, 8450)
      JOIN ContainerLinkObject AS CLO_1 on CLO_1.ContainerId = HistoryCost.ContainerId
                                       and CLO_1.DescId      = zc_ContainerLinkObject_PartionGoods()
                                       and CLO_1.ObjectId    > 0
 WHERE HistoryCost.StartDate IN ('01.04.2024', '01.05.2024')


 with clo AS (SELECT CLO_2.ContainerId 
              FROM ContainerLinkObject AS CLO_2 
                   JOIN Container on Container.Id = CLO_2.ContainerId 
                                 AND Container.DescId = 2
                   JOIN ContainerLinkObject AS CLO_1 on CLO_1.ContainerId = CLO_2.ContainerId 
                                                    and CLO_1.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                    and CLO_1.ObjectId    NOT IN (0) -- 80132 
              WHERE CLO_2.DescId      = zc_ContainerLinkObject_Unit()
                and CLO_2.ObjectId    IN (zc_Unit_RK(), 8451, 8458, 8450) -- select * from Object where Id in (zc_Unit_RK(), 8451, 8458, 8450)
             )

 --SELECT * 
  SELECT distinct Object.*
 FROM MovementItemContainer 
                   left JOIN ContainerLinkObject AS CLO_1 on CLO_1.ContainerId = MovementItemContainer.ContainerId 
                                                    and CLO_1.DescId      = zc_ContainerLinkObject_Goods()
                   left JOIN Object on Object.Id = CLO_1.ObjectId
 WHERE OperDate between '01.05.2024' and '31.05.2024'
   AND MovementItemContainer.ContainerId in (SELECT clo.ContainerId FROM clo)
 --AND MovementDescId <> 10


  */
  

-- select * from gpSelect_Movement_Inventory(instartdate := ('01.05.2024')::TDateTime , inenddate := ('31.05.2024')::TDateTime , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e') where FromName ilike '%база%' order by OperDate
/*
-- baza  
select gpComplete_All_Sybase(28123528 , false, '')
select gpComplete_All_Sybase(28185170 , false, '')
select gpComplete_All_Sybase(28245619 , false, '')
select gpComplete_All_Sybase(28304935 , false, '')
select gpComplete_All_Sybase(28357232, false, '')

-- RK
select gpComplete_All_Sybase(28123737, false, '')
select gpComplete_All_Sybase(28357775, false, '')

-- PACK
select gpComplete_All_Sybase(28364846, false, '')
*/
