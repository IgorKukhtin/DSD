-- Function: gpReComplete_Movement_BankSecondNum(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_BankSecondNum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_BankSecondNum(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankSecondNum());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_BankSecondNum())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_BankSecondNum (inMovementId := inMovementId
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