DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member_isOfficial (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member_isOfficial(
    IN ioId                  Integer   , -- Ключ объекта
 INOUT inIsOfficial          Boolean   , -- ОФициал
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- проверка прав пользователя на вызов процедуры
--     vbUserId:= inSession;

   -- определили признак
   inIsOfficial:= NOT inIsOfficial;

   -- сохранили свойство <Оформлен официально>
--   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- сохранили протокол
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Member_isOfficial(Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 12.09.14                                                       *
*/

