-- Function: gpComplete_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderFinance (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderFinance(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderFinance());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� �������� + ��������� ��������
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_OrderFinance()
                                 , inUserId     := vbUserId
                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.19         *
 */

-- ����
--