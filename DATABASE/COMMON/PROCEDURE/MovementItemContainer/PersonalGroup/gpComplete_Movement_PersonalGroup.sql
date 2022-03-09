-- Function: gpComplete_Movement_PersonalGroup()

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalGroup(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroup());


     -- ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- ������� ��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(inMovementId, FALSE, inSession);

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement_PersonalGroup (inMovementId := inMovementId
                                              , inUserId     := vbUserId
                                             );


-- !!! �������� !!!
IF vbUserId = 5 AND 1=0 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
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
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
