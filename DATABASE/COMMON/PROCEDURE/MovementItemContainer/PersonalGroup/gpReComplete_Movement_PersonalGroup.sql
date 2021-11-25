-- Function: gpReComplete_Movement_PersonalGroup(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalGroup(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroup());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalGroup())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement_PersonalGroup (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalGroup (inMovementId     := inMovementId
                                              , inUserId         := vbUserId);

     --��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup (inMovementId, FALSE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- 