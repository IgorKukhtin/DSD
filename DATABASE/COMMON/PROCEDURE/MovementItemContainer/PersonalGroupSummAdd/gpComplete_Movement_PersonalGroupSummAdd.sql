-- Function: gpComplete_Movement_PersonalGroupSummAdd (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalGroupSummAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroupSummAdd());

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