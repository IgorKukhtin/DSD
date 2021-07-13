-- Function: gpUnComplete_Movement_ProductionUnion (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ProductionUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ProductionUnion(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ProductionUnion());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


    -- ����� ������������� ��� ��������� - ���������� ��� ��� zc_MIFloat_MovementId    
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), MIFloat_MovementId.MovementItemId, 0)
    FROM MovementItemFloat AS MIFloat_MovementId
         INNER JOIN MovementItem AS MI_Child_client
                                 ON MI_Child_client.Id = MIFloat_MovementId.MovementItemId
                                AND MI_Child_client.DescId   = zc_MI_Child()
    WHERE MIFloat_MovementId.ValueData ::Integer = inMovementId
      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/