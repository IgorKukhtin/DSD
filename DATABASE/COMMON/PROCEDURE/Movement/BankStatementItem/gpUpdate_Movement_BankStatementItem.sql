-- Function: gpInsertUpdate_Movement_BankStatementItem()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId         Integer   , -- СПД  
    IN inPartnerId           Integer   , -- Контрагент  
    IN inInfoMoneyId         Integer   , -- Управленческие статьи 
    IN inContractId          Integer   , -- Договор  
    IN inUnitId              Integer   , -- Подразделение
    IN inMovementId_Invoice  Integer   , -- документ счет
    IN inServiceDate         TDateTime , --
   OUT outServiceDate        TDateTime , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankStatementItem());

      
     IF inJuridicalId = 0 THEN
        inJuridicalId := NULL;
     END IF; 
     IF inInfoMoneyId = 0 THEN
        inInfoMoneyId := NULL;
     END IF; 
     IF inContractId = 0 THEN
        inContractId := NULL;
     END IF; 
     IF inUnitId = 0 THEN
        inUnitId := NULL;
     END IF; 

     IF inInfoMoneyId IN (zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                        , zc_Enum_InfoMoney_60102() -- Заработная плата + Алименты
                         )
     THEN
         -- всегда 1-ое число месяца
         outServiceDate := DATE_TRUNC ('MONTH', inServiceDate);
     ELSE
         outServiceDate := NULL;
     END IF;

     
     -- проверили статус
     PERFORM lpInsertUpdate_Movement (ioId:= Id, inDescId:= DescId, inInvNumber:= InvNumber, inOperDate:= OperDate, inParentId:= ParentId, inAccessKeyId:= AccessKeyId)
     FROM Movement WHERE Id = ioId -- AND inSession <> '5'
    ;

     -- Проверка установки значений
     IF NOT EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND (InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500() -- Маркетинг

                                                                                                                                 , zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы

                                                                                                                                 , zc_Enum_InfoMoneyDestination_40100() -- Кредиты банков
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40200() -- Прочие кредиты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40300() -- Овердрафт
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40400() -- проценты по кредитам
                                                                                                                                 -- , zc_Enum_InfoMoneyDestination_40500() -- Ссуды
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40600() -- Депозиты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40700() -- Лиол
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40800() -- Внутренний оборот
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40900() -- Финансовая помощь

                                                                                                                                 , zc_Enum_InfoMoneyDestination_50100() -- Налоговые платежи по ЗП
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50200() -- Налоговые платежи
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50300() -- Налоговые платежи (прочие)
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50400() -- штрафы в бюджет

                                                                                                                                 , zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                                                                                                                                 , zc_Enum_InfoMoneyDestination_41100() -- Банковская гарантия
                                                                                                                                 )
                                                                                                         OR InfoMoneyId = zc_Enum_InfoMoney_21419() -- Штрафы за недовоз
                                                                                                        )
                    )
        -- AND EXISTS (SELECT Id FROM gpGet_Movement_BankStatementItem (inMovementId:= ioId, inSession:= inSession) WHERE ContractId = inContractId)
        AND NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = inInfoMoneyId)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inJuridicalId AND DescId = zc_ObjectLink_Juridical_InfoMoney() AND ChildObjectId IN (zc_Enum_InfoMoney_20801(), zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_21101())) -- Алан + Ирна + Чапли + Дворкин
        AND inContractId > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Неверное значение для <УП статья назначения>.';
     END IF;
     -- проверка
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- Инвестиции
     THEN
        RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <№ док. Счет>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;


     -- сохранили связь с <Юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);     
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);

     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     -- формируются свойство <Месяц начислений>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, outServiceDate);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.07.24         *
 12.09.18         * add ServiceDate
 21.07.16         * zc_MovementLinkMovement_Invoice
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 18.03.14                                        * lpInsertUpdate_Movement
 13.03.14                                        * add Проверка установки значений
 03.12.13                        *
 13.08.13          *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_BankStatementItem (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')

