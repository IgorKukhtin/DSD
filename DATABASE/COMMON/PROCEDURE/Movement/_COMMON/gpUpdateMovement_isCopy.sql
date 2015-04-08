-- Function: gpUpdateMovement_isCopy()

DROP FUNCTION IF EXISTS gpUpdateMovement_isCopy (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isCopy(
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inChecked             Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� �������
     inisCopy:= NOT inisCopy;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isCopy(), ioId, inisCopy);

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
-- SELECT * FROM gpUpdateMovement_isCopy (ioId:= 275079, inChecked:= 'False', inSession:= '2')
