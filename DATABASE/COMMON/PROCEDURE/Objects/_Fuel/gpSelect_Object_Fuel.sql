-- Function: gpSelect_Object_Fuel()

--DROP FUNCTION gpSelect_Object_Fuel();

CREATE OR REPLACE FUNCTION gpSelect_Object_Fuel(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Ratio TFloat
             , RateFuelKindId Integer, RateFuelKindCode Integer, RateFuelKindName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Fuel());

     RETURN QUERY 
       SELECT 
             Object_Fuel.Id          AS Id
           , Object_Fuel.ObjectCode  AS Code
           , Object_Fuel.ValueData   AS Name
           
           , ObjectFloat_Ratio.ValueData AS Ratio
           
           , Object_RateFuelKind.ObjectId    AS RateFuelKindId
           , Object_RateFuelKind.ObjectCode  AS RateFuelKindCode
           , Object_RateFuelKind.ValueData   AS RateFuelKindName
          
           , Object.isErased AS isErased
           
       FROM Object AS Object_Fuel
       
           LEFT JOIN ObjectFloat AS ObjectFloat_Ratio ON ObjectFloat_Ratio.ObjectId = Object_Fuel.Id 
                                                     AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
           LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = Object_Fuel.Id 
                                                               AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
           LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_Fuel_RateFuelKind.ChildObjectId              

     WHERE Object_Fuel.DescId = zc_Object_Fuel();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Fuel(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * add RateFuelKind             
 24.09.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Fuel('2')