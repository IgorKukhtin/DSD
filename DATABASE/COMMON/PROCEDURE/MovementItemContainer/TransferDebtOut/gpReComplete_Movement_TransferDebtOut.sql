-- Function: gpReComplete_Movement_TransferDebtOut(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TransferDebtOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TransferDebtOut(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransferDebtOut());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_TransferDebtOut())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_TransferDebt_all_CreateTemp();
     -- �������� ��������
     outMessageText:= lpComplete_Movement_TransferDebt_all (inMovementId     := inMovementId
                                                          , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.04.15                                        *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_TransferDebtOut (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
