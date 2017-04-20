-- Function: gpComplete_Movement_Visit()

DROP FUNCTION IF EXISTS gpComplete_Movement_Visit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Visit(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Visit());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� �������� + ��������� ��������
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_Visit()
                                 , inUserId     := vbUserId
                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.17         *
 */

-- ����
--