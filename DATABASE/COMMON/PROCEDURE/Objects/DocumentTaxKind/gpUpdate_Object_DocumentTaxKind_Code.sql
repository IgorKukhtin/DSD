-- Function: gpUpdate_Object_DocumentTaxKind_Code(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Code (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentTaxKind_Code(
 INOUT inId             Integer,       -- Ключ объекта <>
    IN inCode           TVarChar,       -- свойство 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_DocumentTaxKind_Code());
   -- vbUserId := inSession;

   -- сохранили свойство <Код причины>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Code(), inId, inCode);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.11.18         *
*/

-- тест
-- 