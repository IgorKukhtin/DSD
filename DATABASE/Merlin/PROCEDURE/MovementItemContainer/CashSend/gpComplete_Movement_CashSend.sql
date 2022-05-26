-- Function: gpComplete_Movement_CashSend()

DROP FUNCTION IF EXISTS gpComplete_Movement_CashSend  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CashSend(
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
 
    -- ���������� ��������
    PERFORM lpComplete_Movement_CashSend(inMovementId, -- ���� ���������
                                         vbUserId);    -- ������������  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
 */