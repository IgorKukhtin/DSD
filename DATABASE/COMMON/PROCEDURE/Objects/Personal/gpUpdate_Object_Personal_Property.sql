-- Function: gpUpdate_Object_Personal_Property ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_Property(
    IN inId                  Integer   , -- ключ объекта <Сотрудники>
    IN inPositionId          Integer   , -- ссылка на Должность
    IN inUnitId              Integer   , -- ссылка на Подразделение
    IN inIsMain              Boolean   , -- Основное место работы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), inId, inPositionId);
   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, inIsMain);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), inId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 15.09.14                                                       *
 12.09.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Personal_Property (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')