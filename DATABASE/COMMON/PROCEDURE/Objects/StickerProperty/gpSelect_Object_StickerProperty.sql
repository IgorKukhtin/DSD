-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Sticker (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerProperty(
    IN inShowAll     Boolean,   
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StickerPropertyGroupId Integer, StickerPropertyGroupName TVarChar
             , StickerPropertyTypeId Integer, StickerPropertyTypeName TVarChar
             , StickerPropertyTagId Integer, StickerPropertyTagName TVarChar
             , StickerPropertySortId Integer, StickerPropertySortName TVarChar
             , StickerPropertyNormId Integer, StickerPropertyNormName TVarChar
             , StickerPropertyFileId Integer, StickerPropertyFileName TVarChar
             , Info TBlob
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StickerProperty());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT Object_StickerProperty.Id                 AS Id
            , Object_StickerProperty.ObjectCode         AS Code
            , Object_StickerProperty.ValueData          AS Comment

            , Object_Juridical.Id               AS JuridicalId
            , Object_Juridical.ObjectCode       AS JuridicalCode
            , Object_Juridical.ValueData        AS JuridicalName 

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            
            , Object_StickerPropertyGroup.Id            AS StickerPropertyGroupId
            , Object_StickerPropertyGroup.ValueData     AS StickerPropertyGroupName 

            , Object_StickerPropertyType.Id             AS StickerPropertyTypeId
            , Object_StickerPropertyType.ValueData      AS StickerPropertyTypeName

            , Object_StickerPropertyTag.Id              AS StickerPropertyTagId
            , Object_StickerPropertyTag.ValueData       AS StickerPropertyTagName

            , Object_StickerPropertySort.Id             AS StickerPropertySortId
            , Object_StickerPropertySort.ValueData      AS StickerPropertySortName
            
            , Object_StickerPropertyNorm.Id             AS StickerPropertyNormId
            , Object_StickerPropertyNorm.ValueData      AS StickerPropertyNormName
            
            , Object_StickerPropertyFile.Id             AS StickerPropertyFileId
            , Object_StickerPropertyFile.ValueData      AS StickerPropertyFileName
                  
            , ObjectBlob_Info.ValueData         AS Info
                                    
            , ObjectFloat_Value1.ValueData      AS Value1
            , ObjectFloat_Value2.ValueData      AS Value2
            , ObjectFloat_Value3.ValueData      AS Value3
            , ObjectFloat_Value4.ValueData      AS Value4
            , ObjectFloat_Value5.ValueData      AS Value5

            , Object_StickerProperty.isErased           AS isErased

       FROM (SELECT Object_StickerProperty.* 
             FROM Object AS Object_StickerProperty 
	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_StickerProperty.isErased
             WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
            ) AS Object_StickerProperty
            
             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Juridical
                                  ON ObjectLink_StickerProperty_Juridical.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_Juridical.DescId = zc_ObjectLink_StickerProperty_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_StickerProperty_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Goods
                                  ON ObjectLink_StickerProperty_Goods.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_Goods.DescId = zc_ObjectLink_StickerProperty_Goods()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_StickerProperty_Goods.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertyGroup
                                  ON ObjectLink_StickerProperty_StickerPropertyGroup.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerPropertyGroup.DescId = zc_ObjectLink_StickerProperty_StickerPropertyGroup()
             LEFT JOIN Object AS Object_StickerPropertyGroup ON Object_StickerPropertyGroup.Id = ObjectLink_StickerProperty_StickerPropertyGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertyType
                                  ON ObjectLink_StickerProperty_StickerPropertyType.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectLink_StickerProperty_StickerPropertyType.DescId = zc_ObjectLink_StickerProperty_StickerPropertyType()
             LEFT JOIN Object AS Object_StickerPropertyType ON Object_StickerPropertyType.Id = ObjectLink_StickerProperty_StickerPropertyType.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertyTag
                                  ON ObjectLink_StickerProperty_StickerPropertyTag.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerPropertyTag.DescId = zc_ObjectLink_StickerProperty_StickerPropertyTag()
             LEFT JOIN Object AS Object_StickerPropertyTag ON Object_StickerPropertyTag.Id = ObjectLink_StickerProperty_StickerPropertyTag.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertySort
                                  ON ObjectLink_StickerProperty_StickerPropertySort.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectLink_StickerProperty_StickerPropertySort.DescId = zc_ObjectLink_StickerProperty_StickerPropertySort()
             LEFT JOIN Object AS Object_StickerPropertySort ON Object_StickerPropertySort.Id = ObjectLink_StickerProperty_StickerPropertySort.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertyNorm
                                  ON ObjectLink_StickerProperty_StickerPropertyNorm.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectLink_StickerProperty_StickerPropertyNorm.DescId = zc_ObjectLink_StickerProperty_StickerPropertyNorm()
             LEFT JOIN Object AS Object_StickerPropertyNorm ON Object_StickerPropertyNorm.Id = ObjectLink_StickerProperty_StickerPropertyNorm.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPropertyFile
                                  ON ObjectLink_StickerProperty_StickerPropertyFile.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectLink_StickerProperty_StickerPropertyFile.DescId = zc_ObjectLink_StickerProperty_StickerPropertyFile()
             LEFT JOIN Object AS Object_StickerPropertyFile ON Object_StickerPropertyFile.Id = ObjectLink_StickerProperty_StickerPropertyFile.ChildObjectId 

             LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                   ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                   ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                   ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                   ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                   ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
             
             LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                  ON ObjectBlob_Info.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectBlob_Info.DescId = zc_ObjectBlob_StickerProperty_Info()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StickerProperty (FALSE, inSession := zfCalc_UserAdmin())
