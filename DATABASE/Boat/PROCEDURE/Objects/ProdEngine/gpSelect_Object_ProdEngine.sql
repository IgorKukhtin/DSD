-- Function: gpSelect_Object_ProdEngine()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdEngine(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdEngine(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Power TFloat, Volume TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdEngine());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
     SELECT 
           Object_ProdEngine.Id            AS Id 
         , Object_ProdEngine.ObjectCode    AS Code
         , Object_ProdEngine.ValueData     AS Name

         , ObjectFloat_Power.ValueData     AS Power
         , ObjectFloat_Volume.ValueData    AS Volume
         , ObjectString_Comment.ValueData  AS Comment

         , Object_Insert.ValueData         AS InsertName
         , ObjectDate_Insert.ValueData     AS InsertDate
         , Object_ProdEngine.isErased      AS isErased
         
     FROM Object AS Object_ProdEngine
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdEngine.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdEngine_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()

          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdEngine.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdEngine.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdEngine.DescId = zc_Object_ProdEngine()
      AND (Object_ProdEngine.isErased = FALSE OR inIsShowAll = TRUE);  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdEngine (False, zfCalc_UserAdmin())
