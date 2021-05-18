-- Function: Считаем Сумму по ценам продажи Со Скидкой - Округление до 0 знаков

DROP FUNCTION IF EXISTS zfCalc_SummChangePercent (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummChangePercent(
    IN inAmount        TFloat, -- Кол-во
    IN inOperPriceList TFloat, -- Цена по прайсу, в ГРН
    IN inChangePercent TFloat  -- % скидки
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumm TFloat;
   DECLARE vbOperPrice TFloat;
BEGIN
    IF zc_Enum_GlobalConst_isTerry() = TRUE
    THEN
        -- Округление до 0 знаков
        vbSumm:= zfCalc_SummPriceList (inAmount, inOperPriceList);
        -- еще раз округлили до 0 знаков
        RETURN vbSumm
             - CAST (vbSumm * COALESCE (inChangePercent, 0) / 100 AS NUMERIC (16, 0));
    ELSE
        -- Округление до 0 знаков
        vbOperPrice:= CAST (inOperPriceList * (1 - COALESCE (inChangePercent, 0) / 100) AS NUMERIC (16, 0));
        -- еще раз округлили до 0 знаков
        RETURN zfCalc_SummPriceList (inAmount, vbOperPrice);

    END IF;
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.17                                        *
*/

-- тест
-- SELECT * FROM zfCalc_SummChangePercent (inAmount:= 1, inOperPriceList:= 250, inChangePercent:= 15)
