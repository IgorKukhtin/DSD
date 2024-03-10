-- Function: gpUnComplete_Movement_BankSecondNum (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_BankSecondNum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_BankSecondNum(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_BankSecondNum());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.03.24         * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_BankSecondNum (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
