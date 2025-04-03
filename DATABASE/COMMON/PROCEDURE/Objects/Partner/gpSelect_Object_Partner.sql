-- Function: gpSelect_Object_Partner()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
    IN inJuridicalId       Integer  ,
    IN inRetailId          Integer  ,
    IN inPersonalTradeId   Integer  ,
    IN inRouteId           Integer  ,
    IN inShowAll           Boolean  ,
    IN inSession           TVarChar   -- сесси€ пользовател€
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, BasisCode Integer,
               ShortName TVarChar, GLNCode TVarChar,
               GLNCodeJuridical_property TVarChar, GLNCodeRetail_property TVarChar, GLNCodeCorporate_property TVarChar,
               GLNCodeJuridical TVarChar, GLNCodeRetail TVarChar, GLNCodeCorporate TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PrepareDayCount TFloat, DocumentDayCount TFloat,
               GPSN TFloat, GPSE TFloat,
               Category TFloat,
               TaxSale_Personal TFloat, TaxSale_PersonalTrade TFloat, TaxSale_MemberSaler1 TFloat, TaxSale_MemberSaler2 TFloat,
               EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean,

               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar, /*GLNCode_Juridical TVarChar,*/
               RetailId Integer, RetailName TVarChar,
               RouteId Integer, RouteCode Integer, RouteName TVarChar,
               RouteId_30201 Integer, RouteCode_30201 Integer, RouteName_30201 TVarChar,
               RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar,

               MemberTakeId Integer, MemberTakeCode Integer, MemberTakeName TVarChar,
               MemberSaler1Id Integer, MemberSaler1Code Integer, MemberSaler1Name TVarChar,
               MemberSaler2Id Integer, MemberSaler2Code Integer, MemberSaler2Name TVarChar,
               
               PersonalId Integer, PersonalCode Integer, PersonalName TVarChar, BranchName_Personal TVarChar, UnitName_Personal TVarChar,
               PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar, BranchName_PersonalTrade TVarChar, UnitName_PersonalTrade TVarChar,
               PersonalMerchId Integer, PersonalMerchCode Integer, PersonalMerchName TVarChar,
               PersonalSigningId Integer, PersonalSigningCode Integer, PersonalSigningName TVarChar,
               AreaId Integer, AreaName TVarChar,
               PartnerTagId Integer, PartnerTagName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyName TVarChar,

               OKPO TVarChar,
               PriceListId Integer, PriceListName TVarChar,
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               PriceListId_Prior Integer, PriceListName_Prior TVarChar,
               PriceListId_30103 Integer, PriceListName_30103 TVarChar,
               PriceListId_30201 Integer, PriceListName_30201 TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,

               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               UnitMobileId Integer, UnitMobileName TVarChar,
               isErased Boolean,
               Value1 Boolean, Value2 Boolean, Value3 Boolean, Value4 Boolean,
               Value5 Boolean, Value6 Boolean, Value7 Boolean,

               --Delivery TVarChar, -- √рафик завоза на ““ - по каким дн€м недели - в строчке 7 символов разделенных ";" t значит true и f значит false
               Delivery1 Boolean, Delivery2 Boolean, Delivery3 Boolean, Delivery4 Boolean,
               Delivery5 Boolean, Delivery6 Boolean, Delivery7 Boolean,

               GUID TVarChar, isGUID Boolean,
               isIrna Boolean,
               isGoodsBox Boolean, 
               MovementComment TVarChar,
               BranchCode TVarChar,
               BranchJur TVarChar,
               Terminal TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
   DECLARE vbGLNCodeCorporate TVarChar;
BEGIN
   -- проверка прав пользовател€ на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- определ€етс€
   vbGLNCodeCorporate:= (SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectString_Juridical_GLNCode());

   -- определ€етс€ уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= zfCalc_AccessKey_GuideAll (vbUserId) = FALSE AND (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbBranchId_Constraint, 0) > 0)
                AND vbUserId <> 471654  -- ’олод ј.¬.
                AND vbUserId <> 4067214 -- ’олод ј.
               ;


   -- –езультат
   RETURN QUERY

     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     , tmpPartner AS (SELECT  Object_Partner.*
                            , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                      FROM Object AS Object_Partner
                           INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId      = Object_Partner.Id
                                                AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
                      WHERE Object_Partner.DescId = zc_Object_Partner()
                     )

     SELECT
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name 
         , ObjectFloat_ObjectCode_Basis.ValueData ::Integer AS BasisCode

         , ObjectString_ShortName.ValueData   AS ShortName
         , ObjectString_GLNCode.ValueData     AS GLNCode

         , ObjectString_GLNCodeJuridical.ValueData AS GLNCodeJuridical_property
         , ObjectString_GLNCodeRetail.ValueData    AS GLNCodeRetail_property
         , ObjectString_GLNCodeCorporate.ValueData AS GLNCodeCorporate_property

         , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeJuridical_partner := ObjectString_GLNCodeJuridical.ValueData
                                  , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                   ) AS GLNCodeJuridical

         , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_GLNCode.ValueData
                               , inGLNCodeRetail_partner := ObjectString_GLNCodeRetail.ValueData
                               , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                               , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                ) AS GLNCodeRetail

         , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_main    := vbGLNCodeCorporate
                                   ) AS GLNCodeCorporate

         , ObjectString_Address.ValueData     AS Address
         , ObjectString_HouseNumber.ValueData AS HouseNumber
         , ObjectString_CaseNumber.ValueData  AS CaseNumber
         , ObjectString_RoomNumber.ValueData  AS RoomNumber

         , Object_Street.Id                   AS StreetId
         , Object_Street.ValueData            AS StreetName

         , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
         , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

         , COALESCE (Partner_GPSN.ValueData,0)         ::Tfloat  AS GPSN
         , COALESCE (Partner_GPSE.ValueData,0)         ::Tfloat  AS GPSE
         , COALESCE (ObjectFloat_Category.ValueData,0) ::TFloat  AS Category

         , COALESCE (ObjectFloat_TaxSale_Personal.ValueData,0)      ::TFloat  AS TaxSale_Personal
         , COALESCE (ObjectFloat_TaxSale_PersonalTrade.ValueData,0) ::TFloat  AS TaxSale_PersonalTrade
         , COALESCE (ObjectFloat_TaxSale_MemberSaler1.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler1
         , COALESCE (ObjectFloat_TaxSale_MemberSaler2.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler2

         , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS EdiOrdspr
         , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS EdiInvoice
         , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS EdiDesadv


         , Object_Juridical.Id             AS JuridicalId
         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName
         , Object_JuridicalGroup.ValueData AS JuridicalGroupName

         , Object_Retail.Id                AS RetailId
         , Object_Retail.ValueData         AS RetailName

         , Object_Route.Id                 AS RouteId
         , Object_Route.ObjectCode         AS RouteCode
         , Object_Route.ValueData          AS RouteName
         , Object_Route_30201.Id           AS RouteId_30201
         , Object_Route_30201.ObjectCode   AS RouteCode_30201
         , Object_Route_30201.ValueData    AS RouteName_30201

         , Object_RouteSorting.Id           AS RouteSortingId
         , Object_RouteSorting.ObjectCode   AS RouteSortingCode
         , Object_RouteSorting.ValueData    AS RouteSortingName

         , Object_MemberTake.Id             AS MemberTakeId
         , Object_MemberTake.ObjectCode     AS MemberTakeCode
         , Object_MemberTake.ValueData      AS MemberTakeName

         , Object_MemberSaler1.Id             AS MemberSaler1Id
         , Object_MemberSaler1.ObjectCode     AS MemberSaler1Code
         , Object_MemberSaler1.ValueData      AS MemberSaler1Name
         , Object_MemberSaler2.Id             AS MemberSaler2Id
         , Object_MemberSaler2.ObjectCode     AS MemberSaler2Code
         , Object_MemberSaler2.ValueData      AS MemberSaler2Name

           -- ‘»ќ сотрудник (супервайзер)
         , Object_Personal.PersonalId        AS PersonalId
         , Object_Personal.PersonalCode      AS PersonalCode
         , Object_Personal.PersonalName      AS PersonalName
         , Object_Personal.BranchName        AS BranchName_Personal
         , Object_Personal.UnitName          AS UnitName_Personal

           -- ‘»ќ сотрудник (“ѕ)
         , Object_PersonalTrade.PersonalId   AS PersonalTradeId
         , Object_PersonalTrade.PersonalCode AS PersonalTradeCode
         , Object_PersonalTrade.PersonalName AS PersonalTradeName
         , Object_PersonalTrade.BranchName   AS BranchName_PersonalTrade
         , Object_PersonalTrade.UnitName     AS UnitName_PersonalTrade

         , Object_PersonalMerch.Id           AS PersonalMerchId
         , Object_PersonalMerch.ObjectCode   AS PersonalMerchCode
         , Object_PersonalMerch.ValueData    AS PersonalMerchName

         , Object_PersonalSigning.Id           AS PersonalSigningId
         , Object_PersonalSigning.ObjectCode   AS PersonalSigningCode
         , Object_PersonalSigning.ValueData    AS PersonalSigningName

         , Object_Area.Id                  AS AreaId
         , Object_Area.ValueData           AS AreaName

         , Object_PartnerTag.Id            AS PartnerTagId
         , Object_PartnerTag.ValueData     AS PartnerTagName

         , Object_GoodsProperty.Id         AS GoodsPropertyId
         , Object_GoodsProperty.ValueData  AS GoodsPropertyName

         , ObjectHistory_JuridicalDetails_View.OKPO

         , Object_PriceList.Id         AS PriceListId
         , Object_PriceList.ValueData  AS PriceListName

         , Object_PriceListPromo.Id         AS PriceListPromoId
         , Object_PriceListPromo.ValueData  AS PriceListPromoName

         , Object_PriceList_Prior.Id         AS PriceListId_Prior
         , Object_PriceList_Prior.ValueData  AS PriceListName_Prior

         , Object_PriceList_30103.Id         AS PriceListId_30103
         , Object_PriceList_30103.ValueData  AS PriceListName_30103

         , Object_PriceList_30201.Id         AS PriceListId_30201
         , Object_PriceList_30201.ValueData  AS PriceListName_30201

         , ObjectDate_StartPromo.ValueData AS StartPromo
         , ObjectDate_EndPromo.ValueData   AS EndPromo

         , Object_Unit.Id         AS UnitId
         , Object_Unit.ObjectCode AS UnitCode
         , Object_Unit.ValueData  AS UnitName

         , Object_UnitMobile.Id        AS UnitMobileId
         , Object_UnitMobile.ValueData AS UnitMobileName

         , Object_Partner.isErased   AS isErased

         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Value1
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Value2
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Value3
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Value4
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Value5
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Value6
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Value7

         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Delivery1
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Delivery2
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Delivery3
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Delivery4
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Delivery5
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Delivery6
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Delivery7

         , ObjectString_GUID.ValueData AS GUID
         , CASE WHEN ObjectString_GUID.ValueData <> '' THEN TRUE ELSE FALSE END :: Boolean AS isGUID
         , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
         , COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE) :: Boolean AS isGoodsBox
         , ObjectString_Movement.ValueData   ::TVarChar AS MovementComment
         , ObjectString_BranchCode.ValueData ::TVarChar AS BranchCode
         , ObjectString_BranchJur.ValueData  ::TVarChar AS BranchJur   
         , ObjectString_Terminal.ValueData   ::TVarChar AS Terminal
     FROM tmpIsErased
         INNER JOIN tmpPartner AS Object_Partner
                               ON Object_Partner.isErased = tmpIsErased.isErased
                              AND Object_Partner.DescId = zc_Object_Partner()

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Partner.JuridicalId

         LEFT JOIN ObjectString AS ObjectString_GUID
                                ON ObjectString_GUID.ObjectId = Object_Partner.Id
                               AND ObjectString_GUID.DescId = zc_ObjectString_Juridical_GUID()
         LEFT JOIN ObjectString AS ObjectString_GLNCode
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

         LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical
                                ON ObjectString_GLNCodeJuridical.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail
                                ON ObjectString_GLNCodeRetail.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeCorporate
                                ON ObjectString_GLNCodeCorporate.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

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

         LEFT JOIN ObjectString AS ObjectString_Schedule
                                ON ObjectString_Schedule.ObjectId = Object_Partner.Id
                               AND ObjectString_Schedule.DescId = zc_ObjectString_Partner_Schedule()
         LEFT JOIN ObjectString AS ObjectString_Delivery
                                ON ObjectString_Delivery.ObjectId = Object_Partner.Id
                               AND ObjectString_Delivery.DescId = zc_ObjectString_Partner_Delivery()

         LEFT JOIN ObjectString AS ObjectString_Movement
                                ON ObjectString_Movement.ObjectId = Object_Partner.Id
                               AND ObjectString_Movement.DescId = zc_ObjectString_Partner_Movement()

         LEFT JOIN ObjectString AS ObjectString_BranchCode
                                ON ObjectString_BranchCode.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchCode.DescId = zc_ObjectString_Partner_BranchCode()
         LEFT JOIN ObjectString AS ObjectString_BranchJur
                                ON ObjectString_BranchJur.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()
         LEFT JOIN ObjectString AS ObjectString_Terminal
                                ON ObjectString_Terminal.ObjectId = Object_Partner.Id
                               AND ObjectString_Terminal.DescId = zc_ObjectString_Partner_Terminal()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectFloat AS Partner_GPSN
                               ON Partner_GPSN.ObjectId = Object_Partner.Id
                              AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()
         LEFT JOIN ObjectFloat AS Partner_GPSE
                               ON Partner_GPSE.ObjectId = Object_Partner.Id
                              AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()

         LEFT JOIN ObjectFloat AS ObjectFloat_Category
                               ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                              AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

         LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                               ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Partner.Id
                              AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()

         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_Personal
                               ON ObjectFloat_TaxSale_Personal.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_Personal.DescId = zc_ObjectFloat_Partner_TaxSale_Personal()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_PersonalTrade
                               ON ObjectFloat_TaxSale_PersonalTrade.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_PersonalTrade.DescId = zc_ObjectFloat_Partner_TaxSale_PersonalTrade()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler1
                               ON ObjectFloat_TaxSale_MemberSaler1.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler1.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler1()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler2
                               ON ObjectFloat_TaxSale_MemberSaler2.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler2.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler2()


         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiOrdspr
                                 ON ObjectBoolean_EdiOrdspr.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiInvoice
                                 ON ObjectBoolean_EdiInvoice.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiDesadv
                                 ON ObjectBoolean_EdiDesadv.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

         LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                              ON ObjectDate_StartPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Partner_StartPromo()

         LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                              ON ObjectDate_EndPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Partner_EndPromo()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object AS Object_Street ON Object_Street.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                ON ObjectString_Juridical_GLNCode.ObjectId = Object_Juridical.Id
                               AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
         LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route_30201
                              ON ObjectLink_Partner_Route_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route_30201.DescId = zc_ObjectLink_Partner_Route30201()
         LEFT JOIN Object AS Object_Route_30201 ON Object_Route_30201.Id = ObjectLink_Partner_Route_30201.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler1
                              ON ObjectLink_Partner_MemberSaler1.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberSaler1.DescId = zc_ObjectLink_Partner_MemberSaler1()
         LEFT JOIN Object AS Object_MemberSaler1 ON Object_MemberSaler1.Id = ObjectLink_Partner_MemberSaler1.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler2
                              ON ObjectLink_Partner_MemberSaler2.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberSaler2.DescId = zc_ObjectLink_Partner_MemberSaler2()
         LEFT JOIN Object AS Object_MemberSaler2 ON Object_MemberSaler2.Id = ObjectLink_Partner_MemberSaler2.ChildObjectId

         -- ‘»ќ сотрудник (супервайзер)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

         -- ‘»ќ сотрудник (“ѕ)
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalMerch
                              ON ObjectLink_Partner_PersonalMerch.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalMerch.DescId = zc_ObjectLink_Partner_PersonalMerch()
         LEFT JOIN Object AS Object_PersonalMerch ON Object_PersonalMerch.Id = ObjectLink_Partner_PersonalMerch.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                              ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalSigning.DescId = zc_ObjectLink_Partner_PersonalSigning()
         LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Partner_PersonalSigning.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

         LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                              ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                              ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
         LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Partner_PriceListPromo.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_Prior
                              ON ObjectLink_Partner_PriceList_Prior.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_Prior.DescId = zc_ObjectLink_Partner_PriceListPrior()
         LEFT JOIN Object AS Object_PriceList_Prior ON Object_PriceList_Prior.Id = ObjectLink_Partner_PriceList_Prior.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30103
                              ON ObjectLink_Partner_PriceList_30103.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30103.DescId = zc_ObjectLink_Partner_PriceList30103()
         LEFT JOIN Object AS Object_PriceList_30103 ON Object_PriceList_30103.Id = ObjectLink_Partner_PriceList_30103.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30201
                              ON ObjectLink_Partner_PriceList_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30201.DescId = zc_ObjectLink_Partner_PriceList30201()
         LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Partner_PriceList_30201.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                              ON ObjectLink_Partner_Unit.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Partner_Unit.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                              ON ObjectLink_Partner_GoodsProperty.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
         LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Partner_GoodsProperty.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_UnitMobile
                              ON ObjectLink_Partner_UnitMobile.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_UnitMobile.DescId = zc_ObjectLink_Partner_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Partner_UnitMobile.ChildObjectId

         LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                 ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                 ON ObjectBoolean_Guide_Irna.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_GoodsBox
                                 ON ObjectBoolean_Partner_GoodsBox.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Partner_GoodsBox.DescId = zc_ObjectBoolean_Partner_GoodsBox()

   WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-”слуги
                                                                )
           -- филиал
           OR Object_PersonalTrade.BranchId = vbBranchId_Constraint
           -- если филиал Ћьвов + еще  филиал  иев
           -- OR (vbBranchId_Constraint = 3080683 AND Object_PersonalTrade.BranchId = 8379)
           -- если филиал  иев + еще  филиал Ћьвов
           OR (vbBranchId_Constraint = 8379 AND Object_PersonalTrade.BranchId = 3080683)
           --
           OR ObjectLink_Partner_PersonalTrade.ChildObjectId IS NULL
           OR ObjectBoolean_isBranchAll.ValueData = TRUE
           OR vbIsConstraint = FALSE
           --OR ObjectHistory_JuridicalDetails_View.OKPO = '2840114093'
          )
      AND (ObjectLink_Juridical_Retail.ChildObjectId      = inRetailId        OR COALESCE (inRetailId, 0)        = 0)
      AND (ObjectLink_Partner_Route.ChildObjectId         = inRouteId         OR COALESCE (inRouteId, 0)         = 0)
      AND (ObjectLink_Partner_PersonalTrade.ChildObjectId = inPersonalTradeId OR COALESCE (inPersonalTradeId, 0) = 0)

 UNION ALL

     SELECT
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name 
         , ObjectFloat_ObjectCode_Basis.ValueData ::Integer AS BasisCode

         , ObjectString_ShortName.ValueData   AS ShortName
         , ObjectString_GLNCode.ValueData     AS GLNCode

         , ObjectString_GLNCodeJuridical.ValueData AS GLNCodeJuridical_property
         , ObjectString_GLNCodeRetail.ValueData    AS GLNCodeRetail_property
         , ObjectString_GLNCodeCorporate.ValueData AS GLNCodeCorporate_property

         , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeJuridical_partner := ObjectString_GLNCodeJuridical.ValueData
                                  , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                   ) AS GLNCodeJuridical

         , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_GLNCode.ValueData
                               , inGLNCodeRetail_partner := ObjectString_GLNCodeRetail.ValueData
                               , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                               , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                ) AS GLNCodeRetail

         , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_GLNCode.ValueData
                                  , inGLNCodeCorporate_partner := ObjectString_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                  , inGLNCodeCorporate_main    := vbGLNCodeCorporate
                                   ) AS GLNCodeCorporate

         , ObjectString_Address.ValueData     AS Address
         , ObjectString_HouseNumber.ValueData AS HouseNumber
         , ObjectString_CaseNumber.ValueData  AS CaseNumber
         , ObjectString_RoomNumber.ValueData  AS RoomNumber

         , Object_Street.Id                   AS StreetId
         , Object_Street.ValueData            AS StreetName

         , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
         , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

         , COALESCE (Partner_GPSN.ValueData,0)         ::Tfloat  AS GPSN
         , COALESCE (Partner_GPSE.ValueData,0)         ::Tfloat  AS GPSE
         , COALESCE (ObjectFloat_Category.ValueData,0) ::TFloat  AS Category

         , COALESCE (ObjectFloat_TaxSale_Personal.ValueData,0)      ::TFloat  AS TaxSale_Personal
         , COALESCE (ObjectFloat_TaxSale_PersonalTrade.ValueData,0) ::TFloat  AS TaxSale_PersonalTrade
         , COALESCE (ObjectFloat_TaxSale_MemberSaler1.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler1
         , COALESCE (ObjectFloat_TaxSale_MemberSaler2.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler2

         , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS EdiOrdspr
         , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS EdiInvoice
         , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS EdiDesadv


         , Object_Juridical.Id             AS JuridicalId
         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName
         , Object_JuridicalGroup.ValueData AS JuridicalGroupName

         , Object_Retail.Id                AS RetailId
         , Object_Retail.ValueData         AS RetailName

         , Object_Route.Id                 AS RouteId
         , Object_Route.ObjectCode         AS RouteCode
         , Object_Route.ValueData          AS RouteName
         , Object_Route_30201.Id           AS RouteId_30201
         , Object_Route_30201.ObjectCode   AS RouteCode_30201
         , Object_Route_30201.ValueData    AS RouteName_30201

         , Object_RouteSorting.Id           AS RouteSortingId
         , Object_RouteSorting.ObjectCode   AS RouteSortingCode
         , Object_RouteSorting.ValueData    AS RouteSortingName

         , Object_MemberTake.Id             AS MemberTakeId
         , Object_MemberTake.ObjectCode     AS MemberTakeCode
         , Object_MemberTake.ValueData      AS MemberTakeName

         , Object_MemberSaler1.Id             AS MemberSaler1Id
         , Object_MemberSaler1.ObjectCode     AS MemberSaler1Code
         , Object_MemberSaler1.ValueData      AS MemberSaler1Name
         , Object_MemberSaler2.Id             AS MemberSaler2Id
         , Object_MemberSaler2.ObjectCode     AS MemberSaler2Code
         , Object_MemberSaler2.ValueData      AS MemberSaler2Name

         , Object_Personal.PersonalId        AS PersonalId
         , Object_Personal.PersonalCode      AS PersonalCode
         , Object_Personal.PersonalName      AS PersonalName
         , Object_Personal.BranchName        AS BranchName_Personal
         , Object_Personal.UnitName          AS UnitName_Personal

         , Object_PersonalTrade.PersonalId   AS PersonalTradeId
         , Object_PersonalTrade.PersonalCode AS PersonalTradeCode
         , Object_PersonalTrade.PersonalName AS PersonalTradeName
         , Object_PersonalTrade.BranchName   AS BranchName_PersonalTrade
         , Object_PersonalTrade.UnitName     AS UnitName_PersonalTrade

         , Object_PersonalMerch.Id           AS PersonalMerchId
         , Object_PersonalMerch.ObjectCode   AS PersonalMerchCode
         , Object_PersonalMerch.ValueData    AS PersonalMerchName

         , Object_PersonalSigning.Id           AS PersonalSigningId
         , Object_PersonalSigning.ObjectCode   AS PersonalSigningCode
         , Object_PersonalSigning.ValueData    AS PersonalSigningName

         , Object_Area.Id                  AS AreaId
         , Object_Area.ValueData           AS AreaName

         , Object_PartnerTag.Id            AS PartnerTagId
         , Object_PartnerTag.ValueData     AS PartnerTagName

         , Object_GoodsProperty.Id         AS GoodsPropertyId
         , Object_GoodsProperty.ValueData  AS GoodsPropertyName

         , ObjectHistory_JuridicalDetails_View.OKPO

         , Object_PriceList.Id         AS PriceListId
         , Object_PriceList.ValueData  AS PriceListName

         , Object_PriceListPromo.Id         AS PriceListPromoId
         , Object_PriceListPromo.ValueData  AS PriceListPromoName

         , Object_PriceList_Prior.Id         AS PriceListId_Prior
         , Object_PriceList_Prior.ValueData  AS PriceListName_Prior

         , Object_PriceList_30103.Id         AS PriceListId_30103
         , Object_PriceList_30103.ValueData  AS PriceListName_30103

         , Object_PriceList_30201.Id         AS PriceListId_30201
         , Object_PriceList_30201.ValueData  AS PriceListName_30201

         , ObjectDate_StartPromo.ValueData AS StartPromo
         , ObjectDate_EndPromo.ValueData   AS EndPromo

         , Object_Unit.Id         AS UnitId
         , Object_Unit.ObjectCode AS UnitCode
         , Object_Unit.ValueData  AS UnitName

         , Object_UnitMobile.Id        AS UnitMobileId
         , Object_UnitMobile.ValueData AS UnitMobileName

         , Object_Partner.isErased   AS isErased

         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Value1
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Value2
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Value3
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Value4
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Value5
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Value6
         , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Value7

         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Delivery1
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Delivery2
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Delivery3
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Delivery4
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Delivery5
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Delivery6
         , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Delivery7

         , ObjectString_GUID.ValueData AS GUID
         , CASE WHEN ObjectString_GUID.ValueData <> '' THEN TRUE ELSE FALSE END :: Boolean AS isGUID
         , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
         , COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE) :: Boolean AS isGoodsBox
         , ObjectString_Movement.ValueData   ::TVarChar AS MovementComment
         , ObjectString_BranchCode.ValueData ::TVarChar AS BranchCode
         , ObjectString_BranchJur.ValueData  ::TVarChar AS BranchJur
         , ObjectString_Terminal.ValueData   ::TVarChar AS Terminal
     FROM tmpIsErased
         INNER JOIN Object AS Object_Partner
                           ON Object_Partner.isErased = tmpIsErased.isErased
                          AND Object_Partner.DescId = zc_Object_Partner()

         LEFT JOIN ObjectString AS ObjectString_GUID
                                ON ObjectString_GUID.ObjectId = Object_Partner.Id
                               AND ObjectString_GUID.DescId = zc_ObjectString_Juridical_GUID()
         LEFT JOIN ObjectString AS ObjectString_GLNCode
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

         LEFT JOIN ObjectString AS ObjectString_GLNCodeJuridical
                                ON ObjectString_GLNCodeJuridical.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeRetail
                                ON ObjectString_GLNCodeRetail.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_GLNCodeCorporate
                                ON ObjectString_GLNCodeCorporate.ObjectId = Object_Partner.Id
                               AND ObjectString_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

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

         LEFT JOIN ObjectString AS ObjectString_Schedule
                                ON ObjectString_Schedule.ObjectId = Object_Partner.Id
                               AND ObjectString_Schedule.DescId = zc_ObjectString_Partner_Schedule()
         LEFT JOIN ObjectString AS ObjectString_Delivery
                                ON ObjectString_Delivery.ObjectId = Object_Partner.Id
                               AND ObjectString_Delivery.DescId = zc_ObjectString_Partner_Delivery()

         LEFT JOIN ObjectString AS ObjectString_Movement
                                ON ObjectString_Movement.ObjectId = Object_Partner.Id
                               AND ObjectString_Movement.DescId = zc_ObjectString_Partner_Movement()

         LEFT JOIN ObjectString AS ObjectString_BranchCode
                                ON ObjectString_BranchCode.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchCode.DescId = zc_ObjectString_Partner_BranchCode()
         LEFT JOIN ObjectString AS ObjectString_BranchJur
                                ON ObjectString_BranchJur.ObjectId = Object_Partner.Id
                               AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()
         LEFT JOIN ObjectString AS ObjectString_Terminal
                                ON ObjectString_Terminal.ObjectId = Object_Partner.Id
                               AND ObjectString_Terminal.DescId = zc_ObjectString_Partner_Terminal()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectFloat AS Partner_GPSN
                               ON Partner_GPSN.ObjectId = Object_Partner.Id
                              AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()
         LEFT JOIN ObjectFloat AS Partner_GPSE
                               ON Partner_GPSE.ObjectId = Object_Partner.Id
                              AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()

         LEFT JOIN ObjectFloat AS ObjectFloat_Category
                               ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                              AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

         LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                               ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Partner.Id
                              AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()

         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_Personal
                               ON ObjectFloat_TaxSale_Personal.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_Personal.DescId = zc_ObjectFloat_Partner_TaxSale_Personal()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_PersonalTrade
                               ON ObjectFloat_TaxSale_PersonalTrade.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_PersonalTrade.DescId = zc_ObjectFloat_Partner_TaxSale_PersonalTrade()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler1
                               ON ObjectFloat_TaxSale_MemberSaler1.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler1.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler1()
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxSale_MemberSaler2
                               ON ObjectFloat_TaxSale_MemberSaler2.ObjectId = Object_Partner.Id
                              AND ObjectFloat_TaxSale_MemberSaler2.DescId = zc_ObjectFloat_Partner_TaxSale_MemberSaler2()


         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiOrdspr
                                 ON ObjectBoolean_EdiOrdspr.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiInvoice
                                 ON ObjectBoolean_EdiInvoice.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiDesadv
                                 ON ObjectBoolean_EdiDesadv.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

         LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                              ON ObjectDate_StartPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Partner_StartPromo()

         LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                              ON ObjectDate_EndPromo.ObjectId = Object_Partner.Id
                             AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Partner_EndPromo()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object AS Object_Street ON Object_Street.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
         LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                ON ObjectString_Juridical_GLNCode.ObjectId = Object_Juridical.Id
                               AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                               AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
         LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route_30201
                              ON ObjectLink_Partner_Route_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route_30201.DescId = zc_ObjectLink_Partner_Route30201()
         LEFT JOIN Object AS Object_Route_30201 ON Object_Route_30201.Id = ObjectLink_Partner_Route_30201.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler1
                              ON ObjectLink_Partner_MemberSaler1.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberSaler1.DescId = zc_ObjectLink_Partner_MemberSaler1()
         LEFT JOIN Object AS Object_MemberSaler1 ON Object_MemberSaler1.Id = ObjectLink_Partner_MemberSaler1.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberSaler2
                              ON ObjectLink_Partner_MemberSaler2.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberSaler2.DescId = zc_ObjectLink_Partner_MemberSaler2()
         LEFT JOIN Object AS Object_MemberSaler2 ON Object_MemberSaler2.Id = ObjectLink_Partner_MemberSaler2.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalMerch
                              ON ObjectLink_Partner_PersonalMerch.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalMerch.DescId = zc_ObjectLink_Partner_PersonalMerch()
         LEFT JOIN Object AS Object_PersonalMerch ON Object_PersonalMerch.Id = ObjectLink_Partner_PersonalMerch.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                              ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalSigning.DescId = zc_ObjectLink_Partner_PersonalSigning()
         LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Partner_PersonalSigning.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

         LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                              ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                              ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
         LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Partner_PriceListPromo.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_Prior
                              ON ObjectLink_Partner_PriceList_Prior.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_Prior.DescId = zc_ObjectLink_Partner_PriceListPrior()
         LEFT JOIN Object AS Object_PriceList_Prior ON Object_PriceList_Prior.Id = ObjectLink_Partner_PriceList_Prior.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30103
                              ON ObjectLink_Partner_PriceList_30103.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30103.DescId = zc_ObjectLink_Partner_PriceList30103()
         LEFT JOIN Object AS Object_PriceList_30103 ON Object_PriceList_30103.Id = ObjectLink_Partner_PriceList_30103.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30201
                              ON ObjectLink_Partner_PriceList_30201.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PriceList_30201.DescId = zc_ObjectLink_Partner_PriceList30201()
         LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Partner_PriceList_30201.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                              ON ObjectLink_Partner_Unit.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Partner_Unit.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                              ON ObjectLink_Partner_GoodsProperty.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
         LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Partner_GoodsProperty.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_UnitMobile
                              ON ObjectLink_Partner_UnitMobile.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_UnitMobile.DescId = zc_ObjectLink_Partner_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Partner_UnitMobile.ChildObjectId

         LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                 ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                 ON ObjectBoolean_Guide_Irna.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_GoodsBox
                                 ON ObjectBoolean_Partner_GoodsBox.ObjectId = Object_Partner.Id
                                AND ObjectBoolean_Partner_GoodsBox.DescId = zc_ObjectBoolean_Partner_GoodsBox()

   WHERE inJuridicalId = 0
      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-”слуги
                                                                )
           -- филиал
           OR Object_PersonalTrade.BranchId = vbBranchId_Constraint
           -- если филиал Ћьвов + еще  филиал  иев
           -- OR (vbBranchId_Constraint = 3080683 AND Object_PersonalTrade.BranchId = 8379)
           -- если филиал  иев + еще  филиал Ћьвов
           OR (vbBranchId_Constraint = 8379 AND Object_PersonalTrade.BranchId = 3080683)
           --
           OR ObjectLink_Partner_PersonalTrade.ChildObjectId IS NULL
           OR ObjectBoolean_isBranchAll.ValueData = TRUE
           OR vbIsConstraint = FALSE
           --OR ObjectHistory_JuridicalDetails_View.OKPO = '2840114093'
          )
      AND (ObjectLink_Juridical_Retail.ChildObjectId      = inRetailId        OR COALESCE (inRetailId, 0)        = 0)
      AND (ObjectLink_Partner_Route.ChildObjectId         = inRouteId         OR COALESCE (inRouteId, 0)         = 0)
      AND (ObjectLink_Partner_PersonalTrade.ChildObjectId = inPersonalTradeId OR COALESCE (inPersonalTradeId, 0) = 0)

   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Partner (integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».
 07.11.24         * PersonalSigning
 04.07.24         * Terminal
 24.10.23         *
 04.05.22         *
 29.04.21         * Category
 19.06.17         * add PersonalMerch
 05.05.17         * add вх.парам-ры
 25.12.15         * add GoodsProperty
 06.10.15         * add inShowAll
 06.02.15         * add redmine
 20.11.14         * add redmine
 10.11.14         * add redmine
 19.10.14                                        * add GLNCode_Juridical
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 16.08.14                                        * add JuridicalGroupName
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street

 11.04.14                        * add inJuridicalId
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add zc_ObjectString_Partner_Address
 12.10.13                                        * !!!первого запроса быть не должно!!!
 30.09.13                                        * add Object_Personal_View
 29.07.13         *  + PersonalTakeId, PrepareDayCount, DocumentDayCount
 03.07.13         *  + Route,RouteSorting
*/

/*
-- 1
select Object_Partner.ObjectCode      FROM Object AS Object_Partner     WHERE Object_Partner.DescId = zc_Object_Partner()  and Object_Partner.ObjectCode <> 0 group by Object_Partner.ObjectCode having count (*) > 1
-- 2
update Object set ObjectCode = 15000 + LineNum
from
(select CAST (row_number() OVER (ORDER BY a1, a2, a3, a4, a5 ) AS INTEGER) AS  LineNum
      , tmp.*
      from
(select coalesce (Object_Retail.ValueData, '€€€€€€€') as a1
        , coalesce (Object_JuridicalGroup.ValueData, '€€€€€€€') as a2
        , coalesce (Object_Juridical.ValueData, '€€€€€€€')as a3
        , coalesce (Object_Route.ValueData, '€€€€€€€')as a4
        , coalesce (Object_Partner.ValueData, '€€€€€€€')as a5
        , Object_Partner.*
     FROM Object AS Object_Partner
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId


         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
         LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId

    WHERE Object_Partner.DescId = zc_Object_Partner() AND Object_Partner.iserased = FALSE
and coalesce (Object_Partner.ObjectCode, 0) = 0
order by  coalesce (Object_Retail.ValueData, '€€€€€€€')
        , coalesce (Object_JuridicalGroup.ValueData, '€€€€€€€')
        , coalesce (Object_Juridical.ValueData, '€€€€€€€')
        , coalesce (Object_Route.ValueData, '€€€€€€€')
        , coalesce (Object_Partner.ValueData, '€€€€€€€')
) as tmp
) as aaa
where aaa.Id = Object.Id
*/
-- тест
-- SELECT * FROM gpSelect_Object_Partner(inJuridicalId := 446549 , inRetailId := 0 , inPersonalTradeId := 0 , inRouteId := 0 , inShowAll := 'False' ,  inSession := '5');
