-- Function: gpUpdate_MI_OrderFinance_Load ()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderFinance_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_OrderFinance_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderFinance_Load(
    IN inMovementId              Integer   , -- ключ Документа
    IN inJuridicalName           TVarChar  , -- 
    IN inOKPO                    TVarChar  , --
    IN inContract                TVarChar  , --
    IN inAmountPlan_1            TFloat    , --
    IN inAmountPlan_2            TFloat    , --
    IN inAmountPlan_3            TFloat    , --
    IN inAmountPlan_4            TFloat    , --
    IN inAmountPlan_5            TFloat    , -- 
    IN inSession                 TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId  Integer;
   DECLARE vbId Integer;

   DECLARE vbStartDate_WeekNumber TDateTime;
   DECLARE vbMIDate_Amount TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

 --RAISE EXCEPTION 'Ошибка.%  % % % %', inInfoMoneyName, inUnitName, inPositionName, inPersonalServiceListName,inBranchName ;
 
     IF NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.Данные отчета не сформированы';
     END IF;

     vbStartDate_WeekNumber := (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData) ::TDateTime AS StartDate_WeekNumber
                                FROM Movement
                                     LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                             ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                            AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                                WHERE Movement.Id = inMovementId
                                );

     SELECT ObjectHistory.ObjectId
            INTO vbJuridicalId
     FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
          JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                            AND vbStartDate_WeekNumber BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
     WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
       AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
     ;

     --проверка
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдено Юр.лицо = <%> с ОКПО = <%>.', inJuridicalName, inOKPO;
     END IF;   
           

     SELECT Object_Contract.Id  AS ContractId
           INTO vbContractId
     FROM ObjectLink AS ObjectLink_Contract_Juridical
          INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                              AND Object_Contract.isErased = FALSE
                                              AND Object_Contract.ValueData = inContract
          LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                               ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                              AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind() 
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                              AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
     WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbJuridicalId
       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
       AND ObjectLink_Contract_PaidKind.ChildObjectId  = zc_Enum_PaidKind_FirstForm()
       AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
     LIMIT 1;   --

     --проверка
     IF COALESCE (vbContractId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Договор № = <%> для Юр.лицо = <%>', inContract, inJuridicalName;
     END IF;  
     
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                    INNER JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                     AND MILinkObject_Contract.ObjectId = vbContractId
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbJuridicalId
              );

     --проверка
     IF COALESCE (vbId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена строка с долгом для Договор № <%> + <%>', inContract, inJuridicalName;
     END IF;

     
     IF COALESCE (inAmountPlan_1,0) <> 0
     THEN
         vbMIDate_Amount := vbStartDate_WeekNumber;
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_1(), vbId, inAmountPlan_1); 
     END IF;    

     IF COALESCE (inAmountPlan_2,0) <> 0
     THEN
         vbMIDate_Amount := vbStartDate_WeekNumber + INTERVAL '1 DAY';
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_2(), vbId, inAmountPlan_2); 
     END IF;

     IF COALESCE (inAmountPlan_3,0) <> 0
     THEN
         vbMIDate_Amount := vbStartDate_WeekNumber + INTERVAL '2 DAY';
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_3(), vbId, inAmountPlan_3); 
     END IF;

     IF COALESCE (inAmountPlan_4,0) <> 0
     THEN
         vbMIDate_Amount := vbStartDate_WeekNumber + INTERVAL '3 DAY';
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_4(), vbId, inAmountPlan_4); 
     END IF;

     IF COALESCE (inAmountPlan_5,0) <> 0
     THEN
         vbMIDate_Amount := vbStartDate_WeekNumber + INTERVAL '4 DAY';
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan_5(), vbId, inAmountPlan_5); 
     END IF;

     -- сохранили свойство <Дата предварительный план>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount(), vbId, vbMIDate_Amount);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.01.26         *
*/

-- тест
-- 