-- View: _bi_Guide_Contract_View

 DROP VIEW IF EXISTS _bi_Guide_Contract_View;

-- Справочник Контрагенты
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

  WHERE Object_Contract.DescId = zc_Object_Contract();
 ;

ALTER TABLE _bi_Guide_Contract_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_Contract_View
