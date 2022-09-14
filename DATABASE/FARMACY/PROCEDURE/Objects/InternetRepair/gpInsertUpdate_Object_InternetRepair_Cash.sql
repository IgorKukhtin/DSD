-- Function: gpInsertUpdate_Object_InternetRepair_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InternetRepair_Cash (Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InternetRepair_Cash(
    IN inId	                 Integer   ,    -- ключ объекта
    IN inNotes               TBlob     ,    -- Пометки

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Ремонт интернета не сохранен.'; 
   END IF;
   
   -- сохранили <Пометки>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InternetRepair_Notes(), inId, inNotes);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InternetRepair_Cash(Integer, TBlob, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.09.22                                                       *              
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InternetRepair_Cash()