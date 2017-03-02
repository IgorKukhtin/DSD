-- Function: gpInsertUpdate_Object_Client (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Покупатели> 
    IN inTotalCount               TFloat    ,    -- Итого количество
    IN inTotalSumm                TFloat    ,    -- Итого Сумма
    IN inTotalSummDiscount        TFloat    ,    -- Итого Сумма скидки
    IN inTotalSummPay             TFloat    ,    -- Итого Сумма оплаты
    IN inLastCount                TFloat    ,    -- Количество в последней покупке
    IN inLastSumm                 TFloat    ,    -- Сумма последней покупки
    IN inLastSummDiscount         TFloat    ,    -- Сумма скидки в последней покупке
    IN inLastDate                 TDateTime ,    -- Последняя дата покупки
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);

 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalCount(), ioId, inTotalCount);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSumm(), ioId, inTotalSumm);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummDiscount(), ioId, inTotalSummDiscount);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummPay(), ioId, inTotalSummPay);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), ioId, inLastCount);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), ioId, inLastSumm);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), ioId, inLastSummDiscount);
 -- сохранили 
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), ioId, inLastDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
01.03.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
