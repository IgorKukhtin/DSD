-- View: _bi_Guide_Contract_View

 DROP VIEW IF EXISTS _bi_Guide_Contract_View;

-- Справочник Договора
CREATE OR REPLACE VIEW _bi_Guide_Contract_View
AS
  WITH -- ВСЕ Условия договора
       tmpContractCondition_Value_all AS (SELECT -- Договор
                                                 View_ContractCondition_Value.ContractId
                                                 -- Тип условия договора
                                               , View_ContractCondition_Value.ContractConditionKind

                                                 -- (-)% Скидки (+)% Наценки
                                               , View_ContractCondition_Value.ChangePercent
                                                 -- % Наценки Павильоны (Приход покупателю)
                                               , View_ContractCondition_Value.ChangePercentPartner
                                                 -- Скидка в цене ГСМ
                                               , View_ContractCondition_Value.ChangePrice

                                                 -- Отсрочка в календарных днях
                                               , View_ContractCondition_Value.DayCalendar
                                                 -- Отсрочка в банковских днях
                                               , View_ContractCondition_Value.DayBank

                                                 -- Период для условия с ....
                                               , View_ContractCondition_Value.StartDate
                                                 -- Период для условия по ....
                                               , View_ContractCondition_Value.EndDate
                                                 -- № п/п
                                               , ROW_NUMBER() OVER (PARTITION BY View_ContractCondition_Value.ContractId, View_ContractCondition_Value.ContractConditionKind
                                                                    ORDER BY View_ContractCondition_Value.StartDate DESC
                                                                   ) AS Ord

                                          FROM Object_ContractCondition_ValueView_all AS View_ContractCondition_Value
                                          -- WHERE CURRENT_DATE BETWEEN View_ContractCondition_Value.StartDate AND View_ContractCondition_Value.EndDate
                                          --   AND COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd()) >= CURRENT_DATE
                                          --   AND COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd()) = zc_DateEnd()
                                         )
       -- последнее Условие договора
     , tmpContractCondition_Value AS (SELECT tmpContractCondition_Value_all.ContractId
                                             -- (-)% Скидки (+)% Наценки
                                           , MAX (tmpContractCondition_Value_all.ChangePercent)        :: TFloat AS ChangePercent
                                             -- % Наценки Павильоны (Приход покупателю)
                                           , MAX (tmpContractCondition_Value_all.ChangePercentPartner) :: TFloat AS ChangePercentPartner
                                             -- Скидка в цене ГСМ
                                           , MAX (tmpContractCondition_Value_all.ChangePrice)          :: TFloat AS ChangePrice

                                             -- Отсрочка в календарных днях
                                           , MAX (tmpContractCondition_Value_all.DayCalendar) :: TFloat AS DayCalendar
                                             -- Отсрочка в банковских днях
                                           , MAX (tmpContractCondition_Value_all.DayBank)     :: TFloat AS DayBank
                                             -- Отсрочка - информативно
                                           , CASE WHEN 0 <> MAX (tmpContractCondition_Value_all.DayCalendar)
                                                      THEN (MAX (tmpContractCondition_Value_all.DayCalendar) :: Integer) :: TVarChar || ' К.дн.'
                                                  WHEN 0 <> MAX (tmpContractCondition_Value_all.DayBank)
                                                      THEN (MAX (tmpContractCondition_Value_all.DayBank)     :: Integer) :: TVarChar || ' Б.дн.'
                                                  ELSE '0 дн.'
                                             END :: TVarChar  AS DelayDay

                                             -- Период для условия с ....
                                           , MAX (tmpContractCondition_Value_all.StartDate) :: TDateTime AS StartDate
                                             -- Период для условия по ....
                                           , MAX (tmpContractCondition_Value_all.EndDate)   :: TDateTime AS EndDate

                                      FROM tmpContractCondition_Value_all
                                      -- !!!последнее Условие договора!!!
                                      WHERE tmpContractCondition_Value_all.Ord = 1
                                      -- собрали в ОДНУ строчку
                                      GROUP BY tmpContractCondition_Value_all.ContractId
                                     )
  -- Результат
  SELECT Object_Contract.Id         AS ContractId
       , Object_Contract.ObjectCode AS ContractCode
       , Object_Contract.ValueData  AS InvNumber
         -- Признак "Удален да/нет"
       , Object_Contract.isErased

         -- отображается в отчетах - договор "объединяющий" аналогичные, его ContractCode + InvNumber
       , COALESCE (Object_Contract_key.Id,         Object_Contract.Id)         :: Integer  AS ContractId_key
       , COALESCE (Object_Contract_key.ObjectCode, Object_Contract.ObjectCode) :: Integer  AS ContractCode_key
       , COALESCE (Object_Contract_key.ValueData,  Object_Contract.ValueData)  :: TVarChar AS InvNumber_key
       , COALESCE (Object_Contract_key.isErased,   Object_Contract.isErased)   :: Boolean  AS isErased_key

         -- Юридическое лицо
       , Object_Juridical.Id               AS JuridicalId
       , Object_Juridical.ObjectCode       AS JuridicalCode
       , Object_Juridical.ValueData        AS JuridicalName
         -- Форма оплаты
       , Object_PaidKind.ObjectCode        AS PaidKindCode
       , Object_PaidKind.ValueData         AS PaidKindName

         -- Главное Юридическое лицо
       , Object_Juridical_basis.Id         AS JuridicalId_basis
       , Object_Juridical_basis.ObjectCode AS JuridicalCode_basis
       , Object_Juridical_basis.ValueData  AS JuridicalName_basis

         -- Юридическое лицо - печать док. - история
       , Object_Juridical_Doc.Id           AS JuridicalId_doc
       , Object_Juridical_Doc.ObjectCode   AS JuridicalCode_doc
       , Object_Juridical_Doc.ValueData    AS JuridicalName_doc

       --Юридические лица(печать док. - реквизиты плательщика)
       , Object_JuridicalInvoice.Id              AS JuridicalInvoiceId
       , Object_JuridicalInvoice.ObjectCode      AS JuridicalInvoiceCode
       , Object_JuridicalInvoice.ValueData       AS JuridicalInvoiceName
       --Классификаторы свойств товаров
       , Object_GoodsProperty.Id                 AS GoodsPropertyId
       , Object_GoodsProperty.ValueData          AS GoodsPropertyName
       -- 	Сотрудники (ответственное лицо)     
       , Object_Personal.Id                      AS PersonalId
       , Object_Personal.ObjectCode              AS PersonalCode
       , Object_Personal.ValueData               AS PersonalName
       --Сотрудники (торговый)
       , Object_PersonalTrade.Id                 AS PersonalTradeId
       , Object_PersonalTrade.ObjectCode         AS PersonalTradeCode
       , Object_PersonalTrade.ValueData          AS PersonalTradeName
       --Сотрудники (сверка)
       , Object_PersonalCollation.Id             AS PersonalCollationId
       , Object_PersonalCollation.ObjectCode     AS PersonalCollationCode
       , Object_PersonalCollation.ValueData      AS PersonalCollationName
       --Сотрудники (подписант)
       , Object_PersonalSigning.Id               AS PersonalSigningId
       , Object_PersonalSigning.ObjectCode       AS PersonalSigningCode
       , Object_PersonalSigning.ValueData        AS PersonalSigningName
       --Расчетный счет (вх.платеж)
       , Object_BankAccount.Id                   AS BankAccountId
       , Object_BankAccount.ValueData            AS BankAccountName
       --Регион(договора)
       , Object_AreaContract.Id                  AS AreaContractId
       , Object_AreaContract.ValueData           AS AreaContractName
       --Предмет договора
       , Object_ContractArticle.Id               AS ContractArticleId
       , Object_ContractArticle.ValueData        AS ContractArticleName
       --Банк(исх.платеж)
       , Object_Bank.Id                          AS BankId
       , Object_Bank.ValueData                   AS BankName
       --Филиал (расчеты нал)
       , Object_Branch.Id                        AS BranchId
       , Object_Branch.ValueData                 AS BranchName
                    
         -- Дата с которой действует договор
       , CASE -- без таких договоров
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              ELSE ObjectDate_Start.ValueData
         END :: TDateTime AS StartDate

         -- Дата до которой действует договор - расчет
       , CASE -- без таких договоров
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              -- если Тип пролонгаций договоров = бессрочный
              WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Long()
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              -- если Тип пролонгаций договоров = на период в месяцах
              WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Month() AND ObjectFloat_Term.ValueData > 0
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              -- иначе без изменений
              ELSE ObjectDate_End.ValueData
         END :: TDateTime AS EndDate

         -- Дата до которой действует договор - информативно
       , CASE -- без таких договоров
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TDateTime
              ELSE ObjectDate_End.ValueData
         END :: TDateTime AS EndDate_real

        --Дата заключения договора
       , ObjectDate_Signing.ValueData AS SigningDate
        -- Тип пролонгаций договоров
       , Object_ContractTermKind.ValueData                  AS ContractTermKindName
        -- Период пролонгации в месяцах
       , COALESCE (ObjectFloat_Term.ValueData, 0) :: TFloat AS Term

        -- УП Статья назначения
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName

         -- Состояние договора
       , Object_ContractStateKind.ObjectCode AS ContractStateKindCode
       , Object_ContractStateKind.ValueData  AS ContractStateKindName

         -- Группа признак договора
       , Object_ContractTagGroup.ObjectCode  AS ContractTagGroupCode
       , Object_ContractTagGroup.ValueData   AS ContractTagGroupName
         -- Признак договора
       , Object_ContractTag.ObjectCode       AS ContractTagCode
       , Object_ContractTag.ValueData        AS ContractTagName

         -- Вид договора - Код
       , CASE -- без таких договоров
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: Integer
              ELSE Object_ContractKind.ObjectCode
         END :: Integer AS ContractKindCode
         -- Вид договора - Название
       , CASE -- без таких договоров
              WHEN Object_Contract.ValueData = '-'
                   THEN NULL :: TVarChar
              ELSE Object_ContractKind.ValueData
         END :: TVarChar AS ContractKindName

         -- Условие договора - (-)% Скидки (+)% Наценки
       , View_ContractCondition_Value.ChangePercent
         -- Условие договора - % Наценки Павильоны (Приход покупателю)
       , View_ContractCondition_Value.ChangePercentPartner
         -- Условие договора - Скидка в цене ГСМ
       , View_ContractCondition_Value.ChangePrice

         -- Условие договора - Скидка в цене ГСМ
       , View_ContractCondition_Value.DayCalendar
         -- Условие договора - Отсрочка в банковских днях
       , View_ContractCondition_Value.DayBank
         -- Условие договора - Отсрочка в календарных днях
       , View_ContractCondition_Value.DelayDay

         -- Период для условия с ....
       , COALESCE (View_ContractCondition_Value.StartDate, zc_DateStart()) AS StartDate_condition
         -- Период для условия по ....
       , COALESCE (View_ContractCondition_Value.EndDate, zc_DateEnd())     AS EndDate_condition
       
       --По умолчанию (для вх. платежей) 
       , COALESCE (ObjectBoolean_Default.ValueData, False)   :: Boolean  AS isDefault
       --По умолчанию (для исх. платежей)
       , COALESCE (ObjectBoolean_DefaultOut.ValueData, False):: Boolean  AS isDefaultOut
       --Типовой
       , COALESCE (ObjectBoolean_Standart.ValueData, False)  :: Boolean  AS isStandart

       --Служебная записка 
       , COALESCE (ObjectBoolean_Personal.ValueData, False) :: Boolean AS isPersonal
       --Без группировки 
       , COALESCE (ObjectBoolean_Unique.ValueData, False)   :: Boolean AS isUnique
       --ставка 0% (таможня)
       , COALESCE (ObjectBoolean_Vat.ValueData, False)      :: Boolean AS isVat
       --клиент без НДС (ставка 0%)
       , COALESCE (ObjectBoolean_NotVat.ValueData, False)             :: Boolean AS isNotVat
       --Ирна
       , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)         :: Boolean AS isIrna   
       --Физ обмен
       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       --Нет возврата тары
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning
       --Ораниченный доступ маркетинг
       , COALESCE (ObjectBoolean_MarketNot.ValueData, FALSE)          :: Boolean AS isMarketNot
       --Отправка данных для ВМС
       , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE)              :: Boolean AS isWMS
       --Кол-во дней для сводной налоговой
       , ObjectFloat_DayTaxSummary.ValueData AS DayTaxSummary
       --Количество докуметов по договору
       , ObjectFloat_DocumentCount.ValueData AS DocumentCount
       --Дата последнего документа
       , ObjectDate_Document.ValueData AS DateDocument       
       --№ архивирования
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
       --Примечание
       , ObjectString_Comment.ValueData            AS Comment
       --Расчетный счет (исх.платеж)
       , ObjectString_BankAccount.ValueData        AS BankAccountExternal
       --Расчетный счет (покупателя)
       , ObjectString_BankAccountPartner.ValueData AS BankAccountPartner
       --Код GLN
       , ObjectString_GLNCode.ValueData            AS GLNCode
       --Код Поставщика
       , ObjectString_PartnerCode.ValueData        AS PartnerCode
       --Дата начала акции   
       , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
       --Дата окончания акции
       , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo     
              
       -- Пользователь (создание)
       , Object_Insert.ValueData   AS InsertName
       -- Пользователь (корректировка)
       , Object_Update.ValueData   AS UpdateName
       --Дата создания
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       --Дата корректировки
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
  FROM Object AS Object_Contract
       -- последнее Условие договора
       LEFT JOIN tmpContractCondition_Value AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract.Id

       -- нашли Ключ - объединяется договор
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKey
                            ON ObjectLink_Contract_ContractKey.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractKey.DescId   = zc_ObjectLink_Contract_ContractKey()
       -- нашли договор "объединяющий" аналогичные
       LEFT JOIN ObjectLink AS ObjectLink_ContractKey_Contract
                            ON ObjectLink_ContractKey_Contract.ObjectId = ObjectLink_Contract_ContractKey.ChildObjectId
                           AND ObjectLink_ContractKey_Contract.DescId   = zc_ObjectLink_ContractKey_Contract()
       -- договор "объединяющий" аналогичные
       LEFT JOIN Object AS Object_Contract_key ON Object_Contract_key.Id = ObjectLink_ContractKey_Contract.ChildObjectId

       -- Юридическое лицо
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId

       -- Форма оплаты
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

       -- Главное Юридическое лицо
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                            ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalBasis.DescId   = zc_ObjectLink_Contract_JuridicalBasis()
       LEFT JOIN Object AS Object_Juridical_basis ON Object_Juridical_basis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId

       -- Юридическое лицо - печать док.
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc
                            ON ObjectLink_Contract_JuridicalDoc.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalDoc.DescId   = zc_ObjectLink_Contract_JuridicalDocument()
       -- Дата с которой действует Юридическое лицо - печать док. - история
       LEFT JOIN ObjectDate AS ObjectDate_JuridicalDoc_Next
                            ON ObjectDate_JuridicalDoc_Next.ObjectId = Object_Contract.Id
                           AND ObjectDate_JuridicalDoc_Next.DescId   = zc_ObjectDate_Contract_JuridicalDoc_Next()
       -- Юридическое лицо - печать док. - история
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc_Next
                            ON ObjectLink_Contract_JuridicalDoc_Next.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_JuridicalDoc_Next.DescId   = zc_ObjectLink_Contract_JuridicalDoc_Next()
                           -- !!!Если дата подходит!!!
                           AND ObjectDate_JuridicalDoc_Next.ValueData >= CURRENT_DATE
       LEFT JOIN Object AS Object_Juridical_Doc ON Object_Juridical_Doc.Id = COALESCE (ObjectLink_Contract_JuridicalDoc_Next.ChildObjectId, ObjectLink_Contract_JuridicalDoc.ChildObjectId)
       --Юридические лица(печать док. - реквизиты плательщика)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                            ON ObjectLink_Contract_JuridicalInvoice.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
       LEFT JOIN Object AS Object_JuridicalInvoice ON Object_JuridicalInvoice.Id = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
       --Классификаторы свойств товаров
       LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                            ON ObjectLink_Contract_GoodsProperty.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
       LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Contract_GoodsProperty.ChildObjectId 
       --Сотрудники (ответственное лицо)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                            ON ObjectLink_Contract_Personal.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
       LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId               
       --Сотрудники (торговый)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                            ON ObjectLink_Contract_PersonalTrade.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
       LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId
       --Сотрудники (сверка)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                            ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
       LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId        
       --Сотрудники (подписант)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                            ON ObjectLink_Contract_PersonalSigning.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
       LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Contract_PersonalSigning.ChildObjectId   
       --Расчетный счет (вх.платеж)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                            ON ObjectLink_Contract_BankAccount.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
       LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId
       --Регион(договора)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                            ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
       LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
       --Предмет договора    
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                            ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
       LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
       --Банк(исх.платеж)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                            ON ObjectLink_Contract_Bank.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
       LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId
       --Филиал (расчеты нал)
       LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                            ON ObjectLink_Contract_Branch.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
       LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Contract_Branch.ChildObjectId       
       --Дата создания
       LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                            ON ObjectDate_Protocol_Insert.ObjectId = Object_Contract.Id
                           AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       --Дата корректировки
       LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                            ON ObjectDate_Protocol_Update.ObjectId = Object_Contract.Id
                           AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
       --Пользователь (создание)
       LEFT JOIN ObjectLink AS ObjectLink_Insert
                            ON ObjectLink_Insert.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
       -- 	Пользователь (корректировка)
       LEFT JOIN ObjectLink AS ObjectLink_Update
                            ON ObjectLink_Update.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
       LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

       -- Дата с которой действует договор
       LEFT JOIN ObjectDate AS ObjectDate_Start
                            ON ObjectDate_Start.ObjectId = Object_Contract.Id
                           AND ObjectDate_Start.DescId   = zc_ObjectDate_Contract_Start()
       -- Дата до которой действует договор - информативно
       LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                           AND ObjectDate_End.DescId   = zc_ObjectDate_Contract_End()

       -- УП Статья назначения
       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

       -- Состояние договора
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractStateKind.DescId   = zc_ObjectLink_Contract_ContractStateKind()
       LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId

       -- Признак договора
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTag.DescId   = zc_ObjectLink_Contract_ContractTag()
       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
       -- + для него Группа признак договора
       LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                            ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = Object_ContractTag.Id
                           AND ObjectLink_ContractTag_ContractTagGroup.DescId   = zc_ObjectLink_ContractTag_ContractTagGroup()
       LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = ObjectLink_ContractTag_ContractTagGroup.ChildObjectId

       -- Вид договора
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                            ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractKind.DescId   = zc_ObjectLink_Contract_ContractKind()
       LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

       -- Период пролонгации
       LEFT JOIN ObjectFloat AS ObjectFloat_Term
                             ON ObjectFloat_Term.ObjectId = Object_Contract.Id
                            AND ObjectFloat_Term.DescId   = zc_ObjectFloat_Contract_Term()
       -- Тип пролонгаций договоров
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTermKind
                            ON ObjectLink_Contract_ContractTermKind.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTermKind.DescId   = zc_ObjectLink_Contract_ContractTermKind()
       LEFT JOIN Object AS Object_ContractTermKind ON Object_ContractTermKind.Id = ObjectLink_Contract_ContractTermKind.ChildObjectId
       --По умолчанию (для вх. платежей)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                               ON ObjectBoolean_Default.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
       --По умолчанию (для исх. платежей)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                               ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()
       --Типовой
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                               ON ObjectBoolean_Standart.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
       --Служебная записка
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                               ON ObjectBoolean_Personal.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
       --Без группировки
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                               ON ObjectBoolean_Unique.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
       --Физ обмен
       LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                               ON ObjectBoolean_RealEx.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()
       --ставка 0% (таможня)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Vat
                               ON ObjectBoolean_Vat.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Vat.DescId = zc_ObjectBoolean_Contract_Vat()
       --клиент без НДС (ставка 0%)
       LEFT JOIN ObjectBoolean AS ObjectBoolean_NotVat
                               ON ObjectBoolean_NotVat.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_NotVat.DescId = zc_ObjectBoolean_Contract_NotVat()
       --Нет возврата тары
       LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                               ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()
       --Ораниченный доступ маркетинг
       LEFT JOIN ObjectBoolean AS ObjectBoolean_MarketNot
                               ON ObjectBoolean_MarketNot.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_MarketNot.DescId = zc_ObjectBoolean_Contract_MarketNot()
       --Отправка данных для ВМС
       LEFT JOIN ObjectBoolean AS ObjectBoolean_isWMS
                               ON ObjectBoolean_isWMS.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_isWMS.DescId = zc_ObjectBoolean_Contract_isWMS()
       --Ирна
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                               ON ObjectBoolean_Guide_Irna.ObjectId = Object_Contract.Id
                              AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

       --Дата заключения договора
       LEFT JOIN ObjectDate AS ObjectDate_Signing
                            ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                           AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                           AND Object_Contract.ValueData <> '-'
       --Количество докуметов по договору
       LEFT JOIN ObjectFloat AS ObjectFloat_DocumentCount
                             ON ObjectFloat_DocumentCount.ObjectId = Object_Contract.Id
                            AND ObjectFloat_DocumentCount.DescId = zc_ObjectFloat_Contract_DocumentCount()
       --Дата последнего документа
       LEFT JOIN ObjectDate AS ObjectDate_Document
                            ON ObjectDate_Document.ObjectId = Object_Contract.Id
                           AND ObjectDate_Document.DescId = zc_ObjectDate_Contract_Document()
       --Кол-во дней для сводной налоговой
       LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary
                             ON ObjectFloat_DayTaxSummary.ObjectId = Object_Contract.Id
                            AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Contract_DayTaxSummary()
       --№ архивирования
       LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                              ON ObjectString_InvNumberArchive.ObjectId = Object_Contract.Id
                             AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()
       --Примечание
       LEFT JOIN ObjectString AS ObjectString_Comment
                              ON ObjectString_Comment.ObjectId = Object_Contract.Id
                             AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
       --Расчетный счет (исх.платеж)
       LEFT JOIN ObjectString AS ObjectString_BankAccount
                              ON ObjectString_BankAccount.ObjectId = Object_Contract.Id
                             AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()
       --Расчетный счет (покупателя)
       LEFT JOIN ObjectString AS ObjectString_BankAccountPartner
                              ON ObjectString_BankAccountPartner.ObjectId = Object_Contract.Id
                             AND ObjectString_BankAccountPartner.DescId = zc_objectString_Contract_BankAccountPartner()
       --Код GLN
       LEFT JOIN ObjectString AS ObjectString_GLNCode
                              ON ObjectString_GLNCode.ObjectId = Object_Contract.Id
                             AND ObjectString_GLNCode.DescId = zc_objectString_Contract_GLNCode()
       --Код Поставщика
       LEFT JOIN ObjectString AS ObjectString_PartnerCode
                              ON ObjectString_PartnerCode.ObjectId = Object_Contract.Id
                             AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode() 
       --Дата начала акции
       LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                            ON ObjectDate_StartPromo.ObjectId = Object_Contract.Id
                           AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Contract_StartPromo()
       --Дата окончания акции
       LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                            ON ObjectDate_EndPromo.ObjectId = Object_Contract.Id
                           AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Contract_EndPromo()

  WHERE Object_Contract.DescId = zc_Object_Contract();
 ;

ALTER TABLE _bi_Guide_Contract_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_Contract_View
