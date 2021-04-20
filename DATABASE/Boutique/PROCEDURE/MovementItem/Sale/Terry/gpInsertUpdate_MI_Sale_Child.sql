-- Function: gpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Sale_Child(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount        TFloat    , -- Дополнительная скидка в продаже ГРН
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbTmp    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- данные из документа
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());


     -- !!!для SYBASE - по другому, + вся скидка сразу в мастере!!!
     IF vbUserId <> zc_User_Sybase() -- AND inParentId = 0
     THEN
         -- заливка Сумма к Оплате
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, Summa TFloat, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, Summa, AmountToPay)
            WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) AS Summa
                                , zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData) AS AmountToPay
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
            -- результат
            SELECT tmpMI.MovementItemId, tmpMI.Summa, tmpMI.AmountToPay
            FROM tmpMI
            WHERE tmpMI.MovementItemId     = inParentId
               OR COALESCE (inParentId, 0) = 0;

         -- расчет Данных Child
         WITH tmpChild AS (SELECT *
                           FROM lpSelect_MI_Child_calc (inMovementId      := inMovementId
                                                      , inUnitId          := vbUnitId
                                                      , inAmountGRN       := inAmountGRN
                                                      , inAmountUSD       := inAmountUSD
                                                      , inAmountEUR       := inAmountEUR
                                                      , inAmountCard      := inAmountCard
                                                      , inAmountDiscount  := inAmountDiscount
                                                      , inCurrencyValueUSD:= inCurrencyValueUSD
                                                      , inParValueUSD     := inParValueUSD
                                                      , inCurrencyValueEUR:= inCurrencyValueEUR
                                                      , inParValueEUR     := inParValueEUR
                                                      , inUserId          := vbUserId
                                                       )
                          )
       -- в мастер записать
     , tmpUpdateMaster AS (SELECT *
                           FROM
                          (SELECT 1 AS Num
                                , _tmp_MI_Master.MovementItemId
                                  -- Дополнительная скидка в продаже ГРН
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(),  _tmp_MI_Master.MovementItemId, COALESCE (tmp.AmountDiscount, 0))
                                  -- Итого скидка в продаже ГРН
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), _tmp_MI_Master.MovementItemId, _tmp_MI_Master.Summa - _tmp_MI_Master.AmountToPay + COALESCE (tmp.AmountDiscount, 0))
                                  -- Итого оплата в продаже ГРН
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), _tmp_MI_Master.MovementItemId, COALESCE (tmp.TotalPay, 0))
                           FROM _tmp_MI_Master
                                LEFT JOIN (SELECT tmpChild.ParentId
                                                , MAX (tmpChild.AmountDiscount) AS AmountDiscount
                                                , SUM (tmpChild.Amount_GRN)     AS TotalPay
                                           FROM tmpChild
                                           WHERE tmpChild.ParentId > 0
                                           GROUP BY tmpChild.ParentId
                                          ) AS tmp ON tmp.ParentId = _tmp_MI_Master.MovementItemId
                          ) AS tmp
                          )
        -- в Child записать
      , tmpInsertChild AS (SELECT 2 AS Num
                                , lpInsertUpdate_MI_Sale_Child (ioId                 := tmpChild.MovementItemId
                                                              , inMovementId         := inMovementId
                                                              , inParentId           := tmpChild.ParentId
                                                              , inCashId             := tmpChild.CashId
                                                              , inCurrencyId         := tmpChild.CurrencyId
                                                              , inCashId_Exc         := tmpChild.CashId_Exc
                                                              , inAmount             := tmpChild.Amount
                                                              , inCurrencyValue      := tmpChild.CurrencyValue
                                                              , inParValue           := tmpChild.ParValue
                                                              , inUserId             := vbUserId
                                                               ) AS MovementItemId
                           FROM tmpChild
                          )
        -- Результат
        SELECT (SELECT MAX (tmpUpdateMaster.MovementItemId) FROM tmpUpdateMaster) :: Integer
             + (SELECT MAX (tmpInsertChild.MovementItemId)  FROM tmpInsertChild)  :: Integer
               INTo vbTmp;

     ELSE
         -- !!!для SYBASE - потом убрать!!! + временно для inParentId

         -- проверка - свойство должно быть установлено
         IF COALESCE (inParentId, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <inParentId>.';
         END IF;

         -- находим кассу для Магазина или р.сч., в которую попадет оплата
         CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
         --
         INSERT INTO _tmpCash (CashId, CurrencyId , Amount, CurrencyValue, ParValue)
            SELECT lpSelect.CashId
                 , lpSelect.CurrencyId
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = FALSE THEN inAmountGRN
                        WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = TRUE  THEN inAmountCard
                        WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN inAmountEUR
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN inAmountUSD
                   END AS Amount
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN COALESCE (inCurrencyValueEUR, 1)
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN COALESCE (inCurrencyValueUSD, 1)
                        ELSE 0
                   END AS CurrencyValue
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN CASE WHEN inParValueEUR > 0 THEN inParValueEUR ELSE 1 END
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN CASE WHEN inParValueUSD > 0 THEN inParValueUSD ELSE 1 END
                        ELSE 0
                   END AS ParValue
             FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
             WHERE 0 <> CASE WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = FALSE THEN inAmountGRN
                             WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = TRUE  THEN inAmountCard
                             WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN inAmountEUR
                             WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN inAmountUSD
                        END
            ;


         -- существущие элементы
         CREATE TEMP TABLE _tmpMI (Id Integer, CashId Integer) ON COMMIT DROP;
         --
         INSERT INTO _tmpMI (Id, CashId)
            SELECT MovementItem.Id
                 , MovementItem.ObjectId AS CashId
            FROM MovementItem
            WHERE MovementItem.ParentId   = inParentId
              AND MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Child()
              AND MovementItem.isErased   = FALSE;

         -- проверка - CashId должен быть уникальным
         IF EXISTS (SELECT 1 FROM _tmpMI GROUP BY _tmpMI.CashId HAVING COUNT(*) > 1) THEN
            RAISE EXCEPTION 'Ошибка.В предыдущих оплатах дублируется касса <%>.', lfGet_Object_ValueData ((SELECT tmp.CashId FROM (SELECT _tmpMI.CashId FROM _tmpMI GROUP BY _tmpMI.CashId HAVING COUNT(*) > 1) AS tmp LIMIT 1));
         END IF;


         -- сохранили
         PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := COALESCE (_tmpMI.Id,0)
                                             , inMovementId         := inMovementId
                                             , inParentId           := inParentId
                                             , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                             , inCurrencyId         := _tmpCash.CurrencyId
                                             , inCashId_Exc         := NULL
                                             , inAmount             := COALESCE (_tmpCash.Amount, 0)
                                             , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue, 0)
                                             , inParValue           := COALESCE (_tmpCash.ParValue, 0)
                                             , inUserId             := vbUserId
                                              )
         FROM _tmpCash
              FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId;


         -- в мастер записать - Итого оплата в Child ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), inParentId
                                                 , CAST (COALESCE ((SELECT SUM (_tmpCash.Amount * CASE WHEN _tmpCash.CurrencyId = zc_Currency_GRN() THEN 1 ELSE _tmpCash.CurrencyValue / _tmpCash.ParValue END)
                                                                    FROM _tmpCash
                                                                   ), 0)
                                                         AS NUMERIC (16, 2)));
     END IF; -- !!!ФИНИШ для Sybase!!!


     -- "сложно" пересчитали "итоговые" суммы по ВСЕМ элементам
     PERFORM lpUpdate_MI_Sale_Total (MovementItem.Id)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Sale_Child (ioId:= 0, inMovementId:= 8, inGoodsId:= 446, inPartionId:= 50, inAmount:= 4, outOperPrice:= 100, ioCountForPrice:= 1, inSession:= zfCalc_UserAdmin());
