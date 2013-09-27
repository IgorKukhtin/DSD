-- Function: gpGet_Object_Route (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_Route (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Route(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , RouteKindId Integer, RouteKindCode Integer, RouteKindName TVarChar
             , FreightId Integer, FreightCode Integer, FreightName TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Route());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Route()) AS Code
           , CAST ('' as TVarChar)  AS Name
                      
           , CAST (0 as Integer)   AS UnitId 
           , CAST (0 as Integer)   AS UnitCode
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS RouteKindId 
           , CAST (0 as Integer)   AS RouteKindCode
           , CAST ('' as TVarChar) AS RouteKindName

           , CAST (0 as Integer)   AS FreightId 
           , CAST (0 as Integer)   AS FreightCode
           , CAST ('' as TVarChar) AS FreightName
            
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_Route.Id         AS Id
           , Object_Route.ObjectCode AS Code
           , Object_Route.ValueData  AS NAME
                      
           , Object_Unit.Id         AS UnitId 
           , Object_Unit.ObjectCode AS UnitCode
           , Object_Unit.ValueData  AS UnitName

           , Object_RouteKind.Id         AS RouteKindId 
           , Object_RouteKind.ObjectCode AS RouteKindCode
           , Object_RouteKind.ValueData AS RouteKindName

           , Object_Freight.Id         AS FreightId 
           , Object_Freight.ObjectCode AS FreightCode
           , Object_Freight.ValueData  AS FreightName
           
           , Object_Route.isErased   AS isErased
           
       FROM Object AS Object_Route
            LEFT JOIN ObjectLink AS ObjectLink_Route_Unit ON ObjectLink_Route_Unit.ObjectId = Object_Route.Id
                                                         AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Route_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteKind ON ObjectLink_Route_RouteKind.ObjectId = Object_Route.Id
                                                              AND ObjectLink_Route_RouteKind.DescId = zc_ObjectLink_Route_RouteKind()
            LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = ObjectLink_Route_RouteKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_Freight ON ObjectLink_Route_Freight.ObjectId = Object_Route.Id
                                                            AND ObjectLink_Route_Freight.DescId = zc_ObjectLink_Route_Freight()
            LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = ObjectLink_Route_Freight.ChildObjectId
            
       WHERE Object_Route.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Route (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          *  add Unit, RouteKind, Freight            
 03.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_Route (2, '')
