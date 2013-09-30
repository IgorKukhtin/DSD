-- Function: gpSelect_Object_Route (TVarChar)

-- DROP FUNCTION gpSelect_Object_Route (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Route(
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

   RETURN QUERY 
   SELECT
         Object_Route.Id         AS Id 
       , Object_Route.ObjectCode AS Code
       , Object_Route.ValueData  AS Name
              
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
   
   WHERE Object_Route.DescId = zc_Object_Route();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Route (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          *  add Unit, RouteKind, Freight
 03.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Route('2')
