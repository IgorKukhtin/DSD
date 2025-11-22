-- Function: gpUpdateMovement_OrderFinance_Plan()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Plan (Integer, Integer, Boolean,Boolean,Boolean,Boolean,Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Plan(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inisAmountPlan_1          Boolean    , --
    IN inisAmountPlan_2          Boolean    , --
    IN inisAmountPlan_3          Boolean    , --
    IN inisAmountPlan_4          Boolean    , --
    IN inisAmountPlan_5          Boolean    , -- 
    IN inOrderFinanceId          Integer    ,
    IN inJuridicalOrderFinanceId Integer    ,
    IN inJuridicalId             Integer    ,
    IN inInfoMoneyId             Integer    , 
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
            vbBankAccountId_main  Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


   /*  IF COALESCE (vbMemberId,0) <> COALESCE (vbMemberId_1,0)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя нет доступа изменять значения <Согласован-1>.';
     END IF;
     */

     ---строки документа
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
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


     -- BankAccount
     IF COALESCE (inBankAccountName_jof,'') <> ''
     THEN
         IF COALESCE (inBankId_jof, 0) = 0
         THEN
           RAISE EXCEPTION 'Ошибка.Банк не выбран для <%> ', inBankAccountName_jof;
         END IF; 
          
         --пробуем найти
         vbBankAccountId_jof:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BankAccount() AND UPPER (TRIM (Object.VAlueData)) = UPPER (TRIM (inBankAccountName_jof)));   
         
         IF COALESCE (vbBankAccountId_jof, 0) = 0
         THEN
             -- сохранили <Объект>
             vbBankAccountId_jof := lpInsertUpdate_Object(vbBankAccountId_jof, zc_Object_BankAccount(), 0, TRIM (inBankAccountName_jof));

             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId_jof, inJuridicalId);
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId_jof, inBankId_jof);

             -- сохранили протокол
             PERFORM lpInsert_ObjectProtocol (vbBankAccountId_jof, vbUserId);
         END IF;
         
         --- zc_ObjectLink_JuridicalOrderFinance_BankAccount
         -- если inJuridicalOrderFinanceId = 0 создаем объект
         IF COALESCE (inJuridicalOrderFinanceId,0) = 0
         THEN 
             --сохранили <Объект>
             inJuridicalOrderFinanceId := lpInsertUpdate_Object (0, zc_Object_JuridicalOrderFinance(), 0, '');

             vbBankAccountId_main := (SELECT ObjectLink.ChildObjectId
                                      FROM ObjectLink
                                      WHERE ObjectLink.DescId = zc_ObjectLink_OrderFinance_BankAccount()
                                        AND ObjectLink.ObjectId = inOrderFinanceId
                                      );
             -- сохранили связь с <>
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_Juridical(), inJuridicalOrderFinanceId, inJuridicalId);
             -- сохранили связь с <>
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccountMain(), inJuridicalOrderFinanceId, vbBankAccountId_main);              
             -- сохранили связь с <>
             PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_InfoMoney(), inJuridicalOrderFinanceId, inInfoMoneyId);
         END IF;
             
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalOrderFinance_BankAccount(), inJuridicalOrderFinanceId, vbBankAccountId_jof);
         -- сохранили св-во <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_JuridicalOrderFinance_Comment(), inJuridicalOrderFinanceId, inComment_jof);

         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (inJuridicalOrderFinanceId, vbUserId);
     END IF;

     if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok.'; end if;
  
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