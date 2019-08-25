-- Function: gpInsert_wms_Movement_INCOMING(TVarChar)
-- 4.1 Уведомление поставки <incoming>

DROP FUNCTION IF EXISTS gpInsert_wms_Movement_INCOMING (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Movement_INCOMING(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbProcName          TVarChar;
   DECLARE vbTagName           TVarChar;
   DECLARE vbTagName_detail    TVarChar;
   DECLARE vbActionName        TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Object_SKU());

     --
     vbProcName:= 'gpInsert_wms_Movement_INCOMING';
     --
     vbTagName       := 'incoming';
     vbTagName_detail:= 'incoming_detail';
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


     -- сформировали новые данные - если надо
     PERFORM lpInsertUpdate_wms_MI_Incoming (inOperDate:= CURRENT_DATE, inUserId:= vbUserId);


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpMI AS (SELECT wms_MI_Incoming.sku_id
                              -- дата документа
                            , wms_MI_Incoming.OperDate
                              -- Дата производства
                            , wms_MI_Incoming.PartionDate
                              -- 
                            , (ROW_NUMBER() OVER (ORDER BY wms_MI_Incoming.Id)) :: Integer AS RowNum
                              -- ObjectId
                            , wms_MI_Incoming.Id
                       FROM wms_MI_Incoming
                       WHERE wms_MI_Incoming.OperDate     = CURRENT_DATE
                         AND wms_MI_Incoming.StatusId     = zc_Enum_Status_UnComplete()
                         -- только те которые еще не передавали
                      -- AND wms_MI_Incoming.StatusId_wms IS NULL
                      )
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (-- Уведомление поставки в WMS с типом «Производство». На каждое SKU создается отдельное задание на упаковку, соответственно отдельное УП.
              SELECT vbProcName     AS ProcName
                   , vbTagName      AS TagName
                   , tmpData.RowNum AS RowNum
                     -- XML
                     -- уведомление поставки
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- Номер документа
                            ||' type="' || 'A'                                       ||'"' -- Тип уведомления поставки: А - Производство; В - Внешняя поставка; С - Возврат;
                    ||' date_to_ship="' || zfConvert_DateToWMS (tmpData.OperDate)    ||'"' -- Ожидаемая дата приема
                     ||' supplier_id="' || '0'                                       ||'"' -- Код поставщика Для приема с упаковки значение по умолчанию: 0 («Не задан»)
                                        ||'>'

                     -- Детали уведомления поставки
                          ||'<' || vbTagName_detail
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- Номер документа
                            ||' line="' || '1'                                       ||'"' -- Номер строки товарной позиции документа
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- Уникальный идентификатор товара
                             ||' qty="' || '1'                                       ||'"' -- Количество товара в базовых единицах ГС 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.PartionDate) ||'"' -- Дата производства
                                        ||'></' || vbTagName_detail || '>'
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData
                     --
                   , tmpData.Id AS ObjectId
                     --
                   , 0          AS GroupId
              FROM tmpMI AS tmpData
           -- WHERE tmpData.sku_id = '795292'
            /* UNION ALL
              -- Детали уведомления поставки
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
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
              FROM tmpMI AS tmpData*/
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;
       
       -- отметили что данные отправлены
       UPDATE wms_MI_Incoming SET StatusId_wms = zc_Enum_Status_UnComplete()
       FROM wms_Message
       WHERE wms_Message.GUID     = inGUID
         AND wms_Message.ObjectId = wms_MI_Incoming.Id
         -- только те которые еще не передавали
      -- AND wms_MI_Incoming.StatusId_wms IS NULL
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
*/
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_wms_Movement_INCOMING ('1', zfCalc_UserAdmin())
