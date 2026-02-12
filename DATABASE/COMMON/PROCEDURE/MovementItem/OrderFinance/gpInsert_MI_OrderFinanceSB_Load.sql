-- Function: gpInsert_MI_OrderFinanceSB_Load ()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderFinanceSB_Load (Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderFinanceSB_Load(
    IN inMovementId            Integer   , -- ключ Документа
    IN inOperDate              TDateTime , -- Дата оплаты
    IN inOKPO                  TVarChar  , -- ОКПО
    IN inObjectName            TVarChar  , -- Контрагент / Назначение 
    IN inContractName          TVarChar  , -- Договор
    IN inPaidKindName          TVarChar  , -- Форма оплаты
    IN inInfoMoneyName         TVarChar  , -- Статья Project
    IN inCashName              TVarChar  , -- Касса 
    IN inInvNumber_Invoice     TVarChar  , -- № счета
    IN inComment               TVarChar  , -- Примечание
    IN inAmount                TFloat    , -- Сумма, грн
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer; 
   DECLARE vbInfoMoneyId  Integer;
           vbCashId       Integer;
           vbContractId   Integer;
           vbPaidKindId   Integer;
           vbObjectId     Integer;
           vbId           Integer;
           vbId_child     Integer;
           vbsumm_parent  TFloat;
           vbOperDate     TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Данные в документе уже заполнены';
     END IF;

     IF COALESCE (inAmount,0) = 0
     THEN
         RETURN;
     END IF;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     SELECT ObjectHistory.ObjectId
            INTO vbObjectId
     FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
          JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                            AND vbOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
     WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
       AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
     ;
     --проверка
     IF COALESCE (vbObjectId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдено ОКПО <%> для <%>.', inOKPO, inObjectName;
     END IF;  
           
     -- Форма оплаты
     vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbPaidKindId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Форма оплаты <%> для <%> ОКПО <%> .', inPaidKindName, inObjectName, inOKPO;
     END IF;   


     SELECT Object_Contract.Id  AS ContractId
            INTO vbContractId
     FROM ObjectLink AS ObjectLink_Contract_Juridical
          INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                              AND Object_Contract.isErased = FALSE
                                              AND Object_Contract.ValueData ILIKE inContractName

          LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                               ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                              AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind() 

          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                              AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
     WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbObjectId
       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
     --AND ObjectLink_Contract_PaidKind.ChildObjectId  = vbPaidKindId
       AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
     LIMIT 1;   --

     --проверка
     IF COALESCE (vbContractId, 0) = 0 AND TRIM (inContractName) <> ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Договор <%> для <%> ОКПО <%> .', inContractName, inObjectName, inOKPO;
     END IF; 


     --проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Infomoney() AND TRIM (Object.ValueData) ILIKE TRIM (inInfoMoneyName))
        AND inInfoMoneyName NOT ILIKE 'Строительные'
     THEN
         RAISE EXCEPTION 'Ошибка.УП статья = <%> определена больше 1 раза.', inInfoMoneyName;
     END IF; 

     -- статья УП
     vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Infomoney() AND TRIM (Object.ValueData) ILIKE TRIM (inInfoMoneyName) ORDER BY Object.Id LIMIT CASE WHEN TRIM (inInfoMoneyName) ILIKE 'Строительные' THEN 1 ELSE 2 END);
     --проверка
     IF COALESCE (vbInfoMoneyId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена статья УП <%> для <%> ОКПО <%> .', inInfoMoneyName, inObjectName, inOKPO;
     END IF; 

     --Касса
     IF COALESCE (inCashName,'') <> ''
     THEN
         vbCashId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND TRIM (Object.ValueData) = TRIM (inCashName) AND Object.isErased = FALSE);
         --проверка
         IF COALESCE (vbCashId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена Касса <%> для <%> ОКПО <%>.', inCashName, inObjectName, inOKPO;
         END IF;
     END IF;   

     --проверка что такой мастер уже есть
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                   INNER JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                     ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                    AND MILinkObject_Contract.ObjectId = vbContractId

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.ObjectId = vbObjectId
              );
     --проверка
     IF COALESCE (vbId,0) = 0
     THEN     
         --сохраняем данные Master
         SELECT tmp.ioId
           INTO vbId 
         FROM gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad (ioId                    := 0                     ::Integer
                                                               , inMovementId            := inMovementId          ::Integer
                                                               , inJuridicalId           := vbObjectId            ::Integer
                                                               , inContractId            := vbContractId          ::Integer
                                                               , inCashId_top            := 0                     ::Integer
                                                               , inCashId                := vbCashId              ::Integer
                                                               , inAmount                := inAmount              ::TFloat
                                                               , ioAmount_old            := 0                     ::TFloat
                                                               , inOperDate_Amount_top   := inOperDate            ::TDateTime
                                                               , ioOperDate_Amount       := inOperDate            ::TDateTime
                                                               , ioOperDate_Amount_old   := zc_DateStart()        ::TDateTime
                                                               , ioAmountPlan_1          := 0                     ::TFloat
                                                               , ioAmountPlan_2          := 0                     ::TFloat
                                                               , ioAmountPlan_3          := 0                     ::TFloat
                                                               , ioAmountPlan_4          := 0                     ::TFloat
                                                               , ioAmountPlan_5          := 0                     ::TFloat
                                                               , inComment               := inComment             ::TVarChar 
                                                                 -- child
                                                               --, inGoodsName_child       := '' ::TVarChar  
                                                               --, inInvNumber_child       := '' ::TVarChar
                                                               --, inInvNumber_Invoice_child := '' ::TVarChar
                                                               , inSession               := inSession             ::TVarChar
                                                                ) AS tmp;


     ELSE
     -- Только после сохранения
     SELECT SUM (COALESCE (MovementItem.Amount,0))          AS Amount
    INTO vbSumm_parent
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
       AND MovementItem.ParentId   = vbId
     ;
         PERFORM gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad (ioId                 := MovementItem.Id                     ::Integer
                                                               , inMovementId            := inMovementId          ::Integer
                                                               , inJuridicalId           := MovementItem.ObjectId            ::Integer
                                                               , inContractId            := vbContractId          ::Integer
                                                               , inCashId_top            := 0                     ::Integer
                                                               , inCashId                := vbCashId              ::Integer
                                                               , inAmount                := COALESCE (vbSumm_parent,0) + COALESCE (inAmount,0)  ::TFloat
                                                               , ioAmount_old            := 0                     ::TFloat
                                                               , inOperDate_Amount_top   := inOperDate            ::TDateTime
                                                               , ioOperDate_Amount       := inOperDate            ::TDateTime
                                                               , ioOperDate_Amount_old   := zc_DateStart()        ::TDateTime
                                                               , ioAmountPlan_1          := 0                     ::TFloat
                                                               , ioAmountPlan_2          := 0                     ::TFloat
                                                               , ioAmountPlan_3          := 0                     ::TFloat
                                                               , ioAmountPlan_4          := 0                     ::TFloat
                                                               , ioAmountPlan_5          := 0                     ::TFloat
                                                               , inComment               := inComment             ::TVarChar 
                                                                 -- child
                                                               --, inGoodsName_child       := '' ::TVarChar  
                                                               --, inInvNumber_child       := '' ::TVarChar
                                                               --, inInvNumber_Invoice_child := '' ::TVarChar
                                                               , inSession               := inSession             ::TVarChar
                                                                ) 
         FROM MovementItem
         WHERE MovementItem.Id = vbId;


     END IF;
     

     --RAISE EXCEPTION 'Ошибка.Мастер ОК';


     --сохраняем Child
     vbId_child := lpInsertUpdate_MovementItem (0, zc_MI_Child(), Null, inMovementId, inAmount, vbId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumber_Invoice(), vbId_child, inInvNumber_Invoice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbId_child, inComment);


    

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbId_child, vbUserId, TRUE);
  
                                                  
    -- тест
    --if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. '; end if;
                                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.26         *
*/

-- тест
-- 