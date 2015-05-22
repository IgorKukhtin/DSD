-- Function: gpSelect_Object_Partner()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
    IN inJuridicalId       Integer  , 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ShortName TVarChar, GLNCode TVarChar,
               GLNCodeJuridical_property TVarChar, GLNCodeRetail_property TVarChar, GLNCodeCorporate_property TVarChar,
               GLNCodeJuridical TVarChar, GLNCodeRetail TVarChar, GLNCodeCorporate TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PrepareDayCount TFloat, DocumentDayCount TFloat,
               EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean,

               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar, /*GLNCode_Juridical TVarChar,*/
               RetailId Integer, RetailName TVarChar,
               RouteId Integer, RouteCode Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar,

               MemberTakeId Integer, MemberTakeCode Integer, MemberTakeName TVarChar,
               PersonalId Integer, PersonalCode Integer, PersonalName TVarChar,
               PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar,
               AreaId Integer, AreaName TVarChar,
               PartnerTagId Integer, PartnerTagName TVarChar,
               
               OKPO TVarChar,
               PriceListId Integer, PriceListName TVarChar, 
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,

               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
   DECLARE vbGLNCodeCorporate TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- ������������ 
   vbGLNCodeCorporate:= (SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectString_Juridical_GLNCode());

   -- ������������ ������� �������
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbBranchId_Constraint, 0) > 0;


   -- ���������
   RETURN QUERY 
     SELECT 
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name

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

         , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS EdiOrdspr
         , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS EdiInvoice
         , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS EdiDesadv


         , Object_Juridical.Id             AS JuridicalId
         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName
         , Object_JuridicalGroup.ValueData AS JuridicalGroupName
         
         , Object_Retail.Id                AS RetailId
         , Object_Retail.ValueData         AS RetailName

         , Object_Route.Id           AS RouteId
         , Object_Route.ObjectCode   AS RouteCode
         , Object_Route.ValueData    AS RouteName

         , Object_RouteSorting.Id           AS RouteSortingId
         , Object_RouteSorting.ObjectCode   AS RouteSortingCode
         , Object_RouteSorting.ValueData    AS RouteSortingName
         
         , Object_MemberTake.Id             AS MemberTakeId
         , Object_MemberTake.ObjectCode     AS MemberTakeCode
         , Object_MemberTake.ValueData      AS MemberTakeName
         
         , Object_Personal.PersonalId        AS PersonalId
         , Object_Personal.PersonalCode      AS PersonalCode
         , Object_Personal.PersonalName      AS PersonalName
         
         , Object_PersonalTrade.PersonalId   AS PersonalTradeId
         , Object_PersonalTrade.PersonalCode AS PersonalTradeCode
         , Object_PersonalTrade.PersonalName AS PersonalTradeName
         
         , Object_Area.Id                  AS AreaId
         , Object_Area.ValueData           AS AreaName
        
         , Object_PartnerTag.Id            AS PartnerTagId
         , Object_PartnerTag.ValueData     AS PartnerTagName
                  
         , ObjectHistory_JuridicalDetails_View.OKPO

         , Object_PriceList.Id         AS PriceListId 
         , Object_PriceList.ValueData  AS PriceListName 

         , Object_PriceListPromo.Id         AS PriceListPromoId 
         , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
         , ObjectDate_StartPromo.ValueData AS StartPromo
         , ObjectDate_EndPromo.ValueData   AS EndPromo 

         , Object_Unit.Id         AS UnitId
         , Object_Unit.ObjectCode AS UnitCode
         , Object_Unit.ValueData  AS UnitName 

         , Object_Partner.isErased   AS isErased
         
     FROM Object AS Object_Partner
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

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

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
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

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

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                              ON ObjectLink_Partner_Unit.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Partner_Unit.ChildObjectId

    WHERE Object_Partner.DescId = zc_Object_Partner() AND (inJuridicalId = 0 OR inJuridicalId = ObjectLink_Partner_Juridical.ChildObjectId)
      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR Object_PersonalTrade.BranchId = vbBranchId_Constraint
           OR vbIsConstraint = FALSE)
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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
 12.10.13                                        * !!!������� ������� ���� �� ������!!!
 30.09.13                                        * add Object_Personal_View
 29.07.13         *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                      
 03.07.13         *  + Route,RouteSorting
*/

-- ����
-- SELECT * FROM gpSelect_Object_Partner (0, zfCalc_UserAdmin())
