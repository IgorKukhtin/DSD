-- Function: lpInsertUpdate_MovementItem_OrderFinance()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , -- 
    IN inContractId            Integer   , -- 
    --IN inBankAccountId         Integer   , --
    IN inAmount                TFloat    , -- 
    --IN inAmountStart           TFloat    , -- 
    IN inAmountPlan_1          TFloat    , --
    IN inAmountPlan_2          TFloat    , --
    IN inAmountPlan_3          TFloat    , --
    IN inAmountPlan_4          TFloat    , --
    IN inAmountPlan_5          TFloat    , --
    IN inisAmountPlan_1        Boolean    , --
    IN inisAmountPlan_2        Boolean    , --
    IN inisAmountPlan_3        Boolean    , --
    IN inisAmountPlan_4        Boolean    , --
    IN inisAmountPlan_5        Boolean    , --
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --проверка что договор не закрыт
     IF (SELECT ObjectLink_Contract_ContractStateKind.ChildObjectId
         FROM ObjectLink AS ObjectLink_Contract_ContractStateKind
         WHERE ObjectLink_Contract_ContractStateKind.ObjectId = inContractId
            AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
        ) = zc_Enum_ContractStateKind_Close()
     THEN
         RAISE EXCEPTION 'Ошибка.Договор <%> уже Завершен.', (SELECT '(' ||Object.ObjectCode||') '|| Object.ValueData FROM Object WHERE Object.Id = inContractId);
     END IF;
      

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);

     -- сохранили свойство <>
     --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStart(), ioId, inAmountStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_1(), ioId, inAmountPlan_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_2(), ioId, inAmountPlan_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_3(), ioId, inAmountPlan_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_4(), ioId, inAmountPlan_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_5(), ioId, inAmountPlan_5);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_1(), ioId, inisAmountPlan_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_2(), ioId, inisAmountPlan_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_3(), ioId, inisAmountPlan_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_4(), ioId, inisAmountPlan_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_5(), ioId, inisAmountPlan_5);


     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

     -- сохранили протокол
     -- !!! времнно откл.!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.25         *
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- тест
--