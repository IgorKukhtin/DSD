-- Function: gpInsertUpdate_MovementItem_PromoUnit_From_Excel()
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_From_Excel (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_From_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inUnitCategoryId      Integer   , -- Ключ категории
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
   DECLARE vbAddBonusPercent TFloat;
   DECLARE vbisFixedPercent boolean;
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
    
    IF NOT EXISTS(SELECT * FROM ObjectLink AS ObjectLink_Unit_Category
                            WHERE ObjectLink_Unit_Category.ChildObjectId = inUnitCategoryId 
                            AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category())
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найдены подразделения с категорией <%>', 
          (SELECT Object_UnitCategory.ValueData FROM Object AS Object_UnitCategory             
                                               WHERE Object_UnitCategory.id = inUnitCategoryId);
    END IF;

    -- нашли цену товара
    vbPrice := (SELECT ROUND(SUM(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                      THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE Price_Value.ValueData END) / COUNT(*), 2)::TFloat  AS Price 
                FROM ObjectLink AS ObjectLink_Price_Unit
                     INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                             ON ObjectLink_Unit_Category.ObjectId = ObjectLink_Price_Unit.ChildObjectId
                            AND ObjectLink_Unit_Category.ChildObjectId = inUnitCategoryId 
                            AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
                     LEFT JOIN ObjectLink AS Price_Goods
                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                     LEFT JOIN ObjectFloat AS Price_Value
                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                     -- Фикс цена для всей Сети
                     LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                             ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                            AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                  AND Price_Goods.ChildObjectId = vbGoodsId);
    
    IF inAmount is not null AND (inAmount < 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Количество <%> не может быть меньше нуля.', inAmount;
    END IF;
    

    SELECT Id INTO vbId from MovementItem Where MovementId = COALESCE(inMovementId,0) AND ObjectId = vbGoodsId;
    
    vbisFixedPercent := COALESCE ((SELECT MovementItemBoolean.ValueData FROM MovementItemBoolean
                                   WHERE MovementItemBoolean.MovementItemId = vbId
                                     AND MovementItemBoolean.DescId = zc_MIBoolean_FixedPercent()) , False);
                                     
    vbAddBonusPercent := COALESCE ((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                    WHERE MovementItemFloat.MovementItemId = vbId
                                      AND MovementItemFloat.DescId = zc_MIBoolean_FixedPercent()) , 0);
                    

    -- сохранили <Элемент документа>
    PERFORM lpInsertUpdate_MovementItem_PromoUnit (ioId                 := COALESCE(vbId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := vbGoodsId
                                                 , inAmount             := inAmount
                                                 , inAmountPlanMax      := inAmountPlanMax
                                                 , inPrice              := COALESCE(vbPrice,0) ::TFloat
                                                 , inComment            := '' ::TVarChar
                                                 , inisFixedPercent     := vbisFixedPercent
                                                 , inAddBonusPercent    := vbAddBonusPercent
                                                 , inUserId             := vbUserId
                                                );

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий ОВ.
  11.05.18                                                                                    * 
  12.06.17        * ушли от Object_Price_View
  04.02.17        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PromoUnit (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inSession:= '2')