-- Function: gpUpdateMovement_Checked()

DROP FUNCTION IF EXISTS gpUpdateMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Checked(
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
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� �������
     inChecked:= NOT inChecked;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 15.08.14                                        * add lpInsert_MovementProtocol
 20.07.14                                        * all
 09.07.14         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
