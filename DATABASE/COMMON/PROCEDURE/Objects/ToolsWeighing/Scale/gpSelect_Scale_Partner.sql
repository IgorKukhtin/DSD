-- Function: gpSelect_Scale_Partner()

DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Partner(
    IN inInfoMoneyId_income Integer     ,
    IN inInfoMoneyId_sale Integer     ,
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (PartnerId     Integer
             , PartnerCode   Integer
             , PartnerName   TVarChar
             , JuridicalName TVarChar
             , PaidKindId    Integer
             , PaidKindName  TVarChar
             , ContractId    Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , InfoMoneyId   Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , ChangePercent TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr   Boolean
             , isEdiInvoice  Boolean
             , isEdiDesadv   Boolean

             , isMovement    Boolean   -- Накладная
             , isAccount     Boolean   -- Счет
             , isTransport   Boolean   -- ТТН
             , isQuality     Boolean   -- Качественное
             , isPack        Boolean   -- Упаковочный
             , isSpec        Boolean   -- Спецификация
             , isTax         Boolean   -- Налоговая

             , ObjectDescId  Integer
             , ItemName      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- определяется уровень доступа
   vbObjectId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId), 0);
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);
   vbIsConstraint:= vbObjectId_Constraint > 0 OR vbBranchId_Constraint > 0;


    -- Результат
    RETURN QUERY
       WITH tmpInfoMoney AS (SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_find ON View_InfoMoney_find.InfoMoneyDestinationId = View_InfoMoney.InfoMoneyDestinationId
                             WHERE View_InfoMoney.InfoMoneyId = inInfoMoneyId_income
                            UNION
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyId IN (/*inInfoMoneyId_income,*/ inInfoMoneyId_sale)
                            )
         , tmpContractPartner AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                       , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                                       , ObjectLink_Partner_Juridical.ChildObjectId        AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                       INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                  AND Object_ContractPartner.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                             ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                            AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                                            AND ObjectLink_ContractPartner_Contract.ChildObjectId >0
                                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                            ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                    AND ObjectLink_ContractPartner_Partner.ChildObjectId >0
                                 )
          , tmpPartner AS (SELECT Object_Partner.Id         AS PartnerId
                                , Object_Partner.ObjectCode AS PartnerCode
                                , Object_Partner.ValueData  AS PartnerName
                                , View_Contract.JuridicalId AS JuridicalId
                                , View_Contract.PaidKindId  AS PaidKindId
                                  /*-- преобразование, т.к. в гриде будет фильтр или для УП-приход, или УП-реализация
                                , CASE WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                            THEN zc_Enum_InfoMoney_10101() -- Основное сырье + Мясное сырье + Живой вес
                                       WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы !!!не лишнее, т.к. ниже может понадобиться OR!!!
                                        AND tmpInfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                            THEN zc_Enum_InfoMoney_30101()
                                       ELSE tmpInfoMoney.InfoMoneyId
                                  END AS InfoMoneyId*/
                                , tmpInfoMoney.InfoMoneyId
                                , MAX (View_Contract.ContractId) AS ContractId
                           FROM tmpInfoMoney
                                LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.InfoMoneyId = tmpInfoMoney.InfoMoneyId
                                                                               AND View_Contract.isErased = FALSE
                                LEFT JOIN tmpContractPartner ON tmpContractPartner.ContractId = View_Contract.ContractId
                                                            AND tmpContractPartner.JuridicalId = View_Contract.JuridicalId
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ChildObjectId = View_Contract.JuridicalId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                    AND tmpContractPartner.ContractId IS NULL
                                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (tmpContractPartner.PartnerId, ObjectLink_Partner_Juridical.ObjectId)

                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

                                LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                     ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                                                    AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                                     ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                                    AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                                                     ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                                                    AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

                           WHERE Object_Partner.IsErased = FALSE
                             AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
                                  OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
                                  OR vbIsConstraint = FALSE
                                 )
                           GROUP BY Object_Partner.Id
                                  , Object_Partner.ObjectCode
                                  , Object_Partner.ValueData
                                  , View_Contract.JuridicalId
                                  , View_Contract.PaidKindId
                                  , tmpInfoMoney.InfoMoneyId
                          )
          , tmpPrintKindItem AS (SELECT tmp.Id, tmp.isMovement, tmp.isAccount, tmp.isTransport, tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax FROM lpSelect_Object_PrintKindItem() AS tmp)

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName
            , Object_Juridical.ValueData           AS JuridicalName
            , Object_PaidKind.Id                   AS PaidKindId
            , Object_PaidKind.ValueData            AS PaidKindName

            , Object_Contract_View.ContractId      AS ContractId
            , Object_Contract_View.ContractCode    AS ContractCode
            , Object_Contract_View.InvNumber       AS ContractNumber
            , Object_Contract_View.ContractTagName AS ContractTagName

            , tmpPartner.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN tmpPartner.PartnerCode = 1 THEN 1 WHEN tmpPartner.PartnerCode = 3 THEN 1 ELSE 1 END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpPrintKindItem.isPack = TRUE OR tmpPrintKindItem.isSpec = TRUE THEN COALESCE (tmpPrintKindItem.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , COALESCE (tmpPrintKindItem.isAccount, FALSE)   :: Boolean AS isAccount
            , COALESCE (tmpPrintKindItem.isTransport, FALSE) :: Boolean AS isTransport
            , COALESCE (tmpPrintKindItem.isQuality, FALSE)   :: Boolean AS isQuality
            , COALESCE (tmpPrintKindItem.isPack, FALSE)      :: Boolean AS isPack
            , COALESCE (tmpPrintKindItem.isSpec, FALSE)      :: Boolean AS isSpec
            , COALESCE (tmpPrintKindItem.isTax, FALSE)       :: Boolean AS isTax

            , ObjectDesc.Id AS ObjectDescId
            , ObjectDesc.ItemName

       FROM tmpPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Partner()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                 ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                 ON ObjectLink_Juridical_PrintKindItem.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()
            LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = COALESCE (ObjectLink_Retail_PrintKindItem.ChildObjectId, ObjectLink_Juridical_PrintKindItem.ChildObjectId)

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpPartner.InfoMoneyId
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId

            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
      UNION ALL
       SELECT Object_ArticleLoss.Id          AS PartnerId
            , Object_ArticleLoss.ObjectCode  AS PartnerCode
            , Object_ArticleLoss.ValueData   AS PartnerName
            , '' :: TVarChar  AS JuridicalName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , NULL :: Integer AS ContractId
            , View_ProfitLossDirection.ProfitLossDirectionCode             AS ContractCode
            , View_ProfitLossDirection.ProfitLossDirectionCode :: TVarChar AS ContractNumber
            , View_ProfitLossDirection.ProfitLossDirectionName             AS ContractTagName

            , NULL :: Integer                     AS InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyCode AS InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName

            , NULL :: TFloat AS ChangePercent
            , NULL :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement
            , FALSE       :: Boolean AS isAccount
            , FALSE       :: Boolean AS isTransport
            , FALSE       :: Boolean AS isQuality
            , FALSE       :: Boolean AS isPack
            , FALSE       :: Boolean AS isSpec
            , FALSE       :: Boolean AS isTax

            , ObjectDesc.Id AS ObjectDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_ArticleLoss
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ArticleLoss.DescId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                                 ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

       WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
         AND Object_ArticleLoss.isErased = FALSE

       ORDER BY 4 -- Object_Juridical.ValueData
              , 3 -- tmpPartner.PartnerName
              , 2 -- tmpPartner.PartnerCode
              , 12 -- View_InfoMoney.InfoMoneyCode
              , 8 -- Object_Contract_View.ContractCode
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_Partner (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Partner (zc_Enum_InfoMoney_10101(), zc_Enum_InfoMoney_30101(), zfCalc_UserAdmin())
