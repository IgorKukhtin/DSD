-- Function: gpInsertUpdate_Object_SunExclusion (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SunExclusion (Integer,Integer,TVarChar, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SunExclusion(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inFromId          Integer   ,    -- 
    IN inToId            Integer   ,    -- 
    IN inisV1            Boolean,       -- 
    IN inisV2            Boolean,       -- 
    IN inisMSC_in        Boolean,       -- 
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession; 

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SunExclusion()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SunExclusion(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SunExclusion_From(), ioId, inFromId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SunExclusion_To(), ioId, inToId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_V1(), ioId, inisV1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_V2(), ioId, inisV2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_MSC_in(), ioId, inisMSC_in);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.04.20         *
*/

-- тест
--