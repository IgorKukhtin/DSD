with tmp1 as 
(SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId 
     , Movement.Id, InvNumber, OperDate

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
WHERE Movement.OperDate between '01.08.2022' and '01.09.2022'
  and Movement.DescID = zc_Movement_Sale()
) 

, t1 as (

SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
     , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
     , Movement.Id As MovementId, Movement.OperDate, Movement.InvNumber
, MovementItem.Id
--, MovementItem.ObjectId as goodsId
-- , MILinkObject_GoodsKind.ObjectId as GoodsKindId
, MovementItem.Amount
, coalesce (MIFloat_BoxCount.ValueData, 0) AS BoxCount
, MovementItem.isErased
, coalesce (MILinkObject_Box.ObjectId , 0) as OldId , ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId as NewId

-- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), MovementItem.Id, ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId)

                          FROM tmp1 AS Movement

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                inner JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()


                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = Movement.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId > 0


                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
AND MovementItem.ObjectId           = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
AND MILinkObject_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId


                                left  JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

                                 LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                             ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

 -- where coalesce (MILinkObject_Box.ObjectId , 0) <> ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
-- and MovementItem.isErased = false
where MovementItem.isErased = false
order by  MovementItem.Id
)

, t11 as (SELECT t1.GoodsId
               , t1.GoodsKindId
               , t1.MovementId, t1.OperDate, t1.InvNumber
               , SUM (t1.Amount) AS Amount
               , SUM (t1.BoxCount) AS BoxCount
               , t1.OldId , t1.NewId
          FROM t1
          where t1.isErased = false
          group by  t1.GoodsId
               , t1.GoodsKindId
               , t1.MovementId, t1.OperDate, t1.InvNumber
               , t1.OldId , t1.NewId
          
         )

, t2 as (select * from Movement where ParentId in (select distinct MovementId  from  t1))

, t33 as ( select MovementId, MovementItem.ObjectId as goodsId, MovementItem.Id as MovementItemId
FROM t2
join MovementItem
 on MovementItem.MovementId = t2.Id
and MovementItem.isErased = false
and MovementItem.Descid = zc_MI_Master()
-- where MovementItem.MovementId in (select distinct t2.Id  from  t2)
-- and MovementItem.isErased = false
-- and MovementItem.Descid = zc_MI_Master()
)
, MIFloat_BoxCount as (select * from MovementItemFloat where MovementItemId IN (select distinct MovementItemId from t33) )
, MILinkObject_GoodsKind as (select * from MovementItemLinkObject where MovementItemId IN (select distinct MovementItemId from t33) )

, t3 as (
select MovementId, coalesce(MIFloat_BoxCount.ValueData, 0) as BoxCount  
, MovementItem.goodsId, MovementItem.MovementItemId
, MILinkObject_GoodsKind.ObjectId as  GoodsKindId
FROM t33 as MovementItem
       left join MIFloat_BoxCount
              ON MIFloat_BoxCount.MovementItemId = MovementItem.MovementItemId
             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                           LEFT JOIN MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
-- where MovementItem.MovementId in (select distinct t2.Id  from  t2)
-- and MovementItem.isErased = false
-- and MovementItem.Descid = zc_MI_Master()
)

, t4 as (select t2.ParentId, goodsId, GoodsKindId, sum(BoxCount) as BoxCount FROM t3 join t2 on t2.Id = t3.MovementId where BoxCount <> 0 group by t2.ParentId, goodsId, GoodsKindId)

, t5 as (select t1 .*, t4.BoxCount as BoxCount_new, t1.BoxCount as BoxCount_old
         FROM t11 as t1 
               join t4 on t4.ParentId = t1.MovementId 
                      and t4.goodsId  = t1.goodsId 
                      and t4.GoodsKindId = t1.GoodsKindId 
-- where OldId <> NewId
)

select * 
-- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), t5.Id, NewId)
  -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), t5.Id, BoxCount_new)
from t5
left join Object on Object.Id = NewId
 where (BoxCount_new <> coalesce (BoxCount_old, 0)
or NewId <> OldId)
-- and MovementId = 23166802 
 -- and MovementId = 23091922
order by OperDate