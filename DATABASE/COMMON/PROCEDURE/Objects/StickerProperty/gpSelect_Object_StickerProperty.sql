-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_StickerProperty (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerProperty(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar
             , StickerId Integer, GoodsId Integer
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StickerPackId Integer, StickerPackName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar, TradeMarkName_StickerFile TVarChar
             , StickerFileId_70_70 Integer, StickerFileName_70_70 TVarChar, TradeMarkName_StickerFile_70_70 TVarChar
             , StickerSkinId Integer, StickerSkinName TVarChar
             , BarCode TVarChar
             , isFix Boolean, isCK Boolean, isNormInDays_not Boolean
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat
               -- Кількість діб -> ***срок в днях
             , Value5 TFloat, Value5_orig TFloat, NormInDays_gk TFloat
               --
             , Value6 TFloat, Value7 TFloat
             , Value8 TFloat, Value9 TFloat, Value10 TFloat, Value11 TFloat
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
          , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                                         , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                         , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                         , ObjectFloat_GK_NormInDays.ValueData                 AS NormInDays_gk
                                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                         JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                         ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                                 ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                              --AND ObjectBoolean_Order.ValueData = TRUE
                                         INNER JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                                ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                                               AND ObjectFloat_GK_NormInDays.ValueData <> 0
                                    WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                   )

       SELECT Object_StickerProperty.Id          AS Id
            , Object_StickerProperty.ObjectCode  AS Code
            , Object_StickerProperty.ValueData   AS Comment

            , ObjectLink_StickerProperty_Sticker.ChildObjectId AS StickerId
            , ObjectLink_Sticker_Goods.ChildObjectId AS GoodsId

            , Object_GoodsKind.Id                AS GoodsKindId
            , Object_GoodsKind.ValueData         AS GoodsKindName

            , Object_StickerPack.Id              AS StickerPackId
            , Object_StickerPack.ValueData       AS StickerPackName

            , Object_StickerFile.Id              AS StickerFileId
            , Object_StickerFile.ValueData       AS StickerFileName
            , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile

            , Object_StickerFile_70_70.Id                                   AS StickerFileId_70_70
            , (Object_StickerFile_70_70.ValueData  || '_70_70') :: TVarChar AS StickerFileName_70_70 
            , Object_TradeMark_StickerFile_70_70.ValueData                  AS TradeMarkName_StickerFile_70_70

            , Object_StickerSkin.Id              AS StickerSkinId
            , Object_StickerSkin.ValueData       AS StickerSkinName

            , ObjectString_BarCode.ValueData     AS BarCode
            , ObjectBoolean_Fix.ValueData        AS isFix
            , COALESCE (ObjectBoolean_CK.ValueData, FALSE) ::Boolean AS isCK
            , COALESCE (ObjectBoolean_NormInDays_not.ValueData, FALSE) ::Boolean AS isNormInDays_not

            , ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
              -- Кількість діб -> ***срок в днях
            , CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 AND 1=0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE ObjectFloat_Value5.ValueData END :: TFloat AS Value5
            , ObjectFloat_Value5.ValueData       AS Value5_orig
            , tmpGoodsByGoodsKind.NormInDays_gk :: TFloat AS NormInDays_gk
              --
            , ObjectFloat_Value6.ValueData       AS Value6
            , ObjectFloat_Value7.ValueData       AS Value7
            , ObjectFloat_Value8.ValueData       AS Value8
            , ObjectFloat_Value9.ValueData       AS Value9
            , ObjectFloat_Value10.ValueData      AS Value10
            , ObjectFloat_Value11.ValueData      AS Value11

            , Object_StickerProperty.isErased    AS isErased

       FROM (SELECT Object_StickerProperty.*
             FROM Object AS Object_StickerProperty
	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_StickerProperty.isErased
             WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
            ) AS Object_StickerProperty

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

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                  ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()
             LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_StickerProperty_StickerFile.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_70_70
                                  ON ObjectLink_StickerProperty_StickerFile_70_70.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerFile_70_70.DescId   = zc_ObjectLink_StickerProperty_StickerFile_70_70()
             LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_StickerProperty_StickerFile_70_70.ChildObjectId


             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                  ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
             LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

             --  вологість мін
             LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                   ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()
             --  вологість макс
             LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                   ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()
             --  Т мін
             LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                   ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()
             --  Т макс
             LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                   ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()

             -- кількість діб
             LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                   ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
             -- вес
             LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                   ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id
                                  AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()

             -- % отклонения
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

             LEFT JOIN ObjectBoolean AS ObjectBoolean_CK
                                     ON ObjectBoolean_CK.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_CK.DescId = zc_ObjectBoolean_StickerProperty_CK()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_NormInDays_not
                                     ON ObjectBoolean_NormInDays_not.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_NormInDays_not.DescId = zc_ObjectBoolean_StickerProperty_NormInDays_not()
              
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = Object_StickerProperty.Id
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_StickerProperty_BarCode()

             LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                  ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                 AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark_70_70
                                  ON ObjectLink_StickerFile_TradeMark_70_70.ObjectId = Object_StickerFile_70_70.Id
                                 AND ObjectLink_StickerFile_TradeMark_70_70.DescId = zc_ObjectLink_StickerFile_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_StickerFile_70_70 ON Object_TradeMark_StickerFile_70_70.Id = ObjectLink_StickerFile_TradeMark_70_70.ChildObjectId
             
             
             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                  ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = ObjectLink_Sticker_Goods.ChildObjectId
                                          AND tmpGoodsByGoodsKind.GoodsKindId = ObjectLink_StickerProperty_GoodsKind.ChildObjectId
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.06.24         * isNormInDays_not
 01.09.23         *
 22.04.21         * zc_ObjectBoolean_StickerProperty_CK
 24.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StickerProperty (FALSE, zfCalc_UserAdmin())
