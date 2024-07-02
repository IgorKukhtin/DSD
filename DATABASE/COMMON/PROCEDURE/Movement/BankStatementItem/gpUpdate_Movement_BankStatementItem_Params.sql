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
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad());
 
       IF COALESCE(inJuridicalId, 0) = 0
       THEN
         -- Пытаемся найти юр. лицо по OKPO
         SELECT ObjectHistory.ObjectId INTO inJuridicalId
         FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
              JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                                AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
         WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
           AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
           ;

         IF COALESCE(inJuridicalId, 0) <> 0 THEN
             -- сохранили связь с <Юр. лицо>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementItemId, inJuridicalId);
         END IF;

       END IF;


        -- 3.0. ЕСЛИ НЕ НАШЛИ - находим свойство <Договор> "по умолчанию" для остальных
        IF COALESCE (inContractId, 0) = 0
        THEN 

            CREATE TEMP TABLE _tmpContract_find ON COMMIT DROP AS -- (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.JuridicalId = vbJuridicalId);
              (SELECT Object_Contract.Id                                  AS ContractId
                    , Object_Contract.isErased                            AS isErased
                    , COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) AS ContractStateKindId
                    , ObjectLink_Contract_PaidKind.ChildObjectId          AS PaidKindId
                    , ObjectLink_Contract_InfoMoney.ChildObjectId         AS InfoMoneyId
                    , ObjectLink_Contract_Juridical.ChildObjectId         AS JuridicalId
               FROM ObjectLink AS ObjectLink_Contract_Juridical
                    INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                        AND Object_Contract.isErased = FALSE
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                         ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                                        AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind() 
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                         ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                        AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                         ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                        AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
               WHERE ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId
                 AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                 AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
              );


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