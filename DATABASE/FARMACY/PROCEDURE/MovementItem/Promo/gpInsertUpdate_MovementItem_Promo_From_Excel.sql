-- Function: gpInsertUpdate_MovementItem_Promo_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo_From_Excel (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo_From_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inGoodsCode           Integer   , -- Код товара
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
	 
    vbGoodsId := 0;
     --поискали товар по коду
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    Select Id INTO vbGoodsId from Object_Goods_View Where ObjectId = vbObjectId AND GoodsCodeInt = inGoodsCode;
    --проверили, а есть ли такой товар в базе
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    END IF;
    
    IF inAmount is not null AND (inAmount < 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Количество <%> не может быть меньше нуля.', inAmount;
    END IF;
    
    IF inPrice is not null AND (inPrice < 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Цена <%> не может быть меньше нуля.', inPrice;
    END IF;
    SELECT Id INTO vbId from MovementItem Where MovementId = COALESCE(inMovementId,0) AND ObjectId = vbGoodsId;
    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_Promo (ioId                 := COALESCE(vbId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := vbGoodsId
                                                 , inAmount             := inAmount
                                                 , inPrice              := inPrice
                                                 , inIsChecked          := False
                                                 , inUserId             := vbUserId);
    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Promo_From_Excel (Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
  25.04.16        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Promo (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inSession:= '2')
