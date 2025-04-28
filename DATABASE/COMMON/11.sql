-- сравнили historycost

select * 
from _tmpContainerList_2024_07
     left join _tmpContainerList_2024_07_save on _tmpContainerList_2024_07_save.ContainerId_count  = _tmpContainerList_2024_07.ContainerId_count 
where _tmpContainerList_2024_07_save.ContainerId_count is null

select * 
from _tmpContainerList_2024_07_save
     left join _tmpContainerList_2024_07 on _tmpContainerList_2024_07_save.ContainerId_count  = _tmpContainerList_2024_07.ContainerId_count 
     left join MovementItemContainer on MovementItemContainer.ContainerId = _tmpContainerList_2024_07_save.ContainerId_count and MovementItemContainer.OperDate between '01.12.2024' and '31.12.2024'
where _tmpContainerList_2024_07.ContainerId_count is null
  and MovementItemContainer.ContainerId > 0

select * from MovementItemContainer where MovementItemContainer.ContainerId = 5279029 and MovementItemContainer.OperDate between '01.12.2024' and '31.12.2024'
select * from MovementItemContainer where MovementItemContainer.ContainerId = 9140694 and MovementItemContainer.OperDate between '27.12.2024' and '31.12.2024'

select * from Movement where Id = 30006337


-- select * from  historycost_2024_12 where StartDate = '01.12.2024' and ContainerId = 5282682
-- select * from  historycost where StartDate = '01.12.2024' and ContainerId = 5282682
-- select Object.ValueData, historycost_2024_12.Price as old , historycost.Price, * 
from  historycost
      join historycost_2024_12 on historycost_2024_12.ContainerId = historycost.ContainerId 
      left join ContainerLinkObject on ContainerLinkObject.ContainerId = historycost.ContainerId and ContainerLinkObject.Descid = zc_ContainerLinkObject_Unit() 
      left join Object on Object.Id = ContainerLinkObject.ObjectId 

where historycost.StartDate = '01.12.2024' and historycost_2024_12.Price <> historycost.Price
and (historycost_2024_12.Price > 1 or  historycost.Price > 1) and abs (historycost_2024_12.Price - historycost.Price) /
 case when historycost_2024_12.Price < historycost.Price and historycost_2024_12.Price > 0 then historycost_2024_12.Price 
      when historycost_2024_12.Price > historycost.Price and historycost.Price > 0 then historycost.Price
      else 1
 end  * 100 > 10

