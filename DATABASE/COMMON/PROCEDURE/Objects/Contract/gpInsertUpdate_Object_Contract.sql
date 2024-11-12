-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TDateTime, TDateTime, TVarChar);
                                                      */
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TDateTime, TDateTime, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                      , Integer, TDateTime, TDateTime, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                      , Tfloat, Tfloat, TDateTime, TDateTime, TDateTime
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                      , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                      , Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                  Integer,       -- Ключ объекта <Договор>
    IN inCode                Integer,       -- Код
    IN inInvNumber           TVarChar,      -- Номер договора
    IN inInvNumberArchive    TVarChar,      -- Номер архивирования
    IN inComment             TVarChar,      -- Примечание
    IN inBankAccountExternal TVarChar,      -- р.счет (исх.платеж)
    IN inBankAccountPartner  TVarChar,      -- р.счет (вх.платеж)
    IN inGLNCode             TVarChar,      -- Код GLN  
    IN inPartnerCode         TVarChar,      -- Код поставщика
    IN inTerm                Tfloat  ,      -- Период пролонгации
    IN inDayTaxSummary       Tfloat  ,      -- Кол-во дней для сводной налоговой, если значение = 0, тогда будет за 1 месяц

    IN inSigningDate         TDateTime,     -- Дата заключения договора
    IN inStartDate           TDateTime,     -- Дата с которой действует договор
    IN inEndDate             TDateTime,     -- Дата до которой действует договор    
    
    IN inJuridicalId         Integer  ,     -- Юридическое лицо
    IN inJuridicalBasisId    Integer  ,     -- Главное юридическое лицо
    IN inJuridicalDocumentId Integer  ,     -- Юридическое лицо (печать док.)
    IN inJuridicalInvoiceId  Integer  ,     -- Юридическое лицо (печать док. - реквизиты плательщика)
    
    IN inInfoMoneyId         Integer  ,     -- УП статья назначения
    IN inContractKindId      Integer  ,     -- Вид договора
    IN inPaidKindId          Integer  ,     -- Вид формы оплаты
    --IN inGoodsPropertyId     Integer  ,     -- Классификаторы свойств товаров

    IN inPersonalId          Integer  ,     -- Сотрудник (отвественное лицо)
    IN inPersonalTradeId     Integer  ,     -- Сотрудник (торговый)
    IN inPersonalCollationId Integer  ,     -- Сотрудник (сверка)
    IN inPersonalSigningId   Integer  ,     -- Сотрудник (подписант)
    IN inBankAccountId       Integer  ,     -- Расчетный счет (исх.платеж)
    IN inContractTagId       Integer  ,     -- Признак договора
    
    IN inAreaContractId      Integer  ,     -- Регион
    IN inContractArticleId   Integer  ,     -- Предмет договора
    IN inContractStateKindId Integer  ,     -- Состояние договора
    IN inContractTermKindId  Integer  ,     -- Типы пролонгаций договоров 
    IN inCurrencyId          Integer  ,     -- Валюта
    IN inBankId              Integer  ,     -- Банк (исх.платеж)
    IN inBranchId            Integer  ,     -- Филиал (расчеты нал)
    IN inisDefault           Boolean  ,     -- По умолчанию (для вх. платежей)
    IN inisDefaultOut        Boolean  ,     -- По умолчанию (для исх. платежей)
    IN inisStandart          Boolean  ,     -- Типовой

    IN inisPersonal          Boolean  ,     -- Служебная записка
    IN inisUnique            Boolean  ,     -- Без группировки3
    IN inisRealEx            Boolean  ,     -- Физ обмен
    IN inisNotVat            Boolean  ,     -- без НДС 
    IN inisNotTareReturning  Boolean  ,     -- Нет возврата тары
    IN inisMarketNot         Boolean  ,     -- Ораниченный доступ маркетинг

    --IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции

    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

   /*
   IF ioId <> 0 
        -- пытаемся найти код
   THEN vbCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); 
        -- Иначе, определяем его как последний+1
   ELSE vbCode:= inCode; -- lfGet_ObjectCode (inCode, zc_Object_Contract()); 
   END IF;*/

   IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT ObjectCode FROM Object WHERE ObjectCode = inCode AND DescId = zc_Object_Contract())
   THEN 
       -- Если код не установлен, определяем его как последний + 1
       vbCode:= lfGet_ObjectCode (0, zc_Object_Contract());
   ELSE
       -- Если код не установлен, определяем его как последний + 1
       vbCode:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   END IF;

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode);

   -- проверка <Номер договора>
   IF TRIM (COALESCE (inInvNumber, '')) = '' 
   THEN
       RAISE EXCEPTION 'Ошибка. Значение <Номер договора> должно быть установлено.';
  END IF;

   -- проверка уникальности для свойства <Номер договора>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Contract(), inInvNumber);


/*
   -- пытаемся найти <Прайс-лист>
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inPriceListId, 0) = 0
   THEN
       -- нашли
       inPriceListId:= (SELECT ObjectLink_PriceList.ChildObjectId
                        FROM ObjectLink
                             INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                   ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                  AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                  AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                             INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                   ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                  AND ObjectLink_PriceList.ChildObjectId > 0
                                                  AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                             LEFT JOIN ObjectLink AS ObjectLink_ContractTag
                                                  ON ObjectLink_ContractTag.ObjectId = ObjectLink.ObjectId
                                                 AND ObjectLink_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                        WHERE ObjectLink.ChildObjectId = inJuridicalId
                          AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                          AND COALESCE (ObjectLink_ContractTag.ChildObjectId, 0) = COALESCE (inContractTagId, 0)
                        LIMIT 1
                       );
   END IF;

   -- проверка - у других договоров тогда прайса быть не должно
   IF COALESCE (inPriceListId, 0) = 0 AND EXISTS (SELECT 1
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                  LIMIT 1
                                                 )
   THEN
       RAISE EXCEPTION 'Ошибка.В даннном договоре для <УП статья назначения> = <%> должен быть установлен Прайс-лист = <%> или <%>.', lfGet_Object_ValueData (inInfoMoneyId)
                       , lfGet_Object_ValueData ((SELECT MAX (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                ))
                       , CASE WHEN           0 < (SELECT MIN (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                  HAVING MAX (ObjectLink_PriceList.ChildObjectId) <> MIN (ObjectLink_PriceList.ChildObjectId)
                                                )
                                  THEN
                         lfGet_Object_ValueData ((SELECT MIN (ObjectLink_PriceList.ChildObjectId)
                                                  FROM ObjectLink
                                                       INNER JOIN ObjectLink AS ObjectLink_InfoMoney
                                                                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                                                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                             ON ObjectLink_PriceList.ObjectId = ObjectLink.ObjectId
                                                                            AND ObjectLink_PriceList.ChildObjectId > 0
                                                                            AND ObjectLink_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                                                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
                                                ))
                              ELSE 'любой другой'
                         END
      ;
   END IF;
   */

   -- проверка уникальность <Номер договора> для !!!одного!! Юр. лица и !!!одной!! Статьи
   IF TRIM (inInvNumber) <> '' AND TRIM (inInvNumber) <> '-' -- and inInvNumber <> '100398' and inInvNumber <> '877' and inInvNumber <> '24849' and inInvNumber <> '19' and inInvNumber <> 'б/н' and inInvNumber <> '369/1' and inInvNumber <> '63/12' and inInvNumber <> '4600034104' and inInvNumber <> '19М'
   THEN
       IF EXISTS (SELECT ObjectLink.ChildObjectId
                  FROM ObjectLink
                       JOIN ObjectLink AS ObjectLink_InfoMoney
                                       ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                                      AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                                      AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                       JOIN Object ON Object.Id = ObjectLink.ObjectId
                                  AND TRIM (Object.ValueData) = TRIM (inInvNumber)
                  WHERE ObjectLink.ChildObjectId = inJuridicalId
                    AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectLink.DescId = zc_ObjectLink_Contract_Juridical())
       THEN
           RAISE EXCEPTION 'Ошибка. Номер договора <%> уже установлен у <%>.', TRIM (inInvNumber), lfGet_Object_ValueData (inJuridicalId);
       END IF;
   END IF;

   -- проверка
   IF COALESCE (inJuridicalBasisId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Главное юридическое лицо> не выбрано.';
   END IF;
   IF COALESCE (inJuridicalBasisId, 0) <> zc_Juridical_Basis() AND vbUserId NOT IN (zfCalc_UserAdmin() :: Integer, zfCalc_UserMain())
   THEN
      RAISE EXCEPTION 'Ошибка.Должно быть выбрано <Главное юридическое лицо> = <%>.', lfGet_Object_ValueData_sh (zc_Juridical_Basis());
   END IF;
   -- проверка
   IF COALESCE (inJuridicalId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Юридическое лицо> не выбрано.';
   END IF;
   -- проверка
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбрана.';
   END IF;
   -- проверка
   IF COALESCE (inPaidKindId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Форма оплаты> не выбрана.';
   END IF;
   -- проверка
   IF inPaidKindId = zc_Enum_PaidKind_FirstForm() AND NOT EXISTS (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = inJuridicalId AND OKPO <> '')
   THEN
      RAISE EXCEPTION 'Ошибка.У <Юридическое лицо> не установлен <ОКПО>.';
   END IF;
   -- проверка для 
   IF COALESCE (inContractTagId, 0) = 0
      AND EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId
                                                                  AND InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                                                                               , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                                                                                ))
   THEN
       RAISE EXCEPTION 'Ошибка.Для <%> необходимо установить <Признак договора>.', lfGet_Object_ValueData (inInfoMoneyId);
   END IF;

   -- проверка
   IF inSigningDate <> DATE_TRUNC ('DAY', inSigningDate) OR inStartDate <> DATE_TRUNC ('DAY', inStartDate) OR inEndDate <> DATE_TRUNC ('DAY', inEndDate) 
   THEN
       RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
   END IF;

   -- проверка
   IF COALESCE (inCurrencyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.<Валюта> не выбрана.';
   END IF;


   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode, TRIM (inInvNumber));

   -- сохранили свойство <Номер договора>
   -- PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumber(), ioId, inInvNumber);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, inSigningDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);

   -- сохранили свойство <Номер архивирования>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumberArchive(), ioId, inInvNumberArchive);

   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_BankAccount(), ioId, inBankAccountExternal);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_BankAccountPartner(), ioId, inBankAccountPartner);

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_GLNCode(), ioId, inGLNCode);
   -- сохранили свойство <Код поставщика>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_PartnerCode(), ioId, inPartnerCode);


   --если не указали значение а тип пролонгации  = бессрочный ставим значение 36
   IF inContractTermKindId =  zc_Enum_ContractTermKind_Long() AND COALESCE (inTerm,0) = 0
   THEN
       inTerm := 36;
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Contract_Term(), ioId, inTerm);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Contract_DayTaxSummary(), ioId, inDayTaxSummary);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Default(), ioId, inisDefault);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_DefaultOut(), ioId, inisDefaultOut);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Standart(), ioId, inisStandart);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Personal(), ioId, inisPersonal);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_Unique(), ioId, inisUnique);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_RealEx(), ioId, inisRealEx);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_NotVAT(), ioId, inisNotVat);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_NotTareReturning(), ioId, inisNotTareReturning);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_MarketNot(), ioId, inisMarketNot);
   
   -- сохранили связь с <Юридическое лицо>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Главным юридическим лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- сохранили связь с <Юридическое лицо(печать док.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalDocument(), ioId, inJuridicalDocumentId); 
   -- сохранили связь с <Юридическое лицо(печать док.- реквизиты плательщика)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_JuridicalInvoice(), ioId, inJuridicalInvoiceId);  
   -- сохранили связь с <Статьи назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <Виды договоров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractKind(), ioId, inContractKindId);
   -- сохранили связь с <Виды форм оплаты>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PaidKind(), ioId, inPaidKindId);

   -- сохранили связь с <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_GoodsProperty(), ioId, inGoodsPropertyId);

   -- сохранили связь с <Сотрудники (отвественное лицо)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);
   
   -- сохранили связь с <Сотрудники (отвественное лицо)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), ioId, inPersonalId);

   -- сохранили связь с <Сотрудники (торговый)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), ioId, inPersonalTradeId);
   -- сохранили связь с <Сотрудники (сверка)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), ioId, inPersonalCollationId);
   -- сохранили связь с <Сотрудники (подписант)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalSigning(), ioId, inPersonalSigningId);
   -- сохранили связь с <Расчетные счета(оплата нам)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <Признак договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTag(), ioId, inContractTagId);
   
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_AreaContract(), ioId, inAreaContractId);
   -- сохранили связь с <Предмет договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractArticle(), ioId, inContractArticleId);
   -- сохранили связь с <Состояние договора>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), ioId, inContractStateKindId);   
   -- сохранили связь с <Типы пролонгаций договоров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractTermKind(), ioId, inContractTermKindId);

   -- сохранили связь с <валюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Currency(), ioId, inCurrencyId);

   -- сохранили связь с <Банк>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Bank(), ioId, inBankId);

   -- сохранили связь с <Филиал (расчеты нал)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Branch(), ioId, inBranchId);

   -- сохранили связь с <>
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_PriceList(), ioId, inPriceListId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_PriceListPromo(), ioId, inPriceListPromoId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_StartPromo(), ioId, DATE (inStartPromo));
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_EndPromo(), ioId, DATE (inEndPromo));
   
   
     -- !!!обязательно!!! сформировали ключ
    PERFORM lpInsertFind_Object_ContractKey (inJuridicalId_basis:= inJuridicalBasisId
                                           , inJuridicalId      := inJuridicalId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractTagId    := inContractTagId
                                           , inContractId_begin := ioId
                                            );

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.11.24         * inisMarketNot
 26.09.23         * inisNotTareReturning
 01.05.23         * inisNotVat
 21.03.22         * inisRealEx
 03.11.21         * inBranchId Филиал (расчеты нал)
 27.05.21         * del inPriceListId
 
 04.02.19         * inBankAccountPartner
 18.01.19         * DefaultOut
 05.10.18         * add PartnerCode
 30.03.17         * inJuridicalInvoiceId
 03.03.17         * inDayTaxSummary
 13.04.16         *
 29.01.16         *
 20.01.16         *
-- 05.05.15         * add   GoodsProperty
 12.02.15         * add StartPromo, EndPromo,
                        PriceList, PriceListPromo
 16.01.15         * add JuridicalDocument
 10.11.14         * add GLNCode               
 07.11.14         * замана Area  на AreaContract
 21.07.14                                        * add проверка <Номер договора>
 22.05.14         * add zc_ObjectBoolean_Contract_Personal
                        zc_ObjectBoolean_Contract_Unique
 08.05.14                                        * add lpCheckRight
 26.04.14                                        * add lpInsertFind_Object_ContractKey
 21.04.14         * add zc_ObjectLink_Contract_PersonalTrade
                        zc_ObjectLink_Contract_PersonalCollation
                        zc_ObjectLink_Contract_BankAccount
                        zc_ObjectLink_Contract_ContractTag
 17.04.14                                        * add TRIM
 19.03.14         * add inisStandart
 13.03.14         * add inisDefault
 05.01.14                                        * add проверка уникальность <Номер договора> для !!!одного!! Юр. лица и !!!одной!! Статьи
 25.02.14                                        * add inIsUpdate and inIsErased
 21.02.14         * add Bank, BankAccount
 08.11.14                        *
 05.01.14                                        * add проверка уникальность <Номер договора> для !!!одного!! Юр. лица
 04.01.14                                        * add !!!inInvNumber not unique!!!
 14.11.13         * add from redmaine               
 21.10.13                                        * add vbCode
 20.10.13                                        * add from redmaine
 19.10.13                                        * del zc_ObjectString_Contract_InvNumber()
 22.07.13         * add  SigningDate, StartDate, EndDate              
 12.04.13                                        *
 16.06.13                                        * красота
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract ()
