-- Function: gpUpdateMovement_OrderFinance_Plan()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Plan(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inisAmountPlan_1          Boolean    , --
    IN inisAmountPlan_2          Boolean    , --
    IN inisAmountPlan_3          Boolean    , --
    IN inisAmountPlan_4          Boolean    , --
    IN inisAmountPlan_5          Boolean    , -- 
    IN inJuridicalOrderFinanceId Integer    ,
    IN inBankId_jof              Integer    ,
    IN inBankAccountName_jof     TVarChar   ,  --zc_ObjectLink_JuridicalOrderFinance_BankAccount
    IN inComment_jof             TVarChar   ,
    IN inComment_pay             TVarChar   ,  
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbUserId     Integer;
            vbBankAccountId_jof   Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


   /*  IF COALESCE (vbMemberId,0) <> COALESCE (vbMemberId_1,0)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя нет доступа изменять значения <Согласован-1>.';
     END IF;
     */


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_1(), inMovementItemId, inisAmountPlan_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_2(), inMovementItemId, inisAmountPlan_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_3(), inMovementItemId, inisAmountPlan_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_4(), inMovementItemId, inisAmountPlan_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_5(), inMovementItemId, inisAmountPlan_5);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_pay(), inMovementItemId, inComment_pay);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.25         *
*/


-- тест
--