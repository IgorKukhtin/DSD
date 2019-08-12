-- Function: lpSelect_Object_wms_SKU()
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS lpSelect_Object_wms_SKU ();

CREATE OR REPLACE FUNCTION lpSelect_Object_wms_SKU(
)
RETURNS TABLE (ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindCode Integer, GoodsTypeKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , sku_id       Integer  -- ***Уникальный код товара в товарном справочнике предприятия
             , sku_code     Integer  -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
             , name         TVarChar -- Наименование товара в товарном справочнике предприятия
             , product_life Integer  -- Срок годности товара в сутках.
              )
AS
$BODY$
   DECLARE vbName_Sh  TVarChar;
   DECLARE vbName_Nom TVarChar;
   DECLARE vbName_Ves TVarChar;
BEGIN
     -- Штучный
     vbName_Sh := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Sh());
     -- Номинальный
     vbName_Nom:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Nom());
     -- Весовой
     vbName_Ves:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Ves());


     -- Результат
     RETURN QUERY
        WITH tmpGoods_all AS (SELECT zfCalc_Text_replace (tmp.GoodsName, CHR(39), '`') AS GoodsName_repl
                                   , *
                              FROM gpSelect_Object_GoodsByGoodsKind_VMC (inRetail1Id:= 0
                                                                       , inRetail2Id:= 0
                                                                       , inRetail3Id:= 0
                                                                       , inRetail4Id:= 0
                                                                       , inRetail5Id:= 0
                                                                       , inRetail6Id:= 0
                                                                       , inSession  := zfCalc_UserAdmin()
                                                                        ) AS tmp
                              WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 
                             )
               , tmpGoods AS (-- Штучный
                              SELECT tmpGoods_all.Id * 10 + 1                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Sh                                                           AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Sh  AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Sh()                                                            AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Sh  = TRUE
                             UNION ALL
                              -- Номинальный
                              SELECT tmpGoods_all.Id * 10 + 2                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Nom                                                          AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Nom AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Nom()                                                           AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Nom = TRUE
                             UNION ALL
                              -- Весовой
                              SELECT tmpGoods_all.Id * 10 + 3                                                              AS sku_id
                                   , tmpGoods_all.WmsCodeCalc_Ves                                                          AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Ves AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , zc_Enum_GoodsTypeKind_Ves()                                                           AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.isGoodsTypeKind_Ves = TRUE
                             )
        -- Результат
        SELECT tmpGoods.Id AS ObjectId
             , tmpGoods.GoodsId, tmpGoods.Code AS GoodsCode, tmpGoods.GoodsName
             , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
             , Object_GoodsTypeKind.Id AS GoodsTypeKindId, Object_GoodsTypeKind.ObjectCode AS GoodsTypeKindCode, Object_GoodsTypeKind.ValueData AS GoodsTypeKindName
             , tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.GoodsGroupNameFull
             , tmpGoods.MeasureId, tmpGoods.MeasureName

             , tmpGoods.sku_id       :: Integer  -- ***Уникальный код товара в товарном справочнике предприятия
             , tmpGoods.sku_code     :: Integer  -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
             , tmpGoods.name         :: TVarChar -- Наименование товара в товарном справочнике предприятия
             , tmpGoods.product_life :: Integer  -- Срок годности товара в сутках.

        FROM tmpGoods
             LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpGoods.GoodsTypeKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- тест
-- SELECT * FROM lpSelect_Object_wms_SKU() ORDER BY sku_code
