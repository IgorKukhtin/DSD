-- Function: zfCalc_SalePriceSiteUnit

DROP FUNCTION IF EXISTS zfCalc_SalePriceSiteUnit(TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SalePriceSiteUnit(
    IN inPriceWithVAT        TFloat    , -- Цена С НДС
    IN inMarginPercent       TFloat    , -- % наценки в КАТЕГОРИИ
    IN inIsTop               Boolean   , -- ТОП позиция
    IN inIsSpecial           Boolean   , -- позиция со спец условиями
    IN inPercentMarkup       TFloat    , -- % наценки у товара
    IN inPercentMarkupPrice  TFloat    , -- % наценки у товара для сайта
    IN inPrice               TFloat    , -- Цена у товара (фиксированная)
    IN inPriceGods           TFloat    , -- Цена у товара (фиксированная пл сети)
    IN inPriceMax            TFloat      -- Максимальная цена для товара
)
RETURNS TFloat AS
$BODY$
  DECLARE vbPercent TFloat;
  DECLARE vbPrice TFloat;
BEGIN

          -- !!!Цена у товара (фиксированная)!!!
     IF COALESCE(inPrice, 0) <> 0  THEN 
        RETURN inPrice;
     END IF;
     
          -- !!!Цена у товара (спец условия)!!!
     IF inIsSpecial = True AND COALESCE(inPriceGods, 0) <> 0 OR
        inIsTop AND COALESCE(inPriceGods, 0) > 0 
     THEN 
        RETURN inPriceGods;
     END IF;

     -- расчет % наценки
     IF inIsTop AND COALESCE(inPercentMarkup, 0) = 100
     THEN
       vbPercent := 0;
     ELSEIF COALESCE(inPercentMarkupPrice, 0) > 0
     THEN
       vbPercent := COALESCE (inPercentMarkupPrice, 0);
     ELSEIF inIsTop AND COALESCE (inPercentMarkup, 0) > 0 AND COALESCE (inPercentMarkup, 0) < COALESCE (inMarginPercent, 0)  THEN
        -- для ТОП = % наценки у товара - % корректировки у Юр Лица для топа
        vbPercent := COALESCE (inPercentMarkup, 0);
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

/*     if inPriceWithVAT = 155.6
     THEN
     RAISE notice '<%> <%> <%> <%> <%> <%> <%> <%> ', 
        inPriceWithVAT
       ,inMarginPercent
       ,inIsTop
       ,inPercentMarkup
       ,inPercentMarkupPrice
       ,inPrice
       ,inPriceGods
       ,inPriceMax ;
     END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_SalePriceSiteUnit(TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.06.21                                                       * 
*/
-- тест 

select zfCalc_SalePriceSiteUnit(2.5, 4, True, True, 0, 0, 0, 2.7, 0.0) 