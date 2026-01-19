-- Function: gpInsert_MI_LossDebt_Load ()

DROP FUNCTION IF EXISTS gpInsert_MI_LossDebt_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_LossDebt_Load(
    IN inMovementId            Integer   , -- ключ Документа
    IN inBranchName            TVarChar  , -- 
    IN inJuridicalBasisName    TVarChar  , -- 
    IN inJuridicalName         TVarChar  , -- 
    IN inContract              TVarChar  , --
    IN inPaidKindName          TVarChar  , -- 
    IN inPartnerName           TVarChar  , -- 
    IN inAmountDebet           TFloat    , --
    IN inAmountKredit          TFloat    , --
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer; 
   DECLARE vbJuridicalId       Integer;
           vbBranchId          Integer;
           vbJuridicalBasisId  Integer;
           vbContractId        Integer;
           vbPaidKindId        Integer;
           vbPartnerId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Данные в документе уже заполнены';
     END IF;

     IF COALESCE (inAmountDebet,0) = 0 AND COALESCE (inAmountKredit,0) = 0
     THEN
         RETURN;
     END IF;


     -- Филиал
     vbBranchId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.ValueData = inBranchName AND Object.isErased = FALSE);
     -- НЕ проверка
     IF COALESCE (vbBranchId,0) = 0 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Филиал <%> для Юр.лица <%>.', inBranchName, inJuridicalName;
     END IF;
     
     -- Гл.Юр.лицо
     vbJuridicalBasisId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND Object.ValueData = inJuridicalBasisName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbJuridicalBasisId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдено Гл.Юр.лицо <%>. для Юр.лица <%>', inJuridicalBasisName, inJuridicalName;
     END IF;
     

     --Юр.лицо
     vbJuridicalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND TRIM (Object.ValueData) = TRIM (inJuridicalName) AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND TRIM (Object.ValueData) = zfCalc_Text_replace (TRIM (inJuridicalName), '`', CHR (39)) AND Object.isErased = FALSE);
     END IF;   
     --проверка
     IF COALESCE (vbJuridicalId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдено Юр.лицо <%> <%>.', TRIM (inJuridicalName), zfCalc_Text_replace (TRIM (inJuridicalName), '`', CHR (39));
-- <Мельникова Дар`я Олександрівна ФОП>
-- <Мельникова Дар'я Олександрівна ФОП>
--  Мельникова Дар'я Олександрівна ФОП 

     END IF;   


     --Форма оплаты
     vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData = inPaidKindName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbPaidKindId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Форма оплаты <%> для Юр.лица <%>.', inPaidKindName, inJuridicalName;
     END IF;            

     --Договор
     vbContractId := (SELECT Object_Contract.Id  AS ContractId
                      FROM ObjectLink AS ObjectLink_Contract_Juridical
                           INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                               AND Object_Contract.isErased = FALSE
                                                               AND Object_Contract.ValueData = inContract
                           LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                               AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                                               AND ObjectLink_Contract_PaidKind.ChildObjectId  = vbPaidKindId
                      WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbJuridicalId
                        AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                        AND Object_Contract.isErased = FALSE
                      LIMIT 1);
     --проверка
     IF COALESCE (vbContractId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Договор № <%> для Юр.лица <%>', inContract, inJuridicalName;
     END IF;  

     --Контрагент
     vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner() AND Object.isErased = FALSE);
     --НЕ проверка
     IF COALESCE (vbPartnerId,0) = 0 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден Контрагент <%> для Юр.лица <%>', inPartnerName, inJuridicalName;
     END IF; 

     
     --сохраняем данные
     PERFORM gpInsertUpdate_MovementItem_LossDebt (ioId                   := 0                        ::Integer
                                                 , inMovementId           := inMovementId             ::Integer
                                                 , inJuridicalId          := vbJuridicalId            ::Integer
                                                 , inJuridicalBasisId     := vbJuridicalBasisId       ::Integer
                                                 , inPartnerId            := vbPartnerId              ::Integer
                                                 , inBranchId             := vbBranchId               ::Integer
                                                 , inContainerId          := 0                        ::TFloat
                                                 , ioAmountDebet          := inAmountDebet            ::TFloat
                                                 , ioAmountKredit         := inAmountKredit           ::TFloat
                                                 , ioSummDebet            := 0                     ::TFloat
                                                 , ioSummKredit           := 0                     ::TFloat
                                                 , inCurrencyPartnerValue := 0                     ::TFloat
                                                 , inParPartnerValue      := 0                     ::TFloat
                                                 , ioAmountCurrencyDebet  := 0                     ::TFloat
                                                 , ioAmountCurrencyKredit := 0                     ::TFloat
                                                 , ioIsCalculated         := False                    ::Boolean
                                                 , inContractId           := vbContractId             ::Integer
                                                 , inPaidKindId           := vbPaidKindId             ::Integer
                                                 , inInfoMoneyId          := zc_Enum_InfoMoney_30101() -- Готовая продукция 
                                                 , inUnitId               := 0                        ::Integer
                                                 , inCurrencyId           := zc_Enum_Currency_Basis() ::Integer
                                                 , inSession              := inSession                ::TVarChar
                                                  ); 
                                                  
    -- тест
    if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. vbJuridicalId <%>', vbJuridicalId; end if;
                                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.26         *
*/

-- тест
-- 