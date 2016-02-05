-- Function: gpUpdate_isDateOut ()

DROP FUNCTION IF EXISTS gpUpdate_isMain (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_isMain(
    IN inId                  Integer   , -- ключ объекта <Сотрудники>
 INOUT ioisMain              Boolean   , -- основное место работы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

    -- проверка
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Элемент справочника не записан.';
     END IF;

   -- определили признак
   ioisMain:= NOT ioisMain;

   -- сохранили свойство <Основное место работы>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, ioisMain);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpUpdate_isMain (Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   
 05.02.16         * 
*/

-- тест
-- SELECT * FROM gpUpdate_isDateOut (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')