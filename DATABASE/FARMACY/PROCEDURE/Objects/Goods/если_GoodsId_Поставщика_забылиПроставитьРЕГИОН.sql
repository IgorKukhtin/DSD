-- update ObjectLink set ChildObjectId  = null where descId = zc_ObjectLink_Goods_Area() and ChildObjectId > 0 


with tmpGoods AS (SELECT Object_Goods.*
                       , Object_Object.Id AS JuridicalId
                       , Object_Object.ObjectCode AS JuridicalCode
                       , Object_Object.ValueData AS JuridicalName

                       , ObjectLink_Main.ChildObjectId AS GoodsMainId
                       , ObjectString_Goods_Code.ValueData AS GoodsCode_jur

                       , Object_Area.Id AS AreaId
                       , Object_Area.ObjectCode AS AreaCode
                       , Object_Area.ValueData AS AreaName

                  FROM Object  AS Object_Goods

                       -- связь с Юридические лица или Торговая сеть или ...
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                            ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Goods_Object.ChildObjectId
                                                         AND Object_Object.DescId = zc_Object_Juridical()

                       -- связь с Юридические лица или Торговая сеть или ...
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                            ON ObjectLink_Goods_Area.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
                       LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

                       -- получается GoodsMainId
                       LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                       LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                       LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                              ON ObjectString_Goods_Code.ObjectId = Object_Goods.Id
                                             AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()

                  WHERE Object_Goods.DescId = zc_Object_Goods()
                 )
, tmpArea AS (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                   , ObjectLink_JuridicalArea_Area.ChildObjectId      AS AreaId
              FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                   INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                            AND Object_JuridicalArea.isErased = FALSE
                   INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                         ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                        AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                   -- Уникальный код поставщика ТОЛЬКО для Региона
                   INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                            ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
              WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
             )

select tmpGoods.*
     , tmpGoods.AreaId
     , LoadPriceList.AreaId AS AreaId_new
   -- , lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Area(), tmpGoods.Id, LoadPriceList.AreaId)
     , LoadPriceListItem.CommonCode, LoadPriceListItem.BarCode, LoadPriceListItem.GoodsCode
     , tmpGoods.GoodsCode_jur
     , ObjectGoods.*
from LoadPriceList
     inner join tmpArea on tmpArea.JuridicalId = LoadPriceList.JuridicalId
                       AND tmpArea.AreaId      = LoadPriceList.AreaId
     inner join LoadPriceListItem on LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
     left join Object AS ObjectGoods on ObjectGoods.Id = LoadPriceListItem.GoodsId

     left join tmpGoods on tmpGoods.JuridicalId = LoadPriceList.JuridicalId
                       AND tmpGoods.GoodsMainId = LoadPriceListItem.GoodsId
where LoadPriceList.AreaId > 0
  AND COALESCE (tmpGoods.AreaId, 0) <> LoadPriceList.AreaId
--  AND tmpGoods.Id is null
--  AND tmpGoods.Id > 0
  AND tmpGoods.Id = 1023282
  and LoadPriceList.AreaId <> 5803492 -- "Днепр"
  