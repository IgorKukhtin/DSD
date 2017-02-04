-- Function: gpInsertUpdate_MovementItem_PromoUnit_From_Excel()
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_From_Excel (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_From_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inUnitId              Integer   , -- Ключ подразделения
    IN inGoodsCode           Integer   , -- Код товара
    IN inAmount              TFloat    , -- Количество
    IN inAmountPlanMax       TFloat    , -- кол-во для премии
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbPrice TFloat;
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

    -- нашли цену товара
    vbPrice := (SELECT Object_Price_View.Price FROM Object_Price_View WHERE Object_Price_View.UnitId = inUnitId AND Object_Price_View.GoodsId = vbGoodsId);
    
    IF inAmount is not null AND (inAmount < 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Количество <%> не может быть меньше нуля.', inAmount;
    END IF;
    

    SELECT Id INTO vbId from MovementItem Where MovementId = COALESCE(inMovementId,0) AND ObjectId = vbGoodsId;

    -- сохранили <Элемент документа>
    PERFORM lpInsertUpdate_MovementItem_PromoUnit (ioId                 := COALESCE(vbId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := vbGoodsId
                                                 , inAmount             := inAmount
                                                 , inAmountPlanMax      := inAmountPlanMax
                                                 , inPrice              := COALESCE(vbPrice,0) ::TFloat
                                                 , inComment            := '' ::TVarChar
                                                 , inUserId             := vbUserId
                                                );

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
  04.02.17        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PromoUnit (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inSession:= '2')
