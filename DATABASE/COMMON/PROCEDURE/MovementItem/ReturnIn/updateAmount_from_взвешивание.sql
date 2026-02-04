-- 2735514023457

  update MovementItem set Amount = case when ord = 1  then a.okk else 0 end
  from (
with from_data  as (
select MovementItem.Id , MovementItem.ObjectId as GoodsId, MILinkObject_GoodsKind.ObjectId as GoodsKindId , MIFloat_RealWeight.ValueData as okk , MovementItem.Amount, MIFloat_AmountPartner.ValueData
-- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id , MIFloat_RealWeight.ValueData)
from MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                              LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                          ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                         AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
where MovementItem.MovementId = 33394041 
and MovementItem.descId = 1
and MovementItem.isErased = false
order by 1
 -- ) as a 
 -- where a.Id = MovementItem.Id-- 
)


, to_data  as (
select MovementItem.Id , MovementItem.ObjectId as GoodsId, MILinkObject_GoodsKind.ObjectId as GoodsKindId , MovementItem.Amount, MIFloat_AmountPartner.ValueData
           -- ¹ ï/ï
         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId ORDER BY 1 DESC) AS Ord
-- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id , MIFloat_RealWeight.ValueData)
from MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
where MovementItem.MovementId = 33396484 
and MovementItem.descId = 1
and MovementItem.isErased = false
order by 1
)

select to_data.Id, okk, ord
-- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), to_data.Id, case when ord = 1  then okk else 0 end)
from to_data 
   left join (select  from_data.GoodsId , from_data.GoodsKindId , sum (okk) as  okk
from from_data group by from_data.GoodsId , from_data.GoodsKindId 
) as  from_data on from_data.GoodsId = to_data .GoodsId and from_data.GoodsKindId  = to_data .GoodsKindId 
-- where from_data.GoodsId is null
-- where Amount <> okk
 ) as a 
  where a.Id = MovementItem.Id


-- select gpComplete_All_Sybase (33396484  ,  false    , '')
