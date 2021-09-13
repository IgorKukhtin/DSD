-- Function: gpSetErased_Movement_OrderPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderPartner(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderPartner());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- ����� ��������� - ���������� ��� ��� zc_MIFloat_MovementId - �� ���� ����� �������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), MIFloat_MovementId.MovementItemId, 0)
     FROM MovementItemFloat AS MIFloat_MovementId
          INNER JOIN MovementItem AS MI_Child_client
                                  ON MI_Child_client.Id       = MIFloat_MovementId.MovementItemId
                                 AND MI_Child_client.DescId   = zc_MI_Child()
                               --AND MI_Child_client.isErased = FALSE
          -- ��� ����� ����� �������
          INNER JOIN Movement ON Movement.Id     = MI_Child_client.MovementId
                             AND Movement.DescId = zc_Movement_OrderClient()

     WHERE MIFloat_MovementId.ValueData = inMovementId
       AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/
