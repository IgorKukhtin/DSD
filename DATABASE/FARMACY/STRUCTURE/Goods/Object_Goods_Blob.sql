-- DROP TABLE IF EXISTS Object_Goods_Blob;
/*
CREATE TABLE Object_Goods_Blob (
  id                  Serial,    -- ID главного товара

  Description         TBlob,     -- Описание товара на сайте                   (zc_objectBlob_Goods_Description)
  NameSite            TBlob,     -- Название товара на сайте                   (zc_objectBlob_Goods_Site)
  
  UnitSupplementSUN1Out TBlob,   -- Подразделения для отправки по дополнению СУН1


  CONSTRAINT Object_Goods_Blob_pkey PRIMARY KEY(ID)
);

SELECT * FROM Object_Goods_Blob
LIMIT 100

ALTER TABLE Object_Goods_Blob ADD UnitSupplementSUN1Out TBlob

*/

--INSERT INTO Object_Goods_Blob
SELECT ObjectLink_Main.ChildObjectId                            AS GoodsMainId

     , ObjectBlob_Goods_Description.ValueData                   AS Description
     , ObjectBlob_Goods_Site.ValueData                          AS NameSite

FROM Object AS Object_Goods

     -- получается GoodsMainId
     LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
     LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

     LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                          ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
     LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
     LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId


     LEFT JOIN ObjectBlob AS ObjectBlob_Goods_Description
                          ON ObjectBlob_Goods_Description.ObjectId = Object_Goods.Id
                         AND ObjectBlob_Goods_Description.DescId = zc_objectBlob_Goods_Description()
                         AND ObjectBlob_Goods_Description.ValueData Is Not Null

     LEFT JOIN ObjectBlob AS ObjectBlob_Goods_Site
                          ON ObjectBlob_Goods_Site.ObjectId = Object_Goods.Id
                         AND ObjectBlob_Goods_Site.DescId = zc_objectBlob_Goods_Site()
                         AND ObjectBlob_Goods_Site.ValueData Is Not Null

WHERE Object_Goods.DescId = zc_Object_Goods()
  AND Object_GoodsObject.DescId = zc_Object_Retail()
  AND Object_GoodsObject.ID = 4
  AND (COALESCE (ObjectBlob_Goods_Description.ObjectId, 0) <> 0
    OR COALESCE (ObjectBlob_Goods_Site.ObjectId, 0) <> 0 )