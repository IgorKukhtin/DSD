-- Function: gpSelect_Object_Partner_Address()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Address(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsPeriod          Boolean   , --
    IN inShowAll           Boolean,
    IN inJuridicalId       Integer  ,
    IN inInfoMoneyId       Integer  ,
    IN inPersonalTradeId   Integer  ,
    IN inRetailId          Integer  ,
    IN inRouteId           Integer  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ShortName TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PostalCode TVarChar, ProvinceCityName TVarChar,
               CityName TVarChar, CityKindName TVarChar, CityKindId Integer,
               RegionName TVarChar, ProvinceName TVarChar,
               StreetKindName TVarChar, StreetKindId Integer,
               JuridicalId Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar, 
               RetailId Integer, RetailName TVarChar, 
               RouteId Integer, RouteName TVarChar,
               Order_ContactPersonKindId Integer, Order_ContactPersonKindName TVarChar, Order_Name TVarChar, Order_Mail TVarChar, Order_Phone TVarChar,
               Doc_ContactPersonKindId Integer, Doc_ContactPersonKindName TVarChar, Doc_Name TVarChar, Doc_Mail TVarChar, Doc_Phone TVarChar,
               Act_ContactPersonKindId Integer, Act_ContactPersonKindName TVarChar, Act_Name TVarChar, Act_Mail TVarChar, Act_Phone TVarChar,
               OKPO TVarChar,
               MemberTakeId Integer, MemberTakeName TVarChar,
               PersonalId Integer, PersonalName TVarChar, UnitName_Personal TVarChar, PositionName_Personal TVarChar, BranchName_Personal TVarChar,
               PersonalTradeId Integer, PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar, PositionName_PersonalTrade TVarChar,
               PersonalMerchId Integer, PersonalMerchName TVarChar, UnitName_PersonalMerch TVarChar, PositionName_PersonalMerch TVarChar,
               AreaId Integer, AreaName TVarChar,
               PartnerTagId Integer, PartnerTagName TVarChar,
               InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               PaidKindName TVarChar, DocBranchName TVarChar, LastDocName TVarChar,
               NameInteger TVarChar,
               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner_Address());
   vbUserId:= lpGetUserBySession (inSession);


/*if inSession <> '5'
then
    RAISE EXCEPTION 'Ошибка.Повторите действие через 3 мин.';
end if;*/
if inIsPeriod = TRUE AND inStartDate + INTERVAL '1 MONTH'  < inEndDate
then
    inIsPeriod:= FALSE;
    -- RAISE EXCEPTION 'Ошибка.Выбранный период с <%> по <%> не может больше чем 1 месяца.', zfConvert_DateToString (inStartDate), zfConvert_DateToString (inEndDate);
end if;


   IF inIsPeriod = FALSE
   THEN
       inStartDate:= NULL;
       inEndDate  := NULL;
   /*ELSE
       inIsPeriod := FALSE;
       inStartDate:= NULL;
       inEndDate  := NULL;*/
   END IF;

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0)
                AND vbUserId <> 471654  -- Холод А.В.
                AND vbUserId <> 4067214 -- Холод А.
               ;

   RETURN QUERY
    WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       , tmpContactPerson AS (SELECT Object_ContactPerson.ValueData   AS Name
                                   , ObjectString_Phone.ValueData     AS Phone
                                   , ObjectString_Mail.ValueData      AS Mail

                                   , ContactPerson_Object.Id          AS PartnerId
                                   , ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId AS ContactPersonKindId

                              FROM Object AS Object_ContactPerson

                                    LEFT JOIN ObjectString AS ObjectString_Phone
                                                           ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id
                                                          AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                    LEFT JOIN ObjectString AS ObjectString_Mail
                                                           ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id
                                                          AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()

                                    LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                         ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                        AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                     JOIN Object AS ContactPerson_Object ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                                                        AND ContactPerson_Object.DescId = zc_Object_Partner()

                                     JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                     ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                                    AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()

                              WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                            )

   , tmpPersonal AS (SELECT Object_Personal.Id             AS PersonalId
                          , Object_Personal.ValueData      AS PersonalName
                          , Object_Position.ValueData      AS PositionName
                          , Object_Unit.Id                 AS UnitId
                          , Object_Unit.ValueData          AS UnitName
                          , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                     FROM Object AS Object_Personal
                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                    WHERE Object_Personal.DescId = zc_Object_Personal()
                     )

   , tmpMovement_1 AS (SELECT Movement.*
                       FROM Movement
                       WHERE Movement.DescId IN (zc_Movement_Income(), zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_ReturnIn())
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND inIsPeriod = TRUE
                      )
   , tmpMovement_2 AS (SELECT MovementLinkObject.*
                       FROM MovementLinkObject
                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_1.Id FROM tmpMovement_1)
                      )
         , tmpMI_1 AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_1.Id FROM tmpMovement_1)
                         AND MovementItem.IsErased = FALSE
                      )
         , tmpMI_2 AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_1.Id FROM tmpMI_1)
                         AND MovementItemLinkObject.DescId = zc_MILinkObject_Branch()
                      )
       , tmpMI_3 AS (SELECT Object.Id AS PartnerId
                          , Movement.DescId AS MovementDescId
                          , MLO_PaidKind.ObjectId AS PaidKindId
                          , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                          , COALESCE (MILO_Branch.ObjectId, 0) AS BranchId
                     FROM tmpMovement_1 AS Movement

                          INNER JOIN tmpMovement_2 AS MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                          INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId
                                           AND Object.DescId = zc_Object_Partner()

                          LEFT JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                          LEFT JOIN MovementLinkObject AS MLO_Contract ON MLO_Contract.MovementId = Movement.Id AND MLO_Contract.DescId =  zc_MovementLinkObject_Contract()
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                               ON ObjectLink_Contract_InfoMoney.ObjectId = MLO_Contract.ObjectId
                                              AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()

                          LEFT JOIN tmpMI_1 AS MovementItem
                                            ON MovementItem.MovementId = Movement.Id
                                           AND MovementItem.IsErased   = FALSE
                          LEFT JOIN tmpMI_2 AS MILO_Branch ON MILO_Branch.MovementItemId = MovementItem.Id AND MILO_Branch.DescId =  zc_MILinkObject_Branch()
                    )

   , tmpMovement AS (SELECT tmpMI_3.PartnerId
                          , MAX (CASE WHEN tmpMI_3.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN 3000
                                      ELSE 0
                                 END
                               + CASE WHEN tmpMI_3.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN zc_Movement_Sale()
                                      ELSE zc_Movement_Income()
                                 END
                                 ) AS DescId
                          , MAX (CASE WHEN MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) AND tmpMI_3.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 3000
                                      WHEN tmpMI_3.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 2000
                                      ELSE 0
                                 END
                               + tmpMI_3.PaidKindId
                                 ) AS PaidKindId
                          , MAX (CASE WHEN tmpMI_3.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                                           THEN tmpMI_3.InfoMoneyId
                                      ELSE -1 * tmpMI_3.InfoMoneyId
                                 END
                                 ) AS InfoMoneyId
                          , MAX (tmpMI_3.BranchId) AS BranchId
                     FROM tmpMI_3
                     WHERE (tmpMI_3.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                     GROUP BY tmpMI_3.PartnerId
                    )
     -- Результат
     SELECT
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name

         , ObjectString_ShortName.ValueData   AS ShortName

         , ObjectString_Address.ValueData     AS Address
         , ObjectString_HouseNumber.ValueData AS HouseNumber
         , ObjectString_CaseNumber.ValueData  AS CaseNumber
         , ObjectString_RoomNumber.ValueData  AS RoomNumber

         , Object_Street_View.Id              AS StreetId
         , Object_Street_View.Name            AS StreetName
         , Object_Street_View.PostalCode      AS PostalCode
         , Object_Street_View.ProvinceCityName  AS ProvinceCityName
         , Object_Street_View.CityName        AS CityName
         , Object_CityKind.ValueData          AS CityKindName
         , Object_CityKind.Id                 AS CityKindId
         , Object_Region.ValueData            AS RegionName
         , Object_Province.ValueData          AS ProvinceName
         , Object_Street_View.StreetKindName  AS StreetKindName
         , Object_Street_View.StreetKindId    AS StreetKindId

         , Object_Juridical.Id              AS JuridicalId
         , Object_Juridical.ValueData       AS JuridicalName
         , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
         , Object_Retail.Id                 AS RetailId
         , Object_Retail.ValueData          AS RetailName
         , Object_Route.Id                  AS RouteId
         , Object_Route.ValueData           AS RouteName

         , zc_Enum_ContactPersonKind_CreateOrder()  AS Order_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_CreateOrder()) AS Order_ContactPersonKindName
         , tmpContactPerson_Order.Name   AS Order_Name
         , tmpContactPerson_Order.Mail   AS Order_Mail
         , tmpContactPerson_Order.Phone  AS Order_Phone

         , zc_Enum_ContactPersonKind_CheckDocument()  AS Doc_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_CheckDocument()) AS Doc_ContactPersonKindName
         , tmpContactPerson_Doc.Name    AS Doc_Name
         , tmpContactPerson_Doc.Mail    AS Doc_Mail
         , tmpContactPerson_Doc.Phone   AS Doc_Phone

         , zc_Enum_ContactPersonKind_AktSverki()  AS Act_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_AktSverki()) AS Act_ContactPersonKindName
         , tmpContactPerson_Act.Name    AS Act_Name
         , tmpContactPerson_Act.Mail    AS Act_Mail
         , tmpContactPerson_Act.Phone   AS Act_Phone


           , ObjectHistory_JuridicalDetails_View.OKPO

           , Object_MemberTake.Id             AS MemberTakeId
           , Object_MemberTake.ValueData      AS MemberTakeName

           , View_Personal.PersonalId         AS PersonalId
           , View_Personal.PersonalName       AS PersonalName
           , View_Personal.UnitName           AS UnitName_Personal
           , View_Personal.PositionName       AS PositionName_Personal
           , Object_Branch.ValueData          AS BranchName_Personal

           , View_PersonalTrade.PersonalId    AS PersonalTradeId
           , View_PersonalTrade.PersonalName  AS PersonalTradeName
           , View_PersonalTrade.UnitName      AS UnitName_PersonalTrade
           , View_PersonalTrade.PositionName  AS PositionName_PersonalTrade

           , View_PersonalMerch.PersonalId    AS PersonalMerchId
           , View_PersonalMerch.PersonalName  AS PersonalMerchName
           , View_PersonalMerch.UnitName      AS UnitName_PersonalMerch
           , View_PersonalMerch.PositionName  AS PositionName_PersonalMerch

           , Object_Area.Id                   AS AreaId
           , Object_Area.ValueData            AS AreaName

           , Object_PartnerTag.Id             AS PartnerTagId
           , Object_PartnerTag.ValueData      AS PartnerTagName

           , (CASE WHEN tmpMovement.InfoMoneyId IS NULL THEN '---' ELSE '' END || Object_InfoMoney_View.InfoMoneyGroupName) :: TVarChar AS InfoMoneyGroupName
           , (CASE WHEN tmpMovement.InfoMoneyId IS NULL THEN '---' ELSE '' END || Object_InfoMoney_View.InfoMoneyDestinationName) :: TVarChar AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , (CASE WHEN tmpMovement.InfoMoneyId IS NULL THEN '---' ELSE '' END || Object_InfoMoney_View.InfoMoneyName) :: TVarChar AS InfoMoneyName
           , (CASE WHEN tmpMovement.InfoMoneyId IS NULL THEN '---' ELSE '' END || Object_InfoMoney_View.InfoMoneyName_all) :: TVarChar AS InfoMoneyName_all

           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_BranchDoc.ValueData       AS DocBranchName
           , MovementDesc_Doc.ItemName        AS LastDocName

           , ObjectString_NameInteger.ValueData AS NameInteger

           , Object_Partner.isErased          AS isErased

     FROM tmpIsErased
          INNER JOIN Object AS Object_Partner
                            ON Object_Partner.isErased = tmpIsErased.isErased
                           AND Object_Partner.DescId = zc_Object_Partner()

          LEFT JOIN  tmpMovement ON tmpMovement.PartnerId = Object_Partner.id
         LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = CASE WHEN tmpMovement.DescId > 3000 THEN tmpMovement.DescId - 3000 WHEN tmpMovement.DescId > 2000 THEN tmpMovement.DescId - 2000 ELSE tmpMovement.DescId END
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CASE WHEN tmpMovement.PaidKindId > 3000 THEN tmpMovement.PaidKindId - 3000 WHEN tmpMovement.PaidKindId > 2000 THEN tmpMovement.PaidKindId - 2000 ELSE tmpMovement.PaidKindId END
         LEFT JOIN Object AS Object_BranchDoc   ON Object_BranchDoc.Id   = tmpMovement.BranchId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                              ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
                             AND tmpMovement.InfoMoneyId IS NULL
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (ABS (tmpMovement.InfoMoneyId), ObjectLink_Juridical_InfoMoney.ChildObjectId)

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

         LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

         LEFT JOIN ObjectString AS ObjectString_ShortName
                                ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                               AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

         LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

         LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_NameInteger
                              ON ObjectString_NameInteger.ObjectId = Object_Partner.Id
                             AND ObjectString_NameInteger.DescId = zc_ObjectString_Partner_NameInteger()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_CityKind
                              ON ObjectLink_City_CityKind.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
         LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Region
                              ON ObjectLink_City_Region.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Province
                              ON ObjectLink_City_Province.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
         LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN tmpPersonal AS View_Personal ON View_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN tmpPersonal AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalMerch
                              ON ObjectLink_Partner_PersonalMerch.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalMerch.DescId = zc_ObjectLink_Partner_PersonalMerch()
         LEFT JOIN tmpPersonal AS View_PersonalMerch ON View_PersonalMerch.PersonalId = ObjectLink_Partner_PersonalMerch.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

         LEFT JOIN tmpContactPerson AS tmpContactPerson_Order on tmpContactPerson_Order.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Order.ContactPersonKindId = 153272    --"Формирование заказов"
         LEFT JOIN tmpContactPerson AS tmpContactPerson_Doc on tmpContactPerson_Doc.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Doc.ContactPersonKindId = 153273    --"Проверка документов"
         LEFT JOIN tmpContactPerson AS tmpContactPerson_Act on tmpContactPerson_Act.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Act.ContactPersonKindId = 153274    --"Акты сверки и выполенных работ"

         LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

    WHERE (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
      AND (tmpMovement.PartnerId > 0 OR inIsPeriod = FALSE)
      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-Услуги
                                                                )
           -- филиал
           OR View_PersonalTrade.BranchId = vbObjectId_Branch_Constraint
           -- если филиал Львов + еще  филиал Киев
           -- OR (vbObjectId_Branch_Constraint = 3080683 AND View_PersonalTrade.BranchId = 8379)
           -- если филиал Киев + еще  филиал Львов
           OR (vbObjectId_Branch_Constraint = 8379 AND View_PersonalTrade.BranchId = 3080683)
           --
           OR tmpMovement.PartnerId > 0
           OR vbIsConstraint = FALSE
           OR ObjectLink_Partner_PersonalTrade.ChildObjectId IS NULL
           --OR ObjectHistory_JuridicalDetails_View.OKPO = '2840114093'
          )
      AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId        OR COALESCE (inRetailId, 0)        = 0)
      AND (ObjectLink_Partner_Route.ChildObjectId    = inRouteId         OR COALESCE (inRouteId, 0)         = 0)
      AND (ObjectLink_Partner_Personal.ChildObjectId = inPersonalTradeId OR COALESCE (inPersonalTradeId, 0) = 0)
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Partner_Address (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.17         * add PersonalMerch
 06.05.17         *
 06.10.15         * add inShowAll
 09.12.14                                        * add inInfoMoneyId
 03.12.14                                        * all
 01.12.14                                                       *
 17.10.14         *
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner_Address(inStartDate := ('01.02.2015')::TDateTime , inEndDate := ('28.02.2015')::TDateTime , inIsPeriod := 'False' , inShowAll := 'False' , inJuridicalId := 15029 , inInfoMoneyId := 0 , inPersonalTradeId := 0 , inRetailId := 0 , inRouteId := 0 ,  inSession := '5');
-- select * from gpSelect_Object_Partner_Address(inStartDate := ('01.05.2021')::TDateTime , inEndDate := ('31.05.2021')::TDateTime , inIsPeriod := 'True' , inShowAll := 'False' , inJuridicalId := 0 , inInfoMoneyId := 8962 , inPersonalTradeId := 0 , inRetailId := 0 , inRouteId := 0 ,  inSession := '5284405');	
