-- Function: gpUpdate_MovementItem_PromoGoods_Plan()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Plan (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Plan(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inAmountPlan1           TFloat    , --
    IN inAmountPlan2           TFloat    , --
    IN inAmountPlan3           TFloat    , --
    IN inAmountPlan4           TFloat    , --
    IN inAmountPlan5           TFloat    , --
    IN inAmountPlan6           TFloat    , --
    IN inAmountPlan7           TFloat    , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

    -- сохраняем 
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan1(), inId, inAmountPlan1);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan2(), inId, inAmountPlan2);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan3(), inId, inAmountPlan3);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan4(), inId, inAmountPlan4);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan5(), inId, inAmountPlan5);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan6(), inId, inAmountPlan6);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan7(), inId, inAmountPlan7);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 10.11.17         *
*/