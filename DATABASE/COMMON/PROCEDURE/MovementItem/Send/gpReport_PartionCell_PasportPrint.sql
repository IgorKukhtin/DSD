
-- Function: gpReport_PartionCell_PasportPrint

DROP FUNCTION IF EXISTS gpReport_PartionCell_PasportPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_PasportPrint(
    IN inMovementItemId    Integer  , --
    IN inPartionCellId     Integer  , -- 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , PartionGoodsDate TDateTime 
             , PartionCellName TVarChar
             , StoreKeeper TVarChar
              )
AS                      
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inPartionCellId,0) = 0
     THEN
         RETURN;
     END IF;
     
  -- ���������
  RETURN QUERY

     --
     SELECT Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName 
          , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime AS PartionGoodsDate
          , Object_PartionCell.ValueData       AS PartionCellName
          , Object_Member.ValueData ::TVarChar AS StoreKeeper
 
     FROM MovementItem
          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
   
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
          LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = inPartionCellId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = vbUserId
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

     WHERE MovementItem.Id = inMovementItemId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.07.24         * 
*/

-- ����
-- select * from gpReport_PartionCell_PasportPrint(inMovementItemId := 294981981   , inPartionCellId := 10239308 , inSession := '5');