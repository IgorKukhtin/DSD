DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal_Property(
 INOUT ioId                  Integer   , -- ключ объекта <Сотрудники>
    IN inPositionId          Integer   , -- ссылка на Должность
    IN inIsMain              Boolean   , -- Основное место работы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 12.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal_Property (ioId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')
