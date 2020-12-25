-- Function: gpGet_Object_ColorPattern()

DROP FUNCTION IF EXISTS gpGet_Object_ColorPattern (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ColorPattern(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , ModelId Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ColorPattern())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS UserCode
           , '' :: TVarChar           AS Comment
           , 0  :: Integer            AS ModelId
           , '' :: TVarChar           AS ModelName
           , CAST (0  AS Integer)     AS BrandId
           , CAST ('' AS TVarChar)    AS BrandName
           , CAST (0  AS Integer)     AS ProdEngineId
           , CAST ('' AS TVarChar)    AS ProdEngineName
       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ColorPattern.Id         AS Id 
         , Object_ColorPattern.ObjectCode AS Code
         , Object_ColorPattern.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Model.Id         ::Integer  AS ModelId
         , Object_Model.ValueData  ::TVarChar AS ModelName
         , Object_Brand.Id                    AS BrandId
         , Object_Brand.ValueData             AS BrandName
         , Object_ProdEngine.Id               AS ProdEngineId
         , Object_ProdEngine.ValueData        AS ProdEngineName

     FROM Object AS Object_ColorPattern
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ColorPattern.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ColorPattern_Code()  
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ColorPattern_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

     WHERE Object_ColorPattern.DescId = zc_Object_ColorPattern()
      AND Object_ColorPattern.Id = inId
     ;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.20         *
*/

-- тест
--  SELECT * FROM gpGet_Object_ColorPattern (0, zfCalc_UserAdmin())