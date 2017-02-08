-- Function: gpUpdateMovement_isCopy()

DROP FUNCTION IF EXISTS gpUpdateMovement_isCopy (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isCopy(
    IN ioId                  Integer   , -- ���� ������� <��������>
    IN inIsCopy              Boolean   , -- 
   OUT outIsCopy             Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UpdateMovement_isCopy());

     -- ���������� �������
     outIsCopy:= NOT inIsCopy;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isCopy(), ioId, outIsCopy);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 15.08.14         * 
*/

-- ����
-- SELECT * FROM gpUpdateMovement_isCopy (ioId:= 275079, inIsCopy:= 'False', inSession:= '2')
