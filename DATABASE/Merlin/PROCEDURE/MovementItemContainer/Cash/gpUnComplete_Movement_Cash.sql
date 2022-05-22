-- Function: gpUnComplete_Movement_Cash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Cash(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.01.22         *
*/
