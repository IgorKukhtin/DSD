-- Function: lpSelect_MI_Child_calc()

DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Child_calc(
    IN inMovementId            Integer   , -- Ключ
    IN inUnitId                Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount        TFloat    , -- Дополнительная скидка  !!! EUR or грн !!!
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inUserId                Integer     -- Ключ
)
RETURNS TABLE (MovementItemId      Integer
             , ParentId            Integer
             , CashId              Integer -- Касса, в которую будет Приход/Расход(если возврат)
             , CurrencyId          Integer -- Валюта кассы, в которую будет Приход/Расход(если возврат)
             , AmountToPay         TFloat  -- Сумма К оплате, грн
             , AmountDiscount      TFloat  -- Сумма скидки, грн
             , Amount              TFloat  -- Сумма оплаты
             , Amount_GRN          TFloat  -- Сумма ИТОГО оплаты в ГРН
             , CurrencyValue       TFloat
             , ParValue            TFloat
             , CashId_Exc          Integer -- касса в ГРН - из которой будет Расход/Приход(если возврат) сумма для Обмена
              )
AS
$BODY$
   DECLARE vbTotalAmountToPay TFloat;
BEGIN

     --
     -- !!!ДЛЯ ТЕСТА!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmp_MI_Master'))
     THEN
         -- заливка мастер - !!!ТОЛЬКО ДЛЯ ТЕСТА!!!
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, Summa TFloat, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, Summa, AmountToPay)
            WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) AS Summa
                                , zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData) AS AmountToPay
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                 ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MovementItem.Id)
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MovementItem.Id)
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
            -- результат
            SELECT tmpMI.MovementItemId, tmpMI.Summa, tmpMI.AmountToPay FROM tmpMI;
            -- SELECT 1, 12550, 12550;

     END IF;
     -- !!!ДЛЯ ТЕСТА!!!
     --


     -- проверка - свойство должно быть установлено
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Магазин>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF NOT EXISTS (SELECT 1 FROM _tmp_MI_Master) THEN
        RAISE EXCEPTION 'Ошибка.Нет данных для распределния оплаты.';
     END IF;

     -- нашли Итого к Оплате
     vbTotalAmountToPay:= (SELECT SUM (_tmp_MI_Master.AmountToPay) FROM _tmp_MI_Master);

     -- проверка
     IF vbTotalAmountToPay < inAmountDiscount THEN
        RAISE EXCEPTION 'Ошибка.Сумма дополнительной скидки = <%> ГРН не может быть больше чем <%> ГРН.', inAmountDiscount, vbTotalAmountToPay;
     END IF;



     -- Результат такой
     RETURN QUERY
          WITH -- кассы
               tmpCash AS (SELECT lpSelect.CashId, lpSelect.CurrencyId, lpSelect.isBankAccount FROM lpSelect_Object_Cash (inUnitId, inUserId) AS lpSelect)
      -- распределили - Дополнительная скидка
   , tmp_MI_Master_all AS (SELECT _tmp_MI_Master.MovementItemId
                                  -- Сумма к выплате
                                , _tmp_MI_Master.AmountToPay
                                  -- распределили Доп. Скидку по элементам
                                , CASE WHEN inAmountDiscount = vbTotalAmountToPay
                                            THEN _tmp_MI_Master.AmountToPay
                                       WHEN FLOOR (inAmountDiscount) <> inAmountDiscount AND inAmountDiscount < 21
                                       -- ОКРУЛИЛИ до 2-х зн.
                                       THEN ROUND (inAmountDiscount * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay, 2)
                                       -- отбросили коп.
                                       ELSE FLOOR (inAmountDiscount * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay)
                                  END AS AmountDiscount
                                , ROW_NUMBER() OVER (ORDER BY _tmp_MI_Master.AmountToPay DESC) AS Ord
                           FROM _tmp_MI_Master
                          )
         -- выровняли - Дополнительная скидка - т.е. разницу на коп. при округлении
       , tmp_MI_Master AS (SELECT tmp_MI_Master_all.MovementItemId
                                  -- Сумма к выплате
                                , tmp_MI_Master_all.AmountToPay
                                  -- Доп. Скидка по элементам минус разница на коп. при округлении
                                , tmp_MI_Master_all.AmountDiscount
                                  - (CASE WHEN tmp_MI_Master_all.Ord = 1
                                               THEN (SELECT SUM (tmp_MI_Master_all.AmountDiscount) AS AmountDiscount FROM tmp_MI_Master_all)
                                                  - inAmountDiscount
                                          ELSE 0
                                     END) AS AmountDiscount
                                  -- Доп. Скидка по элементам БЕЗ разницы
                                , tmp_MI_Master_all.AmountDiscount AS AmountDiscount_two
                                , tmp_MI_Master_all.Ord
                           FROM tmp_MI_Master_all
                          )
            -- 1.1. остаток для оплаты EUR - с накопительной суммой
          , tmp_MI_EUR AS (SELECT tmpMI.MovementItemId
                                  -- сумма в ГРН с учетом Доп. скидки
                                , tmpMI.Amount_all
                                  -- сумма в ГРН с учетом Доп. скидки - для расч. EUR
                                , tmpMI.Amount_calc
                                  -- сумма в ГРН с учетом Доп. скидки - НАКОПИТЕЛЬНО начиная с минимальной
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM (SELECT tmpMI.MovementItemId
                                        -- сумма в ГРН с учетом Доп. скидки
                                      , tmpMI.AmountToPay - tmpMI.AmountDiscount AS Amount_all
                                        -- сумма в ГРН с учетом Доп. скидки - для расч. EUR
                                      , CASE WHEN inAmountGRN > 150 OR inAmountCard > 0
                                                  -- считаем что дробной части нет, т.е. она дополнится гривной
                                                  THEN zfCalc_CurrencyFrom (-- Переводим в Валюту + отбросили коп.
                                                                            FLOOR (zfCalc_CurrencyTo (tmpMI.AmountToPay - tmpMI.AmountDiscount, inCurrencyValueEUR, inParValueEUR))
                                                                          , inCurrencyValueEUR, inParValueEUR)
                                             -- иначе дробная часть будет в обмене
                                             ELSE tmpMI.AmountToPay - tmpMI.AmountDiscount
                                        END AS Amount_calc
                                 FROM tmp_MI_Master AS tmpMI
                                ) AS tmpMI
                          )
        -- 1.2. оплата EUR результат - !!!в ГРН!!!
      , tmp_MI_EUR_res AS (SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR)  - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_EUR AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) > 0
                          )
            -- 2.1. остаток для оплаты USD - с накопительной суммой
          , tmp_MI_USD AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all
                                , tmpMI.Amount_calc
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM (SELECT tmpMI.MovementItemId
                                      , tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) AS Amount_all
                                      , CASE WHEN inAmountGRN > 155 OR inAmountCard > 0
                                                  -- считаем что дробной части нет, т.е. она дополнится гривной
                                                  THEN zfCalc_CurrencyFrom (FLOOR (zfCalc_CurrencyTo (tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0), inCurrencyValueUSD, inParValueUSD))
                                                                          , inCurrencyValueUSD, inParValueUSD)
                                             -- иначе дробная часть будет в обмене
                                             ELSE tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)
                                        END AS Amount_calc
                                 FROM tmp_MI_EUR AS tmpMI
                                      LEFT JOIN tmp_MI_EUR_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                                ) AS tmpMI
                          )
        -- 2.2. оплата USD результат - !!!в ГРН!!!
      , tmp_MI_USD_res AS (SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, inParValueUSD)  - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_USD AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, inParValueUSD) > 0
                          )

            -- 3.1. остаток для оплаты Грн - с накопительной суммой
          , tmp_MI_GRN AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_USD AS tmpMI
                                LEFT JOIN tmp_MI_USD_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
        -- 3.2. оплата Грн результат
      , tmp_MI_GRN_res AS (SELECT DD.MovementItemId
                                , CASE WHEN inAmountGRN - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE inAmountGRN - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_GRN AS DD
                           WHERE inAmountGRN - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountGRN > 0
                          )
           -- 4.1. остаток для оплаты БН Грн - с накопительной суммой
         , tmp_MI_Card AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_GRN AS tmpMI
                                LEFT JOIN tmp_MI_GRN_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
       -- 4.2. оплата БН Грн результат
     , tmp_MI_Card_res AS (SELECT DD.MovementItemId
                                , CASE WHEN inAmountCard - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE inAmountCard - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_Card AS DD
                           WHERE inAmountCard - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountCard > 0
                          )
            -- 5. Опллаты - результат - !!!все в ГРН!!!
          , tmp_MI_res AS (SELECT tmp_MI_Master.MovementItemId
                                , tmp_MI_Master.AmountToPay - tmp_MI_Master.AmountDiscount AS AmountToPay
                                , tmp_MI_Master.AmountDiscount           AS AmountDiscount
                                , COALESCE (tmp_MI_GRN_res.Amount, 0)    AS Amount_GRN
                                , COALESCE (tmp_MI_Card_res.Amount, 0)   AS Amount_Card
                                , COALESCE (tmp_MI_EUR_res.Amount, 0)    AS Amount_EUR_grn
                                , COALESCE (tmp_MI_USD_res.Amount, 0)    AS Amount_USD_grn
                           FROM tmp_MI_Master
                                LEFT JOIN tmp_MI_GRN_res  ON tmp_MI_GRN_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_Card_res ON tmp_MI_Card_res.MovementItemId = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_EUR_res  ON tmp_MI_EUR_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_USD_res  ON tmp_MI_USD_res.MovementItemId  = tmp_MI_Master.MovementItemId
                          )
    -- 6.0. получили ...
  , tmp_Currency_ROUND AS (SELECT tmp_MI_res.Amount_EUR_grn - zfCalc_CurrencyFrom (-- Переводим в Валюту + ОКРУЛИЛИ до 2-х зн.
                                                                                   ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                                                                 , inCurrencyValueEUR, inParValueEUR) AS Amount_EUR_grn
                                , tmp_MI_res.Amount_USD_grn - zfCalc_CurrencyFrom (-- Переводим в Валюту + ОКРУЛИЛИ до 2-х зн.
                                                                                   ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD), 2)
                                                                                 , inCurrencyValueUSD, inParValueUSD) AS Amount_USD_grn
                           FROM tmp_MI_res
                          )
      -- 6.1. получили реальные суммы оплаты в валюте - !!!ОНИ НЕ ВСЕГДА ОКРУГЛЕНЫ ВНИЗ ДО КОП!!! + "хвостики" в ГРН
    , tmp_Currency_all AS (SELECT tmp_MI_res.MovementItemId
                                , tmp_MI_res.Amount_EUR_grn - zfCalc_CurrencyFrom (-- Переводим в Валюту + округлили коп. ИЛИ отбросили коп.
                                                                                   CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                                                                        THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                                                                        ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR))
                                                                                           / 100
                                                                                   END
                                                                                 , inCurrencyValueEUR, inParValueEUR) AS Amount_EUR_grn

                                , CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                       THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                       ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR))
                                          / 100
                                  END AS Amount_EUR

                                , tmp_MI_res.Amount_USD_grn - zfCalc_CurrencyFrom (-- Переводим в Валюту + округлили коп. ИЛИ отбросили коп.
                                                                                   CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                                                                        THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD), 2)
                                                                                        ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD))
                                                                                           / 100
                                                                                   END
                                                                                 , inCurrencyValueUSD, inParValueUSD) AS Amount_USD_grn

                                , CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                       THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD), 2)
                                       ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD))
                                          / 100
                                  END AS Amount_USD

                           FROM tmp_MI_res
                          )
          -- 6.2. получили реальные суммы - ОТБРОСИЛИ "хвостики" в ГРН если по ним ИТОГО = 0
        , tmp_Currency AS (SELECT tmp_Currency_all.MovementItemId
                                , CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_all AS tmp) = 0 THEN 0 ELSE tmp_Currency_all.Amount_EUR_grn END AS Amount_EUR_grn
                                , tmp_Currency_all.Amount_EUR
                                , CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_all AS tmp) = 0 THEN 0 ELSE tmp_Currency_all.Amount_USD_grn END AS Amount_USD_grn
                                , tmp_Currency_all.Amount_USD
                           FROM tmp_Currency_all
                          )
            -- 7. получили ОБМЕНЫ - расход ГРН + приход Валюты
          , tmp_Change AS (-- из "хвостиков" оплаты
                           SELECT  1 * SUM (tmp_Currency.Amount_EUR_grn) AS Amount_EUR_grn
                                ,  1 * SUM (tmp_Currency.Amount_USD_grn) AS Amount_USD_grn
                                , zfCalc_CurrencyTo (SUM (tmp_Currency.Amount_EUR_grn), inCurrencyValueEUR, inParValueEUR) AS Amount_EUR
                                , zfCalc_CurrencyTo (SUM (tmp_Currency.Amount_USD_grn), inCurrencyValueUSD, inParValueUSD) AS Amount_USD
                           FROM tmp_Currency
                          UNION ALL
                           -- из ИТОГО оплат в валюте
                           SELECT  1 * (zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - tmp.Amount_EUR_grn) AS Amount_EUR_grn
                                ,  1 * (zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, inParValueUSD) - tmp.Amount_USD_grn) AS Amount_USD_grn

                                , inAmountEUR - zfCalc_CurrencyTo (tmp.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR) AS Amount_EUR
                                , inAmountUSD - zfCalc_CurrencyTo (tmp.Amount_USD_grn, inCurrencyValueUSD, inParValueUSD) AS Amount_USD
                           FROM -- ИТОГО в ГРН - 1 ЗАПИСЬ
                                (SELECT SUM (tmp_MI_res.Amount_EUR_grn) AS Amount_EUR_grn
                                      , SUM (tmp_MI_res.Amount_USD_grn) AS Amount_USD_grn
                                 FROM tmp_MI_res
                                ) AS tmp
                          )
           -- 8. Данные - Child
         , tmpMI_Child AS (SELECT MovementItem.Id                     AS MovementItemId
                                , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                , MovementItem.ObjectId               AS CashId
                           FROM MovementItem
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                          )
       -- 1.1. Результат : GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay      :: TFloat AS AmountToPay
            , tmp_MI_res.AmountDiscount   :: TFloat AS AmountDiscount

            , (tmp_MI_res.Amount_GRN + COALESCE (tmp_Currency.Amount_EUR_grn, 0)  + COALESCE (tmp_Currency.Amount_USD_grn, 0)) :: TFloat AS Amount
            , tmp_MI_res.Amount_GRN       :: TFloat AS Amount_GRN

            , 0 :: TFloat  AS CurrencyValue
            , 0 :: TFloat  AS ParValue
            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR (tmp_MI_res.Amount_GRN + COALESCE (tmp_Currency.Amount_EUR_grn, 0)  + COALESCE (tmp_Currency.Amount_USD_grn, 0)) <> 0
          OR tmp_MI_res.Amount_GRN     <> 0
          OR tmp_MI_res.AmountDiscount <> 0

      UNION ALL
       -- 1.2. Результат : GRN - Card
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay      :: TFloat AS AmountToPay
            , tmp_MI_res.AmountDiscount   :: TFloat AS AmountDiscount

            , tmp_MI_res.Amount_Card      :: TFloat AS Amount
            , tmp_MI_res.Amount_Card      :: TFloat AS Amount_GRN

            , 0 :: TFloat  AS CurrencyValue
            , 0 :: TFloat  AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp_MI_res.Amount_Card     <> 0

      UNION ALL
       -- 1.3. Результат : EUR
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay      :: TFloat AS AmountToPay
            , tmp_MI_res.AmountDiscount   :: TFloat AS AmountDiscount

            , COALESCE (tmp_Currency.Amount_EUR, 0) :: TFloat AS Amount
            , tmp_MI_res.Amount_EUR_GRN             :: TFloat AS Amount_GRN

            , inCurrencyValueEUR AS CurrencyValue
            , inParValueEUR      AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_EUR()
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp_Currency.Amount_EUR    <> 0

      UNION ALL
       -- 1.4. Результат : USD
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay      :: TFloat AS AmountToPay
            , tmp_MI_res.AmountDiscount   :: TFloat AS AmountDiscount

            , COALESCE (tmp_Currency.Amount_USD, 0) :: TFloat AS Amount
            , tmp_MI_res.Amount_USD_GRN             :: TFloat AS Amount_GRN

            , inCurrencyValueUSD           AS CurrencyValue
            , inParValueUSD                AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_USD()
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp_Currency.Amount_USD    <> 0

      UNION ALL
       -- 2.1. Результат : Exchange EUR -> GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , 0                          AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountDiscount

            , tmp.Amount_EUR     :: TFloat AS Amount
            , tmp.Amount_EUR_grn :: TFloat AS Amount_GRN

            , inCurrencyValueEUR           AS CurrencyValue
            , inParValueEUR                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_Exc

       FROM (SELECT SUM (tmp_Change.Amount_EUR) AS Amount_EUR, SUM (tmp_Change.Amount_EUR_grn) AS Amount_EUR_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_EUR()
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
            -- LEFT JOIN !!!надо бы еще условие для  zc_MILinkObject_Cash!!!
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp.Amount_EUR             <> 0
          OR tmp.Amount_EUR_grn         <> 0

      UNION ALL
       -- 2.2. Результат : Exchange USD -> GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , 0                          AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountDiscount

            , tmp.Amount_USD     :: TFloat AS Amount
            , tmp.Amount_USD_grn :: TFloat AS Amount_GRN

            , inCurrencyValueUSD           AS CurrencyValue
            , inParValueUSD                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_Exc

       FROM (SELECT SUM (tmp_Change.Amount_USD) AS Amount_USD, SUM (tmp_Change.Amount_USD_grn) AS Amount_USD_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_USD() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
            -- LEFT JOIN !!!надо бы еще условие для  zc_MILinkObject_Cash!!!
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp.Amount_USD             <> 0
          OR tmp.Amount_USD_grn         <> 0
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.17         *
*/

-- тест
/*
--WITH tmp AS (SELECT * FROM lpSelect_MI_Child_calc (inMovementId:= 6170, inUnitId:= 6318 , inAmountGRN:= 0, inAmountUSD:= 0, inAmountEUR:= 632 , inAmountCard:= 0, inAmountDiscount:= 0, inCurrencyValueUSD:= 26.05, inParValueUSD:= 1, inCurrencyValueEUR:= 29.2, inParValueEUR:= 1, inUserId:= zfCalc_UserAdmin() :: Integer))
WITH tmp AS (SELECT * FROM lpSelect_MI_Child_calc (inMovementId:= 6170, inUnitId:= 6318 , inAmountGRN:= 0, inAmountUSD:= 0, inAmountEUR:= 1176 , inAmountCard:= 0, inAmountDiscount:= 0, inCurrencyValueUSD:= 26.05, inParValueUSD:= 1, inCurrencyValueEUR:= 29.2, inParValueEUR:= 1, inUserId:= zfCalc_UserAdmin() :: Integer))
SELECT tmpAll.ParentId, tmp_GRN.Amount AS Amount_GRN, tmp_Card.Amount AS Amount_Card, tmp_EUR.Amount AS Amount_EUR, tmp_EUR.Amount_GRN AS Amount_EUR_GRN, tmp_EUR.CurrencyId AS Id_EUR, tmp_USD.Amount AS Amount_USD, tmp_USD.Amount_GRN AS Amount_USD_GRN, tmp_USD.CurrencyId AS Id_USD, tmp_EUR.CurrencyValue, tmp_EUR.ParValue, tmp_USD.CurrencyValue, tmp_USD.ParValue, tmp_EUR.CashId_Exc AS CashId_Exc_fromEUR, tmp_USD.CashId_Exc AS CashId_Exc_fromUSD
FROM (SELECT DISTINCT tmp.ParentId FROM tmp) AS tmpAll
     LEFT JOIN tmp AS tmp_GRN  ON tmp_GRN.ParentId  = tmpAll.ParentId AND tmp_GRN.CurrencyId  = zc_Currency_GRN() AND COALESCE (tmp_GRN.CashId, 0)      IN (SELECT Id FROM Object WHERE DescId = zc_Object_Cash())
     LEFT JOIN tmp AS tmp_Card ON tmp_Card.ParentId = tmpAll.ParentId AND tmp_Card.CurrencyId = zc_Currency_GRN() AND COALESCE (tmp_Card.CashId, 0) NOT IN (SELECT Id FROM Object WHERE DescId = zc_Object_Cash())
     LEFT JOIN tmp AS tmp_EUR  ON tmp_EUR.ParentId  = tmpAll.ParentId AND tmp_EUR.CurrencyId = zc_Currency_EUR()
     LEFT JOIN tmp AS tmp_USD  ON tmp_USD.ParentId  = tmpAll.ParentId AND tmp_USD.CurrencyId = zc_Currency_USD()
ORDER BY 1
*/