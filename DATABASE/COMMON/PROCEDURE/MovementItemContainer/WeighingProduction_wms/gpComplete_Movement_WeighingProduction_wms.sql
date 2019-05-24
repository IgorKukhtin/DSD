-- Function: gpComplete_Movement_WeighingProduction_wms (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_WeighingProduction_wms (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WeighingProduction_wms(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_WeighingProduction());

     -- �������� �������� + ��������� ��������
     UPDATE Movement_WeighingProduction
            SET StatusId = zc_Enum_Status_Complete()
     WHERE Movement_WeighingProduction.Id = inMovementId;
     
     /*PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );
     */
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.15         *
*/

-- ����
