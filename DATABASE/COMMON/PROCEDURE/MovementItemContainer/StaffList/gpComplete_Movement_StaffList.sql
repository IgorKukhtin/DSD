-- Function: gpComplete_Movement_StaffList()

DROP FUNCTION IF EXISTS gpComplete_Movement_StaffList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_StaffList(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_StaffList());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� �������� + ��������� ��������
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_StaffList()
                                 , inUserId     := vbUserId
                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.08.25         *
 */

-- ����
--