-- Function: gpInsertUpdate_Object_Goods_Retail()

DROP FUNCTION IF EXISTS lpInsertUpdate_Goods_CountPrice (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Goods_CountPrice(
    IN inPriceListId         Integer    ,    -- ключ объекта <Прайс лист>
    IN inOperDate            TDateTime  ,    -- Код объекта <дата прайса>
    IN inGoodsId             Integer        -- товар
)
RETURNS Void
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbCountPrice TFloat;
BEGIN

     vbCountPrice:= (COALESCE ((SELECT Count(Movement.Id)
                                FROM Movement 
		                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
				      AND MovementItem.DescId     = zc_MI_Master()
				      AND MovementItem.isErased   = False
                                      AND MovementItem.ObjectId = inGoodsId
		                WHERE DATE_TRUNC ('DAY',Movement.OperDate) = DATE_TRUNC ('DAY', inOperDate)
	                          AND Movement.DescId = zc_Movement_PriceList()
	                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND Movement.Id <> inPriceListId
                                ), 0) + 1) :: TFloat;
      

     -- сохранили еще свойства для <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountPrice(), inGoodsId, vbCountPrice);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.17         *
*/
-- тест
-- SELECT * FROM lpInsertUpdate_Goods_CountPrice
