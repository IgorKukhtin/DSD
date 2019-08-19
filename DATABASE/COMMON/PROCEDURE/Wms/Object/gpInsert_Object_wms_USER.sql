-- Function: gpInsert_Object_wms_USER(TVarChar)
-- 4.3	Добавление пользователя <add_user>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_USER (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_USER(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
   DECLARE vbRowNum     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_USER';
     --
     vbTagName:= 'add_user';
     --
     vbActionName:= 'set';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId)
        WITH tmpMember AS (SELECT Object_Member.DescId, Object_Member.Id AS id, Object_Member.ValueData AS fio
                           FROM Object AS Object_Member
                                INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ChildObjectId = Object_Member.Id
                                                     AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                INNER JOIN Object AS Object_User
                                                  ON Object_User.Id = ObjectLink_User_Member.ObjectId
                                                 AND Object_User.isErased = FALSE
                                                 AND Object_User.Id IN (SELECT ObjectLink_UserRole_View.UserId
                                                                        FROM ObjectLink_UserRole_View
                                                                        WHERE ObjectLink_UserRole_View.RoleId IN (428386 -- Руководитель склад ГП Днепр
                                                                                                                , 428382 -- Кладовщик Днепр
                                                                                                                 )
                                                                       )
                           WHERE Object_Member.DescId   = zc_Object_Member()
                             AND Object_Member.isErased = FALSE
                          )
        -- Результат
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId
        FROM
       (SELECT vbProcName   AS ProcName
             , vbTagName    AS TagName
             , vbActionName AS ActionName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.id) :: Integer) AS RowNum
               -- XML
             , ('<add_user'
                  ||' action="' || vbActionName                     ||'"' -- ???
                      ||' id="' || tmpData.id           :: TVarChar ||'"' -- Уникальный id сотрудника
                    ||' fio="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.fio, CHR(39), '`'), '"', '`') ||'"' -- ФИО сотрудника
                ||'></add_user>'
               ):: Text AS RowData
               -- Id
             , tmpData.id AS ObjectId
        FROM tmpMember AS tmpData
       ) AS tmp
     -- WHERE tmp.RowNum BETWEEN 1 AND 10
        ORDER BY 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- тест
-- SELECT * FROM gpInsert_Object_wms_USER (zfCalc_UserAdmin())
