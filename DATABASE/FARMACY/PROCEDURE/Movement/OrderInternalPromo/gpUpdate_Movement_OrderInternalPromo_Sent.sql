-- Function: gpUpdate_Movement_OrderInternalPromo_Sent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromo_Sent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderInternalPromo_Sent(
    IN inMovementId            Integer    , -- ���� ������� <��������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF vbUserId = 3
    THEN
      RETURN;
    END IF;
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_DATE);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.04.22                                                       *
*/


SELECT * FROM gpUpdate_Movement_OrderInternalPromo_Sent (inMovementId := 27547547 , inSession := '3');
