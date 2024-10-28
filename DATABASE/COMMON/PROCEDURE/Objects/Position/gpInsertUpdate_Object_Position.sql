-- Function: gpInsertUpdate_Object_Position()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId	             Integer   ,    -- ключ объекта <Должности>
    IN inCode                Integer   ,    -- код объекта
    IN inName                TVarChar  ,    -- Название объекта
    IN inSheetWorkTimeId     Integer   ,    -- Режим работы (Шаблон табеля р.вр.)
    IN inPositionPropertyId  Integer   ,    --
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;

BEGIN
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Position());
   -- END IF;

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Position());


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Position());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Position(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Position(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), vbCode_calc, inName);

   -- сохранили связь с <Режим работы (Шаблон табеля р.вр.)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Position_SheetWorkTime(), ioId, inSheetWorkTimeId);
   -- сохранили связь с <Классификатор должности>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Position_PositionProperty(), ioId, inPositionPropertyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         * 
 16.11.16         * add inSheetWorkTimeId
 09.10.13                                        * пытаемся найти код
 01.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Position()
