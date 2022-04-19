-- Function: gpUpdate_MovementItem_Sale_PriceSale()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_PriceSale (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_PriceSale (
  IN inId          integer,
  IN inMovementId  integer,
  IN inPriceSale   TFloat,
  IN inSession     TVarChar
)
RETURNS void AS
$body$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 4183126 <> inSession::Integer AND 235009  <> inSession::Integer AND 183242  <> inSession::Integer 
    THEN
      RAISE EXCEPTION 'Изменение <Цена без скидки> вам запрещено.';
    END IF;
            
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    -- Провкряем элемент по документу
    IF COALESCE (inId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION 'Не найден элемент по документe';
    END IF;

    IF inPriceSale < 0
    THEN
        RAISE EXCEPTION 'Цена должна быть положительной или равно нолю.';
    END IF;      

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), inId, inPriceSale);

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.04.22                                                       *               
*/
  