-- Function: gpSelect_MI_OrderIncome()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderIncome (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderIncome(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderIncome());
     vbUserId:= lpGetUserBySession (inSession);

       --
       OPEN Cursor1 FOR
        SELECT
             MovementItem.Id     AS Id
           , MovementItem.Amount               :: TFloat AS Amount  
           , MIFloat_Price.ValueData           :: TFloat AS Price
           , MIFloat_CountForPrice.ValueData   :: TFloat AS CountForPrice 
           , (MIFloat_Price.ValueData * MovementItem.Amount) :: TFloat AS Summa

           , MIString_Comment.ValueData        :: TVarChar AS Comment

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName

           , Object_OrderIncome.Id               AS OrderIncomeId
           , Object_OrderIncome.ValueData        AS OrderIncomeName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_OrderIncome
                                             ON MILinkObject_OrderIncome.MovementItemId = MovementItem.Id
                                            AND MILinkObject_OrderIncome.DescId = zc_MILinkObject_OrderIncome()
            LEFT JOIN Object AS Object_OrderIncome ON Object_OrderIncome.Id = MILinkObject_OrderIncome.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
          ;

       RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 12.07.16         * 
*/

-- ����
-- SELECT * from gpSelect_MI_OrderIncome (0,False, '3');