-- Function: gpReComplete_Movement_PersonalGroupSummAdd(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalGroupSummAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroupSummAdd());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalGroupSummAdd())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalGroupSummAdd (inMovementId := inMovementId
                                             , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.02.24         *
*/

-- ����