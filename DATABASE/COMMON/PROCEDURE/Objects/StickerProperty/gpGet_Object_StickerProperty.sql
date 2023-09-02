-- Function: gpGet_Object_StickerProperty()

DROP FUNCTION IF EXISTS gpGet_Object_StickerProperty (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_StickerProperty (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerProperty(
    IN inId          Integer,       -- Товар 
    IN inMaskId      Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar
             , StickerId Integer, StickerName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StickerPackId Integer, StickerPackName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar
             , StickerFileId_70_70 Integer, StickerFileName_70_70 TVarChar
             , StickerSkinId Integer, StickerSkinName TVarChar
             , BarCode TVarChar
             , isFix Boolean
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat, Value6 TFloat, Value7 TFloat, Value8 TFloat, Value9 TFloat, Value10 TFloat, Value11 TFloat
              )
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbPriceListName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerProperty());
    
   IF (COALESCE (inId, 0) = 0 AND COALESCE (inMaskId, 0) = 0)
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

            , CAST (0 as Integer)     AS StickerFileId_70_70
            , CAST ('' as TVarChar)   AS StickerFileName_70_70
            
            , CAST (0 as Integer)     AS StickerSkinId
            , CAST ('' as TVarChar)   AS StickerSkinName
            
            , CAST ('' as TVarChar)   AS BarCode
            , CAST (FALSE as Boolean) AS isFix
                                    
            , CAST (0 as TFloat)      AS Value1
            , CAST (0 as TFloat)      AS Value2
            , CAST (0 as TFloat)      AS Value3
            , CAST (0 as TFloat)      AS Value4
            , CAST (0 as TFloat)      AS Value5
            , CAST (0 as TFloat)      AS Value6
            , CAST (0 as TFloat)      AS Value7
            , CAST (0 as TFloat)      AS Value8
            , CAST (0 as TFloat)      AS Value9
            , CAST (0 as TFloat)      AS Value10
            , CAST (0 as TFloat)      AS Value11
            ;
   ELSE
       RETURN QUERY 
       SELECT Object_StickerProperty.Id          AS Id
            --, Object_StickerProperty.ObjectCode  AS Code
            , CASE WHEN  COALESCE (inId, 0) = 0 THEN lfGet_ObjectCode (0, zc_Object_StickerProperty()) ELSE Object_StickerProperty.ObjectCode END AS Code
            , Object_StickerProperty.ValueData   AS Comment
                                                 
            , Object_Sticker.Id                  AS StickerId
            , (Object_Juridical.ValueData||' / '||Object_Goods.ValueData||' / '||Object_Sticker.ValueData) ::TVarChar AS StickerName
                                                 
            , Object_GoodsKind.Id                AS GoodsKindId
            , Object_GoodsKind.ValueData         AS GoodsKindName
                                                 
            , Object_StickerPack.Id              AS StickerPackId
            , Object_StickerPack.ValueData       AS StickerPackName 
                                                 
            , Object_StickerFile.Id              AS StickerFileId
            , Object_StickerFile.ValueData       AS StickerFileName

            , Object_StickerFile_70_70.Id        AS StickerFileId_70_70
            , Object_StickerFile_70_70.ValueData AS StickerFileName_70_70
                            
            , Object_StickerSkin.Id              AS StickerSkinId
            , Object_StickerSkin.ValueData       AS StickerSkinName

            , ObjectString_BarCode.ValueData     AS BarCode
            , ObjectBoolean_Fix.ValueData        AS Fix
                                    
            , ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
            , ObjectFloat_Value5.ValueData       AS Value5
            , ObjectFloat_Value6.ValueData       AS Value6
            , ObjectFloat_Value7.ValueData       AS Value7
            , ObjectFloat_Value8.ValueData       AS Value8
            , ObjectFloat_Value9.ValueData       AS Value9
            , ObjectFloat_Value10.ValueData      AS Value10
            , ObjectFloat_Value11.ValueData      AS Value11
            
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

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_70_70
                                  ON ObjectLink_StickerProperty_StickerFile_70_70.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerFile_70_70.DescId = zc_ObjectLink_StickerProperty_StickerFile_70_70()
             LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_StickerProperty_StickerFile_70_70.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                  ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
             LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

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

             LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                   ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                   ON ObjectFloat_Value7.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value7.DescId = zc_ObjectFloat_StickerProperty_Value7()
             -- Т мін - второй срок 
             LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                   ON ObjectFloat_Value8.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value8.DescId = zc_ObjectFloat_StickerProperty_Value8()
             -- Т макс - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value9
                                   ON ObjectFloat_Value9.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value9.DescId = zc_ObjectFloat_StickerProperty_Value9()
             -- кількість діб - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                   ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
             -- вложенность
             LEFT JOIN ObjectFloat AS ObjectFloat_Value11
                                   ON ObjectFloat_Value11.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value11.DescId = zc_ObjectFloat_StickerProperty_Value11()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                     ON ObjectBoolean_Fix.ObjectId = Object_StickerProperty.Id 
                                    AND ObjectBoolean_Fix.DescId = zc_ObjectBoolean_StickerProperty_Fix()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = Object_StickerProperty.Id 
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_StickerProperty_BarCode()
                                   
             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                  ON ObjectLink_Sticker_Juridical.ObjectId = Object_Sticker.Id
                                 AND ObjectLink_Sticker_Juridical.DescId = zc_ObjectLink_Sticker_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Sticker_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                  ON ObjectLink_Sticker_Goods.ObjectId = Object_Sticker.Id
                                 AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Sticker_Goods.ChildObjectId
             
       WHERE Object_StickerProperty.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN inMaskId ELSE inId END;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.23         *
 24.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StickerProperty (100, 0, '2')
