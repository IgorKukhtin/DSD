-- Function: gpComplete_Movement_Invoice()

DROP FUNCTION IF EXISTS gpComplete_Movement_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Invoice(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice());

     -- �������� ��������
     PERFORM lpComplete_Movement_Invoice (inMovementId     := inMovementId
                                        , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.07.16         *
 */

-- ����
--