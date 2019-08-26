-- Function: gpComplete_wms_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_wms_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_wms_Movement_WeighingProduction(
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
     UPDATE wms_Movement_WeighingProduction
            SET StatusId = zc_Enum_Status_Complete()
     WHERE wms_Movement_WeighingProduction.Id = inMovementId;
     
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
