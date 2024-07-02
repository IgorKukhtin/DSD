-- Function: gpUpdate_Movement_BankStatementItem_Params()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_Params (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem_Params(
    IN inMovementItemId      Integer   , 
    IN inJuridicalId         Integer   , -- 
    IN inContractId          Integer   , --
    IN inOKPO                TVarChar  , -- ОКПО
    --IN inJuridicalName       TVarChar  , -- Юр. лицо
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad());
 


       IF COALESCE(inJuridicalId, 0) = 0 THEN
         -- Пытаемся найти юр. лицо по OKPO
         SELECT ObjectHistory.ObjectId INTO inJuridicalId
         FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
              JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                                AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
         WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
           AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
           ;
       END IF;

       IF COALESCE(inJuridicalId, 0) <> 0 THEN
           -- сохранили связь с <Юр. лицо>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementItemId, inJuridicalId);
       END IF;



        -- 3.0. ЕСЛИ НЕ НАШЛИ - находим свойство <Договор> "по умолчанию" для остальных
        IF COALESCE (inContractId, 0) = 0
        THEN
            SELECT MAX (View_Contract.ContractId) INTO inContractId
            FROM _tmpContract_find AS View_Contract
                 INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
                                                 AND InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                 AND InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_10000()) -- Основное сырье
                                                 AND InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_21500()) -- Общефирменные + Маркетинг
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                          ON ObjectBoolean_Default.ObjectId  = View_Contract.ContractId
                                         AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_Contract_Default()
                                         AND ObjectBoolean_Default.ValueData = TRUE
            WHERE View_Contract.JuridicalId = inJuridicalId
              AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
              AND View_Contract.isErased = FALSE
              AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm();
        END IF;

        -- Находим <Договор> у Юр. Лица !!!БЕЗ зависимоти от ...!!
        IF COALESCE (inContractId, 0) = 0
        THEN
            -- Внутренний оборот
            SELECT MAX (View_Contract.ContractId) INTO inContractId
            FROM _tmpContract_find AS View_Contract
            WHERE View_Contract.JuridicalId = inJuridicalId
              AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
              AND View_Contract.isErased = FALSE
              AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
              AND View_Contract.InfoMoneyId = zc_Enum_InfoMoney_40801() --Внутренний оборот
             ;
        END IF;
        -- Находим <Договор> у Юр. Лица !!!БЕЗ зависимоти от ...!!
        IF COALESCE (inContractId, 0) = 0
        THEN
            -- НЕ Внутренний оборот
            SELECT MAX (View_Contract.ContractId) INTO inContractId
            FROM _tmpContract_find AS View_Contract
            WHERE View_Contract.JuridicalId = inJuridicalId
              AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
              AND View_Contract.isErased = FALSE
              AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
             ;
        END IF;


    IF COALESCE (inContractId, 0) <> 0 THEN
       -- сохранили связь с <Договор>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementItemId, inContractId);
    END IF;
   

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementItemId, vbUserId, TRUE);


 if vbUserId = 5 OR vbUserId = 9457
 then
    RAISE EXCEPTION 'ok. %   %    %  ',  lfGet_Object_ValueData (inJuridicalId), inContractId, lfGet_Object_ValueData (inContractId);
 end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.24         *
*/

-- тест
-- 