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
   DECLARE vbIsInsert       Boolean;
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbSum_1 TFloat;
   DECLARE vbSum_2 TFloat;
   DECLARE vbSum_3 TFloat;
   DECLARE vbSum_1_sum TFloat;
   DECLARE vbSum_2_sum TFloat;
   DECLARE vbSum_3_sum TFloat;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- проверка что договор не закрыт
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
     /*PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_1(), ioId, inisAmountPlan_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_2(), ioId, inisAmountPlan_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_3(), ioId, inisAmountPlan_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_4(), ioId, inisAmountPlan_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPlan_5(), ioId, inisAmountPlan_5);*/


     -- нашли
     vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId = inMovementId
                            AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                         );


     SELECT COALESCE (MovementFloat_TotalSumm_1.ValueData, 0)
          , COALESCE (MovementFloat_TotalSumm_2.ValueData, 0)
          , COALESCE (MovementFloat_TotalSumm_2.ValueData, 0)
            INTO vbSum_1, vbSum_2, vbSum_3
     FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_1
                                    ON MovementFloat_TotalSumm_1.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_1.DescId = zc_MovementFloat_TotalSumm_1()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_2
                                    ON MovementFloat_TotalSumm_2.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_2.DescId = zc_MovementFloat_TotalSumm_2()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_3
                                    ON MovementFloat_TotalSumm_3.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_3.DescId = zc_MovementFloat_TotalSumm_3()
     WHERE Movement.Id = inMovementId
    ;

     -- Результат - после InsertUpdate
     SELECT tmpMI.Sum_1_sum, tmpMI.Sum_2_sum, tmpMI.Sum_3_sum
            INTO vbSum_1_sum, vbSum_2_sum, vbSum_3_sum
     FROM (WITH -- УП-Статья или Группа или ...
                tmpOrderFinanceProperty AS (SELECT DISTINCT
                                                   -- УП - Статья или Группа или ...
                                                   OL_OrderFinanceProperty_Object.ChildObjectId               AS ObjectId
                                                   -- № п/п группы
                                                 , ObjectFloat_Group.ValueData                                AS NumGroup

                                            FROM ObjectLink AS OL_OrderFinanceProperty_OrderFinance
                                                 INNER JOIN Object ON Object.Id       = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                  -- не удален
                                                                  AND Object.isErased = FALSE
                                                 -- УП - Статья или Группа или ...
                                                 INNER JOIN ObjectLink AS OL_OrderFinanceProperty_Object
                                                                       ON OL_OrderFinanceProperty_Object.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                      AND OL_OrderFinanceProperty_Object.DescId        = zc_ObjectLink_OrderFinanceProperty_Object()
                                                                      AND OL_OrderFinanceProperty_Object.ChildObjectId > 0

                                                 -- № п/п группы
                                                 LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                                       ON ObjectFloat_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                      AND ObjectFloat_Group.DescId   = zc_ObjectFloat_OrderFinanceProperty_Group()
                                            WHERE OL_OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                              AND OL_OrderFinanceProperty_OrderFinance.DescId        = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                           )
                   -- разворачивается по УП-статьям + № группы
                 , tmpInfoMoney_OrderF AS (SELECT DISTINCT
                                                  Object_InfoMoney_View.InfoMoneyId
                                                , tmpOrderFinanceProperty.NumGroup
                                           FROM Object_InfoMoney_View
                                                INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                                    OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                                    OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId
                                                                                      )
                                           )
                 -- MI
               , tmpMI AS (SELECT MovementItem.*
                                , MILinkObject_Contract.ObjectId AS ContractId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
               -- св-ва
             , tmpMovementItemFloat AS (SELECT *
                                        FROM MovementItemFloat
                                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                         , zc_MIFloat_AmountPlan_2()
                                                                         , zc_MIFloat_AmountPlan_3()
                                                                         , zc_MIFloat_AmountPlan_4()
                                                                         , zc_MIFloat_AmountPlan_5()
                                                                         )
                                       )
           -- Результат
           SELECT SUM (CASE WHEN tmpInfoMoney_OrderF.NumGroup = 1
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_1_sum
                , SUM (CASE WHEN tmpInfoMoney_OrderF.NumGroup = 2
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_2_sum
                , SUM (CASE WHEN COALESCE (tmpInfoMoney_OrderF.NumGroup, 0) NOT IN (1, 2)
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_3_sum

           FROM tmpMI AS MovementItem
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_1
                                               ON MIFloat_AmountPlan_1.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_2
                                               ON MIFloat_AmountPlan_2.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_3
                                               ON MIFloat_AmountPlan_3.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_4
                                               ON MIFloat_AmountPlan_4.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_5
                                               ON MIFloat_AmountPlan_5.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()
                -- УП - Статья или Группа или ...
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                     ON ObjectLink_Contract_InfoMoney.ObjectId = MovementItem.ContractId
                                    AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                -- УП-статья + № группы
                LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
          ) AS tmpMI
          ;


     -- Проверка-1
     IF vbSum_1_sum > vbSum_1
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = <Говядина>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_1_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_1)
                         ;
     END IF;

     -- Проверка-2
     IF vbSum_2_sum > vbSum_2
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = Для <Живой вес>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_2_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_2)
                         ;
     END IF;

     -- Проверка-3
     IF vbSum_3_sum > vbSum_3
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = <Прочее мясное сырье>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_3_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_3)
                         ;
     END IF;


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