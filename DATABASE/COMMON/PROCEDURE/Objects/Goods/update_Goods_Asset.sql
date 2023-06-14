with tmp as (SELECT * FROM lfSelect_Object_Goods_byGoodsGroup (9354099 ) AS lfSelect )
  , tmp1 as (SELECT * FROM Object where DescId = zc_Object_Goods())
  , tmp3 as (select tmp1.*
                  , case when tmp.GoodsId > 0 THEN true else false end as isAsset_cacl
                  , coalesce (ObjectBoolean.ValueData, false)     as  isAsset
             from tmp1 
                  left join tmp on tmp.GoodsId = tmp1.Id
                  left join ObjectBoolean on ObjectBoolean.ObjectId = tmp1.Id
                                         and ObjectBoolean.DescId = zc_ObjectBoolean_Goods_Asset()
            )
select * 
--     , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Asset(), Id, isAsset_cacl)
from tmp3
where isAsset_cacl <> isAsset
