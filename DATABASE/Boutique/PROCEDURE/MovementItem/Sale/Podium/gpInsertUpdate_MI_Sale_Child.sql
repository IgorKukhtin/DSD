-- Function: gpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Sale_Child(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount_GRN    TFloat    , -- Дополнительная скидка в продаже !!! ГРН !!!
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inCurrencyValueCross    TFloat    , --
    IN inParValueCross         TFloat    , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbTmp    Integer;
   DECLARE vbCurrencyId_Client Integer;
   DECLARE vbCurrencyValue_pl_old TFloat;
   DECLARE vbParValue_pl_old      TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!замена!!! так исправляется списание
     IF inAmountGRN < 0
     THEN
         inAmountDiscount_GRN:= inAmountDiscount_GRN + inAmountGRN;
         inAmountGRN:= 0;
     END IF;

     -- данные из документа
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());

     -- данные из документа
     vbCurrencyId_Client:= COALESCE((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyClient())
                                  , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN zc_Currency_GRN() ELSE zc_Currency_EUR() END
                                   );

     -- если зависим от измения курса
     IF vbCurrencyId_Client <> zc_Currency_GRN()
     THEN
         -- Определили курс - если вводили
         SELECT COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_EUR
              , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_EUR
                INTO vbCurrencyValue_pl_old, vbParValue_pl_old

         FROM MovementItem
               LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id       = MovementItem.ParentId
                                                  AND MI_Master.isErased = FALSE
               LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
               INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                               AND MILinkObject_Currency.ObjectId = zc_Currency_EUR()
               LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                           ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
               LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                           ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
        ;

     END IF;

     -- заливка Сумма к Оплате - !!! грн + EUR !!!
     CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, SummPriceList TFloat, SummPriceList_curr TFloat, AmountToPay TFloat, AmountToPay_curr TFloat) ON COMMIT DROP;
     INSERT INTO _tmp_MI_Master (MovementItemId, SummPriceList, SummPriceList_curr, AmountToPay, AmountToPay_curr)
        WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                              -- SummPriceList
                            , zfCalc_SummIn (MovementItem.Amount, CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                                                            THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, inCurrencyValueEUR, 1)
                                                                       ELSE MIFloat_OperPriceList.ValueData
                                                                  END, 1) AS SummPriceList
                              -- SummPriceList_curr
                            , zfCalc_SummIn (MovementItem.Amount, CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                                                            THEN MIFloat_OperPriceList_curr.ValueData
                                                                       ELSE zfCalc_CurrencyTo (MIFloat_OperPriceList.ValueData, inCurrencyValueEUR, 1)
                                                                  END, 1) AS SummPriceList_curr

                              -- AmountToPay
                            , CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                        THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                , inCurrencyValueEUR, 1)
                                        ELSE zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                              END AS AmountToPay
                              -- AmountToPay_curr
                            , CASE WHEN vbCurrencyId_Client <> zc_Currency_GRN()
                                        THEN zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                        ELSE zfCalc_CurrencyTo (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                              , inCurrencyValueEUR, 1)
                              END AS AmountToPay_curr

                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                        ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                        ON MIFloat_ChangePercentNext.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()

                          /*LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                        ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()*/
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
        -- результат
        SELECT tmpMI.MovementItemId, tmpMI.SummPriceList, tmpMI.SummPriceList_curr, tmpMI.AmountToPay, tmpMI.AmountToPay_curr
        FROM tmpMI
        WHERE tmpMI.MovementItemId     = inParentId
           OR COALESCE (inParentId, 0) = 0;



     -- расчет Данных Child
     WITH tmpChild AS (SELECT *
                       FROM lpSelect_MI_Child_calc (inMovementId          := inMovementId
                                                  , inUnitId              := vbUnitId
                                                  , inAmountGRN           := inAmountGRN          -- сумма оплаты
                                                  , inAmountUSD           := inAmountUSD          -- сумма оплаты
                                                  , inAmountEUR           := inAmountEUR          -- сумма оплаты
                                                  , inAmountCard          := inAmountCard         -- сумма оплаты
                                                  , inAmountDiscount_GRN  := inAmountDiscount_GRN -- Дополнительная скидка  !!! ГРН !!!
                                                  , inCurrencyValueUSD    := inCurrencyValueUSD
                                                  , inParValueUSD         := inParValueUSD
                                                  , inCurrencyValueEUR    := inCurrencyValueEUR
                                                  , inParValueEUR         := inParValueEUR
                                                  , inCurrencyId_Client   := vbCurrencyId_Client
                                                  , inCurrencyValueCross  := inCurrencyValueCross
                                                  , inParValueCross       := inParValueCross
                                                  , inUserId              := vbUserId
                                                   )
                      )
          -- в мастер записать
        , tmpUpdateMaster AS (SELECT *
                              FROM (SELECT 1 AS Num
                                         , _tmp_MI_Master.MovementItemId
                                           -- Дополнительная скидка в продаже ГРН + EUR
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(),       _tmp_MI_Master.MovementItemId, COALESCE (tmp.AmountDiscount,      0))
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(),  _tmp_MI_Master.MovementItemId, COALESCE (tmp.AmountDiscount_curr, 0))
                                           -- Итого скидка в продаже ГРН + EUR
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(),      _tmp_MI_Master.MovementItemId, _tmp_MI_Master.SummPriceList      - _tmp_MI_Master.AmountToPay      + COALESCE (tmp.AmountDiscount, 0))
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), _tmp_MI_Master.MovementItemId, _tmp_MI_Master.SummPriceList_curr - _tmp_MI_Master.AmountToPay_curr + COALESCE (tmp.AmountDiscount_curr, 0))
                                           -- Итого оплата в продаже ГРН + EUR
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      _tmp_MI_Master.MovementItemId, COALESCE (tmp.TotalPay, 0))
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), _tmp_MI_Master.MovementItemId, COALESCE (tmp.TotalPay_curr, 0))
                                    FROM _tmp_MI_Master
                                         LEFT JOIN (SELECT tmpChild.ParentId
                                                         , MAX (tmpChild.AmountDiscount)      AS AmountDiscount
                                                         , MAX (tmpChild.AmountDiscount_curr) AS AmountDiscount_curr
                                                         , SUM (tmpChild.Amount_GRN)          AS TotalPay
                                                         , CASE WHEN MAX (tmpChild.AmountToPay) = SUM (tmpChild.Amount_GRN)
                                                                     THEN MAX (tmpChild.AmountToPay_curr)
                                                                ELSE SUM (tmpChild.Amount_EUR)
                                                           END                                AS TotalPay_curr
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


     -- если зависим от измения курса
     IF vbCurrencyId_Client <> zc_Currency_GRN()
     THEN
         -- если курс изменился
         IF inCurrencyValueEUR <> COALESCE (vbCurrencyValue_pl_old, 0)
         THEN
             -- пересчитали
             PERFORM gpInsertUpdate_MovementItem_SalePodium (ioId                      := MovementItem.Id        -- Ключ объекта <Элемент документа>
                                                           , inMovementId              := inMovementId           -- Ключ объекта <Документ>
                                                           , ioGoodsId                 := MovementItem.ObjectId  -- *** - Товар
                                                           , inPartionId               := MovementItem.PartionId -- Партия
                                                           , ioDiscountSaleKindId      := 0                      -- *** - Вид скидки при продаже
                                                           , inIsPay                   := FALSE                  -- добавить с оплатой
                                                           , ioAmount                  := MovementItem.Amount    -- Количество
                                                           , ioChangePercent           := 0                      -- *** - % Скидки

                                                           , ioSummChangePercent       := 0                      -- *** - Дополнительная скидка в продаже ГРН
                                                           , ioSummChangePercent_curr  := 0                      -- *** - Дополнительная скидка в продаже в валюте***

                                                           , ioOperPriceList           := MIFloat_OperPriceListReal.ValueData -- *** - Цена факт ГРН

                                                           , inBarCode_partner         := ''                         -- Штрих-код поставщика
                                                           , inBarCode_old             := ''                         -- Штрих-код из верхнего грида - old
                                                           , inComment                 := MIString_Comment.ValueData -- примечание
                                                           , inSession                 := inSession                  -- сессия пользователя
                                                            )

             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                              ON MIFloat_OperPriceListReal.MovementItemId = MovementItem.Id
                                             AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
            ;
         END IF;

     END IF;


     -- сохранили в Movement - Кросс-курс 
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyCrossValue(), inMovementId, inCurrencyValueCross);
     -- сохранили в Movement - Номинал для Кросс-курса
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParCrossValue(), inMovementId, inParValueCross);


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
