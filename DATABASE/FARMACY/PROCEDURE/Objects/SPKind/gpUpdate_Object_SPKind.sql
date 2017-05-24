-- Function: gpInsertUpdate_Object_SPKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_SPKind (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_SPKind(
 INOUT ioId            Integer   ,    -- ключ объекта <>
    IN inTax           TFloat    ,    -- % скидки по кассе
    IN inSession       TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SPKind());
   vbUserId := inSession;

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_SPKind_Tax(), ioId, inTax);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.17         * 

*/

-- тест
-- select * from gpUpdate_Object_SPKind(ioId := 3690840 , inTax := 100 ,  inSession := '3');
