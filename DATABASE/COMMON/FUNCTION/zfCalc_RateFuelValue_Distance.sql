-- Function: zfCalc_RateFuelValue_Distance

-- DROP FUNCTION zfCalc_RateFuelValue_Distance (TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_RateFuelValue_Distance(
    IN inDistance            TFloat    , -- Расстояние факт км
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км
    IN inFuel_Ratio          TFloat    , -- Коэффициента перевода нормы
    IN inRateFuelKindTax     TFloat      -- % дополнительного расхода в связи с сезоном/температурой
)
RETURNS TFloat AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- преобразовали на всяк случай
     inDistance         := COALESCE (inDistance, 0);
     inAmountFuel       := COALESCE (inAmountFuel, 0);
     inFuel_Ratio       := COALESCE (inFuel_Ratio, 1); -- !!! здесь обязательно один!!!
     inRateFuelKindTax  := COALESCE (inRateFuelKindTax, 0);

     -- подставили единицу на всяк случай
     inFuel_Ratio := CASE WHEN inFuel_Ratio = 0 THEN 1 ELSE inFuel_Ratio END;


     -- норму увеличиваем на "Коэффициента перевода нормы" и округляем до 2-х знаков
     inAmountFuel := CAST (inAmountFuel * inFuel_Ratio AS NUMERIC (16, 2));

     -- расчет нормы: для расстояния/100 и округляем до 2-х знаков
     vbValue := CAST ((inDistance / 100) * inAmountFuel AS NUMERIC (16, 2));

     -- добавляем к нормe % дополнительного расхода в связи с сезоном/температурой и округляем до 2-х знаков
     vbValue := CAST (vbValue * (1 + inRateFuelKindTax / 100) AS NUMERIC (16, 2));

     -- возвращаем результат, уже округленный до 2-х знаков
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_RateFuelValue_Distance (TFloat, TFloat, TFloat, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.13                        * -- VOLATILE -->> IMMUTABLE
 24.10.13                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_RateFuelValue_Distance (inDistance           := 100
                                           , inAmountFuel         := 17
                                           , inFuel_Ratio         := 1.3059
                                           , inRateFuelKindTax    := 0)
*/