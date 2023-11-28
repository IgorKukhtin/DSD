-- Function: gpInsertUpdate_MI_Loss_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Loss_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Loss_From_Excel(
    IN inMovementId               Integer   ,    -- Идентификатор документа

    IN inGoodsCode                TVarChar  ,    -- Код товара

    IN inAmount                   TVarChar  ,    -- Количкство
    IN inPriceIn                  TVarChar  ,    -- Цена прихода (с НДС)

    IN inPriceSale                TVarChar  ,    -- Цена реализации
    
    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbMovementItemId Integer;
   
   DECLARE vbAmount TFloat;
   DECLARE vbPriceIn TFloat;
   DECLARE vbPriceSale TFloat;

   DECLARE vbIsInsert Boolean;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpGetUserBySession (inSession);
  
  -- определяется <Торговая сеть>
  vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
  
  IF COALESCE(inGoodsCode, '') = ''
  THEN
    RETURN;
  END IF;
    
  -- Определим ID товара  
  BEGIN  
    SELECT Object_Goods_Retail.Id
    INTO vbGoodsId
    FROM Object_Goods_Main AS Object_Goods_Main 
    
         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId  = Object_Goods_Main.Id
                                      AND Object_Goods_Retail.RetailId     = vbObjectId
               
    WHERE Object_Goods_Main.ObjectCode = inGoodsCode::Integer;
  EXCEPTION WHEN others THEN 
    vbGoodsId := Null;
  END;
  
  -- парсим количество
  BEGIN  
    vbAmount := REPLACE(REPLACE(inAmount, ' ', ''), ',', '.')::TFloat;
  EXCEPTION WHEN others THEN 
    vbAmount := 0;
  END;

  -- парсим цену
  IF vbUserId IN (3, 59591, 183242, 4183126)
  THEN
    BEGIN  
      vbPriceIn := REPLACE(REPLACE(inPriceIn, ' ', ''), ',', '.')::TFloat;
    EXCEPTION WHEN others THEN 
      vbPriceIn := 0;
    END;
  ELSE
    vbPriceIn := 0;
  END IF;
  
  -- парсим цену
  IF vbUserId IN (3, 59591, 183242, 4183126)
  THEN
    BEGIN  
      vbPriceSale := REPLACE(REPLACE(inPriceSale, ' ', ''), ',', '.')::TFloat;
    EXCEPTION WHEN others THEN 
      vbPriceSale := 0;
    END;
  ELSE
    vbPriceSale := 0;
  END IF;
  
  SELECT MovementItem.Id
  INTO vbMovementItemId 
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = vbGoodsId;

  -- определяется признак Создание/Корректировка
  vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
  

  -- сохранили <Элемент документа>
  vbMovementItemId := lpInsertUpdate_MovementItem_Loss (vbMovementItemId, inMovementId, vbGoodsId, vbAmount, vbUserId);

  -- сохранили свойство <Цена отпускная>
  IF COALESCE (vbPriceSale, 0) > 0
  THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, vbPriceSale);  
  END IF;


  -- сохранили свойство <Цена прихода (с НДС)>
  IF COALESCE (vbPriceIn, 0) > 0
  THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn(), vbMovementItemId, vbPriceIn);  
  END IF;

  -- сохранили протокол
  PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

                                                          
  /*RAISE EXCEPTION  'Value 03: <%> <%> <%> <%>', vbGoodsId, vbAmount, vbPrice, vbPriceSale;     
  
   IF inSession = '3'
   THEN
      RAISE EXCEPTION 'Прошло.';
   END IF;*/
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.11.2023                                                     *
*/

-- тест

-- select * from gpInsertUpdate_MI_Loss_From_Excel(inMovementId := 34111475 , inGoodsCode := '42645' , inAmount := '1' , inPriceIn := '358.8' , inPriceSale := '' ,  inSession := '3');
