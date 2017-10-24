-- Function: gpGet_Object_StickerProperty()

DROP FUNCTION IF EXISTS gpGet_Object_StickerProperty (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerProperty(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar
             , StickerId Integer, StickerName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StickerPackId Integer, StickerPackName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar
             , StickerSkinId Integer, StickerSkinName TVarChar
             , StickerPropertySortId Integer, StickerPropertySortName TVarChar
             , StickerPropertyNormId Integer, StickerPropertyNormName TVarChar
             , StickerPropertyFileId Integer, StickerPropertyFileName TVarChar
             , Info TBlob
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat, Value6 TFloat, Value7 TFloat
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerProperty());
    
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 

       SELECT CAST (0 as Integer)     AS Id
            , lfGet_ObjectCode(0, zc_Object_StickerProperty()) AS Code
            , CAST ('' as TVarChar)   AS Comment

            , CAST (0 as Integer)     AS StickerId
            , CAST ('' as TVarChar)   AS StickerName 

            , CAST (0 as Integer)     AS GoodsKindId
            , CAST ('' as TVarChar)   AS GoodsKindName
            
            , CAST (0 as Integer)     AS StickerPackId
            , CAST ('' as TVarChar)   AS StickerPackName 

            , CAST (0 as Integer)     AS StickerFileId
            , CAST ('' as TVarChar)   AS StickerFileName

            , CAST (0 as Integer)     AS StickerSkinId
            , CAST ('' as TVarChar)   AS StickerSkinName

            , CAST (0 as Integer)     AS StickerPropertySortId
            , CAST ('' as TVarChar)   AS StickerPropertySortName
            
            , CAST (0 as Integer)     AS StickerPropertyNormId
            , CAST ('' as TVarChar)   AS StickerPropertyNormName
            
            , CAST (0 as Integer)     AS StickerPropertyFileId
            , CAST ('' as TVarChar)   AS StickerPropertyFileName
                  
            , CAST ('' as TBlob)      AS Info
                                    
            , CAST (0 as TFloat)      AS Value1
            , CAST (0 as TFloat)      AS Value2
            , CAST (0 as TFloat)      AS Value3
            , CAST (0 as TFloat)      AS Value4
            , CAST (0 as TFloat)      AS Value5
            ;
   ELSE
       RETURN QUERY 
       SELECT Object_StickerProperty.Id                 AS Id
            , Object_StickerProperty.ObjectCode         AS Code
            , Object_StickerProperty.ValueData          AS Comment

            , Object_Sticker.Id               AS StickerId
            , Object_Sticker.ValueData        AS StickerName 

            , Object_GoodsKind.Id                   AS GoodsKindId
            , Object_GoodsKind.ValueData            AS GoodsKindName
            
            , Object_StickerPack.Id            AS StickerPackId
            , Object_StickerPack.ValueData     AS StickerPackName 

            , Object_StickerFile.Id             AS StickerFileId
            , Object_StickerFile.ValueData      AS StickerFileName

            , Object_StickerSkin.Id              AS StickerSkinId
            , Object_StickerSkin.ValueData       AS StickerSkinName

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

       FROM Object AS Object_StickerProperty
            
             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                  ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
             LEFT JOIN Object AS Object_Sticker ON Object_Sticker.Id = ObjectLink_StickerProperty_Sticker.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                  ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                  ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
             LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                  ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()
             LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_StickerProperty_StickerFile.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                  ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
             LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

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

       WHERE Object_StickerProperty.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_StickerProperty (Integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.11.14         * add inStickerPackAnalystId               
 15.09.14         * add zc_ObjectLink_StickerProperty_StickerSkin()
 04.09.14         * 
 29.09.13                                        * add zc_ObjectLink_StickerProperty_Fuel
 06.09.13                          *              
 02.07.13         * + TradeMark             
 02.07.13                                        * 1251Cyr
 21.06.13         *              
 11.06.13         *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_StickerProperty (100, '2')