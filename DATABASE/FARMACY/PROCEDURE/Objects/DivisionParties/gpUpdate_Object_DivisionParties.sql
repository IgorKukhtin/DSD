-- Function: gpInsertUpdate_Object_DivisionParties (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DivisionParties (Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DivisionParties(
    IN inId              Integer   ,    -- ключ объекта <>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- название
    IN inisBanFiscalSale Boolean   ,    -- Запрет фискальной продажи
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDay Integer;
   DECLARE vbMonth Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_DivisionParties());

   -- сохранили <Объект>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_DivisionParties(), inCode, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DivisionParties_BanFiscalSale(), inId, inBanFiscalSale);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.07.19                                                       *
*/

-- тест
--