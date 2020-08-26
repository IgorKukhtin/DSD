-- Function: gpInsert_wms_Movement_INCOMING(TVarChar)
-- 4.1 Уведомление поставки <incoming>

DROP FUNCTION IF EXISTS gpInsert_wms_Movement_INCOMING (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Movement_INCOMING(
    IN inGUID          VarChar(255),      --
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbProcName          TVarChar;
   DECLARE vbTagName           TVarChar;
   DECLARE vbTagName_detail    TVarChar;
   DECLARE vbActionName        TVarChar;
   DECLARE vbOperDate          TDateTime;
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
     --
     -- vbOperDate:= CURRENT_DATE - INTERVAL '0 DAY';
     vbOperDate:= COALESCE ((SELECT MIN (Movement.OperDate)
                             FROM wms_Movement_WeighingProduction AS Movement
                                  INNER JOIN wms_MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                            AND MI.isErased   = FALSE
                                                                            -- !!!сразу как закрыли ящик!!!
                                                                            AND MI.ParentId   > 0 
                                                                            -- только те которые еще не передавали
                                                                            AND MI.StatusId_wms IS NULL
          
                             WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                                   -- не удален
                               AND Movement.StatusId NOT IN (zc_Enum_Status_Erased()) -- zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()
                            )
                          , CURRENT_DATE);


     -- Проверка
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- удалили прошлые данные
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- сформировали новые данные - если надо - wms_MI_Incoming
     PERFORM lpInsertUpdate_wms_MI_Incoming (inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpTest AS (SELECT lpSelect.GoodsId, lpSelect.sku_id :: TVarChar AS sku_id FROM lpSelect_Object_wms_SKU_test() AS lpSelect
                         WHERE 1=0
                       UNION
                         SELECT CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh ELSE Movement.GoodsId END AS GoodsId
                              , MI.sku_id :: TVarChar AS sku_id 
                         FROM wms_Movement_WeighingProduction AS Movement
                              INNER JOIN wms_MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                        AND MI.isErased   = FALSE
                                                                        -- !!!сразу как закрыли ящик!!!
                                                                        AND MI.ParentId   > 0
                                                                        -- только те которые еще не передавали
                                                                        AND (MI.StatusId_wms IS NULL
                                                                       --OR Movement.OperDate = CURRENT_DATE - INTERVAL '0 DAY'
                                                                            )
                         WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                               -- не удален
                           AND Movement.StatusId NOT IN (zc_Enum_Status_Erased()) -- zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()
                        )
           , tmpMI AS (SELECT wms_MI_Incoming.sku_id
                              -- дата документа
                            , wms_MI_Incoming.OperDate
                              -- Дата производства
                            , wms_MI_Incoming.PartionDate
                              --
                            , (ROW_NUMBER() OVER (ORDER BY wms_MI_Incoming.Id)) :: Integer AS RowNum
                              -- ObjectId
                            , wms_MI_Incoming.Id
                       FROM wms_MI_Incoming
                            INNER JOIN tmpTest ON tmpTest.sku_id = wms_MI_Incoming.sku_id
                       WHERE wms_MI_Incoming.OperDate     = vbOperDate
                         AND wms_MI_Incoming.StatusId     = zc_Enum_Status_UnComplete()
                         -- только те которые еще не передавали
                         AND wms_MI_Incoming.StatusId_wms IS NULL
                       -- тест
                       --AND wms_MI_Incoming.sku_id :: TVarChar IN ('795292', '795293', '38391802', '800562', '800563')
                     --LIMIT 1
                      )
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (-- Уведомление поставки в WMS с типом «Производство». На каждое SKU создается отдельное задание на упаковку, соответственно отдельное УП.
              SELECT vbProcName     AS ProcName
                   , vbTagName      AS TagName
                     -- делаем 0 для сортировки, сначала обрабатывается 1-на строчка документа, потом строки
                   , 0   :: Integer AS RowNum
                     -- XML
                     -- уведомление поставки
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- Номер документа
                            ||' type="' || 'A'                                       ||'"' -- Тип уведомления поставки: А - Производство; В - Внешняя поставка; С - Возврат;
                    ||' date_to_ship="' || zfConvert_Date_toWMS (tmpData.OperDate)   ||'"' -- Ожидаемая дата приема
                     ||' supplier_id="' || '0'                                       ||'"' -- Код поставщика Для приема с упаковки значение по умолчанию: 0 («Не задан»)
                                        ||'>'
/*                     -- Детали уведомления поставки
                          ||'<' || vbTagName_detail
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- Номер документа
                            ||' line="' || '1'                                       ||'"' -- Номер строки товарной позиции документа
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- Уникальный идентификатор товара
                             ||' qty="' || '1'                                       ||'"' -- Количество товара в базовых единицах ГС
                 ||' production_date="' || zfConvert_Date_toWMS (tmpData.PartionDate) ||'"' -- Дата производства
                                        ||'></' || vbTagName_detail || '>'*/
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData
                     --
                   , tmpData.Id AS ObjectId
                     --
                   , tmpData.Id AS GroupId
              FROM tmpMI AS tmpData
             UNION ALL
              -- Детали заказа на отгрузку
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , 1     :: Integer AS RowNum
                     -- еще раз уведомление поставки
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- Номер документа
                            ||' type="' || 'A'                                       ||'"' -- Тип уведомления поставки: А - Производство; В - Внешняя поставка; С - Возврат;
                    ||' date_to_ship="' || zfConvert_Date_toWMS (tmpData.OperDate)   ||'"' -- Ожидаемая дата приема
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
                 ||' production_date="' || zfConvert_Date_toWMS (tmpData.PartionDate) ||'"' -- Дата производства
                                        ||'></' || vbTagName_detail || '>'
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData
                     --
                   , tmpData.Id AS ObjectId
                     --
                   , tmpData.Id AS GroupId
              FROM tmpMI AS tmpData
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY tmp.GroupId, 4
     -- LIMIT 1
       ;

     IF inGUID <> '1'
     THEN
         -- отметили что данные отправлены
         UPDATE wms_MI_Incoming SET StatusId_wms = zc_Enum_Status_UnComplete()
         FROM wms_Message
         WHERE wms_Message.GUID     = inGUID
           AND wms_Message.ObjectId = wms_MI_Incoming.Id
           -- только те которые еще не передавали
        -- AND wms_MI_Incoming.StatusId_wms IS NULL
         ;
     END IF;


       -- Результат
       outRecCount:= (SELECT COUNT(*) FROM wms_Message WHERE wms_Message.GUID = inGUID);

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
