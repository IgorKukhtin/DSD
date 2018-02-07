-- Function: gpInsertUpdate_Object_Goods_Retail()

DROP FUNCTION IF EXISTS lpInsertUpdate_Goods_CountPrice (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Goods_CountPrice(
    IN inPriceListId         Integer    ,    -- ключ Документа <Прайс лист>
    IN inOperDate            TDateTime  ,    -- Код объекта <дата прайса>
    IN inGoodsId             Integer        -- товар
)
RETURNS Void
AS
$BODY$
   DECLARE vbObjectId   Integer;
   DECLARE vbCountPrice TFloat;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate    TDateTime;
BEGIN
     vbStartDate:= DATE_TRUNC ('DAY', inOperDate);
     vbEndDate:=   DATE_TRUNC ('DAY', inOperDate) + INTERVAL '1 DAY';
     -- 
     vbCountPrice:= (COALESCE ((SELECT Count(Movement.Id)
                                FROM Movement 
		                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
				      AND MovementItem.DescId   = zc_MI_Master()
				      AND MovementItem.isErased = FALSE
                                      AND MovementItem.ObjectId = inGoodsId
		                -- WHERE DATE_TRUNC ('DAY',Movement.OperDate) = DATE_TRUNC ('DAY', inOperDate)
		                WHERE Movement.OperDate >= vbStartDate AND Movement.OperDate < vbEndDate
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
