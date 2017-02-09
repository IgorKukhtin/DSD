-- Function: gpUpdate_Object_Member_isOfficial ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_isOfficial (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_isOfficial(
    IN inId                  Integer   , -- Ключ объекта
 INOUT ioIsOfficial          Boolean   , -- ОФициал
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- определили признак
   ioIsOfficial:= NOT ioIsOfficial;

   -- сохранили свойство <Оформлен официально>
   -- PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), inId, ioIsOfficial);

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Member_isOfficial(Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 13.09.14                                        * rename
 12.09.14                                                       *
*/

