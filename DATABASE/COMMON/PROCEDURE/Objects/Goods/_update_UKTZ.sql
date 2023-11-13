-- select zc_ObjectDate_Goods_UKTZED_new(), zc_ObjectString_Goods_UKTZED(), zc_ObjectString_Goods_UKTZED_new
   --   , zc_ObjectDate_GoodsGoodsGroup_UKTZED_new(), zc_ObjectString_GoodsGoodsGroup_UKTZED(), zc_ObjectString_GoodsGoodsGroup_UKTZED_new


with _newnew as (
select '1601009100'as old,'1601009190'as new
union all select '1601009900','1601009990'
union all select '1602201000','1601001000'

union all select '1602392900','1602392900'

union all select '1602419000','1602419000'
union all select '1602491100','1602491100'

union all select '1602491300','1602491300'
union all select '1602491500','1602491500'
union all select '1602491900','1602491900'
union all select '1602499000','1602491900'
union all select '1602509500','1602509500'

union all select '1602499000','1602499000'
union all select '1602491900','1602491900'
union all select '1602509500','1602509500'

union all select '1602392900','1602322900'
union all select '1602209000','1602329000'
union all select '1602209000','1602509500'
union all select '1602903100','1602903100'
union all select '1602209000','1602321900')

, _new as (select distinct old, new from _newnew)

, _test as (select old, new from _new where old in (select old from _new group by old having count(*) > 1 ))
--  select * from _test order by 1 


select ObjectString.ObjectId
      , ObjectString.DescId
     , case when ObjectString.DescId = zc_ObjectString_Goods_UKTZED() then zc_ObjectString_Goods_UKTZED_new()
             when ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED() then zc_ObjectString_GoodsGroup_UKTZED_new()
       end as DescId_new

     , case when ObjectString.DescId = zc_ObjectString_Goods_UKTZED() then zc_ObjectDate_Goods_UKTZED_new()
             when ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED() then zc_ObjectDate_GoodsGroup_UKTZED_new()
       end as DescId_new_date
     , old, new

-- select zc_ObjectDate_Goods_UKTZED_new(), zc_ObjectString_Goods_UKTZED(), zc_ObjectString_Goods_UKTZED_new
   --   , zc_ObjectDate_GoodsGoodsGroup_UKTZED_new(), zc_ObjectString_GoodsGoodsGroup_UKTZED(), zc_ObjectString_GoodsGoodsGroup_UKTZED_new

from ObjectString
join _new on  _new.old = ValueData 
where ObjectString.DescId in (zc_ObjectString_Goods_UKTZED(), zc_ObjectString_GoodsGroup_UKTZED())
and ValueData <> ''
and old in (select old from _test)

-- and new <> old 

order by 1, new
