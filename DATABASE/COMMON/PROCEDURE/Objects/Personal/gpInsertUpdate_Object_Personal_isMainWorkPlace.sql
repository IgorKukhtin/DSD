DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal_isMain(
    IN ioId                  Integer   , -- Ключ объекта
 INOUT inIsMain              Boolean   , -- ОФициал
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- проверка прав пользователя на вызов процедуры
--     vbUserId:= inSession;

   -- определили признак
   inIsMain:= NOT inIsMain;

   -- сохранили свойство <Оформлен официально>
--   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- сохранили протокол
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal_isMain(Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 12.09.14                                                       *
*/