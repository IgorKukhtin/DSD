-- Function: gpInsertUpdate_Movement_Send_Order()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send_Order (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send_Order(
    IN inId                      Integer   , -- ���� ������� <�������� �����������>
    IN inMovementId_Order        Integer   , -- ������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.20         *
*/

-- ����
-- 