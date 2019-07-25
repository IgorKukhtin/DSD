-- Function: gpMovementItem_Loss_AddSend

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddSend (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddSend(
    IN inMovementId       Integer,   -- ��������
    IN inSendID          Integer,   -- �����������
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


    PERFORM lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := MovementItemCheck.ObjectId
                                            , inAmount             := MovementItemCheck.Amount
                                            , inUserId             := vbUserId)
    FROM MovementItem AS MovementItemCheck

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemCheck.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master()

    WHERE MovementItemCheck.MovementId = inSendID
      AND MovementItemCheck.IsErased = False
      AND MovementItemCheck.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_Loss_AddSend (inMovementId:= 1, inOperDate:= NULL);
