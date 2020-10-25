-- Function: gpUpdate_Object_Personal_isMain ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_isMain(
    IN inId                  Integer   , -- Ключ объекта
 INOUT ioIsMain              Boolean   , -- Основное место работы
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- определили признак
   ioIsMain:= NOT ioIsMain;

   -- сохранили свойство <Основное место работы>
   -- PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Main(), inId, ioIsMain);

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 13.09.14                                        * rename
 12.09.14                                                       *
*/