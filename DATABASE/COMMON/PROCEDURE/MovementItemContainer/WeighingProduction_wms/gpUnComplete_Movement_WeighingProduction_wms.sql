-- Function: gpUnComplete_Movement_WeighingProduction_wms (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_WeighingProduction_wms (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_WeighingProduction_wms (
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_WeighingProduction());

     -- ����������� ��������
     UPDATE Movement_WeighingProduction
            SET StatusId = zc_Enum_Status_UnComplete()
     WHERE Movement_WeighingProduction.Id = inMovementId;
     
     /*PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
      */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.05.19         *
*/

-- ����
--