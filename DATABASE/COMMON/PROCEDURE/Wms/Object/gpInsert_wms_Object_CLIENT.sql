-- Function: gpInsert_wms_Object_CLIENT(TVarChar)
-- 4.1.1.3 Справочник контрагентов <client>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_CLIENT (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_CLIENT(
    IN inGUID          VarChar(255),      -- 
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
AS
$BODY$
   DECLARE vbProcName               TVarChar;
   DECLARE vbTagName_client         TVarChar;
   DECLARE vbTagName_client_address TVarChar;
   DECLARE vbActionName             TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Object_CLIENT());

     --
     vbProcName:= 'gpInsert_wms_Object_CLIENT';
     --
     vbTagName_client        := 'client';
     vbTagName_client_address:= 'client_address';
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
        WITH tmpPartner_all AS (-- zc_Object_Partner
                                /*SELECT Object_Partner.DescId, Object_Partner.Id AS client_id, Object_Partner.ValueData AS name
                                     , COALESCE (ObjectString_Address.ValueData, '') AS address
                                FROM Object AS Object_Partner
                                     INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                                          ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                         AND ObjectLink_Juridical_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                          ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                         AND ObjectLink_Juridical_JuridicalGroup.DescId   = zc_ObjectLink_Juridical_JuridicalGroup()
                                     LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                                                          ON ObjectLink_JuridicalGroup_Parent.ObjectId = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
                                                         AND ObjectLink_JuridicalGroup_Parent.DescId   = zc_ObjectLink_JuridicalGroup_Parent()
                                     LEFT JOIN ObjectString AS ObjectString_Address
                                                            ON ObjectString_Address.ObjectId = Object_Partner.Id
                                                           AND ObjectString_Address.DescId   = zc_ObjectString_Partner_Address()
                                WHERE Object_Partner.DescId   = zc_Object_Partner()
                                  AND Object_Partner.isErased = FALSE
                                  AND (ObjectLink_JuridicalGroup_Parent.ChildObjectId    = 8362 -- 03-ПОКУПАТЕЛИ
                                    OR ObjectLink_Juridical_JuridicalGroup.ChildObjectId = 8362 -- 03-ПОКУПАТЕЛИ
                                    OR ObjectLink_Juridical_InfoMoney.ChildObjectId      IN (zc_Enum_InfoMoney_30101() -- Доходы - Готовая продукция
                                                                                           , zc_Enum_InfoMoney_30102() -- Доходы - Тушенка
                                                                                            )
                                      )
    --                            AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (8362   -- 03-ПОКУПАТЕЛИ
    --                                                                                    , 257163 -- покупатели Днепр
    --                                                                                     )
     
                               UNION ALL*/
                                -- zc_Object_Unit
                                SELECT Object_Unit.DescId, Object_Unit.Id AS client_id, Object_Unit.ValueData AS name
                                     , COALESCE (ObjectString_Address.ValueData, '') AS address
                                FROM Object AS Object_Unit
                                     INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                           ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                          AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                     INNER JOIN ObjectLink AS ObjectLink_Unit_Parent_0
                                                           ON ObjectLink_Unit_Parent_0.ObjectId = Object_Unit.Id
                                                          AND ObjectLink_Unit_Parent_0.DescId   = zc_ObjectLink_Unit_Parent()
                                     INNER JOIN ObjectLink AS ObjectLink_Unit_Parent_1
                                                           ON ObjectLink_Unit_Parent_1.ObjectId      = ObjectLink_Unit_Parent_0.ChildObjectId
                                                          AND ObjectLink_Unit_Parent_1.DescId        = zc_ObjectLink_Unit_Parent()
                                                          AND ObjectLink_Unit_Parent_1.ChildObjectId = 8406 -- Филиалы
                                     LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                                          ON ObjectLink_Unit_HistoryCost.ObjectId = Object_Unit.Id
                                                         AND ObjectLink_Unit_HistoryCost.DescId   = zc_ObjectLink_Unit_HistoryCost()
                                     LEFT JOIN ObjectString AS ObjectString_Address
                                                            ON ObjectString_Address.ObjectId = Object_Unit.Id
                                                           AND ObjectString_Address.DescId   = zc_ObjectString_Unit_Address()
                                                           AND 1=0
                                WHERE Object_Unit.DescId   = zc_Object_Unit()
                                  AND Object_Unit.isErased = FALSE
                                  AND ObjectLink_Unit_HistoryCost.ChildObjectId IS NULL
                               )
           , tmpPartner AS (SELECT tmpPartner_all.DescId, tmpPartner_all.client_id, tmpPartner_all.name, tmpPartner_all.address
                            FROM tmpPartner_all
                           UNION
                            SELECT DISTINCT 
                                   COALESCE (Object_From.DescId, 0)               AS DescId
                                 , COALESCE (MovementLinkObject_From.ObjectId, 0) AS client_id
                                 , COALESCE (Object_From.ValueData, '')           AS name
                                 , COALESCE (ObjectString_Address.ValueData, '')  AS address
                            FROM Movement 
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                 LEFT JOIN tmpPartner_all ON tmpPartner_all.client_id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                 LEFT JOIN ObjectString AS ObjectString_Address
                                                        ON ObjectString_Address.ObjectId = Object_From.Id
                                                       AND ObjectString_Address.DescId   = zc_ObjectString_Partner_Address()
                                                       AND Object_From.DescId = zc_Object_Partner()
                           WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '32 DAY'
                             AND Movement.DescId   = zc_Movement_OrderExternal() 
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND tmpPartner_all.client_id IS NULL
                             AND MovementLinkObject_To.ObjectId = 8459 -- Склад Реализации
                          )
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName       AS ProcName
                   , vbTagName_client AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.DescId, tmpData.client_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName_client
                          ||' action="' || vbActionName                     ||'"' -- ???
                       ||' client_id="' || tmpData.client_id    :: TVarChar ||'"' -- Уникальный идентификатор клиента
                            ||' name="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.name, CHR(39), '`'), '"', '`') ||'"' -- Имя клиента
                      ||' short_name="' || ''                               ||'"' -- Короткое имя клиента
        --!              ||' address="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.address, CHR(39), '`'), '"', '`') ||'"' -- Адрес клиента
                           ||' phone="' || ''                               ||'"' -- Телефон клиента
                           ||' email="' || ''                               ||'"' -- E-mail клиента
                             ||' fax="' || ''                               ||'"' -- Факс клиента
                     ||' is_customer="' || CASE WHEN tmpData.DescId = zc_Object_Partner() THEN 't' ELSE 'f' END :: TVarChar ||'"' -- Является ли контрагент покупателем: "f" – не является, "t" – является. Значение по умолчанию: "f"
                     ||' is_supplier="' || 'f'                              ||'"' -- Является ли контрагент поставщиком: "f" – не является, "t" – является. Значение по умолчанию: "f"
                       ||' is_holder="' || 'f'                              ||'"' -- Является ли контрагент владельцем: "f" – не является, "t" – является. Значение по умолчанию: "f"
                 ||' is_manufacturer="' || 'f'                              ||'"' -- Является ли контрагент производителем: "f" – не является, "t" – является. Значение по умолчанию: "f"
                        ||' comments="' || ''                               ||'"' -- Комментарии
                                        ||'></' || vbTagName_client || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.client_id AS ObjectId
                   , 1                 AS GroupId
              FROM tmpPartner AS tmpData
      
             UNION ALL
              -- client_address
              SELECT vbProcName               AS ProcName
                   , vbTagName_client_address AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.DescId, tmpData.client_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName_client_address
                          ||' action="' || vbActionName                     ||'"' -- ???
                      ||' address_id="' || tmpData.client_id    :: TVarChar ||'"' -- Уникальный код адреса клиента
                       ||' client_id="' || tmpData.client_id    :: TVarChar ||'"' -- Уникальный идентификатор клиента
                         ||' address="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.address, CHR(39), '`'), '"', '`') ||'"' -- Адрес доставки
                        ||' comments="' || ''                               ||'"' -- Комментарии
                                        ||'></' || vbTagName_client_address || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.client_id AS ObjectId
                   , 2                 AS GroupId
              FROM tmpPartner AS tmpData
             ) AS tmp
     -- WHERE tmp.RowNum BETWEEN 1 AND 10
        ORDER BY 4;


     -- Результат
     outRecCount:= (SELECT COUNT(*) FROM wms_Message WHERE wms_Message.GUID = inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
/*
 SELECT * 
FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_from
                                         ON MovementLinkObject_from.MovementId = Movement.Id
                                        AND MovementLinkObject_from.DescId = zc_MovementLinkObject_from()
            LEFT JOIN Object AS Object_from ON Object_from.Id = MovementLinkObject_from.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
where Movement.OperDate >= '01.08.2019' 
AND Movement.DescId = zc_Movement_OrderExternal() 
AND Movement.StatusId = zc_Enum_Status_Complete()
and Object_from.Id not in (select ObjectId FROM wms_Message)
and MovementLinkObject_To.ObjectId = 8459 -- Склад Реализации
*/
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_wms_Object_CLIENT ('1', zfCalc_UserAdmin())
