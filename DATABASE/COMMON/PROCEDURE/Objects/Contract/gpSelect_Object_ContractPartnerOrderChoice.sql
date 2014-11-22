-- Function: gpSelect_Object_ContractPartnerOrderChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerOrderChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerOrderChoice(
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
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PersonalTakeId Integer, PersonalTakeName TVarChar
             , InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , ItemName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractPartnerChoice());
   vbUserId:= lpGetUserBySession (inSession);


   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0);
   vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
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

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id        AS PersonalTakeId
       , Object_MemberTake.ValueData AS PersonalTakeName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent

       , ObjectDesc.ItemName
       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

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
     AND COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                                           )
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR vbIsConstraint = FALSE
          OR Object_Partner.Id IN (17316 -- Білла 8221,Запорожье,ул.Яценко,2*600400
                                 , 17344 -- Білла 9221,Запорожье,ул.Яценко,2*500239
                                 , 79360 -- ВК № 37 Вел.Киш.,Запорожье,ГОРЬКОГО,71
                                 , 268754 -- ВК №37 Запорожье, Горького, 71 ВЕЛ.КИШ.ФУДМЕРЕЖА
                                 , 79205 -- ТОВ "РТЦ" Варус-10, Запорожье, ул.Сев.кольц.колб
                                 , 17795 -- РТЦ ТОВ, Варус-10, Запорожье Варто ТМ
                                 , 132330 -- РИТЕЙЛ ВЕСТ МЕЛИТОПОЛЬ,ЛЕНИНА,18/2
                                 , 128902 -- ФОЗЗИ  ФУД, Запорожье Ленина,147
                                 , 128903 -- ФОЗЗИ  ФУД, Запорожье,ул.Иванова,1а
                                  )
         )
  UNION ALL
   SELECT
         NULL :: Integer AS Id
       , NULL :: Integer AS Code
       , NULL :: TVarChar InvNumber
       , NULL :: TDateTime AS StartDate
       , NULL :: TDateTime AS EndDate
       , NULL :: Integer AS ContractTagId
       , NULL :: TVarChar AS ContractTagName
       , NULL :: Integer AS JuridicalId
       , Object_Parent.ObjectCode AS JuridicalCode
       , Object_Parent.ValueData  AS JuridicalName
       , Object_Unit.Id AS PartnerId
       , Object_Unit.ObjectCode AS PartnerCode
       , Object_Unit.ValueData AS PartnerName
       , NULL :: Integer AS PaidKindId
       , NULL :: TVarChar AS PaidKindName
       , NULL :: Integer ContractStateKindCode
       , NULL :: TVarChar AS ContractComment

       , NULL :: Integer AS RouteId
       , NULL :: TVarChar AS RouteName
       , NULL :: Integer AS RouteSortingId
       , NULL :: TVarChar AS RouteSortingName
       , NULL :: Integer AS PersonalTakeId
       , NULL :: TVarChar AS PersonalTakeName

       , NULL :: Integer AS InfoMoneyId
       , NULL :: TVarChar AS InfoMoneyGroupName
       , NULL :: TVarChar AS InfoMoneyDestinationName
       , NULL :: Integer AS InfoMoneyCode
       , NULL :: TVarChar AS InfoMoneyName
       , NULL :: TVarChar AS InfoMoneyName_all

       , NULL :: TVarChar AS OKPO
       , NULL :: TFloat  AS ChangePercent

       , ObjectDesc.ItemName
       , Object_Unit.isErased

   FROM ObjectLink AS ObjectLink_Unit_Parent
         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Parent.ObjectId
         LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
   WHERE ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
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

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id        AS PersonalTakeId
       , Object_MemberTake.ValueData AS PersonalTakeName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent

       , ObjectDesc.ItemName
       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

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
          OR vbIsConstraint = FALSE
          OR Object_Partner.Id IN (17316 -- Білла 8221,Запорожье,ул.Яценко,2*600400
                                 , 17344 -- Білла 9221,Запорожье,ул.Яценко,2*500239
                                 , 79360 -- ВК № 37 Вел.Киш.,Запорожье,ГОРЬКОГО,71
                                 , 268754 -- ВК №37 Запорожье, Горького, 71 ВЕЛ.КИШ.ФУДМЕРЕЖА
                                 , 79205 -- ТОВ "РТЦ" Варус-10, Запорожье, ул.Сев.кольц.колб
                                 , 17795 -- РТЦ ТОВ, Варус-10, Запорожье Варто ТМ
                                 , 132330 -- РИТЕЙЛ ВЕСТ МЕЛИТОПОЛЬ,ЛЕНИНА,18/2
                                 , 128902 -- ФОЗЗИ  ФУД, Запорожье Ленина,147
                                 , 128903 -- ФОЗЗИ  ФУД, Запорожье,ул.Иванова,1а
                                  )
         )

  UNION ALL
   SELECT
         NULL :: Integer AS Id
       , NULL :: Integer AS Code
       , NULL :: TVarChar InvNumber
       , NULL :: TDateTime AS StartDate
       , NULL :: TDateTime AS EndDate
       , NULL :: Integer AS ContractTagId
       , NULL :: TVarChar AS ContractTagName
       , NULL :: Integer AS JuridicalId
       , Object_Parent.ObjectCode AS JuridicalCode
       , Object_Parent.ValueData  AS JuridicalName
       , Object_Unit.Id AS PartnerId
       , Object_Unit.ObjectCode AS PartnerCode
       , Object_Unit.ValueData AS PartnerName
       , NULL :: Integer AS PaidKindId
       , NULL :: TVarChar AS PaidKindName
       , NULL :: Integer ContractStateKindCode
       , NULL :: TVarChar AS ContractComment 

       , NULL :: Integer AS RouteId
       , NULL :: TVarChar AS RouteName
       , NULL :: Integer AS RouteSortingId
       , NULL :: TVarChar AS RouteSortingName
       , NULL :: Integer AS PersonalTakeId
       , NULL :: TVarChar AS PersonalTakeName

       , NULL :: Integer AS InfoMoneyId
       , NULL :: TVarChar AS InfoMoneyGroupName
       , NULL :: TVarChar AS InfoMoneyDestinationName
       , NULL :: Integer AS InfoMoneyCode
       , NULL :: TVarChar AS InfoMoneyName
       , NULL :: TVarChar AS InfoMoneyName_all

       , NULL :: TVarChar AS OKPO
       , NULL :: TFloat  AS ChangePercent

       , ObjectDesc.ItemName
       , Object_Unit.isErased

   FROM ObjectLink AS ObjectLink_Unit_Parent
         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Parent.ObjectId
         LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
   WHERE ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
     AND (ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
          OR vbIsConstraint = FALSE
          OR Object_Unit.Id = 8459 -- Склад Реализации
         )
  ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartnerOrderChoice (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractPartnerOrderChoice (inShowAll:= FALSE, inSession := zfCalc_UserAdmin())
