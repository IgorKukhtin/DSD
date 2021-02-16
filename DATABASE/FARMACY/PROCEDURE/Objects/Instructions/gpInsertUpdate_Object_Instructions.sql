-- Function: gpInsertUpdate_Object_Instructions()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Instructions (Integer, Integer, TVarChar, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Instructions(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inCode             Integer   ,    -- Номер параметра
    IN inName                    TVarChar  ,    -- Название параметра
    IN inInstructionsKindId      Integer   ,    -- Разделы инструкций
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   IF COALESCE (inInstructionsKindId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнен <Раздел инструкций>...';
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Hardware());

   -- проверка уникальности для свойства <Наименование> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Instructions(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Instructions(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Instructions(), vbCode_calc, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Instructions_InstructionsKind(), ioId, inInstructionsKindId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Instructions (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.02.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Instructions ()                            