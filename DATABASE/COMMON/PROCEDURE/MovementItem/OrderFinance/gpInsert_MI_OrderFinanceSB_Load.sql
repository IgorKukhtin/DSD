-- Function: gpInsert_MI_OrderFinanceSB_Load ()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderFinanceSB_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderFinanceSB_Load(
    IN inMovementId            Integer   , -- ключ Документа
    IN inInfoMoneyName         TVarChar  , -- Статья Project
    IN inObjectName            TVarChar  , -- Контрагент / Назначение
    IN inComment_Partner       TVarChar  , -- Примечание Контрагент
    IN inAmount                TFloat    , -- Сумма, грн
    IN inInvNumber_Invoice     TVarChar  , -- № счета
    IN inOKPO                  TVarChar  , -- ОКПО
    IN inContractName          TVarChar  , -- Договор
    IN inComment               TVarChar  , -- Примечание
    IN inOperDate              TDateTime , -- Дата оплаты
    IN inPaidKindName          TVarChar  , -- Форма оплаты
    IN inCashName              TVarChar  , -- Касса
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbInfoMoneyId  Integer;
           vbCashId       Integer;
           vbContractId   Integer;
           vbPaidKindId   Integer;
           vbObjectId     Integer;
           vbId           Integer;
           vbId_child     Integer;
           vbOperDate     TDateTime;
           vbComment_Contract TVarChar;
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


     -- test
      IF (inComment_Partner ilike 'заправка наличными%'
       --or inComment_Partner ilike '%КОМПАНІЯ ОККО-БІЗНЕС  ТОВ%'
         )
      and inAmount > 0
      AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Test <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%>'
                        ,inMovementId            
                        ,inInfoMoneyName         
                        ,inObjectName            
                        ,inComment_Partner       
                        ,inAmount                
                        ,inInvNumber_Invoice     
                        ,inOKPO                  
                        ,inContractName          
                        ,inComment               
                        ,inOperDate              
                        ,inPaidKindName          
                        ,inCashName              
                         ;
     END IF;



     -- Поиск
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     -- 1.1. Поиск - Форма оплаты
     vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbPaidKindId,0) = 0 AND TRIM (inPaidKindName) <> ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Форма оплаты <%> для <%> ОКПО <%> .', inPaidKindName, inObjectName, inOKPO;
     END IF;
     

     -- замена
     IF COALESCE (vbPaidKindId, 0) <> zc_Enum_PaidKind_FirstForm()
     THEN
         -- замена
         IF TRIM (inObjectName) = '' THEN inOKPO:= ''; END IF;
     END IF;


     -- 2.1. Поиск
     IF TRIM (inOKPO) <> ''
     THEN
         SELECT ObjectHistory.ObjectId
                INTO vbObjectId
         FROM ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
              JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId
                                AND vbOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
         WHERE ObjectHistoryString_JuridicalDetails_OKPO.ValueData = inOKPO
           AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
         ;
     END IF;

     -- проверка
     IF COALESCE (vbObjectId,0) = 0 AND vbPaidKindId = zc_Enum_PaidKind_FirstForm()
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдено ОКПО <%> для <%>.', inOKPO, inObjectName;
     END IF;


     -- 3.1. Поиск
     SELECT Object_Contract.Id  AS ContractId
            INTO vbContractId
     FROM ObjectLink AS ObjectLink_Contract_Juridical
          INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                              AND Object_Contract.isErased = FALSE
                                              AND Object_Contract.ValueData ILIKE TRIM (inContractName)

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

     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND TRIM (inContractName) <> ''
     THEN
         IF vbPaidKindId = zc_Enum_PaidKind_FirstForm()
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Договор <%> для <%> ОКПО <%> .', inContractName, inObjectName, inOKPO;
         ELSE
             -- переносим
             vbComment_Contract := TRIM (inContractName);
         END IF;
     END IF;


     -- 4.1. проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND TRIM (Object.ValueData) ILIKE TRIM (inInfoMoneyName))
        AND inInfoMoneyName NOT ILIKE 'Строительные'
        AND inInfoMoneyName NOT ILIKE 'Запчасти и Ремонты'
        AND inInfoMoneyName NOT ILIKE 'Ремонт оборудования'
        AND inInfoMoneyName NOT ILIKE 'Аренда помещений'
        AND inInfoMoneyName NOT ILIKE 'Аренда оборудования'
     THEN
         RAISE EXCEPTION 'Ошибка.УП статья = <%> определена больше 1 раза.', inInfoMoneyName;
     END IF;

     -- статья УП
     vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Infomoney() AND TRIM (Object.ValueData) ILIKE TRIM (inInfoMoneyName)
                       ORDER BY CASE WHEN TRIM (inInfoMoneyName) ILIKE 'Ремонт оборудования' THEN 0
                                     ELSE 0
                                END DESC
                              , Object.Id ASC
                       LIMIT CASE WHEN TRIM (inInfoMoneyName) ILIKE 'Строительные'        THEN 1
                                  WHEN TRIM (inInfoMoneyName) ILIKE 'Запчасти и Ремонты'  THEN 1
                                  WHEN TRIM (inInfoMoneyName) ILIKE 'Ремонт оборудования' THEN 1
                                  WHEN TRIM (inInfoMoneyName) ILIKE 'Аренда помещений'    THEN 1
                                  WHEN TRIM (inInfoMoneyName) ILIKE 'Аренда оборудования' THEN 1
                                  
                                  ELSE 2
                             END
                      );
     -- проверка
     IF COALESCE (vbInfoMoneyId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена статья УП <%> для <%> ОКПО <%> .', inInfoMoneyName, inObjectName, inOKPO;
     END IF;


     -- 5.1.Касса
     IF COALESCE (inCashName,'') <> ''
     THEN
         vbCashId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND TRIM (Object.ValueData) = TRIM (inCashName) AND Object.isErased = FALSE);
         --проверка
         IF COALESCE (vbCashId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена Касса <%> для <%> ОКПО <%>.', inCashName, inObjectName, inOKPO;
         END IF;
     END IF;


     -- 6.проверка что такой мастер уже есть
     IF vbContractId > 0 AND vbObjectId > 0
     THEN
         vbId := (SELECT MovementItem.Id
                  FROM MovementItem
                       INNER JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                                                        AND MILinkObject_Contract.ObjectId       = vbContractId

                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                    AND MovementItem.ObjectId   = vbObjectId
                 );
     END IF;


     -- 1.сохраняем Master, не ошибка - в Master все суммы = 0 + Примечание в чайлд
     SELECT tmp.ioId
            INTO vbId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId                    := vbId                  ::Integer
                                                  , inMovementId            := inMovementId          ::Integer
                                                  , inJuridicalId           := CASE WHEN vbObjectId > 0 THEN vbObjectId ELSE vbInfoMoneyId END
                                                  , inContractId            := vbContractId          ::Integer
                                                  , inCashId                := vbCashId              ::Integer
                                                  , inAmount                := 0
                                                  , inAmount_next           := 0
                                                  , inOperDate_Amount_next  := NULL
                                                  , inAmountPlan_1          := 0                     ::TFloat
                                                  , inAmountPlan_2          := 0                     ::TFloat
                                                  , inAmountPlan_3          := 0                     ::TFloat
                                                  , inAmountPlan_4          := 0                     ::TFloat
                                                  , inAmountPlan_5          := 0                     ::TFloat
                                                  , inComment               := ''                    ::TVarChar
                                                  , inComment_Partner       := inComment_Partner     ::TVarChar
                                                  , inComment_Contract      := COALESCE (vbComment_Contract,'') ::TVarChar
                                                  , inUserId                := vbUserId
                                                   ) AS tmp;


     -- 2.сохраняем Child - Первичный план на неделю
     vbId_child := lpInsertUpdate_MovementItem_OrderFinance_child (ioId                    := 0
                                                                 , inMovementId            := inMovementId
                                                                 , inParentId              := vbId
                                                                 , inAmount                := inAmount
                                                                 , inAmount_next           := inAmount
                                                                 , inOperDate_Amount_next  := inOperDate
                                                                 , inGoodsName             := ''
                                                                 , inInvNumber             := ''
                                                                 , inInvNumber_Invoice     := inInvNumber_Invoice
                                                                 , inComment               := inComment
                                                                 , inUserId                := vbUserId
                                                                  );

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