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
  DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalGroup());

     --�������� ������� ������ ���������
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
     
     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     --��� ������������� ��� �������� - � ������ ���������  ��������� WorkTimeKind 
     -- ���� ������ ������, �� ������ � ������ ��� ���, ���������� ���� ���, ��������� � ����� ���� ��������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(inMovementId, TRUE, inSession);
     END IF;

     --
     IF vbUserId = 5 AND 1=0 THEN
        RAISE EXCEPTION 'Admin = OK'
       ;
     END IF;

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
