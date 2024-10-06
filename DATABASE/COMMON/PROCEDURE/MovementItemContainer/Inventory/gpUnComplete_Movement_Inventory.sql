-- Function: gpUnComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- !!!��������, ������������ ������!!!!
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_List() AND MB.ValueData = TRUE)
        AND 1=0
     THEN
         -- !!! ��� ��������� !!!
         UPDATE MovementItem SET isErased = TRUE
         FROM MovementItemFloat AS MIF_ContainerId
              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                            ON CLO_GoodsKind.ContainerId = MIF_ContainerId.ValueData :: Integer
                                           AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MIF_ContainerId.MovementItemId
                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.isErased   = FALSE
           AND MovementItem.Amount     = 0
           AND NOT EXISTS (SELECT 1 FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_Summ() AND MIF.ValueData <> 0)
           AND MIF_ContainerId.MovementItemId = MovementItem.Id
           AND MIF_ContainerId.DescId         = zc_MIFloat_ContainerId()
           AND MIF_ContainerId.ValueData      > 0
           AND (COALESCE (MILinkObject_GoodsKind.ObjectId, 0) <> COALESCE (CLO_GoodsKind.ObjectId, 0)
             OR (COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 AND COALESCE (CLO_GoodsKind.ObjectId, 0) = 0)
               )
        ;
     END IF;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Inventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
