-- Function: gpSetErased_Movement_ServiceItemAdd (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ServiceItemAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ServiceItemAdd(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- ��������������� ������ � �����������
     PERFORM lpUpdate_Movement_Service_restore (inMovementId_sia:= inMovementId
                                              , inUserId         := vbUserId
                                               );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/
