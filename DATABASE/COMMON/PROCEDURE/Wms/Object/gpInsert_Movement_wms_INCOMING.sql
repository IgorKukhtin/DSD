-- Function: gpInsert_Movement_wms_INCOMING(TVarChar)
-- 4.1 Уведомление поставки <incoming>

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_INCOMING (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_INCOMING(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer, GroupId Integer)
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
     vbProcName:= 'gpInsert_Movement_wms_INCOMING';
     --
     vbTagName       := 'incoming';
     vbTagName_detail:= 'incoming_detail';
     --
     vbActionName:= 'set';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT tmpGoods.sku_id
                                     -- Номер документа
                                   , zfCalc_inc_id_toWMS (CURRENT_DATE, tmpGoods.sku_id) AS inc_id
                                     -- дата документа
                                   , CURRENT_DATE AS OperDate
                                     -- Дата производства
                                   , CURRENT_DATE AS PartionDate
                                     -- 
                                   , (ROW_NUMBER() OVER (ORDER BY tmpGoods.sku_id)) :: Integer AS RowNum
                                     --
                                   , tmpGoods.ObjectId
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
        -- Результат
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- Уведомление поставки в WMS с типом «Производство». На каждое SKU создается отдельное задание на упаковку, соответственно отдельное УП.
              SELECT vbProcName     AS ProcName
                   , vbTagName      AS TagName
                   , vbActionName   AS ActionName
                   , tmpData.RowNum AS RowNum
                     -- XML
                     -- уведомление поставки
                   , ('<' || vbTagName
                         ||' sync_id="' || tmpData.inc_id       :: TVarChar ||'"' -- ???
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- Номер документа
                            ||' type="' || 'A'                              ||'"' -- Тип уведомления поставки: А - Производство; В - Внешняя поставка; С - Возврат;
                    ||' date_to_ship="' || zfConvert_DateToWMS (tmpData.OperDate) ||'"' -- Ожидаемая дата приема
                     ||' supplier_id="' || '0'                              ||'"' -- Код поставщика Для приема с упаковки значение по умолчанию: 0 («Не задан»)
                                        ||'>'

                     -- Детали уведомления поставки
                          ||'<' || vbTagName_detail
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- Номер документа
                            ||' line="' || '1'                              ||'"' -- Номер строки товарной позиции документа
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный идентификатор товара
                             ||' qty="' || '1'                              ||'"' -- Количество товара в базовых единицах ГС 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.PartionDate) ||'"' -- Дата производства
                                        ||'></' || vbTagName_detail || '>'
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData

                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
            /* UNION ALL
              -- Детали уведомления поставки
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , vbActionName     AS ActionName
                   , tmpData.RowNum + 1   AS RowNum
                     -- XML
                   , ('<' || vbTagName_detail
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- Номер документа
                            ||' line="' || '1'                              ||'"' -- Номер строки товарной позиции документа
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный идентификатор товара
                             ||' qty="' || '1'                              ||'"' -- Количество товара в базовых единицах ГС 
                 ||' production_date="' || TO_CHAR (CURRENT_DATE, 'DD-MM-YYYY') :: TVarChar ||'"' -- Дата производства
                                        ||'></' || vbTagName_detail || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 2 AS GroupId
              FROM tmpGoods_all AS tmpData*/
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
-- SELECT * FROM gpInsert_Movement_wms_INCOMING (zfCalc_UserAdmin())
