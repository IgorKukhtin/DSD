-- Function: gpUnComplete_Movement_BankAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_BankAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_BankAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.01.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_BankAccount (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
