-- Function: gpSelect_Object_Partner()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
    IN inSession           TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GLNCode TVarChar,  PrepareDayCount TFloat, DocumentDayCount TFloat,
               JuridicalGroupId Integer, JuridicalGroupCode Integer, JuridicalGroupName TVarChar,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, 
               RouteId Integer, RouteCode Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar,
               PersonalTakeId Integer, PersonalTakeCode Integer, PersonalTakeName TVarChar,
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY 
     SELECT 
           Object_JuridicalGroup.Id          AS Id 
         , Object_JuridicalGroup.ObjectCode  AS Code
         , CAST('' AS TVarChar)              AS NAME
         
         , CAST('' AS TVarChar) AS GLNCode
         , CAST(0 as TFloat)   AS PrepareDayCount
         , CAST(0 as TFloat)   AS DocumentDayCount
         
         , ObjectLink_JuridicalGroup_Parent.ChildObjectId AS JuridicalGroupId
         , Object_JuridicalGroup.ObjectCode  AS JuridicalGroupCode
         , Object_JuridicalGroup.ValueData   AS JuridicalGroupName
         
         , CAST (0 as Integer)    AS JuridicalId 
         , CAST (0 as Integer)    AS JuridicalCode 
         , CAST('' AS TVarChar)   AS JuridicalName
         
         , CAST (0 as Integer)    AS RouteId 
         , CAST (0 as Integer)    AS RouteCode 
         , CAST('' AS TVarChar)   AS RouteName

         , CAST (0 as Integer)    AS RouteSortingId 
         , CAST (0 as Integer)    AS RouteSortingCode 
         , CAST('' AS TVarChar)   AS RouteSortingName
         
         , CAST (0 as Integer)    AS PersonalTakeId
         , CAST (0 as Integer)    AS PersonalTakeCode
         , CAST ('' as TVarChar)  AS PersonalTakeName
                  
         , Object_JuridicalGroup.isErased AS isErased
         
     FROM Object AS Object_JuridicalGroup
         LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
               AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
     WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
      AND 1=0 -- !!!первого запроса быть не должно!!!
   UNION
     SELECT 
           Object_Partner.Id             AS Id
         , Object_Partner.ObjectCode     AS Code
         , Object_Partner.ValueData      AS NAME
         
         , ObjectString_GLNCode.ValueData     AS GLNCode
         
         , Partner_PrepareDayCount.ValueData  AS PrepareDayCount
         , Partner_DocumentDayCount.ValueData AS DocumentDayCount
         
         , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
         , CAST (0 as Integer)           AS JuridicalGroupCode
         , CAST('' AS TVarChar)          AS JuridicalGroupName
         
         , Object_Juridical.Id           AS JuridicalId
         , Object_Juridical.ObjectCode   AS JuridicalCode
         , Object_Juridical.ValueData    AS JuridicalName

         , Object_Route.Id           AS RouteId
         , Object_Route.ObjectCode   AS RouteCode
         , Object_Route.ValueData    AS RouteName

         , Object_RouteSorting.Id           AS RouteSortingId
         , Object_RouteSorting.ObjectCode   AS RouteSortingCode
         , Object_RouteSorting.ValueData    AS RouteSortingName
         
         , View_PersonalTake.PersonalId   AS PersonalTakeId
         , View_PersonalTake.PersonalCode AS PersonalTakeCode
         , View_PersonalTake.PersonalName AS PersonalTakeName
                  
         , Object_Partner.isErased   AS isErased
         
     FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectFloat AS Partner_PrepareDayCount 
                               ON Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()  
        
         LEFT JOIN ObjectFloat AS Partner_DocumentDayCount 
                               ON Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()                                                              

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTake
                              ON ObjectLink_Partner_PersonalTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTake.DescId = zc_ObjectLink_Partner_PersonalTake()
         LEFT JOIN Object_Personal_View AS View_PersonalTake ON View_PersonalTake.PersonalId = ObjectLink_Partner_PersonalTake.ChildObjectId
         
    WHERE Object_Partner.DescId = zc_Object_Partner();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.13                                        * !!!первого запроса быть не должно!!!
 30.09.13                                        * add Object_Personal_View
 29.07.13         *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                      
 03.07.13         *  + Route,RouteSorting
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner ('2')