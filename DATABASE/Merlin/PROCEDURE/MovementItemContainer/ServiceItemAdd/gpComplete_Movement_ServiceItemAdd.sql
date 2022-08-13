-- Function: gpComplete_Movement_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpComplete_Movement_ServiceItemAdd  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ServiceItemAdd(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;

     -- ��������
     PERFORM lpComplete_Movement_ServiceItemAdd (inMovementId  -- ���� ���������
                                               , vbUserId      -- ������������
                                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
 */
 