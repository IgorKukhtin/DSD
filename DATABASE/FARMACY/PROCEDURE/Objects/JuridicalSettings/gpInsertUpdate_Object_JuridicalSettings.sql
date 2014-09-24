-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Установки для ценовых групп>
    IN inJuridicalId             Integer   ,    -- Юр. лицо
    IN inBonus                   TFloat    ,    -- % бонусирования
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

   -- % бонусирования
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_Bonus(), ioId, inBonus);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_JuridicalSettings(Integer, Integer, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalSettings ()                            
