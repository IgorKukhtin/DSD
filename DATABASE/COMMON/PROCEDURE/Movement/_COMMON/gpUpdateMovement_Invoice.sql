-- Function: gpUpdateMovement_Invoice()

DROP FUNCTION IF EXISTS gpUpdateMovement_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Invoice(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UpdateMovement_Invoice());

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
-- SELECT * FROM gpUpdateMovement_Invoice (ioId:= 275079, inInvoice:= 'False', inSession:= '2')
