-- Function: gpSelect_Object_Partner_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_PriceList(
    IN inShowAll        Boolean,       --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, GLNCode TVarChar
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


   -- Результат другой
   RETURN QUERY
   WITH tmpContractPartner_Juridical AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                         FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                              INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                         AND Object_ContractPartner.isErased = FALSE
                                         WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                         GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
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
       , tmpPartner.Id             AS PartnerId
       , tmpPartner.ObjectCode     AS PartnerCode
       , tmpPartner.ValueData      AS PartnerName
       , ObjectString_GLNCode.ValueData AS GLNCode
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName

       , tmpPartner.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData   AS ContractComment 

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , tmpPartner.isErased

   FROM (SELECT Object_Partner.Id
              , Object_Partner.ValueData
              , Object_Partner.isErased

              , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId

              , Object_Contract_View.ContractId
              , Object_Contract_View.ContractCode
              , Object_Contract_View.InvNumber
              , Object_Contract_View.StartDate
              , Object_Contract_View.EndDate
              , Object_Contract_View.ContractTagId
              , Object_Contract_View.ContractTagName
              , Object_Contract_View.ContractStateKindCode

              , Object_InfoMoney_View.InfoMoneyId
              , Object_InfoMoney_View.InfoMoneyGroupName
              , Object_InfoMoney_View.InfoMoneyDestinationName
              , Object_InfoMoney_View.InfoMoneyCode
              , Object_InfoMoney_View.InfoMoneyName
              , Object_InfoMoney_View.InfoMoneyName_all

              , lfGet_Object_Partner_PriceList_onDate_get (inContractId:= 347332, inPartnerId:= 348917, inMovementDescId:= zc_Movement_Sale(), inOperDate_order:= '05.05.2015', inOperDatePartner:= NULL, inIsPrior:= NULL)
         FROM Object AS Object_Partner
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

              LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                   ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                                  AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
              LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                        AND Object_ContractPartner.isErased = FALSE
              LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                   ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                  AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

              LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
              LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                            AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                            AND Object_Contract_View.isErased = FALSE
                                            AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.JuridicalId IS NULL)
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

         WHERE Object_Partner.DescId = zc_Object_Partner()
           AND Object_Partner.isErased = FALSE
           AND (ObjectLink_ContractPartner_Contract.ObjectId > 0 OR Object_ContractPartner.Id IS NULL)
           AND (Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Товары
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Алан
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Ирна
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Чапли
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Дворкин
             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + ЕКСПЕРТ-АГРОТРЕЙД
             OR Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
               )
        ) AS tmpPartner
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

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = tmpPartner.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner_PriceList (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.08.14                                        * add ContractComment
 25.04.14                                        * add ContractTagName
 28.02.14         * add inShowAll
 13.02.14                                        * add zc_Enum_ContractStateKind_Close
 24.01.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner_PriceList (inShowAll:= FALSE, inSession := zfCalc_UserAdmin())
