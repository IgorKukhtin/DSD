-- Function: gpComplete_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderIncome(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderIncome());

     -- �������� ��������
     PERFORM lpComplete_Movement_OrderIncome (inMovementId     := inMovementId
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