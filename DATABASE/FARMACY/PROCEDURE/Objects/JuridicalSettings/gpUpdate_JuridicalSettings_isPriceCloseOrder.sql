-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isPriceCloseOrder(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isPriceCloseOrder(
    IN inId                     Integer   ,    -- ключ объекта <Подразделение>
    IN inisPriceCloseOrder      Boolean   ,    -- правйс закрыт для автопереоценки
   --OUT outisPriceCloseOrder     Boolean   ,
    IN inSession                TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   --outisPriceCloseOrder:= NOT inisPriceCloseOrder;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder(), inId, inisPriceCloseOrder);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.18         *
*/