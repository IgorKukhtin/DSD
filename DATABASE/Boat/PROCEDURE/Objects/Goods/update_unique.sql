-- update MovementItem set ObjectId = Objectid_to
 update ObjectString  set ValueData = ValueData||'---'


from (

with tmp as (
select ObjectString_Article.ValueData, ObjectString_Article.ObjectId
      , ROW_NUMBER() OVER (PARTITION BY ObjectString_Article.ValueData ORDER BY ObjectString_Article.ObjectId ASC) AS Ord

FROM ObjectString AS ObjectString_Article
                                      INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                       AND Object.DescId   = zc_Object_Goods()
                                                       AND Object.isErased = FALSE
left join ObjectLink on ObjectLink.ObjectId = ObjectString_Article.ObjectId
                    AND ObjectLink.DescId    = zc_ObjectLink_Goods_GoodsGroup()
left join Object as Object2 on Object2.Id = ObjectLink.ChildObjectId

where ObjectString_Article.ValueData <> ''
  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
  AND ObjectString_Article.ValueData  In (

select ObjectString_Article.ValueData
FROM ObjectString AS ObjectString_Article
                                      INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                       AND Object.DescId   = zc_Object_Goods()
                                                       AND Object.isErased = FALSE
left join ObjectLink on ObjectLink.ObjectId = ObjectString_Article.ObjectId
                    AND ObjectLink.DescId    = zc_ObjectLink_Goods_GoodsGroup()
left join Object as Object2 on Object2.Id = ObjectLink.ChildObjectId

where Object2.ValueData ilike 'NEW'
  AND ObjectString_Article.ValueData <> ''
  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
  AND ObjectString_Article.ValueData  In (
SELECT ObjectString_Article.ValueData
                                 FROM ObjectString AS ObjectString_Article
                                      INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                       AND Object.DescId   = zc_Object_Goods()
                                                       AND Object.isErased = FALSE
and Object.ValueData not ilike 'Nachnahmegebuhr'
and Object.ValueData not ilike 'Portokosten'

                                 WHERE ObjectString_Article.ValueData <> ''
                                   AND ObjectString_Article.DescId    = zc_ObjectString_Article()
group by ObjectString_Article.ValueData
having count(*) > 1
)

)


and Object.isErased = false

order by 1, case when Object2.ValueData ilike 'NEW' then 1 else 2 end
)

select tmp.Objectid as Objectid_from, tmp2.Objectid as Objectid_to
from tmp 
join tmp  as tmp2  on tmp2.ValueData = tmp.ValueData
                   and tmp2.ord = 2
where tmp .Ord = 1
) as a
-- where MovementId = 703 and IsErased = False and ObjectId = Objectid_from  and descId = 1
where ObjectId = Objectid_from  and DescId    = zc_ObjectString_Article()

-- "49.543.03"