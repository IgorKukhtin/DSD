-- Function: gpInsertUpdate_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceGroupSettings(Integer, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceGroupSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Установки для ценовых групп>
    IN inName                    TVarChar  ,    -- Название
    IN inMinPrice                TFloat    ,    -- Минимальная цена
    IN inPercent                 TFloat    ,    -- Процент
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PriceGroupSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceGroupSettings(), 0, inName);

   -- сохранили связь с <Торговой сетью>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceGroupSettings_Retail(), ioId, vbObjectId);

   -- Минимальная цена
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PriceGroupSettings_MinPrice(), ioId, inMinPrice);

   -- %
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PriceGroupSettings_Percent(), ioId, inPercent);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PriceGroupSettings(Integer, TVarChar, TFloat, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceGroupSettings ()                            
