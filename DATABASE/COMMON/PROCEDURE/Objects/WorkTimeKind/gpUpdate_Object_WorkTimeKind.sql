-- Function: gpUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind (Integer, TVarChar, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind(
 INOUT inId            Integer   ,    -- ключ объекта <>
    IN inShortName     TVarChar  ,    -- Короткое наименование 	
    IN inTax           Tfloat    ,    -- % изменения рабочих часов
    IN inSession       TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), inId, inShortName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Tax(), inId, inTax);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.17         *
 01.10.13         * 

*/

-- тест
-- 