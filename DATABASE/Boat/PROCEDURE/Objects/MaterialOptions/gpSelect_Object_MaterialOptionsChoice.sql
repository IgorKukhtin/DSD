-- Function: gpSelect_Object_MaterialOptionsChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_MaterialOptionsChoice (Integer,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MaterialOptionsChoice(
    IN inProdColorPatternId Integer,
    IN inIsShowAll          Boolean,            -- признак показать удаленные да / нет
    IN inSession            TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT DISTINCT
              Object_MaterialOptions.Id              AS Id
            , Object_MaterialOptions.ObjectCode      AS Code
            , Object_MaterialOptions.ValueData       AS Name

            , Object_ProdColorPattern.Id             AS ProdColorPatternId
            , Object_ProdColorPattern.ObjectCode     AS ProdColorPatternCode
            , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName

            , Object_MaterialOptions.isErased        AS isErased

       FROM Object AS Object_MaterialOptions

            LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                 ON ObjectLink_MaterialOptions.ChildObjectId = Object_MaterialOptions.Id
                                AND ObjectLink_MaterialOptions.DescId       = zc_ObjectLink_ProdOptions_MaterialOptions()

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                 ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_MaterialOptions.ObjectId
                                AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern()
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                                                       -- !!!отключил!!!
                                                       AND 1=1

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ProdColorGroup
                                 ON ObjectLink_ProdColorPattern_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ProdColorPattern_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorPattern_ProdColorGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                 ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()

            LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                 ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
            LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId

       WHERE Object_MaterialOptions.DescId = zc_Object_MaterialOptions()
         AND (Object_MaterialOptions.isErased = FALSE OR inIsShowAll = TRUE)
         AND (ObjectLink_ProdColorPattern.ChildObjectId = inProdColorPatternId /*OR inProdColorPatternId = 0*/)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.26.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MaterialOptionsChoice (inProdColorPatternId:= 32669, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
