-- Function: gpGet_MI_Income_Price()

DROP FUNCTION IF EXISTS gpGet_MI_Income_Price (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_Price(
 INOUT ioAmount              TFloat    , --
 INOUT ioOperPrice_orig      TFloat    , -- Вх. цена без скидки
    IN inCountForPrice       TFloat    , -- Цена за кол.
 INOUT ioDiscountTax         TFloat    , -- % скидки
 INOUT ioOperPrice           TFloat    , -- Вх. цена с учетом скидки в элементе
 INOUT ioSummIn              TFloat    , -- Сумма вх. с учетом скидки
    IN inAmount_old          TFloat    , --
    IN inOperPrice_orig_old  TFloat    , --
    IN inDiscountTax_old     TFloat    , --
    IN inOperPrice_old       TFloat    , --
    IN inSummIn_old          TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN
     -- если ничего не поменялось сразу выходим
     IF inAmount_old = ioAmount AND inOperPrice_orig_old = ioOperPrice_orig AND inDiscountTax_old = ioDiscountTax AND inOperPrice_old = ioOperPrice AND inSummIn_old = ioSummIn
     THEN
         RETURN;
     END IF;


     -- если Кол-во
     IF COALESCE (inAmount_old,0) <> COALESCE (ioAmount,0) OR COALESCE (inOperPrice_orig_old,0) <> COALESCE (ioOperPrice_orig,0)
     THEN
         -- Вх. цена с учетом скидки в элементе
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         -- Сумма вх. с учетом скидки
         ioSummIn    := (ioAmount * ioOperPrice) ::TFloat;

     -- если % скидки
     ELSEIF COALESCE (inDiscountTax_old,0) <> COALESCE (ioDiscountTax,0)
     THEN
         -- Вх. цена с учетом скидки в элементе
         ioOperPrice := (ioOperPrice_orig * (1 - ioDiscountTax / 100)) ::TFloat;
         -- Сумма вх. с учетом скидки
         ioSummIn    := (ioAmount * ioOperPrice) ::TFloat;

     -- если Вх. цена с учетом скидки в элементе
     ELSEIF COALESCE (inOperPrice_old,0) <> COALESCE (ioOperPrice,0)
     THEN
         -- % скидки
         ioDiscountTax := CASE WHEN COALESCE (ioOperPrice_orig,0) <> 0 THEN ((ioOperPrice_orig - ioOperPrice) * 100 / ioOperPrice_orig) ELSE 0 END ::TFloat;
         -- Сумма вх. с учетом скидки
         ioSummIn      := (ioAmount * ioOperPrice) ::TFloat;

     -- если Сумма вх. с учетом скидки
     ELSEIF COALESCE (inSummIn_old,0) <> COALESCE (ioSummIn,0)
     THEN
         -- % скидки - обнулили
         ioDiscountTax := 0 ::TFloat;
         -- Вх. цена с учетом скидки в элементе
         ioOperPrice   := CASE WHEN COALESCE (ioAmount,0) <> 0 THEN ioSummIn /ioAmount ELSE 0 END ::TFloat;

     END IF;

  --RAISE EXCEPTION '0. SummIn <%>  ioOperPrice <%>  ioDiscountTax <%> ioOperPrice_orig <%> ' , ioSummIn, ioOperPrice, ioDiscountTax, ioOperPrice_orig;

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
