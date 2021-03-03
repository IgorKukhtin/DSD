-- Function: zfCalc_RateFuelValue

--DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat);
--DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePrice(
    IN inPriceWithVAT        TFloat    , -- Цена С НДС
    IN inMarginPercent       TFloat    , -- % наценки в КАТЕГОРИИ
    IN inIsTop               Boolean   , -- ТОП позиция
    IN inPercentMarkup       TFloat    , -- % наценки у товара
    IN inJuridicalPercent    TFloat    , -- % корректировки у Юр Лица для ТОПа
    IN inPrice               TFloat    , -- Цена у товара (фиксированная)
    IN inPriceMax            TFloat      -- Максимальная цена для товара
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
  DECLARE vbPrice TFloat;
BEGIN
     -- !!!Цена у товара (фиксированная)!!!
     IF COALESCE(inPrice, 0) <> 0 THEN 
        RETURN inPrice;
     END IF;

     -- расчет % наценки
     IF inIsTop THEN
        -- для ТОП = % наценки у товара - % корректировки у Юр Лица для топа
        vbPercent := COALESCE (inPercentMarkup, 0) - COALESCE (inJuridicalPercent, 0);
     ELSE
        -- остальные = % наценки в КАТЕГОРИИ
        vbPercent := COALESCE (inMarginPercent, 0);
     END IF;

     -- вернули цену
     IF (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1)) < inPriceWithVAT
     THEN
       vbPrice := (CEIL((100 + vbPercent) * inPriceWithVAT / 10) / 10.0);     
     ELSE
       vbPrice := (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1));
     END IF;
     
     IF inPriceMax IS NOT NULL AND COALESCE (inPriceMax, 0) > 0 AND inPriceMax < vbPrice
     THEN
       vbPrice := inPriceMax;
     END IF;
     
     RETURN vbPrice;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.02.21                                                       * 
 10.06.15                        * 
 13.04.15                        * 
*/
-- тест select zfCalc_SalePrice(0.41, 4, False, 0, 0, 0, 0.0) 