-- Function: gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RateFuelKind (
 INOUT ioId              Integer   ,    -- ключ объекта <Виды норм для топлива>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inTax             TFloat    ,    -- % дополнительного расхода в связи с сезоном/температурой
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RateFuelKind());

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_RateFuelKind()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_RateFuelKind(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RateFuelKind(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RateFuelKind(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuelKind_Tax(), ioId, inTax);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ 

LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.09.13          * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RateFuelKind()
