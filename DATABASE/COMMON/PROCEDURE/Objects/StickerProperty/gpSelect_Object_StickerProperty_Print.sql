-- Function: gpSelect_Object_Sticker_Print()

DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerProperty_Print(
    IN inObjectId          Integer  , -- ключ Этикетки
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStickerFileId Integer;
    
    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     vbStickerFileId := (SELECT COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId, ObjectLink_Sticker_StickerFile.ChildObjectId)      AS StickerFileId
                         FROM Object AS Object_StickerProperty 
                              LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                   ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                  AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()

                              LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                   ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id 
                                                  AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()

                              LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                   ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                  AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()
                         WHERE Object_StickerProperty.Id = inObjectId
                        );

     IF COALESCE (vbStickerFileId, 0) = 0 
     THEN 
          RAISE EXCEPTION 'Ошибка.Шаблон не установлен';
     END IF;
     
    --
    OPEN Cursor1 FOR
       SELECT Object_StickerProperty.Id          AS Id
            , Object_StickerProperty.ObjectCode  AS Code
            , Object_StickerProperty.ValueData   AS Comment
                                                 
            , ObjectLink_StickerProperty_Sticker.ChildObjectId AS StickerId
                                                 
            , Object_GoodsKind.Id                AS GoodsKindId
            , Object_GoodsKind.ValueData         AS GoodsKindName
                                                 
            , Object_StickerPack.Id              AS StickerPackId
            , Object_StickerPack.ValueData       AS StickerPackName 
                                                 
            , Object_StickerFile.Id              AS StickerFileId
            , Object_StickerFile.ValueData       AS StickerFileName
            , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile
                                                 
            , Object_StickerSkin.Id              AS StickerSkinId
            , Object_StickerSkin.ValueData       AS StickerSkinName

            , ObjectBoolean_Fix.ValueData        AS isFix
                                    
            , ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
            , ObjectFloat_Value5.ValueData       AS Value5
            , ObjectFloat_Value6.ValueData       AS Value6
            , ObjectFloat_Value7.ValueData       AS Value7

       FROM Object AS Object_StickerProperty 
             LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = vbStickerFileId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                  ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
             
             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                  ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                  ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
             LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId

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
                                  
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                     ON ObjectBoolean_Fix.ObjectId = Object_StickerProperty.Id 
                                    AND ObjectBoolean_Fix.DescId = zc_ObjectBoolean_StickerProperty_Fix()
                                    
             LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                  ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                 AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId
          WHERE Object_StickerProperty.Id = inObjectId
            AND Object_StickerProperty.DescId = zc_Object_StickerProperty()
             
      ;
    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.10.17         *
*/
-- тест
-- SELECT * FROM gpSelect_Object_StickerProperty_Print (inObjectId:= 1005846 , inSession:= zfCalc_UserAdmin()); FETCH ALL "<unnamed portal 1>";
