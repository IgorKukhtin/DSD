-- Function: gpUpdate_Unit_isGoodsUKTZEDRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isGoodsUKTZEDRRO(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isGoodsUKTZEDRRO(
    IN inId                      Integer   ,    -- ключ объекта <Подразделение>
    IN inisGoodsUKTZEDRRO        Boolean   ,    -- Запрет на печать чека, если есть позиция по УКТВЭД
   OUT outisGoodsUKTZEDRRO       Boolean   ,
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisGoodsUKTZEDRRO:= NOT inisGoodsUKTZEDRRO;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_GoodsUKTZEDRRO(), inId, outisGoodsUKTZEDRRO);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.03.21                                                       *
*/