-- Function: gpUpdate_IncomeHouseholdInventory_CountForPrice()

DROP FUNCTION IF EXISTS gpUpdate_IncomeHouseholdInventory_CountForPrice (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IncomeHouseholdInventory_CountForPrice(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inHouseholdInventoryId  Integer   , -- Хозяйственный инвентарь
    IN inCountForPrice         TFloat    , -- Себестоимость 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory());

    IF COALESCE (inId, 0) = 0 OR COALESCE (inCountForPrice, 0) <> 0
    THEN
        RETURN;    
    END IF;
    
    inCountForPrice := COALESCE ((SELECT ObjectFloat_CountForPrice.ValueData FROM ObjectFloat AS ObjectFloat_CountForPrice
                                  WHERE ObjectFloat_CountForPrice.ObjectId = inHouseholdInventoryId
                                    AND ObjectFloat_CountForPrice.DescId = zc_ObjectFloat_HouseholdInventory_CountForPrice()), 0);

    IF COALESCE (inCountForPrice, 0) = 0
    THEN
        RETURN;    
    END IF;

    -- Сохранили <Себестоимость>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, inCountForPrice);
      
    -- пересчитали Итоговые суммы по документу
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
     
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_IncomeHouseholdInventory_CountForPrice (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                      *
*/

-- тест
-- select * from gpUpdate_IncomeHouseholdInventory_CountForPrice(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
