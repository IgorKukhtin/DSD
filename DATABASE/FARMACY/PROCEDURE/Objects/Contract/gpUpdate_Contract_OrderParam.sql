-- Function: gpUpdate_Contract_OrderParam()

DROP FUNCTION IF EXISTS gpUpdate_Contract_OrderParam (Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Contract_OrderParam(
    IN inId                      Integer   ,   	-- ключ объекта <Договор>
    IN inOrderSumm               TFloat    ,    -- минимальная сумма для заказа
    IN inOrderSummComment        TVarChar  ,    -- Примечание к минимальной сумме для заказа
    IN inOrderTime               TVarChar  ,    -- информативно - максимальное время отправки
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= inSession;

   -- проверка
   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- сохранили свойство <минимальная сумма для заказа>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_OrderSumm(), inId, inOrderSumm);

   -- сохранили свойство <информативно - максимальное время отправки>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderTime(), inId, inOrderTime);
      -- сохранили свойство <Примечание к минимальной сумме для заказа>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderSumm(), inId, inOrderSummComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.17         *
*/

-- тест
-- 
