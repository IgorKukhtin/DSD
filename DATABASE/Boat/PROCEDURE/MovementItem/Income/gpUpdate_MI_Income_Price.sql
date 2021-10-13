 -- Function: gpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_Price(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount                TFloat    , -- 
    IN ioOperPrice_orig        TFloat    , -- Цена вх.
 INOUT ioDiscountTax           TFloat    , -- % скидки
 INOUT ioOperPrice             TFloat    , -- Цена вх. с учетом скидки в элементе
 INOUT ioSummIn                TFloat    , -- Сумма вх. с учетом скидки
 INOUT inSummIn_inf              TFloat    , -- сумма вспомогательная
    IN inOperPriceList            TFloat    , -- Цена продажи
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperPrice_orig TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbSummIn TFloat;
   DECLARE vbAmount TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());
     vbUserId := lpGetUserBySession (inSession);


     -- проверка - документ должен быть сохранен
     IF COALESCE (inId, 0) = 0 THEN 

        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не сохранен.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_MI_Income_Price'   :: TVarChar
                                              , inUserId        := vbUserId);
     END IF;


     -- Получаем сохраненные параметры
     vbOperPrice_orig:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPrice_orig());
     vbDiscountTax   := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_DiscountTax());
     vbOperPrice     := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPrice());
     vbSummIn        := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummIn());
     vbAmount        := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master());

     -- сохранили свойство <OperPriceList>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), inId, inOperPriceList);

--RAISE EXCEPTION '0. vbOperPrice_orig <%>  vbDiscountTax <%>  vbOperPrice <%>  vbSummIn <%>  vbAmount <%>' , vbOperPrice_orig, vbDiscountTax, vbOperPrice, vbSummIn , vbAmount;


/*
Нов св-ва zc_MI_Master - c_Movement_Income - для них все вводится в эдит форме - 
1) кол-во 
2)OperPrice_orig 
3)DiscountTax  
4)OperPrice 
5)SummIn 
6)OperPriceList

 - с авто пересчетом, 
 1) если заполнили контрол DiscountTax  - пересчитали 4и5 
 2) если заполнили контрол OperPrice  - пересчитали 3и5 
 3) если заполнили контрол SummIn  - пересчитали 4 и в 3 поставили 0 
 4) если заполнили контрол кол-во или OperPrice_orig - 4 и 5 пересчитали и они будуи другими если в DiscountTax <> 0 
 
 ДЛЯ определения какой именно контрол меняется - каждый раз вызваем проц в которой делается селект и определяется какой параметр изменился,
  в конце все значения сохраняем, при следующем вызове - опять выз проц  и можно сразу определить какой контрол меняется
*/


     IF COALESCE (vbAmount,0) <> COALESCE (inAmount,0) OR COALESCE (vbOperPrice_orig,0) <> COALESCE (ioOperPrice_orig,0)
     THEN

         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         ioSummIn    := (inAmount * ioOperPrice) ::TFloat;

         -- пересохранили <Элемент документа>
         PERFORM lpInsertUpdate_MovementItem (inId
                                             , zc_MI_Master()
                                             , (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master()) --inGoodsId
                                             , inId
                                             , (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.DescId = zc_MI_Master())--inMovementId
                                             , inAmount
                                             , NULL
                                             , vbUserId
                                             );
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);
             
         RETURN;
     END IF;

     IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
     THEN
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         ioSummIn    := (inAmount * ioOperPrice) ::TFloat;
   
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);
         
     --  RAISE EXCEPTION ' 1. ioOperPrice_orig <%>  ioDiscountTax <%>  ioOperPrice <%>  vbSummIn <%>  inAmount <%>' , ioOperPrice_orig, ioDiscountTax, ioOperPrice, ioSummIn , inAmount;

         RETURN;
     END IF;
     
     IF COALESCE (vbOperPrice,0) <> COALESCE (ioOperPrice,0)
     THEN
         ioDiscountTax := CASE WHEN COALESCE (ioOperPrice_orig,0) <> 0 THEN ((ioOperPrice_orig - ioOperPrice) * 100 / ioOperPrice_orig) ELSE 0 END ::TFloat;
         ioSummIn      := (inAmount * ioOperPrice) ::TFloat;
        
         --inSummIn_inf:= ioSummIn;

         --RAISE EXCEPTION ' 2. ioOperPrice_orig <%>  ioDiscountTax <%>  ioOperPrice <%>  vbSummIn <%>  inAmount <%>' , ioOperPrice_orig, ioDiscountTax, ioOperPrice, ioSummIn , inAmount;
         vbDiscountTax := ioDiscountTax;
         vbSummIn    := ioSummIn;
         vbOperPrice:=ioOperPrice;

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);
    --  RAISE EXCEPTION ' 2. ioOperPrice_orig <%>  ioDiscountTax <%>  ioOperPrice <%>  vbSummIn <%>  inAmount <%>' , ioOperPrice_orig, ioDiscountTax, ioOperPrice, ioSummIn , inAmount;

         RETURN;
     END IF;
/*
--RAISE EXCEPTION ' inSummIn_inf.  <%>  ' , inSummIn_inf;
IF COALESCE (ioSummIn,0) = COALESCE (inSummIn_inf,0)
THEN 
     RETURN;
END IF;

     IF COALESCE (vbSummIn,0) <> COALESCE (ioSummIn,0) --AND (COALESCE (inSummIn_inf,0) <> COALESCE (ioSummIn,0))
     THEN
         ioOperPrice   := CASE WHEN COALESCE (inAmount,0) <> 0 THEN ioSummIn /inAmount ELSE 0 END ::TFloat;
         ioDiscountTax := 0 ::TFloat;
         ioOperPrice_orig := ioOperPrice ::TFloat;

         inSummIn_inf:= ioSummIn;

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, ioOperPrice_orig);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);

         RETURN;
     END IF;
*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.21         *
*/

-- тест
-- 
