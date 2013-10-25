-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_RateFuelValue(
    IN inDistance            TFloat    , -- Расстояние факт км
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км
    IN inColdHour            TFloat    , -- Холод, Кол-во факт часов
    IN inAmountColdHour      TFloat    , -- Холод, Кол-во норма в час
    IN inColdDistance        TFloat    , -- Холод, Кол-во факт км
    IN inAmountColdDistance  TFloat    , -- Холод, Кол-во норма на 100 км
    IN inFuel_Ratio          TFloat    , -- Коэффициента перевода нормы
    IN inRateFuelKindTax     TFloat      -- % дополнительного расхода в связи с сезоном/температурой
)
RETURNS TFloat AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- расчет нормы
     vbValue := zfCalc_RateFuelValue_Distance     (inDistance           := inDistance
                                                 , inAmountFuel         := inAmountFuel
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax)
              + zfCalc_RateFuelValue_ColdHour     (inColdHour           := inColdHour
                                                 , inAmountColdHour     := inAmountColdHour
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax)
              + zfCalc_RateFuelValue_ColdDistance (inColdDistance       := inColdDistance
                                                 , inAmountColdDistance := inAmountColdDistance
                                                 , inFuel_Ratio         := inFuel_Ratio
                                                 , inRateFuelKindTax    := inRateFuelKindTax);
     -- возвращаем результат, уже округленный до 2-х знаков
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.13                        * -- VOLATILE -->> IMMUTABLE
 23.10.13                                        * add zfCalc_RateFuelValue_...
 01.10.13                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_RateFuelValue (inDistance           := 100
                                  , inAmountFuel         := 17
                                  , inColdHour           := 1
                                  , inAmountColdHour     := 17
                                  , inColdDistance       := 100
                                  , inAmountColdDistance := 17
                                  , inFuel_Ratio         := 1.3059
                                  , inRateFuelKindTax    := 0)
*/