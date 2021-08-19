-- Function: gpUpdate_Object_WorkTimeKind_NoSheetChoice (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind_NoSheetChoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind_NoSheetChoice(
    IN inId              Integer   ,    -- ключ объекта <>
    IN inisNoSheetChoice Boolean   ,    -- Блокировать выбор в Табеле
   OUT outisNoSheetChoice Boolean  ,
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_WorkTimeKind_NoSheetChoice());

   outisNoSheetChoice := NOT inisNoSheetChoice;

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_WorkTimeKind_NoSheetChoice(), inId, outisNoSheetChoice);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, TRUE);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.08.21         *
*/

-- тест