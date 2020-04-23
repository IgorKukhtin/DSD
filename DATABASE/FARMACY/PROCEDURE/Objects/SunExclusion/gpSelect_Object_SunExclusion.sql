-- Function: gpSelect_Object_SunExclusion()

DROP FUNCTION IF EXISTS gpSelect_Object_SunExclusion(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SunExclusion(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , FromId Integer, FromCode Integer, FromName TVarChar, ItemName_from TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar, ItemName_to TVarChar
             , isV1  Boolean
             , isV2  Boolean
             , isV3  Boolean
             , isV4  Boolean
             , isMSC_in  Boolean
             , isErased   Boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_SunExclusion());

     RETURN QUERY  
       SELECT 
             Object_SunExclusion.Id          AS Id
           , Object_SunExclusion.ObjectCode  AS Code
           , Object_SunExclusion.ValueData   AS Name
           
           , Object_From.Id                  AS FromId
           , Object_From.ObjectCode          AS FromCode
           , Object_From.ValueData           AS FromName
           , ObjectDesc_From.ItemName        AS ItemName_from

           , Object_To.Id                    AS ToId
           , Object_To.ObjectCode            AS ToCode
           , Object_To.ValueData             AS ToName
           , ObjectDesc_To.ItemName          AS ItemName_to

           , COALESCE (ObjectBoolean_SunExclusion_V1.ValueData, FALSE)     :: Boolean AS isV1
           , COALESCE (ObjectBoolean_SunExclusion_V2.ValueData, FALSE)     :: Boolean AS isV2
           , COALESCE (ObjectBoolean_SunExclusion_V3.ValueData, FALSE)     :: Boolean AS isV3
           , COALESCE (ObjectBoolean_SunExclusion_V4.ValueData, FALSE)     :: Boolean AS isV4
           , COALESCE (ObjectBoolean_SunExclusion_MSC_in.ValueData, FALSE) :: Boolean AS isMSC_in
 
           , Object_SunExclusion.isErased    AS isErased
           
       FROM Object AS Object_SunExclusion
   
           LEFT JOIN ObjectLink AS ObjectLink_SunExclusion_From 
                                ON ObjectLink_SunExclusion_From.ObjectId = Object_SunExclusion.Id 
                               AND ObjectLink_SunExclusion_From.DescId = zc_ObjectLink_SunExclusion_From()
           LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_SunExclusion_From.ChildObjectId
           LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId

           LEFT JOIN ObjectLink AS ObjectLink_SunExclusion_To 
                                ON ObjectLink_SunExclusion_To.ObjectId = Object_SunExclusion.Id 
                               AND ObjectLink_SunExclusion_To.DescId = zc_ObjectLink_SunExclusion_To()
           LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_SunExclusion_To.ChildObjectId
           LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V1
                                   ON ObjectBoolean_SunExclusion_V1.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V1.DescId = zc_ObjectBoolean_SunExclusion_V1()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V2
                                   ON ObjectBoolean_SunExclusion_V2.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V2.DescId = zc_ObjectBoolean_SunExclusion_V2()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V3
                                   ON ObjectBoolean_SunExclusion_V3.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V3.DescId = zc_ObjectBoolean_SunExclusion_V3()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_V4
                                   ON ObjectBoolean_SunExclusion_V4.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_V4.DescId = zc_ObjectBoolean_SunExclusion_V4()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SunExclusion_MSC_in
                                   ON ObjectBoolean_SunExclusion_MSC_in.ObjectId = Object_SunExclusion.Id
                                  AND ObjectBoolean_SunExclusion_MSC_in.DescId = zc_ObjectBoolean_SunExclusion_MSC_in()

     WHERE Object_SunExclusion.DescId = zc_Object_SunExclusion();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.04.20         *
 06.04.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_SunExclusion('2')