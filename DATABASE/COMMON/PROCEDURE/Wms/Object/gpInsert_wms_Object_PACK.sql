-- Function: gpInsert_wms_Object_PACK(TVarChar)
-- 3.4	Справочник упаковок <pack>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_PACK (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_PACK(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Object_PACK());

     --
     vbProcName:= 'gpInsert_wms_Object_PACK';
     --
     vbTagName:= 'pack';
     --
     vbActionName:= 'set';


     -- Проверка
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- удалили прошлые данные
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpGoods AS (SELECT tmp.sku_id            :: Integer -- ***Уникальный код товара в товарном справочнике предприятия
                               , tmp.sku_code                     -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
                               , tmp.name                         -- Наименование товара в товарном справочнике предприятия
                                 -- Вес 1-ой ед.
                               , COALESCE (tmp.WeightMin, 0) AS WeightMin
                               , COALESCE (tmp.WeightMax, 0) AS WeightMax
                               , COALESCE (tmp.WeightAvg, 0) AS WeightAvg
                                 -- размеры 1-ой ед.
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Height, 0) END AS Height
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Length, 0) END AS Length
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Width, 0)  END AS Width
                                 -- Ящик (E2/E3)
                               , COALESCE (tmp.GoodsPropertyBoxId, 0) AS GoodsPropertyBoxId
                               , COALESCE (tmp.BoxId, 0) AS BoxId, COALESCE (tmp.BoxCode, 0) AS BoxCode, COALESCE (tmp.BoxName, '') AS BoxName
                               , COALESCE (tmp.WeightOnBox, 0)    AS WeightOnBox              -- Кол-во кг. в ящ. (E2/E3)
                               , COALESCE (tmp.CountOnBox, 0)     AS CountOnBox               -- Кол-во ед. в ящ. (E2/E3)
                               , COALESCE (tmp.BoxVolume, 0)      AS BoxVolume                -- Объем ящ., м3. (E2/E3)
                               , COALESCE (tmp.BoxWeight, 0)      AS BoxWeight                -- Вес самогно ящ. (E2/E3)
                               , COALESCE (tmp.BoxHeight, 0)      AS BoxHeight                -- Высота ящ. (E2/E3)
                               , COALESCE (tmp.BoxLength, 0)      AS BoxLength                -- Длина ящ. (E2/E3)
                               , COALESCE (tmp.BoxWidth, 0)       AS BoxWidth                 -- Ширина ящ. (E2/E3)
                               , COALESCE (tmp.WeightGross, 0)    AS WeightGross              -- Вес брутто полного ящика "по ???" (E2/E3)
                               , COALESCE (tmp.WeightAvgGross, 0) AS WeightAvgGross           -- Вес брутто полного ящика "по среднему весу" (E2/E3)
                               , COALESCE (tmp.WeightAvgNet, 0)   AS WeightAvgNet             -- Вес нетто полного ящика "по среднему весу" (E2/E3)
                          FROM lpSelect_wms_Object_SKU() AS tmp
                         )
              --
            , tmpData AS (-- unit – единичная упаковка
                          SELECT tmpGoods.sku_id                 AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                               -- Уникальное описание упаковки
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- Признак основной упаковки: t – является основной упаковкой; f – не является основной упаковкой Значение по умолчанию t
                               , 't'                 :: TVarChar AS is_main
                               -- Тип упаковки: единичная упаковка
                               , 'unit'              :: TVarChar AS ctn_type
                               -- Элемент упаковки (идентификатор упаковки из которой состоит данная). Для единичных упаковок равен 0. 
                               , '0'                 :: TVarChar AS code_id
                               -- Количество элементов упаковки, т.е. количество вложенных элементов
                               , 1                   :: Integer  AS units
                               -- Количество единичных упаковок в данной
                               , 1                   :: Integer  AS base_units
                               -- Остается пустым, т.к. нет прима палетными нормами
                               , 0                   :: Integer  AS layer_qty
                               -- Ширина упаковки (см)
                               , tmpGoods.Width      :: TFloat   AS width
                               -- Длина упаковки (см)
                               , tmpGoods.Length     :: TFloat   AS length
                               -- Высота упаковки (см)
                               , tmpGoods.Height     :: TFloat   AS height
                               -- Вес упаковки (кг)
                               , 0                   :: TFloat   AS weight
                               -- Вес брутто упаковки (кг) – условное значение, данные при приеме будут передаваться в ASN-сообщении
                               , tmpGoods.WeightAvg  :: TFloat   AS weight_brutto
                               --
                               , 1 AS GroupId
                          FROM tmpGoods
                        --WHERE tmpGoods.sku_id IN (34570361)

                         UNION ALL
                          -- carton – коробочная упаковка
                          SELECT tmpGoods.GoodsPropertyBoxId     AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                                 -- Уникальное описание упаковки
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- Признак основной упаковки: t – является основной упаковкой; f – не является основной упаковкой Значение по умолчанию t
                               , 't'                 :: TVarChar AS is_main
                               -- Тип упаковки: коробочная упаковка
                               , 'carton'            :: TVarChar AS ctn_type
                               -- Элемент упаковки (идентификатор упаковки из которой состоит данная). Для единичных упаковок равен 0. 
                               , tmpGoods.sku_id     :: TVarChar AS code_id
                               -- Количество элементов упаковки, т.е. количество вложенных элементов
                               , CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END) :: Integer AS units
                               -- Количество единичных упаковок в данной
                               , CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END) :: Integer AS base_units
                               -- Остается пустым, т.к. нет прима палетными нормами
                               , 0                   :: Integer  AS layer_qty
                               -- Ширина упаковки (см)
                               , tmpGoods.BoxWidth   :: TFloat   AS width
                               -- Длина упаковки (см)
                               , tmpGoods.BoxLength  :: TFloat   AS length
                               -- Высота упаковки (см)
                               , tmpGoods.BoxHeight  :: TFloat   AS height
                               -- Вес упаковки (кг)
                               , tmpGoods.BoxWeight  :: TFloat   AS weight
                               -- Вес брутто упаковки (кг) – условное значение, данные при приеме будут передаваться в ASN-сообщении
                               , tmpGoods.WeightAvg  :: TFloat   AS weight_brutto
                               --
                               , 2 AS GroupId
                          FROM tmpGoods
                          WHERE tmpGoods.BoxId > 0
                          --AND tmpGoods.sku_id = 795223
                         ) 
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                -- , (ROW_NUMBER() OVER (PARTITION BY tmpData.GroupId ORDER BY tmpData.GroupId, tmpData.sku_id) :: Integer) AS RowNum
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.GroupId, tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                         ||' pack_id="' || tmpData.pack_id               :: TVarChar ||'"' -- Уникальный код упаковки
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- Уникальный код товара в справочнике предприятия 
                     ||' description="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.description, CHR(39), '`'), '"', '`') ||'"' -- Уникальное описание упаковки
                         ||' barcode="' || tmpData.barcode                           ||'"' -- 
                         ||' is_main="' || tmpData.is_main                           ||'"' -- Признак основной упаковки: t – является основной упаковкой; f – не является основной упаковкой Значение по умолчанию t
                        ||' ctn_type="' || tmpData.ctn_type                          ||'"' -- Тип упаковки: unit – единичная упаковка carton – коробочная упаковка
                         ||' code_id="' || tmpData.code_id                           ||'"' -- Элемент упаковки (идентификатор упаковки из которой состоит данная). Для единичных упаковок равен 0. 
                           ||' units="' || tmpData.units                 :: TVarChar ||'"' -- Количество элементов упаковки, т.е. количество вложенных элементов
                      ||' base_units="' || tmpData.base_units            :: TVarChar ||'"' -- Количество единичных упаковок в данной
                       ||' layer_qty="' || tmpData.layer_qty             :: TVarChar ||'"' -- Остается пустым, т.к. нет прима палетными нормами
                           ||' width="' || tmpData.width                 :: TVarChar ||'"' -- Ширина упаковки (см)
                          ||' length="' || tmpData.length                :: TVarChar ||'"' -- Длина упаковки (см)
                          ||' height="' || tmpData.height                :: TVarChar ||'"' -- Высота упаковки (см)
                          ||' weight="' || zfConvert_FloatToString (tmpData.weight)        ||'"' -- Вес упаковки (кг)
                   ||' weight_brutto="' || zfConvert_FloatToString (tmpData.weight_brutto) ||'"' -- Вес брутто упаковки (кг) – условное значение, данные при приеме будут передаваться в ASN-сообщении
                                        ||'></' || vbTagName || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.pack_id AS ObjectId
                   , tmpData.GroupId
              FROM tmpData
              ORDER BY tmpData.GroupId, tmpData.sku_id
             ) AS tmp
      --WHERE tmp.RowNum BETWEEN 1 AND 1
        ORDER BY 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_wms_Object_PACK ('1', zfCalc_UserAdmin())
