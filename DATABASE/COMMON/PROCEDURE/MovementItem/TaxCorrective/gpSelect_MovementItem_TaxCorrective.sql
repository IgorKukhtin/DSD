-- Function: gpSelect_MovementItem_TaxCorrective()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TaxCorrective (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TaxCorrective(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, LineNum Integer, LineNumTax Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , Price TFloat, CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , AmountSumm TFloat, isErased Boolean
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_TaxCorrective());

     --
     IF inShowAll THEN

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- ���������
     RETURN QUERY
     WITH
     tmpMITax AS (SELECT tmp.GoodsId, tmp.Price, tmp.LineNum
                  FROM MovementLinkMovement AS MovementLinkMovement_Child
                      LEFT JOIN lpSelect_TaxFromTaxCorrective(MovementLinkMovement_Child.MovementChildId) AS tmp ON 1=1
                  WHERE MovementLinkMovement_Child.MovementId = inMovementId 
                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                  )
       SELECT
             0                                      AS Id
           , 0                                      AS LineNum    
           , 0                                      AS LineNumTax
           , tmpGoods.GoodsId                       AS GoodsId
           , tmpGoods.GoodsCode                     AS GoodsCode
           , tmpGoods.GoodsName                     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)                  AS Amount
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           , CAST (1 AS TFloat)                     AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (NULL AS TFloat)                  AS AmountSumm
           , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- ���� + ������� ��������� + ������ ������ �����
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                        AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum    
           , tmpMITax.LineNum                       AS LineNumTax
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())
            
            LEFT JOIN tmpMITax ON tmpMITax.GoodsId = Object_Goods.Id
                              AND tmpMITax.Price = MIFloat_Price.ValueData
            ;
     ELSE

     RETURN QUERY
     WITH 
     tmpMITax AS (SELECT tmp.GoodsId, tmp.Price, tmp.LineNum
                  FROM MovementLinkMovement AS MovementLinkMovement_Child
                      LEFT JOIN lpSelect_TaxFromTaxCorrective(MovementLinkMovement_Child.MovementChildId) AS tmp On 1=1
                  WHERE MovementLinkMovement_Child.MovementId = inMovementId 
                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                  )
     
       SELECT
             MovementItem.Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum    
           , tmpMITax.LineNum                       AS LineNumTax
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())
            
            LEFT JOIN tmpMITax ON tmpMITax.GoodsId = Object_Goods.Id
                              AND tmpMITax.Price = MIFloat_Price.ValueData
            ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TaxCorrective (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.03.16         * add LineNum
 31.03.15         * 
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_TaxCorrective (inMovementId:= 4229, inShowAll:= True, inisErased:= True, inSession:= '2')
