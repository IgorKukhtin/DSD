-- Function: gpSelect_Scale_Sticker()

DROP FUNCTION IF EXISTS gpSelect_Scale_Sticker (Boolean, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Sticker(
    IN inIsGoodsComplete       Boolean  ,    -- склад ГП/производство/упаковка or обвалка
    IN inOperDate              TDateTime,
    IN inMovementId            Integer,      -- Документ
    IN inOrderExternalId       Integer,      -- Заявка ИЛИ Договор (для возврата)
    IN inPriceListId           Integer,      -- Сюда передается LanguageId
    IN inGoodsCode             Integer,
    IN inGoodsName             TVarChar,
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (Id Integer, Comment TVarChar
             , GoodsGroupNameFull TVarChar
             , TradeMarkName_goods TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_original TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- на самом деле здесь StickerPack
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
               -- а здесь GoodsKindId - из StickerProperty
             , GoodsKindId_complete Integer, GoodsKindCode_complete Integer, GoodsKindName_complete TVarChar
               -- Сортность
             , StickerSortName TVarChar
               -- Оболочка
             , StickerSkinName TVarChar
               -- название файла fr3 в БАЗЕ
             , StickerFileName TVarChar
               -- название файла fr3 в БАЗЕ
             , StickerFileName_70_70 TVarChar
               -- сколько уже прошло в печати
             , Count_begin TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- временно - замена - Український
    IF inPriceListId = 0 THEN inPriceListId:= 1196581; END IF;

    -- Результат - по заявке
    RETURN QUERY
       WITH tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна + Ирна
                                                                , zc_Enum_InfoMoney_30101() -- Доходы + Готовая продукция
                                                                , zc_Enum_InfoMoney_30102() -- Доходы + Тушенка
                                                                , zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                                                                 )
                            )
              , tmpGoods AS (SELECT Object_Goods.Id                          AS GoodsId
                                  , Object_Goods.ObjectCode                  AS GoodsCode
                                  , Object_Goods.ValueData                   AS GoodsName
                                  , Object_TradeMark_Goods.ValueData         AS TradeMarkName_goods
                                  , tmpInfoMoney.InfoMoneyId
                                  , tmpInfoMoney.InfoMoneyDestinationId
                             FROM tmpInfoMoney
                                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                  JOIN Object AS Object_Goods ON Object_Goods.Id         = ObjectLink_Goods_InfoMoney.ObjectId
                                                             AND Object_Goods.isErased   = FALSE
                                                             AND Object_Goods.ObjectCode <> 0
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                                      AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark_Goods ON Object_TradeMark_Goods.Id = ObjectLink_Goods_TradeMark.ChildObjectId
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
              -- Шаблоны "по умолчанию" - для конкретной ТМ
            , tmpStickerFile AS (SELECT Object_StickerFile.Id                          AS StickerFileId
                                      , ObjectLink_StickerFile_TradeMark.ChildObjectId AS TradeMarkId
                                 FROM Object AS Object_StickerFile
                                      LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Juridical
                                                           ON ObjectLink_StickerFile_Juridical.ObjectId = Object_StickerFile.Id
                                                          AND ObjectLink_StickerFile_Juridical.DescId   = zc_ObjectLink_StickerFile_Juridical()
                                      INNER JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                            ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                           AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()

                                      INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                                               ON ObjectBoolean_Default.ObjectId  = Object_StickerFile.Id
                                                              AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_StickerFile_Default()
                                                              AND ObjectBoolean_Default.ValueData = TRUE

                                 WHERE Object_StickerFile.DescId   = zc_Object_StickerFile()
                                   AND Object_StickerFile.isErased = FALSE
                                   AND ObjectLink_StickerFile_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                                )
            , tmpSticker AS (SELECT Object_StickerProperty.Id
                                  , Object_StickerProperty.ValueData         AS Comment
                                  , ObjectLink_Sticker_Goods.ChildObjectId   AS GoodsId
                                  , Object_StickerGroup.ValueData            AS StickerGroupName
                                  , Object_StickerType.ValueData             AS StickerTypeName
                                  , Object_StickerTag.ValueData              AS StickerTagName
                                  , Object_StickerSort.ValueData             AS StickerSortName
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
                                    -- название файла fr3 в БАЗЕ
                                  , Object_StickerFile.ValueData                    AS StickerFileName
                                  , Object_StickerFile_70_70.ValueData || '_70_70'  AS StickerFileName_70_70

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
                                  INNER JOIN Object AS Object_Sticker ON Object_Sticker.Id       = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                                     AND Object_Sticker.isErased = FALSE

                                  -- Товар
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                       ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()

                                  -- Вид продукта (Группа)
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                                       ON ObjectLink_Sticker_StickerGroup.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerGroup.DescId   = zc_ObjectLink_Sticker_StickerGroup()
                                  LEFT JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId
                                  -- Способ изготовления продукта
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                                       ON ObjectLink_Sticker_StickerType.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerType.DescId   = zc_ObjectLink_Sticker_StickerType()
                                  LEFT JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId
                                  -- Название продукта
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                                       ON ObjectLink_Sticker_StickerTag.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerTag.DescId   = zc_ObjectLink_Sticker_StickerTag()
                                  LEFT JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId
                                  -- Название продукта
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                                       ON ObjectLink_Sticker_StickerSort.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerSort.DescId   = zc_ObjectLink_Sticker_StickerSort()
                                  LEFT JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId

                                  -- Печать - индивидуальный - Свойства этикетки
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                       ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerFile.DescId   = zc_ObjectLink_StickerProperty_StickerFile()
                                  -- Печать - индивидуальный - Этикетка
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                       ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()

                                  -- Печать 70x70 - индивидуальный - Свойства этикетки
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_70_70
                                                       ON ObjectLink_StickerProperty_StickerFile_70_70.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerFile_70_70.DescId   = zc_ObjectLink_StickerProperty_StickerFile_70_70()
                                  -- Печать 70x70 - индивидуальный - Этикетка
                                  LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile_70_70
                                                       ON ObjectLink_Sticker_StickerFile_70_70.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                      AND ObjectLink_Sticker_StickerFile_70_70.DescId = zc_ObjectLink_Sticker_StickerFile_70_70()

                                  -- ТМ у Товара
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()

                                  -- Печать - "по умолчанию" - для конкретной ТМ
                                  LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId

                                  LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId
                                                                                                  , COALESCE (ObjectLink_Sticker_StickerFile.ChildObjectId
                                                                                                            , tmpStickerFile.StickerFileId))
                                  LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = COALESCE (ObjectLink_StickerProperty_StickerFile_70_70.ChildObjectId
                                                                                                              , COALESCE (ObjectLink_Sticker_StickerFile_70_70.ChildObjectId
                                                                                                                        , tmpStickerFile.StickerFileId))
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Language
                                                       ON ObjectLink_StickerFile_Language.ObjectId = Object_StickerFile.Id
                                                      AND ObjectLink_StickerFile_Language.DescId   = zc_ObjectLink_StickerFile_Language()

                             WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                               AND Object_StickerProperty.isErased = FALSE
                               AND ObjectLink_StickerFile_Language.ChildObjectId = inPriceListId
                            )
       -- Результат - по заявке
       SELECT tmpSticker.Id
            , tmpSticker.Comment
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpGoods.TradeMarkName_goods
            , tmpGoods.GoodsId
            , tmpGoods.GoodsCode
            , CASE WHEN tmpSticker.StickerGroupName <> '' OR tmpSticker.StickerTypeName <> '' OR  tmpSticker.StickerTagName <> ''
                        THEN COALESCE (tmpSticker.StickerGroupName, '' ) || ' ' || COALESCE (tmpSticker.StickerTypeName, '') || ' ' || COALESCE (tmpSticker.StickerTagName, '')
                   ELSE tmpGoods.GoodsName
              END :: TVarChar AS GoodsName
            , tmpGoods.GoodsName       AS GoodsName_original
            , Object_Measure.Id        AS MeasureId
            , Object_Measure.ValueData AS MeasureName

            , tmpSticker.GoodsKindId
            , tmpSticker.GoodsKindCode
            , tmpSticker.GoodsKindName
            , tmpSticker.GoodsKindId_complete
            , tmpSticker.GoodsKindCode_complete
            , tmpSticker.GoodsKindName_complete

            , tmpSticker.StickerSortName
            , tmpSticker.StickerSkinName

              -- название файла fr3 в БАЗЕ
            , (tmpSticker.StickerFileName       || '.Sticker') :: TVarChar AS StickerFileName
            , CASE WHEN ObjectForm_70_70.ValueData <> '' THEN ObjectForm_70_70.ValueData ELSE '' END :: TVarChar AS StickerFileName_70_70

            , tmpMI_Weighing.Count_begin :: TFloat AS Count_begin

       FROM tmpGoods
            INNER JOIN tmpSticker ON tmpSticker.GoodsId = tmpGoods.GoodsId
            LEFT JOIN tmpMI_Weighing ON tmpMI_Weighing.GoodsId     = tmpSticker.GoodsId
                                    AND tmpMI_Weighing.GoodsKindId = tmpSticker.GoodsKindId


            LEFT JOIN Object AS ObjectForm_70_70
                             ON ObjectForm_70_70.ValueData = (tmpSticker.StickerFileName_70_70 || '.Sticker') :: TVarChar
                            AND ObjectForm_70_70.DescId    = zc_Object_Form()

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

       ORDER BY COALESCE (tmpSticker.StickerGroupName, '' ) || ' ' || COALESCE (tmpSticker.StickerTypeName, '') || ' ' || COALESCE (tmpSticker.StickerTagName, '')
              , tmpGoods.GoodsName
              , tmpSticker.GoodsKindCode
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
