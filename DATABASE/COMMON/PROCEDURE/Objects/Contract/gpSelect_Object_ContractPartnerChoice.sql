-- Function: gpSelect_Object_ContractPartnerChoice()

--DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerChoice(
    IN inJuridicalId    Integer,
    IN inShowAll        Boolean,       --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, GLNCode TVarChar
             , Address TVarChar, GPSN TFloat, GPSE TFloat
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractStateKindCode Integer
             , ContractComment TVarChar
             , isNotTareReturning Boolean
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , MemberTakeId Integer, MemberTakeName TVarChar
             , MemberTakeId1 Integer, MemberTakeName1 TVarChar,
               MemberTakeId2 Integer, MemberTakeName2 TVarChar,
               MemberTakeId3 Integer, MemberTakeName3 TVarChar,
               MemberTakeId4 Integer, MemberTakeName4 TVarChar,
               MemberTakeId5 Integer, MemberTakeName5 TVarChar,
               MemberTakeId6 Integer, MemberTakeName6 TVarChar,
               MemberTakeId7 Integer, MemberTakeName7 TVarChar
             , personalTakeId Integer, personalTakeName TVarChar
             , InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat, ChangePercentPartner TFloat
             , DelayDay TVarChar
             , PrepareDayCount TFloat, DocumentDayCount TFloat
             , AmountDebet TFloat
             , AmountKredit TFloat
             , BranchName TVarChar, ContainerId Integer
             , CurrencyId Integer, CurrencyName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , VATPercent TFloat, PriceWithVAT Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsIrna       Boolean;
   DECLARE vbIsUserOrder  Boolean;
   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractPartnerChoice());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);

   -- определяется уровень доступа
   vbIsUserOrder:= vbUserId <> 6950843 AND EXISTS (SELECT Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder > 0);
   vbObjectId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId), 0 );
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);
   vbIsConstraint:= (vbObjectId_Constraint > 0 OR vbBranchId_Constraint > 0) AND COALESCE (vbIsIrna, FALSE) = FALSE;


   IF inShowAll= TRUE THEN
   -- Результат такой
   RETURN QUERY
   WITH tmpContractPartner_Juridical AS (SELECT DISTINCT
                                                ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                            --  ObjectLink_Partner_Juridical.ObjectId      AS PartnerId
                                            --, ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                         FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                   AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                                              INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                         AND Object_ContractPartner.isErased = FALSE
                                              INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                                    ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                                   AND ObjectLink_ContractPartner_Contract.DescId   = zc_ObjectLink_ContractPartner_Contract()

                                         WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                        )
        , tmpObject_Contract_View AS (SELECT *
                                      FROM Object_Contract_View
                                      WHERE Object_Contract_View.isErased = FALSE
                                        AND (Object_Contract_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                                     )
        , tmpContainer_Partner_View AS (SELECT * FROM Container_Partner_View WHERE Container_Partner_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
        , tmpObjectHistory_JuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
        , tmpObject_InfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)

      /*  , tmpPartner AS (SELECT Object_Partner.*
                         FROM Object AS Object_Partner
                         WHERE Object_Partner.DescId = zc_Object_Partner()
                         )
*/
   -- Результат
   SELECT DISTINCT
         Object_Contract_View.ContractId      :: Integer   AS Id
       , Object_Contract_View.ContractCode    :: Integer   AS Code
       , Object_Contract_View.InvNumber       :: TVarChar  AS InvNumber
       , Object_Contract_View.StartDate       :: TDateTime AS StartDate
       , Object_Contract_View.EndDate         :: TDateTime AS EndDate
       , Object_Contract_View.ContractTagId   :: Integer   AS ContractTagId
       , Object_Contract_View.ContractTagName :: TVarChar  AS ContractTagName
       , Object_Juridical.Id             AS JuridicalId
       , Object_Juridical.ObjectCode     AS JuridicalCode
       , Object_Juridical.ValueData      AS JuridicalName
       , Object_Partner.Id               AS PartnerId
       , Object_Partner.ObjectCode       AS PartnerCode
       , Object_Partner.ValueData        AS PartnerName
       , ObjectString_GLNCode.ValueData  AS GLNCode
       , ObjectString_Address.ValueData  AS Address
       , COALESCE (Partner_GPSN.ValueData,0) ::Tfloat  AS GPSN
       , COALESCE (Partner_GPSE.ValueData,0) ::Tfloat  AS GPSE 
       , Object_PaidKind.Id              AS PaidKindId
       , Object_PaidKind.ValueData       AS PaidKindName
       , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning 

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id          AS MemberTakeId
       , Object_MemberTake.ValueData   AS MemberTakeName

       , Object_MemberTake1.Id             AS MemberTakeId1
       , Object_MemberTake1.ValueData      AS MemberTakeName1
       , Object_MemberTake2.Id             AS MemberTakeId2
       , Object_MemberTake2.ValueData      AS MemberTakeName2
       , Object_MemberTake3.Id             AS MemberTakeId3
       , Object_MemberTake3.ValueData      AS MemberTakeName3
       , Object_MemberTake4.Id             AS MemberTakeId4
       , Object_MemberTake4.ValueData      AS MemberTakeName4
       , Object_MemberTake5.Id             AS MemberTakeId5
       , Object_MemberTake5.ValueData      AS MemberTakeName5
       , Object_MemberTake6.Id             AS MemberTakeId6
       , Object_MemberTake6.ValueData      AS MemberTakeName6
       , Object_MemberTake7.Id             AS MemberTakeId7
       , Object_MemberTake7.ValueData      AS MemberTakeName7 

       , Object_MemberTake.Id        AS personalTakeId
       , Object_MemberTake.ValueData AS personalTakeName
 
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Contract_View.ChangePercent
       , Object_Contract_View.ChangePercentPartner
       , Object_Contract_View.DelayDay
       , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
       , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

       , Container_Partner_View.AmountDebet
       , Container_Partner_View.AmountKredit

       , Object_Branch.ValueData AS BranchName
       , Container_Partner_View.ContainerId

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName

       , Object_PriceList.Id             AS PriceListId 
       , Object_PriceList.ValueData      AS PriceListName
       , COALESCE (ObjectFloat_VATPercent.ValueData,20)        ::TFloat  AS VATPercent
       , COALESCE (ObjectBoolean_PriceWithVAT.ValueData,FALSE) ::Boolean AS PriceWithVAT


       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                              ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                             AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                              ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake1
                              ON ObjectLink_Partner_MemberTake1.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake1.DescId = zc_ObjectLink_Partner_MemberTake1()
         LEFT JOIN Object AS Object_MemberTake1 ON Object_MemberTake1.Id = ObjectLink_Partner_MemberTake1.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake2
                              ON ObjectLink_Partner_MemberTake2.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake2.DescId = zc_ObjectLink_Partner_MemberTake2()
         LEFT JOIN Object AS Object_MemberTake2 ON Object_MemberTake2.Id = ObjectLink_Partner_MemberTake2.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake3
                              ON ObjectLink_Partner_MemberTake3.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake3.DescId = zc_ObjectLink_Partner_MemberTake3()
         LEFT JOIN Object AS Object_MemberTake3 ON Object_MemberTake3.Id = ObjectLink_Partner_MemberTake3.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake4
                              ON ObjectLink_Partner_MemberTake4.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake4.DescId = zc_ObjectLink_Partner_MemberTake4()
         LEFT JOIN Object AS Object_MemberTake4 ON Object_MemberTake4.Id = ObjectLink_Partner_MemberTake4.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake5
                              ON ObjectLink_Partner_MemberTake5.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake5.DescId = zc_ObjectLink_Partner_MemberTake5()
         LEFT JOIN Object AS Object_MemberTake5 ON Object_MemberTake5.Id = ObjectLink_Partner_MemberTake5.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake6
                              ON ObjectLink_Partner_MemberTake6.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake6.DescId = zc_ObjectLink_Partner_MemberTake6()
         LEFT JOIN Object AS Object_MemberTake6 ON Object_MemberTake6.Id = ObjectLink_Partner_MemberTake6.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake7
                              ON ObjectLink_Partner_MemberTake7.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake7.DescId = zc_ObjectLink_Partner_MemberTake7()
         LEFT JOIN Object AS Object_MemberTake7 ON Object_MemberTake7.Id = ObjectLink_Partner_MemberTake7.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                              ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                             AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
         LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                   AND Object_ContractPartner.isErased = FALSE
         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                              ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                             AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
       --LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
       --                                      AND tmpContractPartner_Juridical.PartnerId   = ObjectLink_Partner_Juridical.ObjectId
       --LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId

         LEFT JOIN tmpObject_Contract_View AS Object_Contract_View
                                           ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                        --*AND Object_Contract_View.isErased = FALSE
                                        --AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.JuridicalId IS NULL)
                                        --AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.ContractId IS NULL)
         LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.ContractId = Object_Contract_View.ContractId

         LEFT JOIN tmpContainer_Partner_View AS Container_Partner_View
                                             ON Container_Partner_View.PartnerId = Object_Partner.Id
                                            AND Container_Partner_View.ContractId = Object_Contract_View.ContractId
                                            AND (Container_Partner_View.BranchId = vbBranchId_Constraint OR vbBranchId_Constraint = 0)

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId)       
        
        LEFT JOIN tmpObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN tmpObject_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, Object_Contract_View.InfoMoneyId)
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, Object_Contract_View.PaidKindId)

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()
 
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId


        /*LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
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
                   ) Object_ContractCondition_Value View AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract_View.ContractId*/

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() THEN zc_ObjectLink_Partner_Route30201() ELSE zc_ObjectLink_Partner_Route() END
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
         LEFT JOIN ObjectFloat AS Partner_GPSN 
                               ON Partner_GPSN.ObjectId = Object_Partner.Id
                              AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()  
         LEFT JOIN ObjectFloat AS Partner_GPSE
                               ON Partner_GPSE.ObjectId = Object_Partner.Id
                              AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE() 
        -- прайс
        LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                             ON ObjectLink_Contract_PriceList.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (ObjectLink_Contract_PriceList.ChildObjectId, zc_PriceList_Basis())

        LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                               AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
        LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                              ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                             AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.ContractId IS NULL
          OR vbIsIrna = TRUE
         )
     AND ((Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
           AND vbBranchId_Constraint > 0)
       OR (COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                                                                            , zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                                            , zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                                             )
           AND vbBranchId_Constraint = 0
           AND vbIsUserOrder = FALSE)
       OR (Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                          , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                           )
           AND vbIsUserOrder = TRUE)
       OR (Object_InfoMoney_View.InfoMoneyId = 8942 AND vbIsUserOrder = FALSE) -- Кротон
       OR (Object_Juridical.Id = 15222 AND vbIsUserOrder = FALSE) -- Кротон НВКФ ТОВ
       OR vbIsIrna = TRUE
         )
     --
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                              , 8359 -- 04-Услуги
                                                               )
          OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
          -- филиал Киев + филиал Львов
          OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 8379 AND vbBranchId_Constraint = 3080683)
          -- филиал Львов + филиал Киев
          OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 3080683 AND vbBranchId_Constraint = 8379)
          --
          OR vbIsConstraint = FALSE
         OR (Object_Partner.Id IN (17316 -- Білла 8221,Запорожье,ул.Яценко,2*600400
                                 , 17344 -- Білла 9221,Запорожье,ул.Яценко,2*500239
                                 , 79360 -- ВК № 37 Вел.Киш.,Запорожье,ГОРЬКОГО,71
                                 , 268754 -- ВК №37 Запорожье, Горького, 71 ВЕЛ.КИШ.ФУДМЕРЕЖА
                                 , 79205 -- ТОВ "РТЦ" Варус-10, Запорожье, ул.Сев.кольц.колб
                                 , 17795 -- РТЦ ТОВ, Варус-10, Запорожье Варто ТМ
                                 , 132330 -- РИТЕЙЛ ВЕСТ МЕЛИТОПОЛЬ,ЛЕНИНА,18/2
                                 , 128902 -- ФОЗЗИ  ФУД, Запорожье Ленина,147
                                 , 128903 -- ФОЗЗИ  ФУД, Запорожье,ул.Иванова,1а
                                  )
             AND COALESCE (vbIsIrna, FALSE) = FALSE
            )
          OR vbIsIrna = TRUE
         )
     AND (COALESCE (vbIsIrna, FALSE) = FALSE
     --OR (vbIsIrna = FALSE AND COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE) = FALSE)
       OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
         )
     AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
  ;

   ELSE
   -- Результат другой
   RETURN QUERY
   WITH tmpContractPartner_Juridical AS (SELECT DISTINCT
                                                ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                            --  ObjectLink_Partner_Juridical.ObjectId      AS PartnerId
                                            --, ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                         FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                   AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                                              INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                         AND Object_ContractPartner.isErased = FALSE
                                              INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                                    ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                                   AND ObjectLink_ContractPartner_Contract.DescId   = zc_ObjectLink_ContractPartner_Contract()

                                         WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                        )
       , tmpOB_isBranchAll AS (SELECT * FROM ObjectBoolean AS OB WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Juridical_isBranchAll())

       , tmpObject_Contract_View AS (SELECT *
                                     FROM Object_Contract_View
                                     WHERE Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE
                                       AND (Object_Contract_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                                    )
       , tmpContainer_Partner_View AS (SELECT * FROM Container_Partner_View WHERE Container_Partner_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
       , tmpObjectHistory_JuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId = inJuridicalId OR inJuridicalId = 0)
       , tmpObject_InfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)
       , tmpContractCondition_Value_all AS (SELECT * FROM Object_ContractCondition_ValueView WHERE CURRENT_DATE BETWEEN Object_ContractCondition_ValueView.StartDate AND Object_ContractCondition_ValueView.EndDate)
       , tmpObject_ContractCondition_ValueView AS (SELECT tmpContractCondition_Value_all.ContractId
                                                        , MAX (tmpContractCondition_Value_all.ChangePercent)        :: TFloat AS ChangePercent
                                                        , MAX (tmpContractCondition_Value_all.ChangePercentPartner) :: TFloat AS ChangePercentPartner
                                                        , MAX (tmpContractCondition_Value_all.ChangePrice)          :: TFloat AS ChangePrice
                                                        
                                                        , MAX (tmpContractCondition_Value_all.DayCalendar) :: TFloat AS DayCalendar
                                                        , MAX (tmpContractCondition_Value_all.DayBank)     :: TFloat AS DayBank
                                                        , CASE WHEN 0 <> MAX (tmpContractCondition_Value_all.DayCalendar)
                                                                   THEN (MAX (tmpContractCondition_Value_all.DayCalendar) :: Integer) :: TVarChar || ' К.дн.'
                                                               WHEN 0 <> MAX (tmpContractCondition_Value_all.DayBank)
                                                                   THEN (MAX (tmpContractCondition_Value_all.DayBank)     :: Integer) :: TVarChar || ' Б.дн.'
                                                               ELSE '0 дн.'
                                                          END :: TVarChar  AS DelayDay
                                                 
                                                        , MAX (tmpContractCondition_Value_all.StartDate) :: TDateTime AS StartDate
                                                        , MAX (tmpContractCondition_Value_all.EndDate)   :: TDateTime AS EndDate
                                                   FROM tmpContractCondition_Value_all
                                                   GROUP BY tmpContractCondition_Value_all.ContractId
                                                  )
   -- 
   SELECT DISTINCT
         Object_Contract_View.ContractId      :: Integer   AS Id
       , Object_Contract_View.ContractCode    :: Integer   AS Code
       , Object_Contract_View.InvNumber       :: TVarChar  AS InvNumber
       , Object_Contract_View.StartDate       :: TDateTime AS StartDate
       , Object_Contract_View.EndDate         :: TDateTime AS EndDate
       , Object_Contract_View.ContractTagId   :: Integer   AS ContractTagId
       , Object_Contract_View.ContractTagName :: TVarChar  AS ContractTagName
       , Object_Juridical.Id             AS JuridicalId
       , Object_Juridical.ObjectCode     AS JuridicalCode
       , Object_Juridical.ValueData      AS JuridicalName
       , Object_Partner.Id               AS PartnerId
       , Object_Partner.ObjectCode       AS PartnerCode
       , Object_Partner.ValueData        AS PartnerName
       , ObjectString_GLNCode.ValueData  AS GLNCode
       , ObjectString_Address.ValueData  AS Address
       , COALESCE (Partner_GPSN.ValueData,0) ::Tfloat  AS GPSN
       , COALESCE (Partner_GPSE.ValueData,0) ::Tfloat  AS GPSE

       , Object_PaidKind.Id              AS PaidKindId
       , Object_PaidKind.ValueData       AS PaidKindName
       , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning 

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id          AS MemberTakeId
       , Object_MemberTake.ValueData   AS MemberTakeName

       , Object_MemberTake1.Id             AS MemberTakeId1
       , Object_MemberTake1.ValueData      AS MemberTakeName1
       , Object_MemberTake2.Id             AS MemberTakeId2
       , Object_MemberTake2.ValueData      AS MemberTakeName2
       , Object_MemberTake3.Id             AS MemberTakeId3
       , Object_MemberTake3.ValueData      AS MemberTakeName3
       , Object_MemberTake4.Id             AS MemberTakeId4
       , Object_MemberTake4.ValueData      AS MemberTakeName4
       , Object_MemberTake5.Id             AS MemberTakeId5
       , Object_MemberTake5.ValueData      AS MemberTakeName5
       , Object_MemberTake6.Id             AS MemberTakeId6
       , Object_MemberTake6.ValueData      AS MemberTakeName6
       , Object_MemberTake7.Id             AS MemberTakeId7
       , Object_MemberTake7.ValueData      AS MemberTakeName7 

       , Object_MemberTake.Id        AS personalTakeId
       , Object_MemberTake.ValueData AS personalTakeName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , View_ContractCondition_Value.ChangePercent
       , View_ContractCondition_Value.ChangePercentPartner
       , View_ContractCondition_Value.DelayDay
       , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
       , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

       , Container_Partner_View.AmountDebet
       , Container_Partner_View.AmountKredit

       , Object_Branch.ValueData AS BranchName
       , Container_Partner_View.ContainerId

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , Object_PriceList.Id             AS PriceListId 
       , Object_PriceList.ValueData      AS PriceListName
       , COALESCE (ObjectFloat_VATPercent.ValueData,20)        ::TFloat  AS VATPercent
       , COALESCE (ObjectBoolean_PriceWithVAT.ValueData,FALSE) ::Boolean AS PriceWithVAT

       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                              ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                             AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                              ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake1
                              ON ObjectLink_Partner_MemberTake1.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake1.DescId = zc_ObjectLink_Partner_MemberTake1()
         LEFT JOIN Object AS Object_MemberTake1 ON Object_MemberTake1.Id = ObjectLink_Partner_MemberTake1.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake2
                              ON ObjectLink_Partner_MemberTake2.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake2.DescId = zc_ObjectLink_Partner_MemberTake2()
         LEFT JOIN Object AS Object_MemberTake2 ON Object_MemberTake2.Id = ObjectLink_Partner_MemberTake2.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake3
                              ON ObjectLink_Partner_MemberTake3.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake3.DescId = zc_ObjectLink_Partner_MemberTake3()
         LEFT JOIN Object AS Object_MemberTake3 ON Object_MemberTake3.Id = ObjectLink_Partner_MemberTake3.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake4
                              ON ObjectLink_Partner_MemberTake4.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake4.DescId = zc_ObjectLink_Partner_MemberTake4()
         LEFT JOIN Object AS Object_MemberTake4 ON Object_MemberTake4.Id = ObjectLink_Partner_MemberTake4.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake5
                              ON ObjectLink_Partner_MemberTake5.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake5.DescId = zc_ObjectLink_Partner_MemberTake5()
         LEFT JOIN Object AS Object_MemberTake5 ON Object_MemberTake5.Id = ObjectLink_Partner_MemberTake5.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake6
                              ON ObjectLink_Partner_MemberTake6.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake6.DescId = zc_ObjectLink_Partner_MemberTake6()
         LEFT JOIN Object AS Object_MemberTake6 ON Object_MemberTake6.Id = ObjectLink_Partner_MemberTake6.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake7
                              ON ObjectLink_Partner_MemberTake7.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake7.DescId = zc_ObjectLink_Partner_MemberTake7()
         LEFT JOIN Object AS Object_MemberTake7 ON Object_MemberTake7.Id = ObjectLink_Partner_MemberTake7.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                              ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                             AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
         LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                   AND Object_ContractPartner.isErased = FALSE
         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                              ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                             AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
       --LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
       --                                      AND tmpContractPartner_Juridical.PartnerId   = ObjectLink_Partner_Juridical.ObjectId
       --LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId

         LEFT JOIN tmpObject_Contract_View AS Object_Contract_View
                                           ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                          --*AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                          --*AND Object_Contract_View.isErased = FALSE
                                        --AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.JuridicalId IS NULL)
                                        --AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.ContractId IS NULL)
         LEFT JOIN tmpContractPartner_Juridical ON tmpContractPartner_Juridical.ContractId = Object_Contract_View.ContractId

         LEFT JOIN tmpContainer_Partner_View AS Container_Partner_View
                                             ON Container_Partner_View.PartnerId = Object_Partner.Id
                                            AND Container_Partner_View.ContractId = Object_Contract_View.ContractId
                                            AND (Container_Partner_View.BranchId = vbBranchId_Constraint OR vbBranchId_Constraint = 0)

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId) 

        LEFT JOIN tmpObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN tmpObject_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, Object_Contract_View.InfoMoneyId)
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, Object_Contract_View.PaidKindId)

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN /*(SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
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
                   )*/ tmpObject_ContractCondition_ValueView AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract_View.ContractId

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() THEN zc_ObjectLink_Partner_Route30201() ELSE zc_ObjectLink_Partner_Route() END
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
         LEFT JOIN ObjectFloat AS Partner_GPSN 
                               ON Partner_GPSN.ObjectId = Object_Partner.Id
                              AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()  
         LEFT JOIN ObjectFloat AS Partner_GPSE
                               ON Partner_GPSE.ObjectId = Object_Partner.Id
                              AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE() 

         LEFT JOIN tmpOB_isBranchAll AS ObjectBoolean_isBranchAll
                                     ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                 -- AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

        -- прайс
        LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                             ON ObjectLink_Contract_PriceList.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (ObjectLink_Contract_PriceList.ChildObjectId, zc_PriceList_Basis())

        LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                               AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
        LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                              ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                             AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND Object_Partner.isErased = FALSE
     AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId OR tmpContractPartner_Juridical.ContractId IS NULL
          OR vbIsIrna = TRUE
         )
     AND ((Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                          , zc_Enum_InfoMoneyDestination_30500() -- Доходы + Прочие доходы
                                                           )
           AND vbBranchId_Constraint > 0)
       OR (COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                                                                            , zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                                                            , zc_Enum_InfoMoneyDestination_30400() -- услуги предоставленные
                                                                             )
           AND vbBranchId_Constraint = 0
           AND vbIsUserOrder = FALSE)
       OR (Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                          , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                          , zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                          , zc_Enum_InfoMoneyDestination_30500() -- Доходы + Прочие доходы
                                                           )
           AND vbIsUserOrder = TRUE)
       OR (Object_InfoMoney_View.InfoMoneyId = 8942 AND vbIsUserOrder = FALSE) -- Кротон
       OR (Object_Juridical.Id = 15222 AND vbIsUserOrder = FALSE) -- Кротон НВКФ ТОВ
       OR vbIsIrna = TRUE
         )
     --
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                              , 8359 -- 04-Услуги
                                                               )
          OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
          -- филиал Киев + филиал Львов
          OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 8379 AND vbBranchId_Constraint = 3080683)
          -- филиал Львов + филиал Киев
          OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 3080683 AND vbBranchId_Constraint = 8379)
          --
          OR ObjectBoolean_isBranchAll.ValueData = TRUE
          OR vbIsConstraint = FALSE
         OR (Object_Partner.Id IN (17316 -- Білла 8221,Запорожье,ул.Яценко,2*600400
                                 , 17344 -- Білла 9221,Запорожье,ул.Яценко,2*500239
                                 , 79360 -- ВК № 37 Вел.Киш.,Запорожье,ГОРЬКОГО,71
                                 , 268754 -- ВК №37 Запорожье, Горького, 71 ВЕЛ.КИШ.ФУДМЕРЕЖА
                                 , 79205 -- ТОВ "РТЦ" Варус-10, Запорожье, ул.Сев.кольц.колб
                                 , 17795 -- РТЦ ТОВ, Варус-10, Запорожье Варто ТМ
                                 , 132330 -- РИТЕЙЛ ВЕСТ МЕЛИТОПОЛЬ,ЛЕНИНА,18/2
                                 , 128902 -- ФОЗЗИ  ФУД, Запорожье Ленина,147
                                 , 128903 -- ФОЗЗИ  ФУД, Запорожье,ул.Иванова,1а
                                  )
             AND COALESCE (vbIsIrna, FALSE) = FALSE
            )
          OR vbIsIrna = TRUE
         )
     AND (COALESCE (vbIsIrna, FALSE) = FALSE
     --OR (vbIsIrna = FALSE AND COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE) = FALSE)
       OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
         )
     AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
  ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.10.24         * inJuridicalId
 26.09.23         * isNotTareReturning
 22.11.18         * add Currency
 10.05.17         *  add Address, GPSE, GPSN
 12.09.15         * add MemberTake1...7
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.08.14                                        * add ContractComment
 25.04.14                                        * add ContractTagName
 28.02.14         * add inShowAll
 13.02.14                                        * add zc_Enum_ContractStateKind_Close
 24.01.14                                                        *
*/

-- тест
-- select * from gpSelect_Object_ContractPartnerChoice (inShowAll:= FALSE, inSession:= '4467766');
-- SELECT * FROM gpSelect_Object_ContractPartnerChoice (inJuridicalId:=149317, inShowAll:= FALSE, inSession:= '4467766') --149317
