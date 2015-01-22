-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings_PriceList(Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings_PriceList(Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettings_PriceList(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Установки для ценовых групп>
    IN inJuridicalId             Integer   ,    -- Юр. лицо
    IN inMainJuridicalId         Integer   ,    -- Юр. лицо
    IN inContractId              Integer   ,    -- Договор
    IN inisPriceClose            Boolean   ,    -- Закрыт прайс
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettings(), 0, '');

   -- сохранили связь с <Торговой сетью>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Retail(), ioId, vbObjectId);

   -- сохранили связь с <Юр. лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Juridical(), ioId, inJuridicalId);

   -- сохранили связь с <Юр. лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_MainJuridical(), ioId, inMainJuridicalId);

   -- сохранили связь с <Договор>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Contract(), ioId, inContractId);

   -- % бонусирования
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceClose(), ioId, inisPriceClose);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_JuridicalSettings_PriceList(Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.15                          *
 13.10.14                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalSettings ()                            
