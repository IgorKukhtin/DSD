-- Function: gpUnComplete_Movement_PersonalGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PersonalGroup(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalGroup());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     --��� ������������� ��� �������� - � ������ ���������  ��������� WorkTimeKind 
     PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(inMovementId, TRUE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_PersonalGroup (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())