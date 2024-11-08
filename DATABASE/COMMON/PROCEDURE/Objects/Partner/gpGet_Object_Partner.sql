-- Function: gpGet_Object_Partner()

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,        -- Контрагенты 
    IN inMaskId      Integer,       -- 
    IN inJuridicalId Integer,        -- 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar,
               GLNCode TVarChar,
               GLNCodeJuridical TVarChar, GLNCodeRetail TVarChar, GLNCodeCorporate TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PrepareDayCount TFloat, DocumentDayCount TFloat,
               GPSN TFloat, GPSE TFloat,
               Category TFloat, 
               TaxSale_Personal TFloat, TaxSale_PersonalTrade TFloat, TaxSale_MemberSaler1 TFloat, TaxSale_MemberSaler2 TFloat,

               EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean,

               JuridicalId Integer, JuridicalName TVarChar, 
               RouteId Integer, RouteName TVarChar,
               RouteId_30201 Integer, RouteName_30201 TVarChar,
               RouteSortingId Integer, RouteSortingName TVarChar,
               MemberTakeId Integer, MemberTakeName TVarChar,
               MemberSaler1Id Integer, MemberSaler1Name TVarChar,
               MemberSaler2Id Integer, MemberSaler2Name TVarChar,
               
               PersonalId Integer, PersonalName TVarChar,
               PersonalTradeId Integer, PersonalTradeName TVarChar,
               PersonalMerchId Integer, PersonalMerchName TVarChar,
               PersonalSigningId Integer, PersonalSigningName TVarChar,
               AreaId Integer, AreaName TVarChar,
               PartnerTagId Integer, PartnerTagName TVarChar,

               GoodsPropertyId Integer, GoodsPropertyName TVarChar,
              
               PriceListId Integer, PriceListName TVarChar,
               PriceListId_30201 Integer, PriceListName_30201 TVarChar,
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,
               
               PostalCode TVarChar, ProvinceCityName TVarChar, 
               CityName TVarChar, CityKindName TVarChar, CityKindId Integer,
               RegionName TVarChar, ProvinceName TVarChar,
               StreetKindName TVarChar, StreetKindId Integer,
               Value1 Boolean, Value2 Boolean, Value3 Boolean, Value4 Boolean, 
               Value5 Boolean, Value6 Boolean, Value7 Boolean,      
               Delivery1 Boolean, Delivery2 Boolean, Delivery3 Boolean, Delivery4 Boolean, 
               Delivery5 Boolean, Delivery6 Boolean, Delivery7 Boolean
             , UnitMobileId Integer, UnitMobileName TVarChar
             , MovementComment TVarChar
             , BranchCode TVarChar
             , BranchJur TVarChar
             , Terminal TVarChar
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

   IF COALESCE (inId, 0) = 0 AND COALESCE (inMaskId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           -- , 0 AS Code -- lfGet_ObjectCode (0, zc_Object_Partner()) AS Code
           , lfGet_ObjectCode (0, zc_Object_Partner()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST ('' as TVarChar)  AS ShortName
           , CAST ('' as TVarChar)  AS GLNCode
               
           , CAST ('' as TVarChar)  AS GLNCodeJuridical      
           , CAST ('' as TVarChar)  AS GLNCodeRetail           
           , CAST ('' as TVarChar)  AS GLNCodeCorporate           

           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS HouseNumber
           , CAST ('' as TVarChar)  AS CaseNumber
           , CAST ('' as TVarChar)  AS RoomNumber           

           , CAST (0 as Integer)    AS StreetId
           , CAST ('' as TVarChar)  AS StreetName
          
           , CAST (0 as TFloat)  AS PrepareDayCount
           , CAST (0 as TFloat)  AS DocumentDayCount
           
           , CAST (0 as TFloat)  AS GPSN
           , CAST (0 as TFloat)  AS GPSE
           , CAST (0 AS TFloat)  AS Category

           , CAST (0 AS TFloat)  AS TaxSale_Personal
           , CAST (0 AS TFloat)  AS TaxSale_PersonalTrade
           , CAST (0 AS TFloat)  AS TaxSale_MemberSaler1
           , CAST (0 AS TFloat)  AS TaxSale_MemberSaler2

           , CAST (False AS Boolean) AS EdiOrdspr
           , CAST (False AS Boolean) AS EdiInvoice
           , CAST (False AS Boolean) AS EdiDesadv
           
           , inJuridicalId    AS JuridicalId
           , lfGet_Object_ValueData (inJuridicalId)  AS JuridicalName
       
           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteId_30201
           , CAST ('' as TVarChar)  AS RouteName_30201

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName
           
           , CAST (0 as Integer)    AS MemberTakeId
           , CAST ('' as TVarChar)  AS MemberTakeName
           
           , CAST (0 as Integer)    AS MemberSaler1Id
           , CAST ('' as TVarChar)  AS MemberSaler1Name
           , CAST (0 as Integer)    AS MemberSaler2Id
           , CAST ('' as TVarChar)  AS MemberSaler2Name

           , CAST (0 as Integer)    AS PersonalId
           , CAST ('' as TVarChar)  AS PersonalName
         
           , CAST (0 as Integer)    AS PersonalTradeId
           , CAST ('' as TVarChar)  AS PersonalTradeName

           , CAST (0 as Integer)    AS PersonalMerchId
           , CAST ('' as TVarChar)  AS PersonalMerchName

           , CAST (0 as Integer)    AS PersonalSigningId
           , CAST ('' as TVarChar)  AS PersonalSigningName
         
           , CAST (0 as Integer)    AS AreaId
           , CAST ('' as TVarChar)  AS AreaName
        
           , CAST (0 as Integer)    AS PartnerTagId
           , CAST ('' as TVarChar)  AS PartnerTagName  

           , CAST (0 as Integer)    AS GoodsPropertyId 
           , CAST ('' as TVarChar)  AS GoodsPropertyName

           , CAST (0 as Integer)    AS PriceListId 
           , CAST ('' as TVarChar)  AS PriceListName 

           , CAST (0 as Integer)    AS PriceListId_30201
           , CAST ('' as TVarChar)  AS PriceListName_30201

           , CAST (0 as Integer)    AS PriceListPromoId 
           , CAST ('' as TVarChar)  AS PriceListPromoName 
       
           , CURRENT_DATE :: TDateTime AS StartPromo
           , CURRENT_DATE :: TDateTime AS EndPromo           
           
           , CAST ('' as TVarChar)       AS PostalCode            
           , CAST ('' as TVarChar)       AS ProvinceCityName
           , CAST ('' as TVarChar)       AS CityName 
           , CAST ('' as TVarChar)       AS CityKindName
           , CAST (0 as Integer)         AS CityKindId
           , CAST ('' as TVarChar)       AS RegionName
           , CAST ('' as TVarChar)       AS ProvinceName
           , CAST ('' as TVarChar)       AS StreetKindName
           , CAST (0 as Integer)         AS StreetKindId
           
           , False  AS Value1
           , False  AS Value2
           , False  AS Value3
           , False  AS Value4
           , False  AS Value5
           , False  AS Value6
           , False  AS Value7        

           , False  AS Delivery1
           , False  AS Delivery2
           , False  AS Delivery3
           , False  AS Delivery4
           , False  AS Delivery5
           , False  AS Delivery6
           , False  AS Delivery7 

           , CAST (0 as Integer)    AS UnitMobileId
           , CAST ('' as TVarChar)  AS UnitMobileName
           , CAST ('' as TVarChar)  AS MovementComment 
           
           , CAST ('' as TVarChar)  AS BranchCode
           , CAST ('' as TVarChar)  AS BranchJur 
           , CAST ('' as TVarChar)  AS Terminal

           ;
   ELSE
       RETURN QUERY 
       SELECT 
             CASE WHEN inMaskId <> 0 THEN 0 ELSE Object_Partner.Id END :: Integer AS Id
           , CASE WHEN inMaskId <> 0 THEN lfGet_ObjectCode (0, zc_Object_Partner()) ELSE Object_Partner.ObjectCode END :: Integer AS Code
           , CASE WHEN inMaskId <> 0 THEN '' ELSE Object_Partner.ValueData END :: TVarChar AS Name
       
           , ObjectString_ShortName.ValueData AS ShortName
           , CASE WHEN inMaskId <> 0 THEN '' ELSE Partner_GLNCode.ValueData END :: TVarChar AS GLNCode
           
           , CASE WHEN inMaskId <> 0 THEN '' ELSE Partner_GLNCodeJuridical.ValueData END :: TVarChar AS GLNCodeJuridical
           , CASE WHEN inMaskId <> 0 THEN '' ELSE Partner_GLNCodeRetail.ValueData    END :: TVarChar AS GLNCodeRetail
           , CASE WHEN inMaskId <> 0 THEN Partner_GLNCodeCorporate.ValueData ELSE Partner_GLNCodeCorporate.ValueData END :: TVarChar AS GLNCodeCorporate

           , ObjectString_Address.ValueData     AS Address
           , ObjectString_HouseNumber.ValueData AS HouseNumber
           , ObjectString_CaseNumber.ValueData  AS CaseNumber
           , ObjectString_RoomNumber.ValueData  AS RoomNumber          

           , Object_Street_View.Id              AS StreetId 
           , Object_Street_View.Name            AS StreetName 

           , Partner_PrepareDayCount.ValueData  AS PrepareDayCount
           , Partner_DocumentDayCount.ValueData AS DocumentDayCount

           , COALESCE (Partner_GPSN.ValueData,0) ::Tfloat  AS GPSN
           , COALESCE (Partner_GPSE.ValueData,0) ::Tfloat  AS GPSE 

           , COALESCE (ObjectFloat_Category.ValueData,0) ::TFloat  AS Category

           , COALESCE (ObjectFloat_TaxSale_Personal.ValueData,0)      ::TFloat  AS TaxSale_Personal
           , COALESCE (ObjectFloat_TaxSale_PersonalTrade.ValueData,0) ::TFloat  AS TaxSale_PersonalTrade
           , COALESCE (ObjectFloat_TaxSale_MemberSaler1.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler1
           , COALESCE (ObjectFloat_TaxSale_MemberSaler2.ValueData,0)  ::TFloat  AS TaxSale_MemberSaler2
                              
           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS EdiOrdspr
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS EdiInvoice
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS EdiDesadv
           
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Route.Id           AS RouteId
           , Object_Route.ValueData    AS RouteName

           , Object_Route_30201.Id          AS RouteId_30201
           , Object_Route_30201.ValueData   AS RouteName_30201

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ValueData  AS RouteSortingName
           
           , Object_MemberTake.Id             AS MemberTakeId
           , Object_MemberTake.ValueData      AS MemberTakeName

           , Object_MemberSaler1.Id             AS MemberSaler1Id
           , Object_MemberSaler1.ValueData      AS MemberSaler1Name
           , Object_MemberSaler2.Id             AS MemberSaler2Id
           , Object_MemberSaler2.ValueData      AS MemberSaler2Name
         
           , Object_Personal.PersonalId         AS PersonalId
           , Object_Personal.PersonalName       AS PersonalName
         
           , Object_PersonalTrade.PersonalId    AS PersonalTradeId
           , Object_PersonalTrade.PersonalName  AS PersonalTradeName

           , Object_PersonalMerch.Id            AS PersonalMerchId
           , Object_PersonalMerch.ValueData     AS PersonalMerchName

           , Object_PersonalSigning.Id          AS PersonalSigningId
           , Object_PersonalSigning.ValueData   AS PersonalSigningName
         
           , Object_Area.Id                  AS AreaId
           , Object_Area.ValueData           AS AreaName
        
           , Object_PartnerTag.Id            AS PartnerTagId
           , Object_PartnerTag.ValueData     AS PartnerTagName           

           , Object_GoodsProperty.Id         AS GoodsPropertyId
           , Object_GoodsProperty.ValueData  AS GoodsPropertyName
           
           , Object_PriceList.Id         AS PriceListId 
           , Object_PriceList.ValueData  AS PriceListName 

           , Object_PriceList_30201.Id         AS PriceListId_30201
           , Object_PriceList_30201.ValueData  AS PriceListName_30201

           , Object_PriceListPromo.Id         AS PriceListPromoId 
           , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
           , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
           , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo 
           
           , Object_Street_View.PostalCode        AS PostalCode            
           , Object_Street_View.ProvinceCityName  AS ProvinceCityName
           , Object_Street_View.CityName          AS CityName 
           , Object_CityKind.ValueData            AS CityKindName
           , Object_CityKind.Id                   AS CityKindId
           , Object_Region.ValueData              AS RegionName
           , Object_Province.ValueData            AS ProvinceName
           , Object_Street_View.StreetKindName    AS StreetKindName
           , Object_Street_View.StreetKindId      AS StreetKindId

           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Value1
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Value2
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Value3
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Value4
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Value5
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Value6
           , CASE WHEN COALESCE(ObjectString_Schedule.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Schedule.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Value7
           
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 1) AS Boolean) END  ::Boolean   AS Value1
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 2) AS Boolean) END  ::Boolean   AS Value2
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 3) AS Boolean) END  ::Boolean   AS Value3
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 4) AS Boolean) END  ::Boolean   AS Value4
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 5) AS Boolean) END  ::Boolean   AS Value5
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 6) AS Boolean) END  ::Boolean   AS Value6
           , CASE WHEN COALESCE(ObjectString_Delivery.ValueData,'') = '' THEN False ELSE CAST (zfCalc_Word_Split (inValue:= ObjectString_Delivery.ValueData, inSep:= ';', inIndex:= 7) AS Boolean) END  ::Boolean   AS Value7

           , Object_UnitMobile.Id        AS UnitMobileId
           , Object_UnitMobile.ValueData AS UnitMobileName 
           
           , ObjectString_Movement.ValueData   ::TVarChar AS MovementComment
           , ObjectString_BranchCode.ValueData ::TVarChar AS BranchCode
           , ObjectString_BranchJur.ValueData  ::TVarChar AS BranchJur
           , ObjectString_Terminal.ValueData   ::TVarChar AS Terminal
       FROM Object AS Object_Partner
           LEFT JOIN ObjectString AS Partner_GLNCode 
                                  ON Partner_GLNCode.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

           LEFT JOIN ObjectString AS Partner_GLNCodeJuridical 
                                  ON Partner_GLNCodeJuridical.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
           LEFT JOIN ObjectString AS Partner_GLNCodeRetail 
                                  ON Partner_GLNCodeRetail.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
           LEFT JOIN ObjectString AS Partner_GLNCodeCorporate 
                                  ON Partner_GLNCodeCorporate.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()                                                                  

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

           LEFT JOIN ObjectFloat AS Partner_PrepareDayCount 
                                 ON Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                                AND Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()                                 
        
           LEFT JOIN ObjectFloat AS Partner_DocumentDayCount 
                                 ON Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                                AND Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()    

           LEFT JOIN ObjectFloat AS Partner_GPSN 
                                 ON Partner_GPSN.ObjectId = Object_Partner.Id
                                AND Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()  
           LEFT JOIN ObjectFloat AS Partner_GPSE
                                 ON Partner_GPSE.ObjectId = Object_Partner.Id
                                AND Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()  

           LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                 ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                                AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

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
           LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

           LEFT JOIN ObjectLink AS Partner_Juridical
                                ON Partner_Juridical.ObjectId = Object_Partner.Id 
                               AND Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Partner_Juridical.ChildObjectId
                                               AND COALESCE (inMaskId, 0) = 0
          
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

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList_30201
                                ON ObjectLink_Partner_PriceList_30201.ObjectId = Object_Partner.Id
                               AND ObjectLink_Partner_PriceList_30201.DescId = zc_ObjectLink_Partner_PriceList30201()
           LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Partner_PriceList_30201.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo 
                                ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
           LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Partner_PriceListPromo.ChildObjectId 

           LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                ON ObjectLink_Partner_GoodsProperty.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
           LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Partner_GoodsProperty.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_UnitMobile
                                ON ObjectLink_Partner_UnitMobile.ObjectId = Object_Partner.Id
                               AND ObjectLink_Partner_UnitMobile.DescId = zc_ObjectLink_Partner_UnitMobile()
           LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Partner_UnitMobile.ChildObjectId

         
           LEFT JOIN ObjectLink AS ObjectLink_City_CityKind                                          -- по улице
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
         
       WHERE Object_Partner.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN inMaskId ELSE inId END;
       
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Partner (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.11.24         * PersonalSigning
 04.07.24         * 
 24.10.23         *
 27.01.23         * MovementComment
 25.05.21         *
 19.06.17         * add PersonalMerch
 25.12.15         * add GoodsProperty
 10.02.15         * add remine  05.02.15
 20.11.14         * add remine 
 11.11.14         * add поля адреса
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street
 24.04.14                                        * add inJuridicalId
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add zc_ObjectString_Partner_Address
 30.09.13                                        * add Object_Personal_View
 03.09.13                        *
 29.07.13          *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                
 03.07.13          *  + Route, RouteSorting             
 13.06.13          *
 00.06.13          
*/

-- тест
-- SELECT * FROM gpGet_Object_Partner (0, 0, 1, '2')
--select * from gpGet_Object_Partner(inId := 212570 , inMaskId := 0 , inJuridicalId := 0 ,  inSession := '5');