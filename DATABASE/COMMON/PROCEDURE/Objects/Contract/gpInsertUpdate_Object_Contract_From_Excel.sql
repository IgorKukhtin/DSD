-- Function: gpInsertUpdate_Object_Contract_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_From_Excel (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_From_Excel(
    IN inContractName       TVarChar   , -- 
    IN inContractTagName    TVarChar   , -- 
    IN inPaidKindName       TVarChar   , -- 
    IN inJuridicalName      TVarChar   , --
    IN inInfoMoneyName      TVarChar   ,  
    IN inStartDate          TDateTime  ,
    IN inEndDate            TDateTime  ,
    IN inSession            TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbContractId_find Integer;
    DECLARE vbContractTagId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbJuridicalId Integer;
    DECLARE vbInfoMoneyId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- Проверка
    IF COALESCE(inContractName, '') = ''
    THEN
        RETURN;
    END IF;
    
    IF COALESCE (TRIM (inContractTagName), '') <> ''
    THEN 
         -- поиск признака
         vbContractTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ContractTag() AND UPPER (Object.ValueData) = TRIM(UPPER (inContractTagName)) LIMIT 1);
         IF COALESCE (vbContractTagId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Признак договора <%> не найдено.', inContractTagName;
         END IF;
    END IF;
    
    IF COALESCE (TRIM (inPaidKindName), '') <> ''
    THEN 
         -- поиск ФО
         vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND UPPER(Object.ValueData) = TRIM (UPPER(inPaidKindName)) LIMIT 1);
         IF COALESCE (vbPaidKindId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Форма оплаты <%> не найдено.', inPaidKindName;
         END IF;
    END IF;

    IF COALESCE (TRIM (inJuridicalName), '') <> ''
    THEN 
         -- поиск юр.лица
         vbJuridicalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Juridical() AND UPPER (Object.ValueData) = TRIM(UPPER (inJuridicalName)) LIMIT 1);
         IF COALESCE (vbJuridicalId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение Юридическое лицо <%> не найдено.', inJuridicalName;
         END IF;
    END IF;

    IF COALESCE (TRIM (inInfoMoneyName), '') <> ''
    THEN 
         -- поиск УП
         vbInfoMoneyId := (SELECT Object.InfoMoneyId FROM Object_InfoMoney_View AS Object WHERE UPPER (Object.InfoMoneyName_all) = TRIM(UPPER (inInfoMoneyName)) LIMIT 1);
         IF COALESCE (vbInfoMoneyId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение УП статья назначения <%> не найдено.', inInfoMoneyName;
         END IF;
    END IF;

    vbContractId_find:= (SELECT tmp_View.ContractId
                         FROM Object_Contract_View AS tmp_View
                         WHERE tmp_View.JuridicalId = vbJuridicalId
                           AND tmp_View.PaidKindId  = vbPaidKindId
                           AND tmp_View.InfoMoneyId = vbInfoMoneyId
                           AND tmp_View.InvNumber   = TRIM(inContractName)
                        );
    -- с проверкой, если по юр л. есть такой дог (номер + ФО + УП + юр-л), тогда сообщение с ошибкой  
    IF vbContractId_find > 0 AND 1=1
    THEN
        RAISE EXCEPTION 'Ошибка.Договор <%> для <%> ФО <%> УП статья <%> уже существует.', inContractName, inJuridicalName, inPaidKindName, inInfoMoneyName;
    END IF;

    -- сохранили новый договор
    PERFORM gpInsertUpdate_Object_Contract (ioId                 := vbContractId_find             -- Ключ объекта <Договор>
                                          , inCode               := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbContractId_find)
                                                                            , lfGet_ObjectCode (0, zc_Object_Contract())
                                                                             ) ::Integer
                                          , inInvNumber          := TRIM (inContractName)::TVarChar      -- Номер договора
                                          , inInvNumberArchive   := NULL           ::TVarChar      -- Номер архивирования
                                          , inComment            := NULL           ::TVarChar      -- Примечание
                                          , inBankAccountExternal:= NULL           ::TVarChar      -- р.счет (исх.платеж)
                                          , inBankAccountPartner := NULL           ::TVarChar      -- р.счет (вх.платеж)
                                          , inGLNCode            := NULL           ::TVarChar      -- Код GLN  
                                          , inPartnerCode        := NULL           ::TVarChar      -- Код поставщика
                                          , inTerm               := NULL           ::Tfloat        -- Период пролонгации
                                          , inDayTaxSummary      := NULL           ::Tfloat        -- Кол-во дней для сводной налоговой, если значение = 0, тогда будет за 1 месяц
                                          , inSigningDate        := inStartDate    ::TDateTime    -- Дата заключения договора
                                          , inStartDate          := inStartDate    ::TDateTime    -- Дата с которой действует договор
                                          , inEndDate            := inEndDate      ::TDateTime    -- Дата до которой действует договор    
                                          , inJuridicalId        := vbJuridicalId  ::Integer      -- Юридическое лицо
                                          , inJuridicalBasisId   := zc_Juridical_Basis()           ::Integer      -- Главное юридическое лицо
                                          , inJuridicalDocumentId:= NULL           ::Integer      -- Юридическое лицо (печать док.)
                                          , inJuridicalInvoiceId := NULL           ::Integer      -- Юридическое лицо (печать док. - реквизиты плательщика)
                                          , inInfoMoneyId        := vbInfoMoneyId           ::Integer      -- УП статья назначения
                                          , inContractKindId     := NULL           ::Integer      -- Вид договора
                                          , inPaidKindId         := vbPaidKindId   ::Integer      -- Вид формы оплаты
                                          , inPersonalId         := NULL           ::Integer      -- Сотрудник (отвественное лицо)
                                          , inPersonalTradeId    := NULL           ::Integer      -- Сотрудник (торговый)
                                          , inPersonalCollationId:= NULL           ::Integer      -- Сотрудник (сверка)
                                          , inPersonalSigningId  := NULL           ::Integer      -- Сотрудник (подписант)
                                          , inBankAccountId      := NULL           ::Integer      -- Расчетный счет (исх.платеж)
                                          , inContractTagId      := vbContractTagId::Integer      -- Признак договора
                                          , inAreaContractId     := NULL           ::Integer      -- Регион
                                          , inContractArticleId  := NULL           ::Integer      -- Предмет договора
                                          , inContractStateKindId:= NULL           ::Integer      -- Состояние договора
                                          , inContractTermKindId := NULL           ::Integer      -- Типы пролонгаций договоров 
                                          , inCurrencyId         := zc_Enum_Currency_Basis()   ::Integer      -- Валюта
                                          , inBankId             := NULL           ::Integer      -- Банк (исх.платеж)
                                          , inBranchId           := NULL           ::Integer      -- Филиал (расчеты нал)
                                          , inIsDefault          := FALSE          ::Boolean      -- По умолчанию (для вх. платежей)
                                          , inIsDefaultOut       := FALSE          ::Boolean      -- По умолчанию (для исх. платежей)
                                          , inIsStandart         := FALSE          ::Boolean      -- Типовой
                                          , inIsPersonal         := FALSE          ::Boolean      -- Служебная записка
                                          , inIsUnique           := TRUE           ::Boolean      -- !!!Без объединения!!!
                                          , inIsRealEx           := TRUE           ::Boolean      -- Физ обмен
                                          , inIsNotVat           := FALSE          ::Boolean      -- без НДС 
                                          , inPriceListPromoId   := NULL           ::Integer      -- Прайс-лист(Акционный)
                                          , inStartPromo         := NULL           ::TDateTime    -- Дата начала акции
                                          , inEndPromo           := NULL           ::TDateTime    -- Дата окончания акции
                                          , inSession            := inSession      ::TVarChar     -- сессия пользователя 
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.23         *
*/

-- тест