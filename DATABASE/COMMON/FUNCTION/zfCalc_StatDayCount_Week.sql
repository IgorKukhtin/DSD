-- Function: zfCalc_StatDayCount_Week()

DROP FUNCTION IF EXISTS zfCalc_StatDayCount_Week (TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_StatDayCount_Week (
    IN inAmount            TFloat   , -- остаток, после ВСЕЙ заявки
    IN inAmountPartnerNext TFloat   , -- "информативно" заказ покупателя + Акции, завтра
    IN inCountForecast     TFloat   , -- "средняя" за 1 день - продажа ИЛИ заявка БЕЗ акций
    IN inPlan1             TFloat   , -- заказ покупателя + Акции, +1 день
    IN inPlan2             TFloat   , -- заказ покупателя + Акции, +2 день
    IN inPlan3             TFloat   , -- заказ покупателя + Акции, +3 день
    IN inPlan4             TFloat   , -- заказ покупателя + Акции, +4 день
    IN inPlan5             TFloat   , -- заказ покупателя + Акции, +5 день
    IN inPlan6             TFloat   , -- заказ покупателя + Акции, +6 день
    IN inPlan7             TFloat     -- заказ покупателя + Акции, +7 день
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbRes TFloat;
BEGIN

      -- увеличиваем План на 1-ый день, т.к. у нас есть 90% факта
      IF inPlan1 < inAmountPartnerNext THEN inPlan1:= inAmountPartnerNext; END IF;


      -- если вернуть "информативно" и все равно не хватает
      IF inAmount + inAmountPartnerNext <= 0 OR COALESCE (inCountForecast, 0) = 0
      THEN -- тогда ноль
           vbRes:= 0;

      -- если Остаток больше 8 ДНЕЙ
      ELSEIF inAmount >= inCountForecast * 8 AND inCountForecast > 0
      THEN -- тогда по старой схеме
           vbRes:= (inAmount) / inCountForecast;

      -- если Остаток меньше чем План на 1-ый день
      ELSEIF inAmount + inAmountPartnerNext <= inPlan1
      THEN -- тогда учитываем заказ покупателя + Акции, завтра
           vbRes:= (inAmount + inAmountPartnerNext) / inPlan1;

      ELSE
          -- стартанули, на 1-ый день хватит остатка
          vbRes:= 1;

          -- остается после 1-ого дня
          inAmount:= inAmount + inAmountPartnerNext - inPlan1;
          -- проверка
          IF inAmount < 0 THEN RETURN (-1); RAISE EXCEPTION 'Ошибка.Остается после дня = <%> кол-во = <%>', vbRes, inAmount; END IF;

          WHILE inAmount > 0
          LOOP
              -- если Остаток меньше чем План на vbRes + 1 день
              IF inAmount <= (CASE vbRes WHEN 1 THEN inPlan2
                                         WHEN 2 THEN inPlan3
                                         WHEN 3 THEN inPlan4
                                         WHEN 4 THEN inPlan5
                                         WHEN 5 THEN inPlan6
                                         WHEN 6 THEN inPlan7
                                         WHEN 7 THEN inPlan1
                                         WHEN 8 THEN inPlan2
                                         WHEN 9 THEN inPlan3
                                         WHEN 10 THEN inPlan4
                                         WHEN 11 THEN inPlan5
                                         WHEN 12 THEN inPlan6
                                         WHEN 13 THEN inPlan7
                                         WHEN 14 THEN inPlan1
                                         WHEN 15 THEN inPlan2
                                         ELSE inCountForecast
                              END)

              THEN -- тогда посчитали этот хвостик и все.
                   vbRes:= vbRes + inAmount / CASE vbRes WHEN 1 THEN inPlan2
                                                         WHEN 2 THEN inPlan3
                                                         WHEN 3 THEN inPlan4
                                                         WHEN 4 THEN inPlan5
                                                         WHEN 5 THEN inPlan6
                                                         WHEN 6 THEN inPlan7
                                                         WHEN 7 THEN inPlan1
                                                         WHEN 8 THEN inPlan2
                                                         WHEN 10 THEN inPlan4
                                                         WHEN 11 THEN inPlan5
                                                         WHEN 12 THEN inPlan6
                                                         WHEN 13 THEN inPlan7
                                                         WHEN 14 THEN inPlan1
                                                         WHEN 15 THEN inPlan2
                                                         WHEN 9 THEN inPlan3
                                                         ELSE inCountForecast
                                              END;
                  -- обнулили Остаток
                  inAmount:= 0;
              ELSE
                  -- сначала - минуснули ОСТАТОК
                  inAmount:= inAmount - CASE vbRes WHEN 1 THEN inPlan2
                                                   WHEN 2 THEN inPlan3
                                                   WHEN 3 THEN inPlan4
                                                   WHEN 4 THEN inPlan5
                                                   WHEN 5 THEN inPlan6
                                                   WHEN 6 THEN inPlan7
                                                   WHEN 7 THEN inPlan1
                                                   WHEN 8 THEN inPlan2
                                                   WHEN 9 THEN inPlan3
                                                   WHEN 10 THEN inPlan4
                                                   WHEN 11 THEN inPlan5
                                                   WHEN 12 THEN inPlan6
                                                   WHEN 13 THEN inPlan7
                                                   WHEN 14 THEN inPlan1
                                                   WHEN 15 THEN inPlan2
                                                   ELSE inCountForecast
                                        END;

                  -- продолжаем, т.к. на день vbRes + 1 остатка хватает
                  vbRes:= vbRes + 1;


              END IF;

              -- проверка
              IF inAmount < 0 THEN RETURN (-2); RAISE EXCEPTION 'Ошибка.Остается после дня = <%> кол-во = <%>', vbRes, inAmount; END IF;
              -- проверка
              IF vbRes > 15 THEN RETURN (-3); RAISE EXCEPTION 'Ошибка.Слишком много дней = <%> кол-во = <%>', vbRes, inAmount; END IF;

          END LOOP;


      END IF;

      RETURN CAST (vbRes AS NUMERIC (16, 1));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 22.11.17                                        *
*/

-- тест
-- SELECT * FROM zfCalc_StatDayCount_Week (inAmount:= 3, inAmountPartnerNext:= 0, inCountForecast:= 200, inPlan1:= 7, inPlan2:= 6, inPlan3:= 5, inPlan4:= 4, inPlan5:= 3, inPlan6:= 2, inPlan7:= 1)
