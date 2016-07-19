-- Function: gpComplete_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderIncome (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderIncome(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderIncome());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Complete(), inComment:= '��������');


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     -- PERFORM lpComplete_Movement_OrderIncome_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_OrderIncome (inMovementId     := inMovementId
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