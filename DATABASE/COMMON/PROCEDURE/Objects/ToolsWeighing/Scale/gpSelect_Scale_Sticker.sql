-- Function: gpSelect_Scale_Sticker()

DROP FUNCTION IF EXISTS gpSelect_Scale_Sticker (Boolean, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Sticker(
    IN inIsGoodsComplete       Boolean  ,    -- склад ГП/производство/упаковка or обвалка
    IN inOperDate              TDateTime,
    IN inMovementId            Integer,      -- Документ
    IN inOrderExternalId       Integer,      -- Заявка ИЛИ Договор (для возврата)
    IN inPriceListId           Integer,
    IN inGoodsCode             Integer,
    IN inGoodsName             TVarChar,
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- на самом деле здесь StickerPack
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
               -- а здесь GoodsKindId - из StickerProperty
             , GoodsKindId_complete Integer, GoodsKindCode_complete Integer, GoodsKindName_complete TVarChar
               -- Оболочка
             , StickerSkinName TVarChar
               -- сколько уже прошло в печати
             , Count_begin TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат - по заявке
    RETURN QUERY
       WITH tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна + Ирна
                                                                , zc_Enum_InfoMoney_30101() -- Доходы + Готовая продукция
                                                                , zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                                                                 )
                            )
              , tmpGoods AS (SELECT Object_Goods.Id                               AS GoodsId
                                  , Object_Goods.ObjectCode                       AS GoodsCode
                                  , Object_Goods.ValueData                        AS GoodsName
                                  , tmpInfoMoney.InfoMoneyId
                                  , tmpInfoMoney.InfoMoneyDestinationId
                             FROM tmpInfoMoney
                                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                  JOIN Object AS Object_Goods ON Object_Goods.Id         = ObjectLink_Goods_InfoMoney.ObjectId
                                                             AND Object_Goods.isErased   = FALSE
                                                             AND Object_Goods.ObjectCode <> 0
                            )
        , tmpMI_Weighing AS (SELECT MovementItem.ObjectId                         AS GoodsId
                                  , SUM (COALESCE (MIFloat_Count.ValueData, 0))   AS Count_begin
                                    -- на самом деле здесь StickerPack
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             FROM MovementItem
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                              ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Count.DescId         = zc_MIFloat_Count()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                             GROUP BY MovementItem.ObjectId
                                    , MILinkObject_GoodsKind.ObjectId
                            )
            , tmpSticker AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId AS GoodsId
                                    -- заменяем Вид пакування -> Вид товара 
                                  , Object_StickerPack.Id         AS GoodsKindId
                                  , Object_StickerPack.ObjectCode AS GoodsKindCode
                                  , Object_StickerPack.ValueData  AS GoodsKindName
                                    -- Вид товара 
                                  , Object_GoodsKind.Id           AS GoodsKindId_complete
                                  , Object_GoodsKind.ObjectCode   AS GoodsKindCode_complete
                                  , Object_GoodsKind.ValueData    AS GoodsKindName_complete
                                    -- Оболочка
                                  , Object_StickerSkin.ValueData  AS StickerSkinName
                                  
                             FROM Object AS Object_StickerProperty
                                  -- Свойства этикетки
                                  -- Вид товара
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                       ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_GoodsKind.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()
                                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

                                  -- вид пакування
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                                       ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
                                  LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId

                                  -- Оболочка
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                                       ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
                                  LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

                                  -- Этикетка
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                       ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()

                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                      ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                     AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()

                             WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                               AND Object_StickerProperty.isErased = FALSE
                            )
       -- Результат - по заявке
       SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpGoods.GoodsId
            , tmpGoods.GoodsCode
            , tmpGoods.GoodsName
            , Object_Measure.Id        AS MeasureId
            , Object_Measure.ValueData AS MeasureName

            , tmpSticker.GoodsKindId
            , tmpSticker.GoodsKindCode
            , tmpSticker.GoodsKindName
            , tmpSticker.GoodsKindId_complete
            , tmpSticker.GoodsKindCode_complete
            , tmpSticker.GoodsKindName_complete

            , tmpSticker.StickerSkinName

            , tmpMI_Weighing.Count_begin :: TFloat AS Count_begin

       FROM tmpGoods
            LEFT JOIN tmpSticker ON tmpSticker.GoodsId = tmpGoods.GoodsId
            LEFT JOIN tmpMI_Weighing ON tmpMI_Weighing.GoodsId     = tmpSticker.GoodsId
                                    AND tmpMI_Weighing.GoodsKindId = tmpSticker.GoodsKindId


            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       ORDER BY tmpGoods.GoodsName
              , tmpSticker.GoodsKindName
              -- , ObjectString_Goods_GoodsGroupFull.ValueData
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.12.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Sticker (inIsGoodsComplete:= TRUE, inOperDate:= '01.12.2016', inMovementId:= -79137, inOrderExternalId:= 0, inPriceListId:=0, inGoodsCode:= 0, inGoodsName:= '', inBranchCode:= 301, inSession:=zfCalc_UserAdmin()) WHERE GoodsCode = 901
