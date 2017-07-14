-- Function: gpInsertUpdate_MI_GoodsAccount_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsAccount_Child(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount        TFloat    , -- сумма скидки
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
   DECLARE vbCashId_Exc Integer;
   DECLARE vbCashId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());


     -- оплата 1 товара
     IF COALESCE (inParentId,0) <> 0
        THEN
            -- данные из документа дата
            SELECT Movement.OperDate 
           INTO vbOperDate
            FROM Movement
            WHERE Movement.Id = inMovementId;

            -- данные из документа подразделение
            SELECT MovementLinkObject_Unit.ObjectId
          INTO vbUnitId
            FROM MovementItemLinkObject AS MILinkObject_PartionMI
                 LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId 
                 LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                 LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                             AND MovementLinkObject_Unit.DescId = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                                       WHEN Movement_Sale.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                                                  END
            WHERE MILinkObject_PartionMI.MovementItemId = inParentId
              AND MILinkObject_PartionMI.DescId = zc_MILinkObject_PartionMI();

           -- таблица данных валюта, оплата, курс
           CREATE TEMP TABLE _tmpPay (CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
             INSERT INTO _tmpPay (CurrencyId, Amount, CurrencyValue, ParValue)
                   SELECT zc_Currency_GRN(), COALESCE(inAmountGRN,0), 1, 1
                 UNION
                   SELECT zc_Currency_USD(), COALESCE(inAmountUSD,0), COALESCE(inCurrencyValueUSD,1), COALESCE(inParValueUSD,1)
                 UNION
                   SELECT zc_Currency_EUR(), COALESCE(inAmountEUR,0), COALESCE(inCurrencyValueEUR,1), COALESCE(inParValueEUR,1);
   
           -- определяем кассу для подразделение /валюта 
           CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
             INSERT INTO _tmpCash (CashId, CurrencyId , Amount, CurrencyValue, ParValue)
                   SELECT tmp.CashId
                        , _tmpPay.CurrencyId
                        , _tmpPay.Amount
                        , _tmpPay.CurrencyValue  ::TFloat  AS CurrencyValue
                        , _tmpPay.ParValue       ::TFloat  AS ParValue
                   FROM _tmpPay
                        LEFT JOIN (SELECT Object_Cash.Id               AS CashId
                                        , ObjectLink_Cash_Currency.ChildObjectId AS CurrencyId
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
                                  ) AS tmp ON tmp.CurrencyId = _tmpPay.CurrencyId
                 UNION
                   -- расчетный счет подразделения
                   SELECT ObjectLink_Unit_BankAccount.ChildObjectId AS BankAccountId
                        , ObjectLink_BankAccount_Currency.ChildObjectId
                        , COALESCE (inAmountCard,0)
                        , 1
                        , 1
                   FROM ObjectLink AS ObjectLink_Unit_BankAccount
                   INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                  ON ObjectLink_BankAccount_Currency.ObjectId = ObjectLink_Unit_BankAccount.ChildObjectId
                                 AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
                                 AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_Basis()
                   WHERE ObjectLink_Unit_BankAccount.DescId = zc_ObjectLink_Unit_BankAccount()
                     AND ObjectLink_Unit_BankAccount.ObjectId = vbUnitId 
                   ;
             -- выбираем сохраненные чайлды
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
            PERFORM lpInsertUpdate_MI_GoodsAccount_Child  (ioId                 := COALESCE (_tmpMI.Id,0)
                                                         , inMovementId         := inMovementId
                                                         , inParentId           := inParentId
                                                         , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                                         , inCurrencyId         := COALESCE (_tmpCash.CurrencyId, _tmpMI.CurrencyId)
                                                         , inCashId_Exc         := Null
                                                         , inAmount             := COALESCE (_tmpCash.Amount,0)
                                                         , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue,1)
                                                         , inParValue           := COALESCE (_tmpCash.ParValue,1)
                                                         , inUserId             := vbUserId
                                                          )
             FROM _tmpCash
                 FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId
                                 AND _tmpMI.CurrencyId = _tmpCash.CurrencyId;

            -- скидку записываем в мастер
            -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inParentId, inAmountDiscount);

            -- в мастер записать итого сумма оплаты грн
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), inParentId, SUM (COALESCE (_tmpCash.Amount,0) * COALESCE (_tmpCash.CurrencyValue,1)) )
            FROM _tmpCash
                FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId
                                AND _tmpMI.CurrencyId = _tmpCash.CurrencyId
             ; 

     END IF;
     

     -- "сложно" пересчитали "итоговые" суммы по ВСЕМ элементам - здесь оплата за продажу
     PERFORM lpUpdate_MI_Sale_Total (Object.ObjectCode)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILO_PartionMI
                                            ON MILO_PartionMI.MovementItemId = MovementItem.Id
                                           AND MILO_PartionMI.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object ON Object.Id = MILO_PartionMI.ObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

     -- "сложно" пересчитали "итоговые" суммы по ВСЕМ элементам - здесь возврат оплаты
     PERFORM lpUpdate_MI_Sale_Total (Object.ObjectCode)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILO_PartionMI_return
                                            ON MILO_PartionMI_return.MovementItemId = MovementItem.Id
                                           AND MILO_PartionMI_return.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object AS Object_PartionMI_return ON Object_PartionMI_return.Id = MILO_PartionMI_return.ObjectId

          INNER JOIN MovementItemLinkObject AS MILO_PartionMI
                                            ON MILO_PartionMI.MovementItemId = Object_PartionMI_return.ObjectCode
                                           AND MILO_PartionMI.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object ON Object.Id = MILO_PartionMI.ObjectId

     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_GoodsAccount_Child (inMovementId := 35 , inParentId := 112 , inisPayTotal := 'False' , inisPayGRN := 'True' , inisPayUSD := 'False' , inisPayEUR := 'False' , inisPayCard := 'False' , inisDiscount := 'False' , inAmountGRN := 100 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCARD := 0 , inAmountDiscount := 0 ,  inSession := '2');
