-- Function: gpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- % скидки на товар
 INOUT ioPrice               TFloat    , --Цена в прайсе
   OUT outPriceWithOutVAT    TFloat    , --Цена отгрузки без учета НДС, с учетом скидки, грн
   OUT outPriceWithVAT       TFloat    , --Цена отгрузки с учетом НДС, с учетом скидки, грн
    IN inAmountReal          TFloat    , --Объем продаж в аналогичный период, кг
    IN inAmountPlanMin       TFloat    , --Минимум планируемого объема продаж на акционный период (в кг)
    IN inAmountPlanMax       TFloat    , --Максимум планируемого объема продаж на акционный период (в кг)
    IN inGoodsKindId         TFloat    , --ИД обьекта <Вид товара>
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoGoods());
    vbUserId := inSession;
    --Проверили уникальность товар/вид товара
    IF EXISTS(SELECT 1 
              FROM
                  MovementItem_PromoGoods_View AS MI_PromoGoods
              WHERE
                  MI_PromoGoods.MovementId = inMovementId
                  AND
                  MI_PromoGoods.GoodsId = inGoodsId
                  AND
                  COALESCE(MI_PromoGoods.GoodsKindId,0) = COALESCE(inGoodsKindId,0)
                  AND
                  MI_PromoGoods.Id = COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже указана скидка на выбранный товар <%> и вид товара <%>.', (SELECT ValueData FROM Object WHERE id = inGoodsId),(SELECT ValueData FROM Object WHERE id = inGoodsKindId);
    END IF;
    -- сохранили
    ioId := lpInsertUpdate_MovementItem_PromoGoods (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := inPrice
                                            , inPriceWithOutVAT    := inPriceWithOutVAT
                                            , inPriceWithVAT       := inPriceWithVAT
                                            , inAmountReal         := inAmountReal
                                            , inAmountPlanMin      := inAmountPlanMin
                                            , inAmountPlanMax      := inAmountPlanMax
                                            , inGoodsKindId        := inGoodsKindId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.10.15                                                                         *
*/