-- Function: gpGet_Object_Partner()

--DROP FUNCTION gpGet_Object_Partner(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,        -- Контрагенты 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GLNCode TVarChar, PrepareDayCount TFloat, DocumentDayCount TFloat,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, 
               RouteId Integer, RouteCode Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar,
               PersonalTakeId Integer, PersonalTakeCode Integer, PersonalTakeName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS GLNCode
           
           , CAST ('' as TFloat)  AS PrepareDayCount
           , CAST ('' as TFloat)  AS DocumentDayCount
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName
       
           , CAST (0 as Integer)    AS RouteId
           , CAST (0 as Integer)    AS RouteCode
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST (0 as Integer)    AS RouteSortingCode
           , CAST ('' as TVarChar)  AS RouteSortingName
           
           , CAST (0 as Integer)    AS PersonalTakeId
           , CAST (0 as Integer)    AS PersonalTakeCode
           , CAST ('' as TVarChar)  AS PersonalTakeName
                      
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_Partner();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Partner.Id          AS Id
           , Object_Partner.ObjectCode  AS Code
           , Object_Partner.ValueData   AS NAME
           
           , Partner_GLNCode.ValueData  AS GLNCode
           , Partner_PrepareDayCount.ValueData  AS PrepareDayCount
           , Partner_DocumentDayCount.ValueData AS DocumentDayCount
           
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Route.Id           AS RouteId
           , Object_Route.ObjectCode   AS RouteCode
           , Object_Route.ValueData    AS RouteName

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ObjectCode AS RouteSortingCode
           , Object_RouteSorting.ValueData  AS RouteSortingName
           
           , Object_PersonalTake.Id         AS PersonalTakeId
           , Object_PersonalTake.ObjectCode AS PersonalTakeCode
           , Object_PersonalTake.ValueData  AS PersonalTakeName

           , Object_Partner.isErased   AS isErased
           
       FROM OBJECT AS Object_Partner
           LEFT JOIN ObjectString AS Partner_GLNCode 
                                  ON Partner_GLNCode.ObjectId = Object_Partner.Id
                                 AND Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                                 
           LEFT JOIN ObjectFloat AS Partner_PrepareDayCount 
                                 ON Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                                AND Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()                                 
        
           LEFT JOIN ObjectFloat AS Partner_DocumentDayCount 
                                 ON Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                                AND Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()    
                                 
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
           
           LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTake
                                ON ObjectLink_Partner_PersonalTake.ObjectId = Object_Partner.Id 
                               AND ObjectLink_Partner_PersonalTake.DescId = zc_ObjectLink_Partner_PersonalTake()
           LEFT JOIN Object AS Object_PersonalTake ON Object_PersonalTake.Id = ObjectLink_Partner_PersonalTake.ChildObjectId
           
         
       WHERE Object_Partner.Id = inId;
       
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Partner(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.13          *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                
 03.07.13          *  + Route, RouteSorting             
 13.06.13          *
 00.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Partner('2')