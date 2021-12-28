-- Function: gpUpdate_Object_CardFuel_kind(Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpUpdate_Object_CardFuel_kind (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CardFuel_kind(
    IN inId                Integer   , -- Ключ объекта <Топливные карты>
    IN inCardFuelKindId    Integer   , -- Cтатус
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CardFuel());

   -- сохранили связь с <Статус>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_CardFuelKind(), inId, inCardFuelKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.21         *
*/

-- тест
--