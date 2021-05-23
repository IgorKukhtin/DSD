-- Function: gpUpdate_Object_WorkTimeKind_Summ (Integer, Tfloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind_Summ (Integer, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind_Summ(
 INOUT inId            Integer   ,    -- ключ объекта <>
    IN inSumm          TFloat    ,    -- Сумма за раб. день, грн
    IN inSession       TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_WorkTimeKind_Summ());


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Summ(), inId, inSumm);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.20         *
*/

-- тест
-- 