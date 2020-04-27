-- Function: gpInsert_wms_Object_USER(TVarChar)
-- 4.3	Добавление пользователя <add_user>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_USER (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_USER(
    IN inGUID          VarChar(255),      -- 
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Object_USER());

     --
     vbProcName:= 'gpInsert_wms_Object_USER';
     --
     vbTagName:= 'add_user';
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
        WITH tmpMember AS (SELECT DISTINCT Object_Member.DescId, Object_Member.Id AS id, Object_Member.ValueData AS fio
                           FROM Object AS Object_Member
                                INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ChildObjectId = Object_Member.Id
                                                     AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                INNER JOIN Object AS Object_User
                                                  ON Object_User.Id       = ObjectLink_User_Member.ObjectId
                                                 AND Object_User.isErased = FALSE
                                               --AND Object_User.Id IN (SELECT ObjectLink_UserRole_View.UserId
                                               --                       FROM ObjectLink_UserRole_View
                                               --                       WHERE ObjectLink_UserRole_View.RoleId IN (428386 -- Руководитель склад ГП Днепр
                                               --                                                               , 428382 -- Кладовщик Днепр
                                               --                                                                )
                                               --                      )
                                LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.UserId = Object_User.Id
                           WHERE Object_Member.DescId   = zc_Object_Member()
                             AND Object_Member.isErased = FALSE
                             AND (ObjectLink_UserRole_View.UserId IS NULL
                               OR ObjectLink_UserRole_View.RoleId IN (428386 -- Руководитель склад ГП Днепр
                                                                    , 428382 -- Кладовщик Днепр
                                                                     )
                                 )
                          )
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                          ||' action="' || vbActionName                     ||'"' -- ???
                              ||' id="' || tmpData.id           :: TVarChar ||'"' -- Уникальный id сотрудника
                             ||' fio="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.fio, CHR(39), '`'), '"', '`') ||'"' -- ФИО сотрудника
                                        ||'></' || vbTagName || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.id AS ObjectId
                   , 0          AS GroupId

              FROM tmpMember AS tmpData
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
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_wms_Object_USER ('1', zfCalc_UserAdmin())
