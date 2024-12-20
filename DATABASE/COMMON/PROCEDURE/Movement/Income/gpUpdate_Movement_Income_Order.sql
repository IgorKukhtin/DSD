-- gpUpdate_Movement_Income_Order()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_Order (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_Order (
    IN inId                            Integer   , -- ���� ������� <��������>
    IN inMovementId_Order          Integer   , -- 
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     -- ��������� ����� � ���������� <������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.04.17         * 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Income_Order (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
