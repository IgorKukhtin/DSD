-- Function: lpComplete_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeAsset (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer                 -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN

/*
     -- ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeAsset()
                                , inUserId     := inUserId
                                 );
*/
     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Income_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                       , inUserId         := inUserId
                                       , inIsLastComplete := FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.16         *
 
*/

-- ����
/*
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpComplete_Movement_IncomeAsset (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer, inIsLastComplete:= FALSE)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1100 , inSession:= zfCalc_UserAdmin())
*/
