-- Function: gpSetErased_Movement_Invoice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Invoice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Invoice());

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- ������� ����� � ���������� ������ / ����� ���� ����� ����
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), MLM.MovementId, inMovementId)
    FROM MovementLinkMovement AS MLM
    WHERE MLM.DescId = zc_MovementLinkMovement_Invoice()
      AND MLM.MovementChildId = inMovementId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/
