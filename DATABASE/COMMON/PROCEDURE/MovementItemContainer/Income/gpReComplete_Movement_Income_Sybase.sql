-- Function: gpReComplete_Movement_Income_Sybase()

DROP FUNCTION IF EXISTS gpReComplete_Movement_Income_Sybase (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Income_Sybase(
    IN inMovementId        Integer                , -- ���� ���������
    IN inContractId        Integer                , -- 
    IN inSession           TVarChar                 -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());


     IF (inContractId <> 0) OR 0 <> (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Contract())
     THEN
          -- ����������� ��������
          PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                       , inUserId     := vbUserId);

          -- ��������� ����� � <��������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);

          IF EXISTS (SELECT * FROM Movement WHERE Movement.Id = inMovementId AND DescId = zc_Movement_Income())
          THEN
              -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
              PERFORM lpComplete_Movement_Income_CreateTemp();
              -- �������� ��������
              PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                                , inUserId         := vbUserId
                                                , inIsLastComplete := NULL);
          ELSE
              -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
              PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
              -- �������� ��������
              PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                                   , inUserId         := vbUserId
                                                   , inIsLastComplete := NULL);
          END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.04.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Income_Sybase (inMovementId:= 149639, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
