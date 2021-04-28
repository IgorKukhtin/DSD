-- Function: gpReComplete_Movement_Currency()

DROP FUNCTION IF EXISTS gpReComplete_Movement_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Currency(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Currency());

     --  ������
     IF vbUserId = zfCalc_UserAdmin() :: Integer
     THEN
         vbUserId:= zc_Enum_Process_Auto_PrimeCost();
     END IF;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_Currency (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.12.16                                        *
*/
