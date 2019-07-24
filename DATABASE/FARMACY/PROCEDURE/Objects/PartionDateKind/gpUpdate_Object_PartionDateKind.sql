-- Function: gpInsertUpdate_Object_PartionDateKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionDateKind(
    IN inId            Integer   ,    -- ключ объекта <>
    IN inCode          Integer   ,    -- Код объекта <>
    IN inName          TVarChar  ,    -- название
    IN inDay           Integer   ,    -- кол-во дней
    IN inMonth 	       Integer   ,    -- кол-во месяцев
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDay Integer;
   DECLARE vbMonth Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_PartionDateKind());

   -- проверка
   IF COALESCE (inDay,0) <> 0 AND COALESCE (inMonth,0) <> 0
   THEN
       RAISE EXCEPTION 'Ошибка.Должен быть введен только один из параметров Кол.дней или Кол.месяцев.';
   END IF;
   
   -- сохранили <Объект>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_PartionDateKind(), inCode, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Day(), inId, inDay);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Month(), inId, inMonth);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.07.19         * inMonth
 15.07.19                                                       *
 19.04.19         * 
*/

-- тест
--