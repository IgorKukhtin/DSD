-- Function: gpSelect_Object_AssetGroup_GoodsGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_AssetGroup_GoodsGroup (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetGroup_GoodsGroup(
    IN inisShowDel         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescId Integer, DescName TVarChar
             , isAsset Boolean
             , isErased Boolean
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY

     SELECT 
           Object_GoodsGroup.Id                AS Id 
         , Object_GoodsGroup.ObjectCode        AS Code
         , Object_GoodsGroup.ValueData         AS Name 
         , ObjectDesc.ItemName                 AS DescName
         , COALESCE(ObjectBoolean_GoodsGroup_Asset.ValueData, FALSE) ::Boolean AS isAsset
         , Object_GoodsGroup.isErased          AS isErased
     FROM Object AS Object_GoodsGroup
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_GoodsGroup.DescId
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsGroup_Asset
                                   ON ObjectBoolean_GoodsGroup_Asset.ObjectId = Object_GoodsGroup.Id 
                                  AND ObjectBoolean_GoodsGroup_Asset.DescId = zc_ObjectBoolean_GoodsGroup_Asset()
     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup() 
     AND (Object_GoodsGroup.isErased = FALSE OR inisShowDel = TRUE)
 UNION ALL
     SELECT 
           Object_AssetGroup.Id            AS Id 
         , Object_AssetGroup.ObjectCode    AS Code
         , Object_AssetGroup.ValueData     AS Name 
         , ObjectDesc.ItemName             AS DescName
         , TRUE ::Boolean                  AS isAsset
         , Object_AssetGroup.isErased      AS isErased
     FROM OBJECT AS Object_AssetGroup
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_AssetGroup.DescId
     WHERE Object_AssetGroup.DescId = zc_Object_AssetGroup()
     AND (Object_AssetGroup.isErased = FALSE OR inisShowDel = TRUE)
     ;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.23         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_AssetGroup_GoodsGroup (inisShowDel := FALSE, inSession := zfCalc_UserAdmin())
