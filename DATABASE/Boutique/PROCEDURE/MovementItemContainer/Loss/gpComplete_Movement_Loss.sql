-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
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

     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_Loss_CreateTemp();

    -- ���������� ��������
    PERFORM lpComplete_Movement_Loss (inMovementId -- ���� ���������
                                    , vbUserId     -- ������������
                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 25.04.17         *
 */