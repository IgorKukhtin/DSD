-- Function: gpDelete_Object_Hardware()

DROP FUNCTION IF EXISTS gpDelete_Object_Hardware(integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Hardware(
    IN inId            Integer,       -- ключ объекта <Города>
    IN isCashRegister  Boolean,       -- касса
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF isCashRegister = True
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение данных по кассам запрещено...';
   END IF;

    -- Разрешаем только сотрудникам с правами админа    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Удаление запрещено, обратитесь к системному администратору';
   END IF;
    
   IF COALESCE (inId, 0) <> 0
   THEN
     PERFORM lpDelete_Object(inId, inSession);
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_Hardware(integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 13.04.20                                                                      *  
*/

-- тест
-- SELECT * FROM gpDelete_Object_Hardware (0, True, '3')