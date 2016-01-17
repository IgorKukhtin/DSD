-- Function: gpGet_Object_RouteMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_RouteMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RouteMember(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer
             , RouteMemberName TBlob
             , isErased boolean
             ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_RouteMember()) AS Code
           , CAST ('' as TBlob)     AS RouteMemberName
           , CAST (NULL AS Boolean) AS isErased
           
           ;
   ELSE
       RETURN QUERY 

       SELECT Object.Id          AS Id 
            , Object.ObjectCode  AS Code
            , OB_RouteMember_Description.ValueData AS RouteMemberName
     
            , Object.isErased    AS isErased          
       FROM Object
           LEFT JOIN ObjectBlob AS OB_RouteMember_Description
                             ON OB_RouteMember_Description.ObjectId = Object.Id
                            AND OB_RouteMember_Description.DescId = zc_ObjectBlob_RouteMember_Description()
                                      
       WHERE Object.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RouteMember (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_RouteMember (1, zfCalc_UserAdmin())
