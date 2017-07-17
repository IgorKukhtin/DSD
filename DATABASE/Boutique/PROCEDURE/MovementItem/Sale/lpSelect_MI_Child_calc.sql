-- Function: lpSelect_MI_Child_calc()

DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Child_calc(
    IN inMovementId            Integer   , -- Ключ
    IN inUnitId                Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount        TFloat    , -- Дополнительная скидка ГРН
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inUserId                Integer     -- Ключ
)
RETURNS TABLE (ParentId       Integer
             , MovementItemId Integer
             , CashId         Integer -- Касса, в которую будет Приход/Расход(если возврат)
             , CurrencyId     Integer -- Валюта кассы, в которую будет Приход/Расход(если возврат)
             , AmountToPay    TFloat  -- Сумма К оплате
             , AmountDiscount TFloat  -- Сумма скидки
             , Amount_GRN     TFloat  -- Сумма оплаты
             , Amount_Card    TFloat  -- Сумма оплаты
             , Amount_EUR     TFloat  -- Сумма оплаты
             , Amount_USD     TFloat  -- Сумма оплаты
             , CurrencyValue  TFloat
             , ParValue       TFloat
             , CashId_ch      Integer -- касса в ГРН - из которой будет Расход/Приход(если возврат) сумма для Обмена
              )
AS
$BODY$
   DECLARE vbTotalAmountToPay TFloat;
BEGIN

     -- !!!ДЛЯ ТЕСТА!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmp_MI_Master'))
     THEN
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, AmountToPay)
            SELECT 1, 100
           UNION
            SELECT 2, 200
           UNION
            SELECT 3, 300
           ;
     END IF;


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
                                , _tmp_MI_Master.AmountToPay
                                , CASE WHEN inAmountDiscount = vbTotalAmountToPay THEN _tmp_MI_Master.AmountToPay ELSE CAST (inAmountDiscount * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay AS NUMERIC (16, 2)) END AS AmountDiscount
                                , ROW_NUMBER() OVER (ORDER BY _tmp_MI_Master.AmountToPay DESC) AS Ord
                           FROM _tmp_MI_Master
                          )
         -- выровняли - Дополнительная скидка - т.е. разницу на коп. при округлении
       , tmp_MI_Master AS (SELECT tmp_MI_Master_all.MovementItemId
                                , tmp_MI_Master_all.AmountToPay
                                , tmp_MI_Master_all.AmountDiscount
                                  - (CASE WHEN tmp_MI_Master_all.Ord = 1
                                               THEN (SELECT SUM (tmp_MI_Master_all.AmountDiscount) AS AmountDiscount FROM tmp_MI_Master_all)
                                                  - inAmountDiscount
                                          ELSE 0
                                     END) AS AmountDiscount
                                , tmp_MI_Master_all.AmountDiscount AS AmountDiscount_two
                                , tmp_MI_Master_all.Ord
                           FROM tmp_MI_Master_all
                          )
            -- 1.1. остаток для оплаты Грн - с накопительной суммой
          , tmp_MI_GRN AS (SELECT tmpMI.MovementItemId
                                , tmpMI.AmountToPay - tmpMI.AmountDiscount AS Amount_calc
                                , SUM (tmpMI.AmountToPay - tmpMI.AmountDiscount) OVER (ORDER BY tmpMI.AmountToPay - tmpMI.AmountDiscount ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_Master AS tmpMI
                          )
        -- 1.2. оплата Грн результат
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
           -- 2.1. остаток для оплаты БН Грн - с накопительной суммой
         , tmp_MI_Card AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_GRN AS tmpMI
                                LEFT JOIN tmp_MI_GRN_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
       -- 2.2. оплата БН Грн результат
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
            -- 3.1. остаток для оплаты EUR - с накопительной суммой
          , tmp_MI_EUR AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_Card AS tmpMI
                                LEFT JOIN tmp_MI_Card_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
        -- 3.2. оплата EUR результат - !!!в ГРН!!!
      , tmp_MI_EUR_res AS (SELECT DD.MovementItemId
                                , CASE WHEN inAmountEUR * inCurrencyValueEUR / inParValueEUR  - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE inAmountEUR * inCurrencyValueEUR / inParValueEUR - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_EUR AS DD
                           WHERE inAmountEUR * inCurrencyValueEUR / inParValueEUR - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountEUR * inCurrencyValueEUR / inParValueEUR > 0
                          )
            -- 4.1. остаток для оплаты EUR - с накопительной суммой
          , tmp_MI_USD AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_EUR AS tmpMI
                                LEFT JOIN tmp_MI_EUR_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
        -- 4.2. оплата EUR результат - !!!в ГРН!!!
      , tmp_MI_USD_res AS (SELECT DD.MovementItemId
                                , CASE WHEN inAmountUSD * inCurrencyValueUSD / inParValueUSD  - DD.Amount_SUM > 0
                                       -- оплатили полностью
                                       THEN DD.Amount_calc
                                       -- оплатили частично
                                       ELSE inAmountUSD * inCurrencyValueUSD / inParValueUSD - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_USD AS DD
                           WHERE inAmountUSD * inCurrencyValueUSD / inParValueUSD - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountUSD * inCurrencyValueUSD / inParValueUSD > 0
                          )
            -- 5. Опллаты - результат - !!!все в ГРН!!!
          , tmp_MI_res AS (SELECT tmp_MI_Master.MovementItemId
                                , tmp_MI_Master.AmountToPay - tmp_MI_Master.AmountDiscount AS AmountToPay
                                , tmp_MI_Master.AmountDiscount           AS AmountDiscount
                                , COALESCE (tmp_MI_GRN_res.Amount, 0)   AS Amount_GRN
                                , COALESCE (tmp_MI_Card_res.Amount, 0)  AS Amount_Card
                                , COALESCE (tmp_MI_EUR_res.Amount, 0)   AS Amount_EUR_grn
                                , COALESCE (tmp_MI_USD_res.Amount, 0)   AS Amount_USD_grn
                           FROM tmp_MI_Master
                                LEFT JOIN tmp_MI_GRN_res  ON tmp_MI_GRN_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_Card_res ON tmp_MI_Card_res.MovementItemId = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_EUR_res  ON tmp_MI_EUR_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_USD_res  ON tmp_MI_USD_res.MovementItemId  = tmp_MI_Master.MovementItemId
                          )
          -- 6. получили реальные суммы оплаты в валюте - !!!ОНИ ВСЕГДА ОКРУГЛЕНЫ ВНИЗ ДО ЦЕЛОГО!!! + "хвостики" в ГРН
        , tmp_Currency AS (SELECT tmp_MI_res.MovementItemId
                                , FLOOR (tmp_MI_res.Amount_EUR_grn / inCurrencyValueEUR * inParValueEUR) AS Amount_EUR
                                , tmp_MI_res.Amount_EUR_grn - FLOOR (tmp_MI_res.Amount_EUR_grn / inCurrencyValueEUR * inParValueEUR) * inCurrencyValueEUR / inParValueEUR AS Amount_EUR_grn
                                , FLOOR (tmp_MI_res.Amount_USD_grn / inCurrencyValueUSD * inParValueUSD) AS Amount_USD
                                , tmp_MI_res.Amount_USD_grn - FLOOR (tmp_MI_res.Amount_USD_grn / inCurrencyValueUSD * inParValueUSD) * inCurrencyValueUSD / inParValueUSD AS Amount_USD_grn
                           FROM tmp_MI_res
                          )
            -- 7. получили ОБМЕНЫ - расход ГРН + приход Валюты
          , tmp_Change AS (-- из "хвостиков" оплаты
                           SELECT -1 * SUM (tmp_Currency.Amount_EUR_grn) AS Amount_EUR_grn
                                , -1 * SUM (tmp_Currency.Amount_USD_grn) AS Amount_USD_grn
                                , SUM (tmp_Currency.Amount_EUR_grn) / inCurrencyValueEUR * inParValueEUR AS Amount_EUR
                                , SUM (tmp_Currency.Amount_USD_grn) / inCurrencyValueUSD * inParValueUSD AS Amount_USD
                           FROM tmp_Currency
                          UNION
                           -- из ИТОГО оплат в валюте
                           SELECT -1 * (inAmountEUR * inCurrencyValueEUR / inParValueEUR - tmp.Amount_EUR_grn) AS Amount_EUR_grn
                                , -1 * (inAmountUSD * inCurrencyValueUSD / inParValueUSD - tmp.Amount_USD_grn) AS Amount_USD_grn

                                , inAmountEUR - tmp.Amount_EUR_grn / inCurrencyValueEUR * inParValueEUR AS Amount_EUR
                                , inAmountUSD - tmp.Amount_USD_grn / inCurrencyValueUSD * inParValueUSD AS Amount_USD
                           FROM -- ИТОГО в ГРН - 1 ЗАПИСЬ
                                (SELECT SUM (tmp_MI_res.Amount_EUR_grn) AS Amount_EUR_grn
                                      , SUM (tmp_MI_res.Amount_USD_grn) AS Amount_USD_grn
                                 FROM tmp_MI_res
                                ) AS tmp
                          )

       -- Результат
       SELECT tmp_MI_res.MovementItemId AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay      :: TFloat AS AmountToPay
            , tmp_MI_res.AmountDiscount   :: TFloat AS AmountDiscount
            , (tmp_MI_res.Amount_GRN + COALESCE (tmp_Currency.Amount_EUR_grn, 0)  + COALESCE (tmp_Currency.Amount_USD_grn, 0)) :: TFloat AS Amount_GRN
            , tmp_MI_res.Amount_Card      :: TFloat AS Amount_Card
            -- , tmp_MI_res.Amount_EUR_GRN   :: TFloat AS Amount_EUR
            -- , tmp_MI_res.Amount_USD_GRN   :: TFloat AS Amount_USD
            , COALESCE (tmp_Currency.Amount_EUR, 0) :: TFloat AS Amount_EUR
            , COALESCE (tmp_Currency.Amount_USD, 0) :: TFloat AS Amount_USD

            , (COALESCE ((SELECT SUM (tmp_MI_GRN_res.Amount) FROM tmp_MI_GRN_res), 0)
             + COALESCE ((SELECT SUM (tmp_MI_Card_res.Amount) FROM tmp_MI_Card_res), 0)
             + COALESCE ((SELECT SUM (tmp_MI_EUR_res.Amount) FROM tmp_MI_EUR_res), 0)
             + COALESCE ((SELECT SUM (tmp_MI_USD_res.Amount) FROM tmp_MI_USD_res), 0)
              ) :: TFloat  AS CurrencyValue
            , 0 :: TFloat  AS ParValue
            , 0 :: Integer AS CashId_ch

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
      UNION ALL
       SELECT 0 AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountDiscount

            , tmp.Amount_EUR_grn :: TFloat AS Amount_GRN
            , 0                  :: TFloat AS Amount_Card
            , tmp.Amount_EUR     :: TFloat AS Amount_EUR
            , 0                  :: TFloat AS Amount_USD

            , inCurrencyValueEUR           AS CurrencyValue
            , inParValueEUR                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_ch

       FROM (SELECT SUM (tmp_Change.Amount_EUR) AS Amount_EUR, SUM (tmp_Change.Amount_EUR_grn) AS Amount_EUR_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_EUR()
      UNION ALL
       SELECT 0 AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountDiscount

            , tmp.Amount_USD_grn :: TFloat AS Amount_GRN
            , 0                  :: TFloat AS Amount_Card
            , 0                  :: TFloat AS Amount_EUR
            , tmp.Amount_USD     :: TFloat AS Amount_USD

            , inCurrencyValueUSD           AS CurrencyValue
            , inParValueUSD                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_ch

       FROM (SELECT SUM (tmp_Change.Amount_USD) AS Amount_USD, SUM (tmp_Change.Amount_USD_grn) AS Amount_USD_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_USD()
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
-- SELECT * FROM lpSelect_MI_Master_calc (inUnitId:= 6332, inAmountGRN:= 400, inAmountUSD:= 2, inAmountEUR:= 2, inAmountCard:= 90, inAmountDiscount:= 0, inCurrencyValueUSD:= 25, inParValueUSD:= 1, inCurrencyValueEUR:= 30, inParValueEUR:= 1, inUserId:= zfCalc_UserAdmin() :: Integer);
