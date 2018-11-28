-- Function: gpReComplete_Movement_LossDebt (Integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_LossDebt(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossDebt());

     IF inMovementId = 123096 -- � 15 �� 31.12.2013
     THEN
         RAISE EXCEPTION '������.�������� �� ����� ���� �����������.';
     END IF;


     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_LossDebt())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_LossDebt (inMovementId     := inMovementId
                                         , inUserId         := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.11.18                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 11541130, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_LossDebt (inMovementId:= 11541130, inSession:= zfCalc_UserAdmin())
