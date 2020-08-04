-- Function: gpComplete_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProfitIncomeService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProfitIncomeService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

/*
     -- !!!�������� - ���������!!!
     UPDATE MovementItem SET Amount = CAST (MovementItem.Amount AS NUMERIC (16, 2))
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> CAST (MovementItem.Amount AS NUMERIC (16, 2))
    ;
*/

     -- �������� ��������
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.07.20         * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProfitIncomeService (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
