-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpCheckMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckMovement_Checked(
 INout ioId                  Integer   , -- ���� ������� <��������>
    IN inChecked             Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;  -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

  
     -- ���������� ������� ��������
     IF inChecked = True
     THEN
         -- ������ �������� <��������> �� ����
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, False);

            
     ELSE
         -- ������ �������� <��������> �� ������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, True);
         
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.07.14         * 
*/


-- ����
-- SELECT * FROM gpCheckMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
