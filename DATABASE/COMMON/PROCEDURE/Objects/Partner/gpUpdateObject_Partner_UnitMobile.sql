-- Function: gpUpdateObject_Partner_UnitMobile()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_UnitMobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_UnitMobile(
    IN inId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inUnitMobileId        Integer   ,    -- Прайс-лист
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_UnitMobile());
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_UnitMobile(), inId, inUnitMobileId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.09.21         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_UnitMobile()
