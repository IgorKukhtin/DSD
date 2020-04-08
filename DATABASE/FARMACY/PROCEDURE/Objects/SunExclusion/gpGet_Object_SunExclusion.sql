-- Function: gpGet_Object_SunExclusion()

DROP FUNCTION IF EXISTS gpGet_Object_SunExclusion(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SunExclusion(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , isV1  Boolean
             , isV2  Boolean
             , isMSC_in  Boolean
             , isErased   Boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_SunExclusion());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SunExclusion()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS FromId
           , CAST (0 as Integer)    AS FromCode
           , CAST ('' as TVarChar)  AS FromName

           , CAST (0 as Integer)    AS FromId
           , CAST (0 as Integer)    AS FromCode
           , CAST ('' as TVarChar)  AS FromName

           , FALSE :: Boolean       AS isV1
           , FALSE :: Boolean       AS isV2
           , FALSE :: Boolean       AS isMSC_in
           , FALSE :: Boolean       AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_SunExclusion.Id          AS Id
           , Object_SunExclusion.ObjectCode  AS Code
           , Object_SunExclusion.ValueData   AS Name
           
           , Object_From.Id                  AS FromId
           , Object_From.ObjectCode          AS FromCode
           , Object_From.ValueData           AS FromName

           , Object_To.Id                    AS ToId
           , Object_To.ObjectCode            AS ToCode
           , Object_To.ValueData             AS ToName

           , COALESCE (ObjectBoolean_SunExclusion_V1.ValueData, FALSE)     :: Boolean AS isV1
           , COALESCE (ObjectBoolean_SunExclusion_V2.ValueData, FALSE)     :: Boolean AS isV2
           , COALESCE (ObjectBoolean_SunExclusion_MSC_in.ValueData, FALSE) :: Boolean AS isMSC_in

           , Object_SunExclusion.isErased    AS isErased
           
       FROM Object AS Object_SunExclusion
       
           LEFT JOIN ObjectLink AS ObjectLink_SunExclusion_From 
                                ON ObjectLink_SunExclusion_From.ObjectId = Object_SunExclusion.Id 
                               AND ObjectLink_SunExclusion_From.DescId = zc_ObjectLink_SunExclusion_From()
           LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_SunExclusion_From.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_SunExclusion_To 
                                ON ObjectLink_SunExclusion_To.ObjectId = Object_SunExclusion.Id 
                               AND ObjectLink_SunExclusion_To.DescId = zc_ObjectLink_SunExclusion_To()
           LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_SunExclusion_To.ChildObjectId 

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V1
                                   ON ObjectBoolean_SunExclusion_V1.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V1.DescId = zc_ObjectBoolean_SunExclusion_V1()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V2
                                   ON ObjectBoolean_SunExclusion_V2.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V2.DescId = zc_ObjectBoolean_SunExclusion_V2()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_MSC_in
                                   ON ObjectBoolean_SunExclusion_MSC_in.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_MSC_in.DescId = zc_ObjectBoolean_SunExclusion_MSC_in()
       WHERE Object_SunExclusion.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_SunExclusion(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.04.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_SunExclusion (2, '')
