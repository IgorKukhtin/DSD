-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , PartionId Integer--, IdBarCode TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , Amount TFloat, AmountRemains TFloat
             , Price TFloat
             , Summa TFloat
             , PartNumber TVarChar
             , Comment TVarChar
             , Ord Integer
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate_pr TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �����
     vbOperDate_pr:= (SELECT MIN (MovementProtocol.OperDate) FROM MovementProtocol WHERE MovementProtocol.MovementId = inMovementId);

     -- �� ����� ����� ������������� ��� ��������
     vbUnitId := (SELECT MovementLinkObject.ObjectId 
                  FROM MovementLinkObject 
                  WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
                    AND MovementLinkObject.MovementId = inMovementId
                  );

     -- ��������� �����
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_Price.ValueData, 0)        AS Price
                           , COALESCE (MIString_Comment.ValueData,'')     AS Comment
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , MovementItem.isErased
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       )

     , tmpRemains AS (SELECT Container.ObjectId AS GoodsId
                           , CAST (SUM (COALESCE (Container.Amount,0)) AS NUMERIC (16,0)) AS Remains
                      FROM Container
                      WHERE Container.DescId = zc_Container_Count()
                        AND Container.PartionId IN (SELECT DISTINCT tmpMI.PartionId FROM tmpMI)
                        AND (Container.WhereObjectId = vbUnitId OR COALESCE (vbUnitId,0) = 0)
                        AND COALESCE (Container.Amount,0) <> 0
                      GROUP BY Container.ObjectId 
                      )

       -- ���������
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           --, zfFormat_BarCode (zc_BarCodePref_Object(), ObjectString_EAN.ValueData) AS IdBarCode
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData      AS Article
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI.Amount
           , tmpRemains.Remains           ::TFloat AS AmountRemains
           , tmpMI.Price                  ::TFloat

           , (tmpMI.Amount * tmpMI.Price) ::TFloat AS Summa
 
           , tmpMI.PartNumber             ::TVarChar
           , tmpMI.Comment                ::TVarChar
           --, tmpProtocol.OperDate                  AS OperDate_pr

           , ROW_NUMBER() OVER (ORDER BY tmpMI.Id ASC) :: Integer AS Ord
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
           /* LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                                 AND tmpProtocol.Ord            = 1*/
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.22         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId := 23 , inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());
