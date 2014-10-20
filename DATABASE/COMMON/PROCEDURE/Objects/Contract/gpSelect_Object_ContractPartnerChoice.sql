-- Function: gpSelect_Object_ContractPartnerChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerChoice(
    IN inShowAll        Boolean,       --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractStateKindCode Integer
             , ContractComment TVarChar
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractPartnerChoice());
   vbUserId:= lpGetUserBySession (inSession);


   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;


   IF inShowAll= TRUE THEN
   -- Результат такой
   RETURN QUERY
   SELECT
         Object_Contract_View.ContractId   AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_Contract_View.ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent
       , Object_Partner.isErased

   FROM Object AS Object_Partner
        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                             ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

        LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                      AND Object_Contract_View.isErased = FALSE
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

 	LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                                                                          , zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                                          , zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                                           )
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR vbIsConstraint = FALSE)
  ;

   ELSE
   -- Результат другой
   RETURN QUERY
   SELECT
         Object_Contract_View.ContractId   AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_Contract_View.ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent
       , Object_Partner.isErased

   FROM Object AS Object_Partner
        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                             ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

        LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                      AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                      AND Object_Contract_View.isErased = FALSE
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

 	LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                                                                          , zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                                          , zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                                           )
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR vbIsConstraint = FALSE)
  ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartnerChoice (Boolean, TVarChar) OWNER TO postgres;

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
-- SELECT * FROM gpSelect_Object_ContractPartnerChoice (inShowAll:= FALSE, inSession := zfCalc_UserAdmin())
