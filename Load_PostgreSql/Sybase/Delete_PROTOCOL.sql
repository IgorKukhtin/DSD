with tmp_MI as (select MovementItemId from MovementItemProtocol where UserId = 5 and Id between 2000001 and 5000000 group by MovementItemId)
   , tmp1 as (select MovementItemProtocol.* from MovementItemProtocol join tmp_MI on tmp_MI.MovementItemId = MovementItemProtocol.MovementItemId)
   , tmp2 as (select min (Id) as Id, MovementItemId from tmp1 group by MovementItemId)
   , tmp3 as (select max (Id) as Id, MovementItemId from tmp1 group by MovementItemId)
   , tmp4 as (select max (tmp1.Id) as Id, tmp1.MovementItemId from tmp1 inner join tmp3 on tmp3.MovementItemId = tmp1.MovementItemId and tmp3.Id > tmp1.Id group by tmp1.MovementItemId)
   , tmp_find as (select Id from tmp2 union select Id from tmp3 union select Id from tmp4)
   , tmp_all as (select tmp1.Id from tmp1 left join tmp_find on tmp_find.Id = tmp1.Id where tmp_find.Id is null)

--  delete from MovementItemProtocol where id in (select Id from tmp_all)

-- select 1, count(*) from tmp1 
-- union all
-- select 2, count(*) from tmp_all 
-- select count(*) from tmp1
--select count(*), MovementItemId from tmp1 group by MovementItemId order by 1 desc



