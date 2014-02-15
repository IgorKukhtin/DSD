-- Function: gpInsertUpdate_Object_Fuel (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fuel (Integer,Integer,TVarChar, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fuel(
 INOUT ioId              Integer   ,    -- ключ объекта <Виды топлива>
    IN inCode            Integer   ,    -- Код объекта <Виды топлива>
    IN inName            TVarChar  ,    -- Название объекта <Виды топлива>
    IN inRatio           TFloat    ,    -- Коэффициент перевода нормы
    IN inRateFuelKindId  Integer   ,    -- Виды норм для топлива
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Fuel());

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Fuel()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fuel(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fuel(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fuel(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Fuel_Ratio(), ioId, inRatio);

   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Fuel_RateFuelKind(), ioId, inRateFuelKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_Fuel(Integer,Integer,TVarChar, TFloat, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13          *  add  RateFuelKind
 24.09.13          * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Fuel()
