-- Function: gpSelect_MovementItem_Check_UpdateOrdersSite()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_UpdateOrdersSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_UpdateOrdersSite(
    IN inMovementId       Integer  ,  -- �������������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Price TFloat
             , Amount TFloat
             , AmountOrder TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
    SELECT
           MovementItem.Id
         , MovementItem.GoodsId
         , MovementItem.GoodsCode
         , MovementItem.GoodsName
         , MovementItem.Price
         , MovementItem.Amount
         , MovementItem.AmountOrder
         , MovementItem.isErased
     FROM MovementItem_Check_View AS MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND COALESCE (MovementItem.AmountOrder, 0) > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.22                                                       * 
*/

-- ����
-- 

SELECT * FROM gpSelect_MovementItem_Check_UpdateOrdersSite (inMovementId:= 28455544, inSession:= '3')