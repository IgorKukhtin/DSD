-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DetermentPaymentDate(
    IN inContractConditionId Integer   , -- Тип отсрочки
    IN inDayCount            Integer   , -- Дней отсрочки
    IN inDate                TDateTime , -- Дата от которой надо посчитать начало действия отсрочки
)
RETURNS TDateTime AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- возвращаем результат, уже округленный до 2-х знаков
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.14                        * 
*/
/*
-- тест
SELECT * FROM zfCalc_DetermentPaymentDate (inDistance           := 100
                                  , inAmountFuel         := 17
                                  , inColdHour           := 1
                                  , inAmountColdHour     := 17
                                  , inColdDistance       := 100
                                  , inAmountColdDistance := 17
                                  , inFuel_Ratio         := 1.3059
                                  , inRateFuelKindTax    := 0)
*/