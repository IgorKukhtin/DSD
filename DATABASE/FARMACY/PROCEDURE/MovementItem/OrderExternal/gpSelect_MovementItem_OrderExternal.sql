-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsId Integer, PartnerGoodsCode TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat, PartionGoodsDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

     RETURN QUERY
       SELECT
             tmpMI.Id            AS Id
           , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
           , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
           , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
           , tmpMI.PartnerGoodsId       AS PartnerGoodsId 
           , tmpMI.PartnerGoodsCode     AS PartnerGoodsCode
           , tmpMI.Amount               AS Amount
           , tmpMI.Price                AS Price
           , tmpMI.Summ::TFloat         AS Summ
           , tmpMI.PartionGoodsDate     AS PartionGoodsDate
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods() AND inShowAll = true AND 
                   Object_Goods.isErased = false ) AS tmpGoods

            FULL JOIN (SELECT 
                              MovementItem.Id 
                            , ObjectString.ValueData             AS PartnerGoodsCode
                            , MILinkObject_Goods.ObjectId        AS PartnerGoodsId
                            , Object_Goods.ObjectCode            AS GoodsCode
                            , Object_Goods.ValueData             AS GoodsName
                            , MovementItem.Amount                AS Amount
                            , MIFloat_Price.ValueData            AS Price
                            , MovementItem.Amount * MIFloat_Price.ValueData   AS Summ
                            , MovementItem.isErased              AS isErased
                            , MovementItem.ObjectId              AS GoodsId
                            , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()

                       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                        ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
 
                       LEFT JOIN ObjectString ON ObjectString.ObjectId = MILinkObject_Goods.ObjectId
                                             AND ObjectString.DescId = zc_ObjectString_Goods_Code()


                      ) AS tmpMI ON tmpMI.GoodsId  = tmpGoods.GoodsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
