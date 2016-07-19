-- Function: gpComplete_Movement_Invoice()

DROP FUNCTION IF EXISTS gpComplete_Movement_Invoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Invoice(
    IN inMovementId        Integer                , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT False , -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Complete(), inComment:= '��������');


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Invoice_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_Invoice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId
                                            , inIsLastComplete := inIsLastComplete);

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