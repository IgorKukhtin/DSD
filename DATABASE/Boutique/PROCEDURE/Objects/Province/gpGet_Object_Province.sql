-- Function: gpGet_Object_Province (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Province (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Province(
    IN inId          Integer,       -- ключ объекта <Район>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , RegionId Integer, RegionCode Integer, RegionName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Province());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_Province.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS RegionId
           , CAST (0 as Integer)    AS RegionCode
           , CAST ('' as TVarChar)  AS RegionName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_Province
       WHERE Object_Province.DescId = zc_Object_Province();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Province.Id          AS Id
           , Object_Province.ObjectCode  AS Code
           , Object_Province.ValueData   AS Name
           
           , Object_Region.Id          AS RegionId
           , Object_Region.ObjectCode  AS RegionCode
           , Object_Region.ValueData   AS RegionName
           
           , Object_Province.isErased AS isErased
           
       FROM Object AS Object_Province
            LEFT JOIN ObjectLink AS ObjectLink_Province_Region
                                 ON ObjectLink_Province_Region.ObjectId = Object_Province.Id
                                AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Province_Region.ChildObjectId

       WHERE Object_Province.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Province (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Province (2, '')
