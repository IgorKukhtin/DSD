-- Function: gpComplete_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Transport());

     -- �������� �������� ��������
     -- PERFORM lpCheckPeriodClose(vbUserId, inMovementId);


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Transport_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_Transport (inMovementId := inMovementId
                                          , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.17         * ���������� ���������������, ������������
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 25.02.13                        * lpCheckPeriodClose
 03.11.13                                        * add RouteId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 26.10.13                                        * add CREATE TEMP TABLE...
 12.10.13                                        * del lpComplete_Movement_Income
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Transport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
