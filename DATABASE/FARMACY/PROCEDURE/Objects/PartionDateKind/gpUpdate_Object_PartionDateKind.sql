-- Function: gpInsertUpdate_Object_PartionDateKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionDateKind(
    IN inId            Integer   ,    -- ключ объекта <>
    IN inCode          Integer   ,    -- Код объекта <>
    IN inName          TVarChar  ,    -- название
    IN inDay           Integer   ,    -- кол-во дней
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_PartionDateKind());

   -- сохранили <Объект>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_PartionDateKind(), inCode, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Day(), inId, inDay);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.07.19                                                       *
 19.04.19         * 
*/

-- тест
--