-- Function: gpSelect_Object_Partner_PriceList()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Partner_PriceList (Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Object_Partner_PriceList (TDateTime, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Object_Partner_PriceList (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_PriceList (TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_PriceList(
    IN inOperDate       TDateTime,     --
    IN inRetailId       Integer, 
    IN inJuridicalId    Integer, 
    IN inShowAll        Boolean,   
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, RetailName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, GLNCode TVarChar
             , PriceListName_income TVarChar
             , PriceListName_GP_sale TVarChar, PriceListName_GP_return TVarChar, PriceListName_GP_return_prior TVarChar
             , PriceListName_30103_sale TVarChar, PriceListName_30103_return TVarChar
             , PriceListName_30201_sale TVarChar, PriceListName_30201_return TVarChar

             , OperDate_income TDateTime
             , OperDate_GP_sale TDateTime, OperDate_GP_return TDateTime, OperDate_GP_return_prior TDateTime
             , OperDate_30103_sale TDateTime, OperDate_30103_return TDateTime
             , OperDate_30201_sale TDateTime, OperDate_30201_return TDateTime

             , DescName_income TVarChar
             , DescName_GP_sale TVarChar, DescName_GP_return TVarChar, DescName_GP_return_prior TVarChar
             , DescName_30103_sale TVarChar, DescName_30103_return TVarChar
             , DescName_30201_sale TVarChar, DescName_30201_return TVarChar

             , PersonalTradeCode Integer, PersonalTradeName TVarChar, PositionName_PersonalTrade TVarChar, BranchName_PersonalTrade TVarChar
             , PersonalMerchCode Integer, PersonalMerchName TVarChar, PositionName_PersonalMerch TVarChar, BranchName_PersonalMerch TVarChar 
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractStateKindCode Integer
             , ContractComment TVarChar
             , InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , OKPO TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Partner_PriceList());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!нет Результата!!!
   IF inOperDate = '01.01.2015'
   THEN RETURN;
   END IF;


   -- Результат
   RETURN QUERY
   WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
 
      , tmpContractPartner_Juridical AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                         FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                              INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                         AND Object_ContractPartner.isErased in (SELECT tmpIsErased.isErased FROM tmpIsErased)-- FALSE
                                         WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                         GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                        )
      , tmpPersonal AS (SELECT * FROM Object_Personal_View)
      , tmpInfoMoney AS (SELECT *
                         FROM Object_InfoMoney_View
                         WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20800() -- Общефирменные + Алан
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Чапли
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21100() -- Общефирменные + Дворкин
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21150() -- Общефирменные + ЕКСПЕРТ-АГРОТРЕЙД
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                        )
       , tmpContract AS (SELECT Object_Contract_View.*
                         FROM tmpIsErased
                              INNER JOIN Object_Contract_View ON Object_Contract_View.isErased = tmpIsErased.isErased
                                                             AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                              INNER JOIN tmpInfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
                       --  WHERE Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                       --    AND Object_Contract_View.isErased = FALSE
                        )
       , tmpPartner AS (SELECT * FROM 
        (SELECT Object_Partner.Id
              , Object_Partner.ObjectCode
              , Object_Partner.ValueData
              , Object_Partner.isErased

              , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
              , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId

              , Object_Contract_View.ContractId
              , Object_Contract_View.ContractCode
              , Object_Contract_View.InvNumber
              , Object_Contract_View.StartDate
              , Object_Contract_View.EndDate
              , Object_Contract_View.ContractTagId
              , Object_Contract_View.ContractTagName
              , Object_Contract_View.ContractStateKindCode
              , Object_Contract_View.PaidKindId

              , Object_InfoMoney_View.InfoMoneyId
              , Object_InfoMoney_View.InfoMoneyGroupName
              , Object_InfoMoney_View.InfoMoneyDestinationName
              , Object_InfoMoney_View.InfoMoneyCode
              , Object_InfoMoney_View.InfoMoneyName
              , Object_InfoMoney_View.InfoMoneyName_all

                -- 1. Приход
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 1
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*
                -- 2.1. ГП
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 21
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*

                -- 2.2.1. ГП
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 221
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*

                -- 2.2.2. ГП
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 222
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*

                -- 3.1. Хлеб
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 31
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*
                -- 3.2. Хлеб
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 32
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*

                -- 4.1. Мясное сырье
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 41
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*
                -- 4.2. Мясное сырье
              , (lfGet_Object_Partner_PriceList_onDate_calc (inParam                  := 42
                                                          , inContractId             := Object_Contract_View.ContractId
                                                          , inPartnerId              := Object_Partner.Id
                                                          , inOperDate               := inOperDate
                                                          , inInfoMoneyGroupId       := Object_InfoMoney_View.InfoMoneyGroupId
                                                          , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                          , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                           )).*

         FROM tmpIsErased
              INNER JOIN Object AS Object_Partner 
                                ON Object_Partner.isErased = tmpIsErased.isErased --FALSE
                               AND Object_Partner.DescId = zc_Object_Partner()
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

              LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                   ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                                  AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
              LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                        AND Object_ContractPartner.isErased in (SELECT tmpIsErased.isErased FROM tmpIsErased)-- FALSE
              LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                   ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                  AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

              LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
              LEFT JOIN tmpContract AS Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                            AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.JuridicalId IS NULL)
              LEFT JOIN tmpInfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

         WHERE (ObjectLink_ContractPartner_Contract.ObjectId > 0 OR Object_ContractPartner.Id IS NULL)
           AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
           AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)

        ) AS tmp (Id, ObjectCode, ValueData, isErased
                , JuridicalId
                , RetailId
                , ContractId
                , ContractCode
                , InvNumber
                , StartDate
                , EndDate
                , ContractTagId
                , ContractTagName
                , ContractStateKindCode
                , PaidKindId
                , InfoMoneyId
                , InfoMoneyGroupName
                , InfoMoneyDestinationName
                , InfoMoneyCode
                , InfoMoneyName
                , InfoMoneyName_all

                , OperDate_income
                , PriceListId_income
                , PriceListName_income
                , DescId_income

                , OperDate_GP_sale
                , PriceListId_GP_sale
                , PriceListName_GP_sale
                , DescId_GP_sale

                , OperDate_GP_return
                , PriceListId_GP_return
                , PriceListName_GP_return
                , DescId_GP_return

                , OperDate_GP_return_prior
                , PriceListId_GP_return_prior
                , PriceListName_GP_return_prior
                , DescId_GP_return_prior

                , OperDate_30103_sale
                , PriceListId_30103_sale
                , PriceListName_30103_sale
                , DescId_30103_sale

                , OperDate_30103_return
                , PriceListId_30103_return
                , PriceListName_30103_return
                , DescId_30103_return

                , OperDate_30201_sale
                , PriceListId_30201_sale
                , PriceListName_30201_sale
                , DescId_30201_sale

                , OperDate_30201_return
                , PriceListId_30201_return
                , PriceListName_30201_return
                , DescId_30201_return
                 )
        )

   SELECT
         tmpPartner.ContractId      :: Integer   AS Id
       , tmpPartner.ContractCode    :: Integer   AS Code
       , tmpPartner.InvNumber       :: TVarChar  AS InvNumber
       , tmpPartner.StartDate       :: TDateTime AS StartDate
       , tmpPartner.EndDate         :: TDateTime AS EndDate
       , tmpPartner.ContractTagId   :: Integer   AS ContractTagId
       , tmpPartner.ContractTagName :: TVarChar  AS ContractTagName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Retail.ValueData       AS RetailName
       , tmpPartner.Id             AS PartnerId
       , tmpPartner.ObjectCode     AS Partnerode
       , tmpPartner.ValueData      AS PartnerName
       , ObjectString_GLNCode.ValueData AS GLNCode

       , tmpPartner.PriceListName_income
       , tmpPartner.PriceListName_GP_sale
       , tmpPartner.PriceListName_GP_return
       , tmpPartner.PriceListName_GP_return_prior
       , tmpPartner.PriceListName_30103_sale
       , tmpPartner.PriceListName_30103_return
       , tmpPartner.PriceListName_30201_sale
       , tmpPartner.PriceListName_30201_return

       , tmpPartner.OperDate_income
       , tmpPartner.OperDate_GP_sale
       , tmpPartner.OperDate_GP_return
       , tmpPartner.OperDate_GP_return_prior
       , tmpPartner.OperDate_30103_sale
       , tmpPartner.OperDate_30103_return
       , tmpPartner.OperDate_30201_sale
       , tmpPartner.OperDate_30201_return

       , CASE tmpPartner.DescId_income
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_income

       , CASE tmpPartner.DescId_GP_sale
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_GP_sale

       , CASE tmpPartner.DescId_GP_return
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_GP_return

       , CASE tmpPartner.DescId_GP_return_prior
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_GP_return_prior

       , CASE tmpPartner.DescId_30103_sale
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_30103_sale

       , CASE tmpPartner.DescId_30103_return
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_30103_return

       , CASE tmpPartner.DescId_30201_sale
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_30201_sale

       , CASE tmpPartner.DescId_30201_return
              WHEN zc_ObjectLink_Partner_PriceList()   THEN 'Контрагент'
              WHEN zc_ObjectLink_Contract_PriceList()  THEN 'Договор'
              WHEN zc_ObjectLink_Juridical_PriceList() THEN 'Юр.лицо'

              WHEN zc_ObjectLink_Partner_PriceListPrior()   THEN 'Контрагент предыдущие'
              WHEN zc_ObjectLink_Juridical_PriceListPrior() THEN 'Юр.лицо предыдущие'

              WHEN zc_ObjectLink_Partner_PriceList30103() THEN 'Контрагент Хлеб'
              WHEN zc_ObjectLink_Partner_PriceList30201() THEN 'Контрагент Мясо'

              WHEN zc_ObjectLink_Juridical_PriceList30103() THEN 'Юр.лицо Хлеб'
              WHEN zc_ObjectLink_Juridical_PriceList30201() THEN 'Юр.лицо Мясо'

              WHEN zc_ObjectLink_Partner_PriceListPromo()   THEN 'Контрагент Акция'
              WHEN zc_ObjectLink_Contract_PriceListPromo()  THEN 'Договор Акция'
              WHEN zc_ObjectLink_Juridical_PriceListPromo() THEN 'Юр.лицо Акция'


              WHEN 0 THEN '*для всех'
              ELSE ''
         END :: TVarChar AS DescName_30201_return


       , View_PersonalTrade.PersonalCode  AS PersonalTradeCode
       , View_PersonalTrade.PersonalName  AS PersonalTradeName
       , View_PersonalTrade.PositionName  AS PositionName_PersonalTrade
       , Object_Branch.ValueData          AS BranchName_PersonalTrade

       , View_PersonalMerch.PersonalCode  AS PersonalMerchCode
       , View_PersonalMerch.PersonalName  AS PersonalMerchName
       , View_PersonalMerch.PositionName  AS PositionName_PersonalMerch
       , View_PersonalMerch.BranchName    AS BranchName_PersonalMerch

       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName

       , tmpPartner.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData   AS ContractComment 

       , tmpPartner.InfoMoneyId
       , tmpPartner.InfoMoneyGroupName
       , tmpPartner.InfoMoneyDestinationName
       , tmpPartner.InfoMoneyCode
       , tmpPartner.InfoMoneyName
       , tmpPartner.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , tmpPartner.isErased

    FROM tmpPartner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = tmpPartner.Id
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpPartner.Id
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                              ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                             AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                              ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN tmpPersonal AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalMerch
                              ON ObjectLink_Partner_PersonalMerch.ObjectId = tmpPartner.Id
                             AND ObjectLink_Partner_PersonalMerch.DescId = zc_ObjectLink_Partner_PersonalMerch()
         LEFT JOIN tmpPersonal AS View_PersonalMerch ON View_PersonalMerch.PersonalId = ObjectLink_Partner_PersonalMerch.ChildObjectId

         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpPartner.RetailId
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId
         LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

         LEFT JOIN ObjectString AS ObjectString_Comment
                                ON ObjectString_Comment.ObjectId = tmpPartner.ContractId
                               AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
    -- WHERE tmpPartner.ContractId > 0
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner_PriceList (TDateTime, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.06.17         * add PersonalMerch
 22.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner_PriceList (inOperDate:= '01.06.2015', inRetailId:= 0,  inJuridicalId:= 78893, inShowAll:= False, inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Partner_PriceList (inOperDate:= '01.01.2017', inRetailId:= 0,  inJuridicalId:= 0, inShowAll:= FALSE, inSession := zfCalc_UserAdmin())
-- select * from gpSelect_Object_Partner_PriceList(inOperDate := ('19.06.2017')::TDateTime , inRetailId := 340848 , inJuridicalId := 0 , inShowAll := 'False' ,  inSession := '5');