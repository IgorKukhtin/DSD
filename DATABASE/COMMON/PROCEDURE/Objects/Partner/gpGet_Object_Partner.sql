-- Function: gpGet_Object_Partner()

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,        -- Контрагенты 
    IN inJuridicalId Integer,        -- 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar,
               GLNCode TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PrepareDayCount TFloat, DocumentDayCount TFloat,
               JuridicalId Integer, JuridicalName TVarChar, 
               RouteId Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingName TVarChar,
               MemberTakeId Integer, MemberTakeName TVarChar,
               
               PersonalId Integer, PersonalName TVarChar,
               PersonalTradeId Integer, PersonalTradeName TVarChar,
               AreaId Integer, AreaName TVarChar,
               PartnerTagId Integer, PartnerTagName TVarChar,
              
               PriceListId Integer, PriceListName TVarChar, 
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,
               
               PostalCode TVarChar, ProvinceCityName TVarChar, 
               CityName TVarChar, CityKindName TVarChar, CityKindId Integer,
               RegionName TVarChar, ProvinceName TVarChar,
               StreetKindName TVarChar, StreetKindId Integer
               
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , 0 AS Code -- lfGet_ObjectCode (0, zc_Object_Partner()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST ('' as TVarChar)  AS ShortName
           , CAST ('' as TVarChar)  AS GLNCode          

           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS HouseNumber
           , CAST ('' as TVarChar)  AS CaseNumber
           , CAST ('' as TVarChar)  AS RoomNumber           

           , CAST (0 as Integer)    AS StreetId
           , CAST ('' as TVarChar)  AS StreetName
          
           , CAST (0 as TFloat)  AS PrepareDayCount
           , CAST (0 as TFloat)  AS DocumentDayCount
           
           , inJuridicalId    AS JuridicalId
           , lfGet_Object_ValueData (inJuridicalId)  AS JuridicalName
       
           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName
           
           , CAST (0 as Integer)    AS PersonalTakeId
           , CAST ('' as TVarChar)  AS MemberTakeName
           
           , CAST (0 as Integer)    AS PersonalId
           , CAST ('' as TVarChar)  AS PersonalName
         
           , CAST (0 as Integer)    AS PersonalTradeId
           , CAST ('' as TVarChar)  AS PersonalTradeName
         
           , CAST (0 as Integer)    AS AreaId
           , CAST ('' as TVarChar)  AS AreaName
        
           , CAST (0 as Integer)    AS PartnerTagId
           , CAST ('' as TVarChar)  AS PartnerTagName  

           , CAST (0 as Integer)    AS PriceListId 
           , CAST ('' as TVarChar)  AS PriceListName 

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
           
           
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Partner.Id               AS Id
           , Object_Partner.ObjectCode       AS Code
           , Object_Partner.ValueData        AS Name
       
           , ObjectString_ShortName.ValueData AS ShortName
           , Partner_GLNCode.ValueData        AS GLNCode

           , ObjectString_Address.ValueData     AS Address
           , ObjectString_HouseNumber.ValueData AS HouseNumber
           , ObjectString_CaseNumber.ValueData  AS CaseNumber
           , ObjectString_RoomNumber.ValueData  AS RoomNumber          

           , Object_Street_View.Id              AS StreetId 
           , Object_Street_View.Name            AS StreetName 

           , Partner_PrepareDayCount.ValueData  AS PrepareDayCount
           , Partner_DocumentDayCount.ValueData AS DocumentDayCount
           
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Route.Id           AS RouteId
           , Object_Route.ValueData    AS RouteName

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ValueData  AS RouteSortingName
           
           , Object_MemberTake.Id             AS MemberTakeId
           , Object_MemberTake.ValueData      AS MemberTakeName
         
           , Object_Personal.PersonalId         AS PersonalId
           , Object_Personal.PersonalName       AS PersonalName
         
           , Object_PersonalTrade.PersonalId    AS PersonalTradeId
           , Object_PersonalTrade.PersonalName  AS PersonalTradeName
         
           , Object_Area.Id                  AS AreaId
           , Object_Area.ValueData           AS AreaName
        
           , Object_PartnerTag.Id            AS PartnerTagId
           , Object_PartnerTag.ValueData     AS PartnerTagName           
           
           , Object_PriceList.Id         AS PriceListId 
           , Object_PriceList.ValueData  AS PriceListName 

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

       FROM Object AS Object_Partner
           LEFT JOIN ObjectString AS Partner_GLNCode 
                                  ON Partner_GLNCode.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
          
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
                               
           LEFT JOIN ObjectFloat AS Partner_PrepareDayCount 
                                 ON Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                                AND Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()                                 
        
           LEFT JOIN ObjectFloat AS Partner_DocumentDayCount 
                                 ON Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                                AND Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()    

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

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Partner_PriceList.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo 
                                ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
           LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Partner_PriceListPromo.ChildObjectId 
         
         
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
         
       WHERE Object_Partner.Id = inId;
       
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Partner (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
-- SELECT * FROM gpGet_Object_Partner (0, 1, '2')