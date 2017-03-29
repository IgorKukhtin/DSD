-- Function: gpUpdate_Object_Partner_Delivery()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Delivery (Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Delivery(
    IN inId                  Integer  ,  -- ключ объекта <Контрагент> 
    IN inValue1              Boolean  ,  -- понедельник значение
    IN inValue2              Boolean  ,  -- вторник
    IN inValue3              Boolean  ,  -- среда
    IN inValue4              Boolean  ,  -- четверг
    IN inValue5              Boolean  ,  -- пятница
    IN inValue6              Boolean  ,  -- суббота
    IN inValue7              Boolean  ,  -- воскресенье
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbDelivery TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Schedule());
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!надо так криво обработать когда добавляют несколько пользователей!!!)
   IF COALESCE (inId, 0) = 0
   THEN 
       RETURN;
   END IF;

   vbDelivery:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;
   vbDelivery:= replace( replace (vbDelivery, 'true', 't'), 'false', 'f');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Delivery(), inId, vbDelivery);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.03.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Delivery()
