-- Function: zfCalc_RateFuelValue

-- DROP FUNCTION zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_RateFuelValue(
    IN inDistance            TFloat    , -- Расстояние факт км
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км
    IN inColdHour            TFloat    , -- Холод, Кол-во факт часов
    IN inAmountColdHour      TFloat    , -- Холод, Кол-во норма в час
    IN inColdDistance        TFloat    , -- Холод, Кол-во факт км
    IN inAmountColdDistance  TFloat    , -- Холод, Кол-во норма на 100 км
    IN inRateFuelKindTax     TFloat      -- % дополнительного расхода в связи с сезоном/температурой
)
RETURNS TFloat AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     vbValue := (-- для расстояния / 100
                 CAST ( (COALESCE (inDistance, 0) / 100) * COALESCE (inAmountFuel, 0) AS NUMERIC (16, 2))
                 -- для Холод, часов
               + CAST ( COALESCE (inColdHour, 0) * COALESCE (inAmountColdHour, 0) AS NUMERIC (16, 2))
                 -- для Холод, км / 100
               + CAST ( (COALESCE (inColdDistance, 0) / 100) * COALESCE (inAmountColdDistance, 0) AS NUMERIC (16, 2))
                )
                 -- добавляем % дополнительного расхода в связи с сезоном/температурой
              * (1 + COALESCE (inRateFuelKindTax, 0) / 100)
     ;

     RETURN (CAST (vbValue AS NUMERIC (16, 2)));

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION zfCalc_RateFuelValue (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.13                                        *
 01.10.13                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_RateFuelValue (inDistance           := 100
                                  , inAmountFuel         := 10
                                  , inColdHour           := 20
                                  , inAmountColdHour     := 10
                                  , inColdDistance       := 100
                                  , inAmountColdDistance := 30
                                  , inRateFuelKindTax    := 10)
*/