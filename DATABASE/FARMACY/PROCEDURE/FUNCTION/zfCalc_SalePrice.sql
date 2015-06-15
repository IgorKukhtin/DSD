-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePrice(
    IN inPriceWithVAT        TFloat    , -- Цена С НДС
    IN inMarginPercent       TFloat    , -- % наценки
    IN inIsTop               Boolean   , -- ТОП позиция
    IN inPercentMarkup       TFloat    , -- % наценки у товара
    IN inJuridicalPercent    TFloat    , -- % корректировки у Юр Лица для топа
    IN inPrice               TFloat      -- Цена у товара
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
BEGIN
     IF COALESCE(inPrice, 0) <> 0 THEN 
        RETURN inPrice;
     END IF;

     -- расчет % наценки
   
     IF inIsTop THEN 
        vbPercent := COALESCE(inPercentMarkup, 0) - COALESCE(inJuridicalPercent, 0);
     ELSE
        vbPercent := COALESCE(inMarginPercent, 0);
     END IF;

     RETURN (ROUND((100 + vbPercent) * inPriceWithVAT / 100, 1));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePrice(TFloat, TFloat, Boolean, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.15                        * 
 13.04.15                        * 
*/
/*
-- тест
*/