-- Function: gpSetErased_Movement_ChangePercent (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_ChangePercent());


     -- ��������� ��� ����������� �������������
     PERFORM lpSetErased_Movement (inMovementId := MovementLinkMovement.MovementId
                                 , inUserId     := vbUserId)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.MovementChildId = inMovementId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 24.12.14				         * add ��������� ��� ����������� �������������
 25.04.14         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ChangePercent (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
