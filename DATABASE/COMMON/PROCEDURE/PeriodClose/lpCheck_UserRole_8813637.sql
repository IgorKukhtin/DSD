-- Проверка - 10200 - нет ВООБЩЕ доступа к просмотру данных ЗП
-- Function: lpCheck_UserRole_8813637()

DROP FUNCTION IF EXISTS lpCheck_UserRole_8813637 (Integer);

CREATE OR REPLACE FUNCTION lpCheck_UserRole_8813637(
    IN inUserId          Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- Ограничение - 10200 - нет ВООБЩЕ доступа к просмотру данных ЗП
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
     THEN
         RAISE EXCEPTION 'Ошибка.Для роли <%> нет прав для выбранного действия.', lfGet_Object_ValueData_sh (8813637);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.22                                        *
*/

-- тест
-- SELECT lpCheck_UserRole_8813637 (inUserId:= 81241)
