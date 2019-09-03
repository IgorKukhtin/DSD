-- Function: lpSelect_Object_wms_SKU()
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS lpSelect_wms_Object_SKU ();

CREATE OR REPLACE FUNCTION lpSelect_wms_Object_SKU(
)
RETURNS TABLE (ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindCode Integer, GoodsTypeKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- Вес 1-ой ед.
             , WeightMin TFloat
             , WeightMax TFloat
             , WeightAvg TFloat
               -- размеры 1-ой ед.
             , Height    TFloat
             , Length    TFloat
             , Width     TFloat
               -- Ящик (E2/E3)
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , WeightOnBox    TFloat -- Кол-во кг. в ящ. (E2/E3)
             , CountOnBox     TFloat -- Кол-во ед. в ящ. (E2/E3)
             , BoxVolume      TFloat -- Объем ящ., м3. (E2/E3)
             , BoxWeight      TFloat -- Вес самогно ящ. (E2/E3)
             , BoxHeight      TFloat -- Высота ящ. (E2/E3)
             , BoxLength      TFloat -- Длина ящ. (E2/E3)
             , BoxWidth       TFloat -- Ширина ящ. (E2/E3)
             , WeightGross    TFloat -- Вес брутто полного ящика "по ???" (E2/E3)
             , WeightAvgGross TFloat -- Вес брутто полного ящика "по среднему весу" (E2/E3)
             , WeightAvgNet   TFloat -- Вес нетто полного ящика "по среднему весу" (E2/E3)

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
        WITH tmpGoods_all AS (SELECT Object_Goods.ObjectCode          AS GoodsCode
                                   , Object_Goods.ValueData           AS GoodsName
                                   , zfCalc_Text_replace (zfCalc_Text_replace (Object_Goods.ValueData, CHR(39), '`'), '"', '`') AS GoodsName_repl
                                   , Object_GoodsKind.ObjectCode      AS GoodsKindCode
                                   , Object_GoodsKind.ValueData       AS GoodsKindName
                                   , Object_Measure.ValueData         AS MeasureName
                                   , Object_Box.ObjectCode            AS BoxCode
                                   , Object_Box.ValueData             AS BoxName
                                   , ObjectFloat_Volume.ValueData     AS BoxVolume
                                   , ObjectFloat_Height.ValueData     AS BoxHeight
                                   , ObjectFloat_Length.ValueData     AS BoxLength
                                   , ObjectFloat_Width.ValueData      AS BoxWidth
                                   , ObjectLink_Goods_GoodsGroup.ChildObjectId   AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                                   , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                                   , tmp.*
                              FROM wms_Object_GoodsByGoodsKind AS tmp
                                   LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmp.GoodsId
                                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
                                   LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = tmp.MeasureId
                                   LEFT JOIN Object AS Object_Box       ON Object_Box.Id       = tmp.BoxId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                                         ON ObjectFloat_Volume.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Volume.DescId   = zc_ObjectFloat_Box_Volume()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                                         ON ObjectFloat_Height.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Height.DescId   = zc_ObjectFloat_Box_Height()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                                         ON ObjectFloat_Length.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Length.DescId   = zc_ObjectFloat_Box_Length()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                                         ON ObjectFloat_Width.ObjectId = tmp.BoxId
                                                        AND ObjectFloat_Width.DescId   = zc_ObjectFloat_Box_Width()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                       AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                   LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                                         AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                              WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 AND tmp.isErased = FALSE
                             )
               , tmpGoods AS (-- Штучный
                              SELECT tmpGoods_all.sku_id_Sh                                                                AS sku_id
                                   , tmpGoods_all.sku_code_Sh                                                              AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Sh  AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Sh                                                       AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Sh  = zc_Enum_GoodsTypeKind_Sh()
                             UNION ALL
                              -- Номинальный
                              SELECT tmpGoods_all.sku_id_Nom                                                               AS sku_id
                                   , tmpGoods_all.sku_code_Nom                                                             AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Nom AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Nom                                                      AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Nom = zc_Enum_GoodsTypeKind_Nom()
                             UNION ALL
                              -- Весовой
                              SELECT tmpGoods_all.sku_id_Ves                                                               AS sku_id
                                   , tmpGoods_all.sku_code_Ves                                                             AS sku_code
                                   , tmpGoods_all.GoodsName_repl || ' ' || tmpGoods_all.GoodsKindName || ' ' || vbName_Ves AS name
                                   , tmpGoods_all.NormInDays                                                               AS product_life
                                   , tmpGoods_all.GoodsTypeKindId_Ves                                                      AS GoodsTypeKindId
                                   , *
                              FROM tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Ves = zc_Enum_GoodsTypeKind_Ves()
                             )
        -- Результат
        SELECT tmpGoods.ObjectId
             , tmpGoods.GoodsId, tmpGoods.GoodsCode, tmpGoods.GoodsName
             , tmpGoods.GoodsKindId, tmpGoods.GoodsKindCode, tmpGoods.GoodsKindName
             , Object_GoodsTypeKind.Id AS GoodsTypeKindId, Object_GoodsTypeKind.ObjectCode AS GoodsTypeKindCode, Object_GoodsTypeKind.ValueData AS GoodsTypeKindName
             , tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.GoodsGroupNameFull
             , tmpGoods.MeasureId, tmpGoods.MeasureName

               -- Вес 1-ой ед.
             , tmpGoods.WeightMin
             , tmpGoods.WeightMax
             , ((tmpGoods.WeightMin + tmpGoods.WeightMax) / 2) :: TFloat AS WeightAvg
               -- размеры 1-ой ед.
             , tmpGoods.Height
             , tmpGoods.Length
             , tmpGoods.Width

               -- Ящик (E2/E3)
             , tmpGoods.GoodsPropertyBoxId
             , tmpGoods.BoxId, tmpGoods.BoxCode, tmpGoods.BoxName

               -- *заменили - Кол-во кг. в ящ. (E2/E3) - тоже что и WeightAvgNet
             , CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMin > 0 AND tmpGoods.WeightMax > 0
                         THEN tmpGoods.CountOnBox * (tmpGoods.WeightMin + tmpGoods.WeightMax) / 2
                    ELSE tmpGoods.WeightOnBox
               END :: TFloat AS WeightOnBox

             , tmpGoods.CountOnBox               -- Кол-во ед. в ящ. (E2/E3)
             , tmpGoods.BoxVolume                -- Объем ящ., м3. (E2/E3)
             , tmpGoods.BoxWeight                -- Вес самого ящ. (E2/E3)
             , tmpGoods.BoxHeight                -- Высота ящ. (E2/E3)
             , tmpGoods.BoxLength                -- Длина ящ. (E2/E3)
             , tmpGoods.BoxWidth                 -- Ширина ящ. (E2/E3)

               -- *заменили - Вес брутто полного ящика "??? по среднему весу" (E2/E3)
             , (CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMin > 0 AND tmpGoods.WeightMax > 0
                          THEN tmpGoods.CountOnBox * (tmpGoods.WeightMin + tmpGoods.WeightMax) / 2
                     ELSE tmpGoods.WeightOnBox
                END
              + tmpGoods.BoxWeight
               ) :: TFloat AS WeightGross

               -- *заменили - Вес брутто полного ящика "по среднему весу" (E2/E3)
             , (CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMin > 0 AND tmpGoods.WeightMax > 0
                          THEN tmpGoods.CountOnBox * (tmpGoods.WeightMin + tmpGoods.WeightMax) / 2
                     ELSE tmpGoods.WeightOnBox
                END
              + tmpGoods.BoxWeight
               ) :: TFloat AS WeightAvgGross

               -- *заменили - Вес нетто полного ящика "по среднему весу" (E2/E3) - тоже что и WeightOnBox
             , (CASE WHEN tmpGoods.CountOnBox > 0 AND tmpGoods.WeightMin > 0 AND tmpGoods.WeightMax > 0
                          THEN tmpGoods.CountOnBox * (tmpGoods.WeightMin + tmpGoods.WeightMax) / 2
                     ELSE tmpGoods.WeightOnBox
                END
               ) :: TFloat AS WeightAvgNet

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
-- SELECT * FROM lpSelect_wms_Object_SKU() where sku_id = 795222 ORDER BY sku_code

