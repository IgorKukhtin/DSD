-- Function: gpSelect_Object_Products_effie_xml

DROP FUNCTION IF EXISTS gpSelect_Object_Products_effie_xml ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Products_effie_xml(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData Text)
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE _tmpResult (NPP Integer, RowData Text) ON COMMIT DROP;
  
        -- первые строчки XML
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-30, '<?xml version="1.0" encoding="windows-1251"?>');
         INSERT INTO _tmpResult (NPP, RowData) VALUES (-20, '<ROOT>');
         
           -- товары
           INSERT INTO _tmpResult(NPP, RowData) VALUES (-10, '<LocalProducts>');
           --
           INSERT INTO _tmpResult (NPP, RowData
                                   
                                   )       
                                   
           WITH
           tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                          ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS ObjectId
                                        , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                        , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                   FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                   WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  )                   

                   SELECT ROW_NUMBER() OVER (ORDER BY Object_Goods.ObjectCode) AS NPP
                        , '<LocalProduct'
                               -- Внешний код товара
                               ||  ' LOCALCODE="' || (Object_Goods.ObjectCODE)::TVarChar || '"'

                               -- Название товара (отображается в таблице заказа на мобильном клиенте)
                               || ' NAME="' || TRIM (Object_Goods.ValueData)  ||'"' 
                               -- Полное название товара (отображается при долгом нажатии на товаре в таблице заказа на мобильном клиенте)
                               || ' FULLNAME="' || TRIM (Object_Goods.ValueData)  ||'"'
                               -- Внешний код бренда товара
                               || ' BRANDEXTID="' || COALESCE(Object_TradeMark.Id ::TVarchar ,'')||'"'
                               -- Название бренда товара
                               || ' BRANDNAME="' || TRIM (COALESCE(Object_TradeMark.ValueData,''))  ||'"'
                               -- Внешний код бренда товара
                              || ' SUBBRANDEXTID="' || COALESCE(Object_GoodsGroupDirection.Id::TVarchar ,'')  ||'"'
                               -- Название бренда товара
                               || ' SUBBRANDNAME="' || TRIM (COALESCE(Object_GoodsGroupDirection.ValueData,''))  ||'"'
                               -- Количество в упаковке
                               || ' PACK_QTY="' || '0' ||'"'
                               -- Внешний код производителя товара
                               || ' MANUFACTUREREXTID="' || COALESCE(Object_GoodsPlatform.Id::TVarchar ,'')  ||'"'
                               -- Название производителя товара
                               || ' MANUFACTURERNAME="' || TRIM (COALESCE(Object_GoodsPlatform.ValueData,''))  ||'"'
                               -- Внешний код категории товара
                               || ' CATEGORYEXTID="' || COALESCE(Object_GoodsGroupPropertyParent.Id::TVarchar ,'') ||'"'
                               -- Название категории товара
                               || ' CATEGORYNAME="' || TRIM (COALESCE(Object_GoodsGroupPropertyParent.ValueData,''))  ||'"'
                               -- Внешний код сабкатегории товара
                               || ' SUBCATEGORYEXTID="' || COALESCE(Object_GoodsGroupProperty.Id::TVarchar ,'') ||'"'
                               -- Название сабкатегории товара
                               || ' SUBCATEGORYNAME="' || TRIM (COALESCE(Object_GoodsGroupProperty.ValueData,''))  ||'"'
                               -- Внешний код линейки товара
                               || ' SUBCATEGORYLINEEXTID="' || COALESCE(Object_GoodsKind.Id::TVarchar ,'') ||'"'
                               -- Название линейки товара
                               || ' SUBCATEGORYLINENAME="' || TRIM (COALESCE(Object_GoodsKind.ValueData,''))  ||'"'
                               -- Статус (2 - активный, 9 - расформирован, удален, деактивирован)
                               || ' STATUS="' || CASE WHEN Object_Goods.isErased = FALSE THEN '2' ELSE 'удален' END  ||'"'
                               -- Внешний код группы товаров
                               || ' GroupExtId="' || COALESCE(Object_GoodsGroup.Id::TVarchar ,'') ||'"'
                               -- Признак вагового товару
                               || ' UNITFACTOR="' || (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN '0' ELSE '1' END) ||'"'
                               -- Глобальний код товару
                               || ' GLOBALCODE="' || COALESCE(tmpGoodsByGoodsKind.ObjectId::TVarchar ,'') ||'"'
                               -- Необходимость лицензии у товара: 0 = Нет / 1 = Да
                               || ' NeedLicense="' || '0' ||'"'
                               -- Кол-во в упаковке
                               || ' QntPerPack="' || '0' ||'"'
                               -- Возможность продавать упаковками: 0 = Нет / 1 = Да
                               || ' EnableSellByPack="' || '0' ||'"'
                               -- Вес товара, брутто (кг)
                               || ' GrossWeight="' || COALESCE (ObjectFloat_Weight.ValueData,0) + COALESCE (ObjectFloat_WeightTare.ValueData,0) ||'"'
                               -- Подарочный товар 0 = Нет / 1 = да
                               || ' IsPromoGift="' || '0' ||'"'

                               || '/>'

                    
                   FROM Object AS Object_Goods
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                             ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                        LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                             ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
                        LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = ObjectLink_Goods_GoodsGroupDirection.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                             ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                        LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                             ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                        LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                             ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                            AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                        LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

                        LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoodsByGoodsKind.GoodsKindId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                             AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                        LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                              ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                                             AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()

                   WHERE Object_Goods.DescId = zc_Object_Goods()
                  -- LIMIT 10 
                  ;

  
           -- последние строчки XML
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</LocalProducts>');
           INSERT INTO _tmpResult (NPP, RowData) VALUES ((SELECT COUNT(*) FROM _tmpResult) + 1, '</ROOT>');
  
     -- Результат
     RETURN QUERY
        SELECT _tmpResult.RowData FROM _tmpResult ORDER BY NPP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Products_effie_xml (zfCalc_UserAdmin()::TVarChar);
