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


     -- Проверка - Дата Документа
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка.Нет доступа для проведения - gpComplete_Movement_Sale_recalc.';
     END IF;

     --
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- Проверка - Дата Документа
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , OperCount TFloat, OperPriceList TFloat, OperPriceList_pl TFloat, SummChangePercent TFloat
                               , TotalSummPriceList TFloat, TotalChangePercent TFloat, TotalPay TFloat
                               , CurrencyValue TFloat, ParValue TFloat
                               , CashId Integer
                                ) ON COMMIT DROP;
     INSERT INTO _tmpItem_recalc (MovementItemId
                                , OperCount, OperPriceList, OperPriceList_pl, SummChangePercent
                                , TotalSummPriceList, TotalChangePercent, TotalPay
                                , CurrencyValue, ParValue
                                , CashId
                                 )
        WITH -- Курс - из истории
             tmpCurrency AS (SELECT *
                             FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate      := vbOperDate
                                                                      , inCurrencyFromId:= zc_Currency_Basis()
                                                                      , inCurrencyToId  := 0
                                                                       )
                            )
                 , tmpMI AS (SELECT MovementItem.Id                     AS MovementItemId
                                  , MovementItem.Amount                 AS OperCount
                                  , MIFloat_ChangePercent.ValueData     AS ChangePercent
                                  , MIFloat_OperPriceListReal.ValueData AS OperPriceList
                                  , COALESCE ((SELECT zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmp.ValuePrice, tmpCurrency.Amount, tmpCurrency.ParValue))
                                               FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                     , OL_pl.ChildObjectId
                                                                                     , MovementItem.ObjectId
                                                                                      ) AS tmp)
                                             , 0) AS OperPriceList_pl
                                  , (SELECT lpSelect.CashId FROM lpSelect_Object_Cash (MovementLinkObject_From.ObjectId, vbUserId) AS lpSelect
                                     WHERE lpSelect.isBankAccount = FALSE
                                       AND lpSelect.CurrencyId    = zc_Currency_GRN()
                                    ) AS CashId

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
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MovementLinkObject_From.ObjectId
                                                               AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
                                  LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = OL_pl.ChildObjectId
                                                                     AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()

                                  LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = OL_currency.ChildObjectId OR tmpCurrency.CurrencyToId = OL_currency.CurrencyId)
                                                       AND OL_currency.CurrencyId <> zc_Currency_Basis()

                             WHERE Movement.Id       = inMovementId
                               AND Movement.DescId   = zc_Movement_Sale()
                             --AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                            )
        SELECT tmpMI.MovementItemId
             , tmpMI.OperCount
             , tmpMI.OperPriceList
             , tmpMI.OperPriceList_pl
               -- SummChangePercent: 10% = 900 - 800 = 100
             , zfCalc_SummChangePercent (tmpMI.OperCount, tmpMI.OperPriceList_pl, tmpMI.ChangePercent)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS SummChangePercent

               -- TotalSummPriceList: 1000
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_pl) AS TotalSummPriceList

               -- TotalChangePercent: 1000 - 800
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList_pl)
             - zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS TotalChangePercent

               -- TotalPay: 1000 - 200
             , zfCalc_SummPriceList (tmpMI.OperCount, tmpMI.OperPriceList) AS TotalPay

             , tmpCurrency.Amount   AS CurrencyValue
             , tmpCurrency.ParValue AS ParValue
             
             , tmpMI.CashId
        FROM tmpMI
       ;

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), _tmpItem_recalc.MovementItemId, COALESCE (MovementItemId.SummChangePercent, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), _tmpItem_recalc.MovementItemId, _tmpItem_recalc.TotalChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), _tmpItem_recalc.MovementItemId, _tmpItem_recalc.TotalPay)
     FROM _tmpItem_recalc
    ;

     -- сохранили
     PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := tmp.Id
                                         , inMovementId         := inMovementId
                                         , inParentId           := ioId
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
                          WHERE MovementItem.ParentId   = ioId
                            AND MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Child()
                            AND MovementItem.isErased   = FALSE
                         )
           SELECT tmpMI.Id                                                  AS Id
                , COALESCE (_tmpCash.CashId, _tmpItem_recalc.CashId)                  AS CashId
                , COALESCE (_tmpCash.CurrencyId, tmpMI.CurrencyId)          AS CurrencyId
                , CASE WHEN _tmpCash.CashId > 0 THEN _tmpItem_recalc.TotalPay ELSE 0 END AS Amount
                , COALESCE (tmpMI.CurrencyValue_pl, 0) AS CurrencyValue
                , COALESCE (tmpMI.ParValue_pl, 0)      AS ParValue
           FROM (SELECT DISTINCT _tmpItem_recalcCashId AS CashId, zc_Currency_GRN() AS CurrencyId FROM _tmpItem_recalc
                ) AS _tmpCash
                FULL JOIN tmpMI ON tmpMI.CashId = _tmpCash.CashId
          ) AS tmp
     ;


     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- собственно проводки
     PERFORM lpComplete_Movement_Sale (inMovementId  -- Документ
                                     , vbUserId);    -- Пользователь

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
