-- Function: gpComplete_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_MemberHoliday());

     --��������  �� ���� ������ �������, ���� ��� ������ � �����-�� ���� �������� ������ ��� �� ����  ��������� � ���� � �.�.
     PERFORM gpGet_MemberHoliday_Check_byPersonalGroup (inMovementId, inSession);
     
     -- ��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, FALSE, (-1 * vbUserId)::TVarChar);

    -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MemberHoliday()
                                , inUserId     := vbUserId
                                 );

-- !!! �������� !!!
IF vbUserId = 5 AND 1=1 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
