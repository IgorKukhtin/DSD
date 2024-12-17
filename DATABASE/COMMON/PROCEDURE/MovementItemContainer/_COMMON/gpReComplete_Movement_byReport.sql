-- Function: gpReComplete_Movement_byReport()

DROP FUNCTION IF EXISTS gpReComplete_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_byReport(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_());
     vbUserId:= lpGetUserBySession (inSession);
     
     
     IF COALESCE (inMovementId,0) = 0
     THEN
         RETURN;
     END IF;


    /* -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inMovementId
                                            , inUserId     := vbUserId);
    */

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 17.12.24
*/
