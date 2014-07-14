-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpUpdateMovement_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Checked(
    IN ioId                  Integer   , -- ���� ������� <��������>
    IN inChecked             Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

  
     -- ���������� ������� ��������
     IF inChecked = True
     THEN
         -- ������ �������� <��������> �� ����
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, False);

            
     ELSE
         -- ������ �������� <��������> �� ������
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, True);
         
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.07.14         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_Checked (ioId:= 275079, inChecked:= 'False', inSession:= '2')
