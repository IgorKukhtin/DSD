-- Function: gpSelect_MovementItem_OrderGoods()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods_Child (Integer, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderGoods_Child(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , ParentId Integer
             , Amount TFloat     
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbPriceListId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);
     -- ��������� ������
     RETURN QUERY

     SELECT MovementItem.Id
          , MovementItem.ParentId
          , MovementItem.Amount
          , Object_GoodsKind.Id        	AS GoodsKindId
          , Object_GoodsKind.ValueData 	AS GoodsKindName
          , Object_Insert.ValueData     AS InsertName
          , MIDate_Insert.ValueData     AS InsertDate          
          , MovementItem.isErased       AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementItem.ObjectId
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.21         *
*/

-- ����
-- select * from gpSelect_MovementItem_OrderGoods_Child(inMovementId := 18298048 ,  inSession := '5')
