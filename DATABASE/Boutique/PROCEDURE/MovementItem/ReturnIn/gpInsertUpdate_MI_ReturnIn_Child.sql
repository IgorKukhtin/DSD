-- Function: gpInsertUpdate_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReturnIn_Child (Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                         ,TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReturnIn_Child(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ
    IN inisPayTotal            Boolean   ,
    IN inisPayGRN              Boolean   ,
    IN inisPayUSD              Boolean   ,
    IN inisPayEUR              Boolean   ,
    IN inisPayCard             Boolean   ,
    IN inisDiscount            Boolean   ,
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount        TFloat    , -- сумма скидки
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCashId_Exc Integer;
   DECLARE vbCashId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     -- проверка - документ должен быть сохранен
     /*IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

    SELECT Amount, ParValue
  INTO outCurrencyValue, outParValue
    FROM lfSelect_Movement_Currency_byDate (inOperDate:= '11.05.2017', inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD());
*/
     IF inisPayTotal = FALSE
        THEN
            SELECT Movement.OperDate 
                 , MovementLinkObject_To.ObjectId
           INTO vbOperDate, vbUnitId
            FROM Movement
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            WHERE Movement.Id = inMovementId;


           CREATE TEMP TABLE _tmpPay (CurrencyId Integer, Amount TFloat) ON COMMIT DROP;
             INSERT INTO _tmpPay (CurrencyId, Amount)
                   SELECT zc_Currency_GRN(), COALESCE(inAmountGRN,0) WHERE inisPayGRN = TRUE
                 UNION
                   SELECT zc_Currency_USD(), COALESCE(inAmountUSD,0) WHERE inisPayUSD = TRUE
                 UNION
                   SELECT zc_Currency_EUR(), COALESCE(inAmountEUR,0) WHERE inisPayEUR = TRUE;
   

           CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
             INSERT INTO _tmpCash (CashId, CurrencyId , Amount, CurrencyValue, ParValue)
                   SELECT tmp.CashId
                        , _tmpPay.CurrencyId
                        , _tmpPay.Amount
                        , COALESCE(tmpCurrency.Amount,1)     ::TFloat  AS CurrencyValue
                        , COALESCE(tmpCurrency.ParValue,0)   ::TFloat  AS ParValue
                   FROM _tmpPay
                        LEFT JOIN (SELECT Object_Cash.Id               AS CashId
                                        , ObjectLink_Cash_Currency.ChildObjectId AS CurrencyId
                                   FROM Object As Object_Cash
                                     INNER JOIN ObjectLink AS ObjectLink_Cash_Unit
                                             ON ObjectLink_Cash_Unit.ObjectId = Object_Cash.Id
                                            AND ObjectLink_Cash_Unit.DescId = zc_ObjectLink_Cash_Unit()
                                            AND ObjectLink_Cash_Unit.ChildObjectId = vbUnitId
                                     LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                            ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                           AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
                                   WHERE Object_Cash.DescId = zc_Object_Cash()
                                     AND Object_Cash.isErased = FALSE
                                   ) AS tmp ON tmp.CurrencyId = _tmpPay.CurrencyId
                        LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= _tmpPay.CurrencyId) AS tmpCurrency ON 1=1
                   WHERE _tmpPay.Amount <> 0 
                 UNION
                   SELECT ObjectLink_Unit_BankAccount.ChildObjectId AS BankAccountId
                        , ObjectLink_BankAccount_Currency.ChildObjectId
                        , COALESCE (inAmountCard,0)
                        , 1
                        , 0
                   FROM ObjectLink AS ObjectLink_Unit_BankAccount
                   INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                  ON ObjectLink_BankAccount_Currency.ObjectId = ObjectLink_Unit_BankAccount.ChildObjectId
                                 AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
                                 AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_Basis()
                   WHERE ObjectLink_Unit_BankAccount.DescId = zc_ObjectLink_Unit_BankAccount()
                     AND ObjectLink_Unit_BankAccount.ObjectId = vbUnitId 
                     AND inisPayCard = TRUE;

             CREATE TEMP TABLE _tmpMI (Id Integer, CashId Integer, CurrencyId Integer) ON COMMIT DROP;
                   INSERT INTO _tmpMI (Id, CashId, CurrencyId) 
                            SELECT MovementItem.Id
                                  , MovementItem.ObjectId          AS CashId
                                  , MILinkObject_Currency.ObjectId AS CurrencyId
                             FROM MovementItem
                                   LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                             WHERE MovementItem.ParentId   = inParentId
                               AND MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Child()
                               AND MovementItem.isErased   = FALSE;
                      

            -- сохранили
            PERFORM lpInsertUpdate_MI_ReturnIn_Child  (ioId                 := COALESCE (_tmpMI.Id,0)
                                                     , inMovementId         := inMovementId
                                                     , inParentId           := inParentId
                                                     , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                                     , inCurrencyId         := COALESCE (_tmpCash.CurrencyId, _tmpMI.CurrencyId)
                                                     , inCashId_Exc         := Null
                                                     , inAmount             := COALESCE (_tmpCash.Amount,0)
                                                     , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue,1)
                                                     , inParValue           := COALESCE (_tmpCash.ParValue,0)
                                                     , inUserId             := vbUserId
                                                      )
             FROM _tmpCash
                 FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId
                                 AND _tmpMI.CurrencyId = _tmpCash.CurrencyId;

            -- скидку записываем в мастер
            IF inisDiscount THEN
               -- сохранили свойство <>
               PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inParentId, inAmountDiscount);
            END IF;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.17         *
*/

-- тест
-- select * from gpInsertUpdate_MI_ReturnIn_Child(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');