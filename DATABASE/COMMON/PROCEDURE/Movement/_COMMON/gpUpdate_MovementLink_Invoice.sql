-- Function: gpUpdate_MovementLink_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_MovementLink_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementLink_Invoice(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inMovementId_Invoice   Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MovementLink_Invoice());

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inId, inMovementId_Invoice);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.07.16         * 
*/

-- ����
-- SELECT * FROM gpUpdate_MovementLink_Invoice (ioId:= 275079, inInvoice:= 'False', inSession:= '2')
