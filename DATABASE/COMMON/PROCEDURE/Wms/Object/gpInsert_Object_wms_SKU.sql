-- Function: gpInsert_Object_wms_SKU(TVarChar)
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
-- DECLARE vbRowNum     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_SKU';
     --
     vbTagName := 'sku';
     --
     vbActionName:= 'set';


     -- !!!Залили ВСЕ данные - в Object_GoodsByGoodsKind - линейная табл.!!!
     PERFORM gpInsertUpdate_Object_GoodsByGoodsKind_wms (inSession);


     -- Проверка
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- удалили прошлые данные
         DELETE FROM Object_WMS WHERE Object_WMS.GUID = inGUID; -- AND Object_WMS.ProcName = vbProcName;
     END IF;


     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (GUID, ProcName, TagName, RowNum, RowData) VALUES (inGUID, vbProcName, vbTagName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
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
       --!          ||' control_date="' || '2'                              ||'"' -- Параметр, определяющий каким образом СУСК должна следить за сроками годности товара на складе:"0" – Не учитывать"1" – По сроку годности"2" – По дате окончания срока годности"3" – По дате производства и дате окончания срока годности.Значение по умолчанию: 0
                    ||' product_life="' || tmpData.product_life :: TVarChar ||'"' -- Срок годности товара в сутках.
       --!               ||' measure="' || tmpData.MeasureName              ||'"' -- Единица измерения товара (идентификатор из справочника в ГС).
       --!       ||' lot_capture_req="' || 'f'                              ||'"' -- Параметр товара, указывающий на необходимость ввода партии товара для груза при приеме товара на склад: f – Не вводить t – Вводить
       --!        ||' weight_control="' || 'A'                              ||'"' -- Режим учета веса: "A" – автоматически при приемке "M" – вручную при приемке
       --! ||' host_transform_factor="' || '1'                              ||'"' -- Коэффициент пересчета из базовых единиц (сколько базовых единиц ГС в одной штучной в WMS).
                             ||' upc="' || ''                               ||'"' -- Штрихкод товара
                        ||' weight_g="' || CASE WHEN tmpData.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 't' ELSE 'f' END ||'"' -- Признак весового товара "f" – не является, "t" – является. Значение по умолчанию: "f"
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM lpSelect_Object_wms_SKU() AS tmpData
           -- WHERE tmpData.sku_id = '795292'
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
-- select * FROM Object_WMS WHERE RowData ILIKE '%sync_id=1%
-- select * FROM Object_WMS WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_Object_wms_SKU ('1', zfCalc_UserAdmin())
