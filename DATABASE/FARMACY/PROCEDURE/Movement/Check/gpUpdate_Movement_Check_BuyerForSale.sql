-- Function: gpUpdate_Movement_Check_BuyerForSale()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_BuyerForSale (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_BuyerForSale(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inBuyerForSaleId    Integer   , -- Подразделени
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSale(), inId, inBuyerForSaleId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.06.22                                                       *
*/
-- тест
-- select * from gpUpdate_Movement_Check_BuyerForSale(inId := 7784533 , inBuyerForSaleId := 183294 ,  inSession := '3');