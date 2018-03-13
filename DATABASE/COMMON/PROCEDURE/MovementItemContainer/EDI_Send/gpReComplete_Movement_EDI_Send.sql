-- Function: gpReComplete_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpReComplete_Movement_EDI_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_EDI_Send(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_EDI_Send());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- �������� ��������
     PERFORM lpComplete_Movement_EDI_Send (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/
