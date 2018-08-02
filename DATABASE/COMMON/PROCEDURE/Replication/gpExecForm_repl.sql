-- 

DROP FUNCTION IF EXISTS gpExecForm_repl (TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpExecForm_repl (
    IN inFormName        TVarChar,      -- главное Название объекта <Форма> 
    IN inFormData        TBLOB   ,      -- Данные формы 
    IN gConnectHost      TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession         TVarChar       -- сессия пользователя
) 
RETURNS VOID
AS $BODY$
BEGIN
      PERFORM gpInsertUpdate_Object_Form (inFormName, inFormData, zfCalc_UserAdmin());
END; $BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.18                                        *
*/

-- тест
-- SELECT * FROM gpExecForm_repl ('select 1', '', zfCalc_UserAdmin())
