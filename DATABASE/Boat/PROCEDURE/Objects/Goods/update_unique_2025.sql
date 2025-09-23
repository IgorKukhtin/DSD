--  update MovementItem set ObjectId = Id_new from (
--  update Object set isErased = true from (
--  update ObjectBoolean set ValueData = true from (
--   update ObjectString set ValueData = ObjectString.ValueData || '_deleted_' from (
with tmp_1 AS
  (select ObjectString_Article.ValueData  as Article
       FROM Object as Object_Goods
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
    where Object_Goods.DescId = zc_Object_Goods()
and ObjectString_Article.ValueData <> 'Nachnahme'
and ObjectString_Article.ValueData <> 'Porto'
and ObjectString_Article.ValueData <> ''

 group by ObjectString_Article.ValueData 
having count(*) > 1
)

, tmp_1_1 AS
  (select ObjectString_Article.ValueData  as Article
        , Object_Goods.ValueData
       FROM Object as Object_Goods
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
    where Object_Goods.DescId = zc_Object_Goods()
and ObjectString_Article.ValueData <> 'Nachnahme'
and ObjectString_Article.ValueData <> 'Porto'
and ObjectString_Article.ValueData <> ''
 group by ObjectString_Article.ValueData 
        , Object_Goods.ValueData
 having count(*) > 1
)

, tmp_2 AS
  (select ObjectString_Article.ValueData as Article
        , ROW_NUMBER() OVER (PARTITION BY ObjectString_Article.ValueData ORDER BY Object_Goods.Id ASC) AS Ord
        , Object_Goods.*
       FROM Object as Object_Goods
            JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
             JOIN tmp_1 ON tmp_1.Article = ObjectString_Article.ValueData 
    where Object_Goods.DescId = zc_Object_Goods()
)

, res as (
select distinct tmp_2.*, MovementDesc.Code
from tmp_2
left join MovementItem on MovementItem.ObjectId = tmp_2.Id
left join Movement on Movement.Id = MovementItem.MovementId and (Movement.StatusId = zc_Enum_Status_Complete() or (Movement.StatusId = zc_Enum_Status_UnComplete() and Movement.DescId in ( zc_Movement_PriceList())))
left join MovementDesc on MovementDesc.Id = Movement.DescId 
where ord = 2
  and (Movement.DescId in ( zc_Movement_PriceList(), zc_Movement_OrderClient())  or Movement.DescId is null) -- 22039
)

, res_2 as (
select distinct tmp_2.*, MovementDesc.Code -- , Movement.OperDate, Movement.InvNumber
from tmp_2
join MovementItem on MovementItem.ObjectId = tmp_2.Id
join Movement on Movement.Id = MovementItem.MovementId and Movement.StatusId = zc_Enum_Status_Complete()
join MovementDesc on MovementDesc.Id = Movement.DescId 
where ord = 2
   and Movement.DescId <> zc_Movement_PriceList()
   and Movement.DescId <> zc_Movement_OrderClient()
)

, tmp_diff_Article as (
select *
from tmp_1
where tmp_1.Article not in (select tmp_1_1.Article from tmp_1_1)
)


 , a as (  select res.* , tmp_2.Id AS Id_new, tmp_2.ValueData AS ValueData_new
FROM res
     left join res_2 on res_2.Id = res.Id
     left join tmp_2 on tmp_2.Article = res.Article
                     and tmp_2.ord = 1
where res_2.Id is null
 -- and tmp_2.ValueData <>  res.ValueData
)

-- 22037
-- select * from res where Article not in (select Article from a)
 select * from tmp_2 --  where Article in ('529035991', 'BA-9485V') -- 158
 --select * from res  where Article in ('SE-545-010-11')


--  ) as tmp where tmp.Id = MovementItem.ObjectId
--  ) as tmp where tmp.Id = Object.Id
-- ) as tmp where tmp.Id = ObjectBoolean.ObjectId and ObjectBoolean.DescId = zc_ObjectBoolean_Goods_Arc()
-- ) as tmp where tmp.Id = ObjectString.ObjectId and ObjectString.DescId = zc_ObjectString_Article()

--  select count(*) FROM Object as Object_Goods where Object_Goods.DescId = zc_Object_Goods()
--  select count(*) FROM ObjectBoolean where DescId = zc_ObjectBoolean_Goods_Arc() and ValueData = true
