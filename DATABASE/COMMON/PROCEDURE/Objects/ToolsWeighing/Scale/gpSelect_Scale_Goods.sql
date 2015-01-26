-- Function: gpSelect_Scale_Goods()

DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Goods(
    IN inOperDate              TDateTime,
    IN inOrderExternalId       Integer,
    IN inPriceListId           Integer,
    IN inInfoMoneyId           Integer,
    IN inDayPrior_PriceReturn  Integer,
    IN inSession               TVarChar      -- ������ ������������
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , ChangePercent TFloat
             , Price TFloat
             , Price_Return TFloat
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpGoods.GoodsId           AS GoodsId
            , tmpGoods.GoodsCode         AS GoodsCode
            , tmpGoods.GoodsName         AS GoodsName
            , Object_GoodsKind.Id        AS GoodsKindId
            , Object_GoodsKind.ValueData AS GoodsKindName
            , Object_Measure.Id          AS MeasureId
            , Object_Measure.ValueData   AS MeasureName
            , CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE 0 END :: TFloat AS ChangePercent
            , lfObjectHistory_PriceListItem.ValuePrice :: TFloat                        AS Price
            , lfObjectHistory_PriceListItem_Return.ValuePrice :: TFloat                 AS Price_Return

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                                             AND Object_Goods.ObjectCode <> 0
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND 1=0
             WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����
            ) AS tmpGoods

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inOperDate - (inDayPrior_PriceReturn :: TVarChar || ' DAY') :: INTERVAL)
                   AS lfObjectHistory_PriceListItem_Return ON lfObjectHistory_PriceListItem_Return.GoodsId = tmpGoods.GoodsId

       ORDER BY ObjectString_Goods_GoodsGroupFull.ValueData
              , tmpGoods.GoodsName
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Scale_Goods (inOperDate:= '01.01.2015', inOrderExternalId:=0, inPriceListId:=0, inInfoMoneyId:=0, inDayPrior_PriceReturn:= 10, inSession:=zfCalc_UserAdmin())
