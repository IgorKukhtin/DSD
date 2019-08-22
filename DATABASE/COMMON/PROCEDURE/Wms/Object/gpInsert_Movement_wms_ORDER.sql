-- Function: gpInsert_Movement_wms_ORDER(TVarChar)
-- 4.2	Заказ на отгрузку <order>

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ORDER (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ORDER(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_ORDER';
     --
     vbTagName       := 'order';
     vbTagName_detail:= 'order_detail'
     --
     vbActionName:= 'set';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT tmpGoods.sku_id, tmpGoods.ObjectId
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- Заказ на отгрузку
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
                   , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' action="' || vbActionName                     ||'"' -- ???
                       ||' order_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Номер документа
                      ||' client_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Код заказчика в справочнике предприятия.
                           ||' type="' || 'А'                              ||'"' -- Тип заказа: Доставка - А; Списание брака - В; Отоварка - С;
              ||' processing_method="' || 'А'                              ||'"' -- Способ обработки заказа (может быть пустое): Оптовый - А; Мелкий - В; Без маркировки - С;
                   ||' date_to_ship="' || CURRENT_DATE         :: TVarChar ||'"' -- Предполагаемая дата отгрузки заказа
                       ||' comments="' || tmpData.Comment      :: TVarChar ||'"' -- Комментарии к документу
                                       ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
              FROM tmpGoods_all AS tmpData
             UNION ALL
              -- Детали заказа на отгрузку
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , vbActionName     AS ActionName
                   , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' + vbTagName_detail
                         ||' action="' || vbActionName                     ||'"' -- ???
                       ||' order_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Номер документа
                           ||' line="' || '1'                              ||'"' -- Номер строки товарной позиции документа
                         ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный идентификатор товара
                         ||' status="' || tmpData.sku_id       :: TVarChar ||'"' -- Категория груза: Доступен (для типа заказа «Доставка») - А; Некондиция (Для типа заказа «Отоварка») - В; Брак (Для типа заказа «Списание брака») - С;
                            ||' qty="' || '1'                              ||'"' -- Количество товара в базовых единицах ГС 
                       ||' comments="' || tmpData.Comment      :: TVarChar ||'"' -- Комментарии к строке документа
                                       ||'></' || vbTagName_detail || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
              FROM tmpGoods_all AS tmpData
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
 20.08.19                                       *
*/
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- тест
-- SELECT * FROM gpInsert_Movement_wms_ORDER (zfCalc_UserAdmin())
