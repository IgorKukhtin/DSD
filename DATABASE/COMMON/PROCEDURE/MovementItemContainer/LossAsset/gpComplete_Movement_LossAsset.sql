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
     THEN vbUserId:= lpGetUserBySession (inSession)  :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossAsset());
     END IF;

/*IF vbUserId = 5
then
   update Movement set OperDate = '31.08.2020' where Id = inMovementId;
end if;
*/
     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Loss_CreateTemp();

     -- !!!��������!!!
     PERFORM lpComplete_Movement_Loss (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.20         *
*/
