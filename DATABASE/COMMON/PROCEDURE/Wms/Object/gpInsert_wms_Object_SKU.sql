-- Function: gpInsert_wms_Object_SKU(TVarChar)
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_SKU (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_SKU(
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
-- DECLARE vbRowNum     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_wms_Object_SKU());

     --
     vbProcName:= 'gpInsert_wms_Object_SKU';
     --
     vbTagName := 'sku';
     --
     vbActionName:= 'set';


     -- !!!Залили ВСЕ данные - в Object_GoodsByGoodsKind - линейная табл.!!!
     PERFORM gpInsertUpdate_wms_Object_GoodsByGoodsKind (inSession);


     -- Проверка
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- удалили прошлые данные
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO wms_Message (GUID, ProcName, TagName, RowNum, RowData) VALUES (inGUID, vbProcName, vbTagName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
       --                 ||' syncid="' || tmpData.sku_id       :: TVarChar ||'"' -- ???
                          ||' action="' || vbActionName                     ||'"' -- ???
       --               ||' syncdate="' || CURRENT_TIMESTAMP    :: TVarChar ||'"' -- ???
       --           ||' _internal_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный код товара в товарном справочнике предприятия
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный код товара в товарном справочнике предприятия
       --               ||' sku_code="' || tmpData.sku_code     :: TVarChar ||'"' -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
                            ||' sdid="' || tmpData.sku_code     :: TVarChar ||'"' -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
                            ||' name="' || tmpData.name                     ||'"' -- Наименование товара в товарном справочнике предприятия
                     ||' description="' || ''                               ||'"' -- Описание товара в товарном справочнике предприятия.
                    ||' control_date="' || '1'                              ||'"' -- Параметр, определяющий каким образом СУСК должна следить за сроками годности товара на складе:"0" – Не учитывать"1" – По сроку годности"2" – По дате окончания срока годности"3" – По дате производства и дате окончания срока годности.Значение по умолчанию: 0
                    ||' product_life="' || tmpData.product_life :: TVarChar ||'"' -- Срок годности товара в сутках.
       --!               ||' measure="' || tmpData.MeasureName              ||'"' -- Единица измерения товара (идентификатор из справочника в ГС).
       --!       ||' lot_capture_req="' || 'f'                              ||'"' -- Параметр товара, указывающий на необходимость ввода партии товара для груза при приеме товара на склад: f – Не вводить t – Вводить
       --!        ||' weight_control="' || 'A'                              ||'"' -- Режим учета веса: "A" – автоматически при приемке "M" – вручную при приемке
       --! ||' host_transform_factor="' || '1'                              ||'"' -- Коэффициент пересчета из базовых единиц (сколько базовых единиц ГС в одной штучной в WMS).
                             ||' upc="' || ''                               ||'"' -- Штрихкод товара
                        ||' weight_g="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 't' ELSE 'f' END ||'"' -- Признак весового товара "f" – не является, "t" – является. Значение по умолчанию: "f"
                --||' weight_control="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Nom() THEN 'M' ELSE 'A' END ||'"' -- А - расчет автоматический, передается для штучного товара и не номинального M - задавать вручную, передается для номинального товара
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM lpSelect_wms_Object_SKU() AS tmpData
            --WHERE tmpData.sku_id IN ('795513', '38391802')
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- 956-16 - select * from wms_Object_GoodsByGoodsKind where '38391802' in (sku_id_sh, sku_id_nom, sku_id_ves)
-- 39-3   - select * from wms_Object_GoodsByGoodsKind where sku_id_nom = '795292'
-- select * FROM wms_Message WHERE RowData ILIKE '%sku_id=945179%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_wms_Object_SKU ('1', zfCalc_UserAdmin())
