-- Function: gpComplete_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_EDI_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_EDI_Send(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_EDI_Send());

     -- �������� ��������
     PERFORM lpComplete_Movement_EDI_Send (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_EDI_Send (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
