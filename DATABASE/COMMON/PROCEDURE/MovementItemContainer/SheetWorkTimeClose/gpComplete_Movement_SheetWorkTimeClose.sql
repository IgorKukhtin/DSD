-- Function: gpComplete_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpComplete_Movement_SheetWorkTimeClose (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SheetWorkTimeClose(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SheetWorkTimeClose());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� �������� + ��������� ��������
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_SheetWorkTimeClose()
                                 , inUserId     := vbUserId
                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.21         *
 */

-- ����
--