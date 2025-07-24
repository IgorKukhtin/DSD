-- Function: gpReComplete_Movement_HospitalDoc_1C(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_HospitalDoc_1C (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_HospitalDoc_1C(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_HospitalDoc_1C());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_HospitalDoc_1C())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_HospitalDoc_1C (inMovementId     := inMovementId
                                               , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.25         *
*/

-- ����
-- 