-- Function: gpUpdate_InfoMoney_ProfitLoss()

DROP FUNCTION IF EXISTS gpUpdate_InfoMoney_ProfitLoss(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_InfoMoney_ProfitLoss(
    IN inId                  Integer   ,    -- ключ объекта
    IN inisProfitLoss        Boolean   ,    -- 
   OUT outisProfitLoss       Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_InfoMoney_ProfitLoss());
   
   -- определили признак
   outisProfitLoss:= NOT inisProfitLoss;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_ProfitLoss(), inId, outisProfitLoss);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.12.18         *
*/