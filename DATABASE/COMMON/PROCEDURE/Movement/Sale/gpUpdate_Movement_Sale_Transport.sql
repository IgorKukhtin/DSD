-- gpUpdate_Movement_Sale_Transport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Transport (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Transport (
    IN inId                            Integer   , -- ���� ������� <��������>
    IN inMovementId_Transport          Integer   , -- 
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Transport());

     -- ��������� ����� � ���������� <���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.08.15         * 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Sale_Transport (inId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inSession:= '2')
