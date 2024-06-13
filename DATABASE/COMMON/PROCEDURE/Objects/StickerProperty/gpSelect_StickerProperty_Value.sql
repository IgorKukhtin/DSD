-- Function: gpSelect_StickerProperty_Value()

DROP FUNCTION IF EXISTS gpSelect_StickerProperty_Value (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_StickerProperty_Value(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat
             , Value5 TFloat, Value6 TFloat, Value7 TFloat
             , Value8 TFloat, Value9 TFloat, Value10 TFloat, Value11 TFloat
             , Id Integer, Name TVarChar
             , isCK Boolean, isNormInDays_not Boolean
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
       WITH tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
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
                                      AND 1=0
                                   )
       SELECT DISTINCT
              ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
              -- Кількість діб -> ***срок в днях
            , CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE ObjectFloat_Value5.ValueData END :: TFloat AS Value5
              -- 
            , ObjectFloat_Value6.ValueData       AS Value6
            , ObjectFloat_Value7.ValueData       AS Value7
            , ObjectFloat_Value8.ValueData       AS Value8
            , ObjectFloat_Value9.ValueData       AS Value9
            , ObjectFloat_Value10.ValueData      AS Value10
            , ObjectFloat_Value11.ValueData      AS Value11
            
            , 0               AS Id
            , '' :: TVarChar  AS Name

            , COALESCE (ObjectBoolean_CK.ValueData, FALSE) ::Boolean AS isCK
            , COALESCE (ObjectBoolean_NormInDays_not.ValueData, FALSE) ::Boolean AS isNormInDays_not
       FROM Object AS Object_StickerProperty
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

              LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                   ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                  AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
             LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                  ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                 AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                  ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                 AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = ObjectLink_Sticker_Goods.ChildObjectId
                                          AND tmpGoodsByGoodsKind.GoodsKindId = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_CK
                                     ON ObjectBoolean_CK.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_CK.DescId = zc_ObjectBoolean_StickerProperty_CK()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_NormInDays_not
                                     ON ObjectBoolean_NormInDays_not.ObjectId = Object_StickerProperty.Id
                                    AND ObjectBoolean_NormInDays_not.DescId = zc_ObjectBoolean_StickerProperty_NormInDays_not()

       WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
         AND Object_StickerProperty.isErased = FALSE
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.06.24         *
 25.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_StickerProperty_Value ( zfCalc_UserAdmin())
