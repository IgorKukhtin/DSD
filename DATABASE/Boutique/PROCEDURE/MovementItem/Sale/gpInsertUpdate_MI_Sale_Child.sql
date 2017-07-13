-- Function: gpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                     ,TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                     ,TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
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
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- проверка - свойство должно быть установлено
     IF COALESCE (inParentId, 0) = 0 AND vbUserId = zc_User_Sybase() THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <inParentId>.';
     END IF;


     -- данные из документа
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- проверка - CurrencyId должен быть уникальным
     IF EXISTS (SELECT 1
                FROM Object AS Object_Unit
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                          ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                         AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                     LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                          ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                         AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                     LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                          ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                         AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                         AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                     INNER JOIN Object AS Object_Cash
                                       ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                      AND Object_Cash.DescId   = zc_Object_Cash()
                                      AND Object_Cash.isErased = FALSE
                     INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                           ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                          AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                          AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                WHERE Object_Unit.Id = vbUnitId
                HAVING COUNT(*) > 1
               )
     THEN
        RAISE EXCEPTION 'Ошибка.Для магазина <%> установлено несколько касс в валюте <%>.', lfGet_Object_ValueData (vbUnitId)
                       , lfGet_Object_ValueData ((SELECT tmp.CurrencyId
                                                  FROM (SELECT ObjectLink_Cash_Currency.ChildObjectId
                                                        FROM Object AS Object_Unit
                                                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                                                 AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                                                             LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                                                                  ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                                                                 AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                                                             LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                                                                  ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                                                                 AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                                                                 AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                                                             INNER JOIN Object AS Object_Cash
                                                                               ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                                                              AND Object_Cash.DescId   = zc_Object_Cash()
                                                                              AND Object_Cash.isErased = FALSE
                                                             INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                                                   ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                                                                  AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                                                                  AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                                                        WHERE Object_Unit.Id = vbUnitId
                                                        GROUP BY ObjectLink_Cash_Currency.ChildObjectId
                                                        HAVING COUNT(*) > 1
                                                       ) AS tmp LIMIT 1))
                        ;
     END IF;


     -- оплата 1 товара
     IF inParentId >  0
     THEN
         -- находим кассу для Магазина или р.сч., в которую попадет оплата
         CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
         --
         INSERT INTO _tmpCash (CashId, CurrencyId , Amount, CurrencyValue, ParValue)
            WITH -- оплата - НАЛ
                 tmpPay AS (SELECT zc_Currency_GRN() AS CurrencyId, inAmountGRN AS Amount, 0 AS CurrencyValue, 0 AS ParValue WHERE inAmountGRN <> 0
                           UNION
                            SELECT zc_Currency_USD() AS CurrencyId, inAmountUSD AS Amount, COALESCE (inCurrencyValueUSD, 1) AS CurrencyValue, CASE WHEN inParValueUSD > 0 THEN inParValueUSD ELSE  1 END AS ParValue WHERE inAmountUSD > 0
                           UNION
                            SELECT zc_Currency_EUR() AS CurrencyId, inAmountEUR AS Amount, COALESCE (inCurrencyValueEUR, 1) AS CurrencyValue, CASE WHEN inParValueEUR > 0 THEN inParValueEUR ELSE  1 END AS ParValue WHERE inAmountEUR > 0
                           )
                 -- кассы Магазина
               , tmpCash AS (SELECT Object_Cash.Id                          AS CashId
                                  , ObjectLink_Cash_Currency.ChildObjectId  AS CurrencyId
                             FROM Object AS Object_Unit
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                       ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                      AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                                  LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                                       ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                                      AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                                  LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                                       ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                                      AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                                      AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                                  INNER JOIN Object AS Object_Cash
                                                    ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                                   AND Object_Cash.DescId   = zc_Object_Cash()
                                                   AND Object_Cash.isErased = FALSE
                                  INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                        ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                                       AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                                       AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                             WHERE Object_Unit.Id = vbUnitId
                            )
                 -- нашли кассу
                 SELECT tmpCash.CashId
                      , tmpPay.CurrencyId
                      , tmpPay.Amount
                      , tmpPay.CurrencyValue
                      , tmpPay.ParValue
                 FROM tmpPay
                      INNER JOIN tmpCash ON tmpCash.CurrencyId = tmpPay.CurrencyId
                UNION ALL
                 -- расчетный счет Магазина - в ГРН
                 SELECT ObjectLink_Unit_BankAccount.ChildObjectId     AS CashId
                      , ObjectLink_BankAccount_Currency.ChildObjectId AS CurrencyId
                      , inAmountCard AS Amount
                      , 0            AS CurrencyValue
                      , 0            AS ParValue
                 FROM ObjectLink AS ObjectLink_Unit_BankAccount
                      INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                            ON ObjectLink_BankAccount_Currency.ObjectId      = ObjectLink_Unit_BankAccount.ChildObjectId
                                           AND ObjectLink_BankAccount_Currency.DescId        = zc_ObjectLink_BankAccount_Currency()
                                           AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_GRN()
                 WHERE ObjectLink_Unit_BankAccount.ObjectId = vbUnitId
                   AND ObjectLink_Unit_BankAccount.DescId   = zc_ObjectLink_Unit_BankAccount()
                   AND inAmountCard                         <> 0
                ;

         -- проверка - CashId должен быть уникальным
         IF EXISTS (SELECT 1 FROM _tmpCash GROUP BY _tmpCash.CashId HAVING COUNT(*) > 1) THEN
            RAISE EXCEPTION 'Ошибка.Дублируется элемент <%>.', lfGet_Object_ValueData ((SELECT tmp.CashId FROM (SELECT _tmpCash.CashId FROM _tmpCash GROUP BY _tmpCash.CashId HAVING COUNT(*) > 1) AS tmp LIMIT 1));
         END IF;


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


         -- в мастер записать - Дополнительная скидка в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inParentId, inAmountDiscount);

         -- в мастер записать - Итого скидка в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), inParentId
                                                 , inAmountDiscount
                                                  + COALESCE ((SELECT SUM (CAST (CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 0))
                                                                               * COALESCE (MIFloat_ChangePercent.ValueData, 0) / 100 AS NUMERIC (16, 0)))
                                                               FROM MovementItem
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                                                ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                                                ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                                               WHERE MovementItem.Id       = inParentId
                                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                                 AND MovementItem.isErased = FALSE
                                                              ), 0));

         -- в мастер записать - Итого оплата в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), inParentId
                                                 , COALESCE ((SELECT SUM (_tmpCash.Amount * CASE WHEN _tmpCash.CurrencyId = zc_Currency_GRN() THEN 1 ELSE _tmpCash.CurrencyValue / _tmpCash.ParValue END)
                                                              FROM _tmpCash
                                                             ), 0));


         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     END IF;

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
