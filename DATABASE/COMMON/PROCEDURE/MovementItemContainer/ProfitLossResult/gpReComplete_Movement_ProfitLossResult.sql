-- Function: gpReComplete_Movement_Send(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ProfitLossResult (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ProfitLossResult(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProfitLossResult());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProfitLossResult())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     -- PERFORM lpComplete_Movement_ProfitLossResult_CreateTemp();
     -- �������� ��������
     PERFORM gpComplete_Movement_ProfitLossResult (inMovementId     := inMovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����
-- 