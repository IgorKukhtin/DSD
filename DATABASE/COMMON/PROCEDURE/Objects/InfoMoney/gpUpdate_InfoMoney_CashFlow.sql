-- Function: gpUpdate_InfoMoney_CashFlow()

DROP FUNCTION IF EXISTS gpUpdate_InfoMoney_CashFlow(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_InfoMoney_CashFlow(
    IN inId                  Integer   ,    -- ключ объекта
    IN inCashFlowId_in       Integer   ,    -- 
    IN inCashFlowId_out      Integer   ,    -- 
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_InfoMoney_CashFlow());
   
   -- сохранили связь с <Статья отчета ДДС расход>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_in(), ioId, inCashFlowId_in);
   -- сохранили связь с <Статья отчета ДДС приход>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_out(), ioId, inCashFlowId_out);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.20         *
*/