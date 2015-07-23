-- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, PartionGoodsOperDate TDateTime
             , Price TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
     vbUserId:= lpGetUserBySession (inSession);
     
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
     --���������� ������������� ��� ��������� ����
     SELECT MovementLinkObject_Unit.ObjectId INTO vbUnitId
     from MovementLinkObject AS MovementLinkObject_Unit
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

     IF inShowAll THEN
     -- ���������
     RETURN QUERY
       SELECT
             COALESCE(MovementItem.Id,0)           AS Id
           , Object_Goods_View.Id                  AS GoodsId
           , Object_Goods_View.GoodsCode           AS GoodsCode
           , Object_Goods_View.GoodsName           AS GoodsName
           
           , MovementItem.Amount                   AS Amount
           , Object_PartionGoods.Id                AS PartionGoodsId
           , Object_PartionGoods.ValueData         AS PartionGoodsName
           , ObjectDate_Value.ValueData            AS PartionGoodsOperDate
           , Object_Price.Price                    AS Price
           
           , COALESCE(MovementItem.IsErased,FALSE) AS isErased

       FROM Object_Goods_View
            LEFT JOIN MovementItem ON Object_Goods_View.Id = MovementItem.ObjectId 
                                  AND MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                      -- ����
                                                      AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
            LEFT JOIN ObjectDate as objectdate_value ON objectdate_value.ObjectId = Object_PartionGoods.Id                    -- ����
                                                    AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN Object_Price_View AS Object_Price
                                        ON Object_Price.GoodsId = Object_Goods_View.Id
                                       AND Object_Price.UnitId = vbUnitId
       WHERE Object_Goods_View.ObjectId = vbObjectId
         AND (Object_Goods_View.isErased = FALSE or MovementItem.Id IS NOT NULL);
     ELSE
     -- ���������
     RETURN QUERY
       SELECT
             MovementItem.Id                       AS Id
           , Object_Goods_View.Id                  AS GoodsId
           , Object_Goods_View.GoodsCode           AS GoodsCode
           , Object_Goods_View.GoodsName           AS GoodsName
           
           , MovementItem.Amount                   AS Amount
           , Object_PartionGoods.Id                AS PartionGoodsId
           , Object_PartionGoods.ValueData         AS PartionGoodsName
           , ObjectDate_Value.ValueData            AS PartionGoodsOperDate
           , Object_Price.Price                    AS Price
           
           , COALESCE(MovementItem.IsErased,FALSE) AS isErased

       FROM MovementItem
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem.ObjectId 
                                  AND Object_Goods_View.ObjectId = vbObjectId
                                  
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                      -- ����
                                                      AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
            LEFT JOIN ObjectDate as objectdate_value ON objectdate_value.ObjectId = Object_PartionGoods.Id                    -- ����
                                                    AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN Object_Price_View AS Object_Price
                                        ON Object_Price.GoodsId = Object_Goods_View.Id
                                       AND Object_Price.UnitId = vbUnitId
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND (MovementItem.isErased = FALSE or inIsErased = TRUE);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.03.15         * add GoodsGroupNameFull, MeasureName
 17.10.14         * add ��-�� PartionGoods
 08.10.14                                        * add Object_InfoMoney_View
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
