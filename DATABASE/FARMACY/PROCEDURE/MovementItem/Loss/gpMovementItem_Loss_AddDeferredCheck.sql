-- Function: gpMovementItem_Loss_AddDeferredCheck

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddDeferredCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddDeferredCheck(
    IN inMovementId       Integer,   -- ��������
    IN inCheckID          Integer,   -- ���
    IN inSession          TVarChar  -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '�������� �� ��������.';
    END IF;


    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                            , lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                                                              , inMovementId         := inMovementId
                                                                              , inGoodsId            := MovementItemCheck.ObjectId
                                                                              , inAmount             := MovementItemCheck.Amount
                                                                              , inUserId             := vbUserId)
                                            , MovementItemCheck.Price)  
    FROM (SELECT MovementItemCheck.ObjectId
               , SUM(MovementItemCheck.Amount)  AS Amount
               , MAX(MIFloat_Price.ValueData)   AS Price
          FROM MovementItem AS MovementItemCheck
               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItemCheck.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()          
          WHERE MovementItemCheck.MovementId = inCheckID
          AND MovementItemCheck.IsErased = False
          AND MovementItemCheck.DescId = zc_MI_Master()
          GROUP BY MovementItemCheck.ObjectId) AS MovementItemCheck

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemCheck.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.07.19                                                       *
*/

-- ����
-- select * from gpMovementItem_Loss_AddDeferredCheck(inMovementId := 16461309 , inCheckID := 16357692 ,  inSession := '3');