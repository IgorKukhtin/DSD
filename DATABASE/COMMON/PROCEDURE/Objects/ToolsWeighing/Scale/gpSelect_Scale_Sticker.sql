-- Function: gpSelect_Scale_Sticker()

DROP FUNCTION IF EXISTS gpSelect_Scale_Sticker (Boolean, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Sticker(
    IN inIsGoodsComplete       Boolean  ,    -- ����� ��/������������/�������� or �������
    IN inOperDate              TDateTime,
    IN inMovementId            Integer,      -- ��������
    IN inOrderExternalId       Integer,      -- ������ ��� ������� (��� ��������)
    IN inPriceListId           Integer,
    IN inGoodsCode             Integer,
    IN inGoodsName             TVarChar,
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
               -- �� ����� ���� ����� StickerPack
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
               -- � ����� GoodsKindId - �� StickerProperty
             , GoodsKindId_complete Integer, GoodsKindCode_complete Integer, GoodsKindName_complete TVarChar
               -- ��������
             , StickerSkinName TVarChar
               -- �������� ����� fr3 � ����
             , StickerFileName TVarChar
               -- ������� ��� ������ � ������
             , Count_begin TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- ��������� - �� ������
    RETURN QUERY
       WITH tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- ���� + ����
                                                                , zc_Enum_InfoMoney_30101() -- ������ + ������� ���������
                                                                , zc_Enum_InfoMoney_30201() -- ������ + ������ �����
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
                                    -- �� ����� ���� ����� StickerPack
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
              -- ������� "�� ���������" - ��� ���������� ��
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
                                   AND ObjectLink_StickerFile_Juridical.ChildObjectId IS NULL -- !!!����������� ��� ����������!!!
                                )
            , tmpSticker AS (SELECT Object_StickerProperty.Id
                                  , ObjectLink_Sticker_Goods.ChildObjectId AS GoodsId
                                    -- �������� ��� ��������� -> ��� ������
                                  , Object_StickerPack.Id         AS GoodsKindId
                                  , Object_StickerPack.ObjectCode AS GoodsKindCode
                                  , Object_StickerPack.ValueData  AS GoodsKindName
                                    -- ��� ������
                                  , Object_GoodsKind.Id           AS GoodsKindId_complete
                                  , Object_GoodsKind.ObjectCode   AS GoodsKindCode_complete
                                  , Object_GoodsKind.ValueData    AS GoodsKindName_complete
                                    -- ��������
                                  , Object_StickerSkin.ValueData  AS StickerSkinName
                                    -- �������� ����� fr3 � ����
                                  , Object_StickerFile.ValueData  AS StickerFileName

                             FROM Object AS Object_StickerProperty
                                  -- �������� ��������
                                  -- ��� ������
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                       ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_GoodsKind.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()
                                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId

                                  -- ��� ���������
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                                       ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
                                  LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId

                                  -- ��������
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                                       ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
                                  LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId

                                  -- ��������
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                       ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                      AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()

                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                      ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                     AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()

                                 -- ������ - �������������� - �������� ��������
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                      ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                     AND ObjectLink_StickerProperty_StickerFile.DescId   = zc_ObjectLink_StickerProperty_StickerFile()

                                 -- ������ - �������������� - ��������
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                      ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                     AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                      ON ObjectLink_Goods_TradeMark.ObjectId = ObjectLink_Sticker_Goods.ChildObjectId
                                                     AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                                 -- ������ - "�� ���������" - ��� ���������� ��
                                 LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId

                                 LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId, COALESCE (ObjectLink_Sticker_StickerFile.ChildObjectId, tmpStickerFile.StickerFileId))

                             WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                               AND Object_StickerProperty.isErased = FALSE
                            )
       -- ��������� - �� ������
       SELECT tmpSticker.Id
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
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
            
              -- �������� ����� fr3 � ����
            , (tmpSticker.StickerFileName || '.Sticker') :: TVarChar AS StickerFileName

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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.12.17                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Scale_Sticker (inIsGoodsComplete:= TRUE, inOperDate:= '01.12.2016', inMovementId:= -79137, inOrderExternalId:= 0, inPriceListId:=0, inGoodsCode:= 0, inGoodsName:= '', inBranchCode:= 301, inSession:=zfCalc_UserAdmin()) WHERE GoodsCode = 901
