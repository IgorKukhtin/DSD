-- Function: gpComplete_Movement_Sale_recalc()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale_recalc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale_recalc(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());


     -- Проверка
     IF zc_Enum_GlobalConst_isTerry() = TRUE OR zfCalc_User_PriceListReal (vbUserId) = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка.Нет доступа для проведения - gpComplete_Movement_Sale_recalc.';
     END IF;

     --
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_recalc (MovementItemId Integer, GoodsId Integer
                                      , OperCount TFloat, OperPriceList TFloat, OperPriceList_pl TFloat, OperPriceList_curr TFloat
                                      , SummChangePercent TFloat, SummChangePercent_curr TFloat
                                      , TotalSummPriceList      TFloat, TotalChangePercent      TFloat, TotalPay      TFloat
                                      , TotalSummPriceList_curr TFloat, TotalChangePercent_curr TFloat, TotalPay_curr TFloat
                                      , CurrencyId_pl Integer
                                      , CurrencyValue TFloat, ParValue TFloat
                                      , CashId Integer, CurrencyId_cash Integer
                                       ) ON COMMIT DROP;
     INSERT INTO _tmpItem_recalc (MovementItemId, GoodsId
                                , OperCount, OperPriceList, OperPriceList_pl, OperPriceList_curr
                                , SummChangePercent, SummChangePercent_curr
                                , TotalSummPriceList, TotalSummPriceList_curr
                                , TotalChangePercent, TotalChangePercent_curr
                                , TotalPay, TotalPay_curr
                                , CurrencyId_pl
                                , CurrencyValue, ParValue
                                , CashId, CurrencyId_cash
                                 )
        WITH -- Курс - из истории
             tmpCurrency AS (SELECT *
                             FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate      := vbOperDate
                                                                      , inCurrencyFromId:= zc_Currency_Basis()
                                                                      , inCurrencyToId  := 0
                                                                       )
                            )
                 , tmpMI AS (SELECT MovementItem.Id                     AS MovementItemId
                                  , MovementItem.ObjectId               AS GoodsId
                                  , MovementItem.Amount                 AS OperCount
                                  , MIFloat_ChangePercent.ValueData     AS ChangePercent
                                  , MIFloat_ChangePercentNext.ValueData AS ChangePercentNext

                                    -- Цена факт ГРН, со всеми скидками
                                  , MIFloat_OperPriceListReal.ValueData AS OperPriceList
                                    -- Цена факт - в валюте, со всеми скидками - !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                  , zfCalc_SummPriceList (1, zfCalc_CurrencySumm (MIFloat_OperPriceListReal.ValueData, zc_Currency_Basis(), zc_Currency_EUR(), tmpCurrency.Amount, tmpCurrency.ParValue)) AS OperPriceListReal_curr

                                    -- Цена по прайсу, без скидки - в ГРН
                                  , COALESCE ((SELECT zfCalc_SummPriceList (1, zfCalc_CurrencySumm (tmp.ValuePrice, tmp.CurrencyId, zc_Currency_Basis(), tmpCurrency.Amount, tmpCurrency.ParValue))
                                               FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                     , OL_pl.ChildObjectId
                                                                                     , MovementItem.ObjectId
                                                                                      ) AS tmp)
                                            , 0.0) AS OperPriceList_pl
                                    -- Цена по прайсу, без скидки - в валюте - !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                  , COALESCE ((SELECT zfCalc_SummPriceList (1, zfCalc_CurrencySumm (tmp.ValuePrice, tmp.CurrencyId, zc_Currency_EUR(), tmpCurrency.Amount, tmpCurrency.ParValue))
                                               FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                     , OL_pl.ChildObjectId
                                                                                     , MovementItem.ObjectId
                                                                                      ) AS tmp)
                                            , 0.0) AS OperPriceList_curr

                                    -- CurrencyId_pl
                                  , COALESCE ((SELECT tmp.CurrencyId
                                               FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                     , OL_pl.ChildObjectId
                                                                                     , MovementItem.ObjectId
                                                                                      ) AS tmp)
                                            , zc_Currency_Basis()) AS CurrencyId_pl

                                  , (SELECT lpSelect.CashId FROM lpSelect_Object_Cash (MovementLinkObject_From.ObjectId, vbUserId) AS lpSelect
                                     WHERE lpSelect.isBankAccount = FALSE
                                       AND lpSelect.CurrencyId    = zc_Currency_GRN()
                                    ) AS CashId
                                  , zc_Currency_GRN() AS CurrencyId_cash

                                  , tmpCurrency.Amount   AS CurrencyValue
                                  , tmpCurrency.ParValue AS ParValue

                             FROM Movement
                                  JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                  LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                                              ON MIFloat_OperPriceListReal.MovementItemId = MovementItem.Id
                                                             AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
                                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                              ON MIFloat_ChangePercentNext.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MovementLinkObject_From.ObjectId
                                                               AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
                                  LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = OL_pl.ChildObjectId
                                                                     AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()

                                  LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = OL_currency.ChildObjectId OR tmpCurrency.CurrencyToId = OL_currency.ChildObjectId)
                                                       AND OL_currency.ChildObjectId <> zc_Currency_Basis()

                             WHERE Movement.Id       = inMovementId
                               AND Movement.DescId   = zc_Movement_Sale()
                             --AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                            )
        SELECT tmpMI.MovementItemId
             , tmpMI.GoodsId
             , tmpMI.OperCount
             , tmpMI.OperPriceList
             , tmpMI.OperPriceList_pl
             , tmpMI.OperPriceList_curr

               -- SummChangePercent: 10% = 900 - 800 = 100
             , zfCalc_SummChangePercentNext (tmpMI.OperCount, tmpMI.OperPriceList_pl, tmpMI.ChangePercent, tmpMI.ChangePercentNext)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS SummChangePercent
               -- SummChangePercent_curr: 10% = 900 - 800 = 100
             , zfCalc_SummChangePercentNext (tmpMI.OperCount, tmpMI.OperPriceList_curr, tmpMI.ChangePercent, tmpMI.ChangePercentNext)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceListReal_curr) AS SummChangePercent_curr

               -- TotalSummPriceList: 1000
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_pl)   AS TotalSummPriceList
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_curr) AS TotalSummPriceList_curr

               -- TotalChangePercent: 1000 - 800
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_pl)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS TotalChangePercent
               -- TotalChangePercent_curr: 1000 - 800
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_curr)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceListReal_curr) AS TotalChangePercent_curr

               -- TotalPay: 1000 - 200
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS TotalPay
               -- TotalPay_curr: 1000 - 200
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceListReal_curr) AS TotalPay_curr

             , tmpMI.CurrencyId_pl

             , tmpMI.CurrencyValue
             , tmpMI.ParValue

             , tmpMI.CashId
             , tmpMI.CurrencyId_cash
        FROM tmpMI
       ;

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(),      _tmpItem_recalc.MovementItemId, _tmpItem_recalc.OperPriceList_pl)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList_curr(), _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.OperPriceList_curr, 0))

           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(),      _tmpItem_recalc.MovementItemId, _tmpItem_recalc.SummChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(), _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.SummChangePercent_curr, 0))

           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(),      _tmpItem_recalc.MovementItemId, _tmpItem_recalc.TotalChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.TotalChangePercent_curr, 0))

           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      _tmpItem_recalc.MovementItemId, _tmpItem_recalc.TotalPay)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.TotalPay_curr, 0))

           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency_pl(), _tmpItem_recalc.MovementItemId, _tmpItem_recalc.CurrencyId_pl)

           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(),      _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.CurrencyValue, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),           _tmpItem_recalc.MovementItemId, COALESCE (_tmpItem_recalc.ParValue, 0))

     FROM _tmpItem_recalc
    ;
--    RAISE EXCEPTION '.<%>  <%>  <%>'
--    , (select sum (_tmpItem_recalc.SummChangePercent) from _tmpItem_recalc)
--    , (select sum (_tmpItem_recalc.TotalChangePercent) from _tmpItem_recalc)
--    , (select sum (_tmpItem_recalc.TotalPay) from _tmpItem_recalc)
--    ;
/*
    RAISE EXCEPTION 'Ошибка.<%>   %   %', (select _tmpItem_recalc.TotalChangePercent from _tmpItem_recalc)
, (select _tmpItem_recalc.TotalChangePercent_curr from _tmpItem_recalc)
, (select _tmpItem_recalc.OperPriceList_pl from _tmpItem_recalc)

;*/

     -- сохранили
     PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := tmp.Id
                                         , inMovementId         := inMovementId
                                         , inParentId           := tmp.ParentId
                                         , inCashId             := tmp.CashId
                                         , inCurrencyId         := tmp.CurrencyId
                                         , inCashId_Exc         := NULL
                                         , inAmount             := tmp.Amount
                                         , inCurrencyValue      := tmp.CurrencyValue
                                         , inParValue           := tmp.ParValue
                                         , inUserId             := vbUserId
                                          )
     FROM (WITH tmpMI AS (SELECT MovementItem.Id                 AS Id
                               , MovementItem.ObjectId           AS CashId
                               , MovementItem.ParentId           AS ParentId
                               , MILinkObject_Currency.ObjectId  AS CurrencyId
                               , MIFloat_CurrencyValue.ValueData AS CurrencyValue
                               , MIFloat_ParValue.ValueData      AS ParValue
                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                           ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                               LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                           ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Child()
                            AND MovementItem.isErased   = FALSE
                         )
           SELECT tmpMI.Id                                                        AS Id
                , COALESCE (_tmpCash.MovementItemId, tmpMI.ParentId)              AS ParentId
                , COALESCE (_tmpCash.CashId, tmpMI.CashId)                        AS CashId
                , COALESCE (_tmpCash.CurrencyId, tmpMI.CurrencyId)                AS CurrencyId
                , CASE WHEN _tmpCash.CashId > 0 THEN _tmpCash.TotalPay ELSE 0 END AS Amount
                , COALESCE (tmpMI.CurrencyValue, 0)                               AS CurrencyValue
                , COALESCE (tmpMI.ParValue, 1)                                    AS ParValue
           FROM (SELECT DISTINCT _tmpItem_recalc.MovementItemId, _tmpItem_recalc.CashId, _tmpItem_recalc.CurrencyId_cash AS CurrencyId, _tmpItem_recalc.TotalPay FROM _tmpItem_recalc
                ) AS _tmpCash
                FULL JOIN tmpMI ON tmpMI.CashId   = _tmpCash.CashId
                               AND tmpMI.ParentId = _tmpCash.MovementItemId
          ) AS tmp
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 14.05.17         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Sale_recalc (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
