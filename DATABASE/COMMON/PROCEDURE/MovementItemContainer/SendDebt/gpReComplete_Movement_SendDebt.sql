-- Function: gpReComplete_Movement_SendDebt(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendDebt(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebt());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendDebt())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_SendDebt (inMovementId     := inMovementId
                                        , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.10.24                                        *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_SendDebt (inMovementId:= 29491314, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar)
