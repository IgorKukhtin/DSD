-- Function: gpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProductionUnion (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionUnion(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsLastComplete    Boolean DEFAULT False, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF inSession IN (zc_Enum_Process_Auto_PrimeCost() :: TVarChar, zc_Enum_Process_Auto_Defroster() :: TVarChar, zc_Enum_Process_Auto_Kopchenie() :: TVarChar)
     THEN vbUserId:= lpGetUserBySession (inSession) :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionUnion());
     END IF;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId    := inMovementId
                                                , inIsHistoryCost := TRUE
                                                , inUserId        := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.05.15                                        * set lp
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 143712, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProductionUnion (inMovementId:= 143712, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 143712, inSession:= '2')
