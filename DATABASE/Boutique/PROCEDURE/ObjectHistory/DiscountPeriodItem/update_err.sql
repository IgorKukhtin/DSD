-- update  ObjectHistory set EndDate = coalesce (tmp.nextStartDate, zc_DateEnd()) from (
with tmp as (
select ObjectHistory_Price.*
     , Row_Number() OVER (PARTITION BY ObjectHistory_Price.ObjectId ORDER BY ObjectHistory_Price.StartDate Asc, ObjectHistory_Price.Id) AS Ord
from ObjectHistory AS ObjectHistory_Price
-- Where ObjectHistory_Price.DescId = zc_ObjectHistory_PriceListItem()
-- Where ObjectHistory_Price.DescId = zc_ObjectHistory_DiscountPeriodItem()
-- Where ObjectId = 265141
)

select  tmp.Id, tmp.ObjectId, tmp.StartDate as oldStartDate, tmp.EndDate as oldEndDate,  tmp2.StartDate as nextStartDate, tmp2.Ord, ObjectHistoryDesc.Code
from tmp
     left join tmp as tmp2 on tmp2.ObjectId = tmp.ObjectId and tmp2.Ord = tmp.Ord + 1 and tmp2.DescId = tmp.DescId
     left join ObjectHistoryDesc on ObjectHistoryDesc. Id = tmp.DescId
where tmp.EndDate <> coalesce (tmp2.StartDate, zc_DateEnd())
  and tmp2.StartDate is not null
 order by 3

--  ) as tmp where tmp.Id = ObjectHistory.Id

-- select * from ObjectHistory   where ObjectId = 215254 order by StartDate
-- select ObjectHistoryDesc.Code, ObjectId, StartDate, count (*) from ObjectHistory  join ObjectHistoryDesc on ObjectHistoryDesc. Id = DescId group by ObjectHistoryDesc.Code, ObjectId, StartDate having count (*) > 1
-- select lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId)
-- select lpGetInsert_Object_DiscountPeriodItem (1155, 72831, 2)
-- select * from Object where id in (1155, 72831)


-- delete from ObjectHistoryFloat where ObjectHistoryId in (select Id from ObjectHistory  where DescId = zc_ObjectHistory_DiscountPeriodItem()) -- and EndDate <> zc_DateEnd()
-- delete from ObjectHistory where DescId = zc_ObjectHistory_DiscountPeriodItem() -- and EndDate <> zc_DateEnd()
