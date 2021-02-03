-- Function: gpUpdate_MI_OrderInternalPromo_PriceAdjustment()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_PriceAdjustment (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_PriceAdjustment(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPriceAdjustment     TFloat    , -- Кореектировка цены прайса, -% или +%
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inPriceAdjustment, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка.Не введен процент.';    
    END IF;
    
    
    --сохраняем данные в мастере
    PERFORM lpInsertUpdate_MI_OrderInternalPromo
                                                 (ioId                 := MovementItem.Id
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := MovementItem.ObjectId
                                                , inJuridicalId        := MILinkObject_Juridical.ObjectId
                                                , inContractId         := MILinkObject_Contract.ObjectId
                                                , inAmount             := MovementItem.Amount
                                                , inPromoMovementId    := MIFloat_PromoMovementId.ValueData
                                                , inPrice              := Round(MIFloat_Price.ValueData * (100.0 + inPriceAdjustment) / 100, 2) :: TFloat
                                                , inUserId             := vbUserId
                                                )
    FROM MovementItem
         
         LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                     ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                    AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                          ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                         AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                          ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                         AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.02.21                                                       *
*/

--select * from gpUpdate_MI_OrderInternalPromo_PriceAdjustment(inMovementId := 21065554 , inPriceAdjustment := 10 ,  inSession := '3');