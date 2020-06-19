-- Function: gpComplete_Movement_LossAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_LossAsset (Integer,  TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LossAsset(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= inSession :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossAsset());
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Loss_CreateTemp();
  
     -- !!!��������!!!
     /*PERFORM lpComplete_Movement_Loss (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );
       */
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_LossAsset()
                                 , inUserId     := vbUserId
                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.20         *
*/
