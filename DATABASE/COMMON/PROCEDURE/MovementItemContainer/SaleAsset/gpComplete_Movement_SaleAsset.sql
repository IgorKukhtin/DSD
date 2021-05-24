-- Function: gpComplete_Movement_SaleAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_SaleAsset (Integer,  TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SaleAsset(
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
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleAsset());
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Sale_CreateTemp();
  
     -- !!!��������!!!
     PERFORM lpComplete_Movement_Sale (inMovementId:= inMovementId
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
