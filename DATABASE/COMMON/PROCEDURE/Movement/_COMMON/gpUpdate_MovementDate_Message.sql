-- Function: gpUpdate_MovementDate_Message()

DROP FUNCTION IF EXISTS gpUpdate_MovementDate_Message (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementDate_Message(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Message(), inMovementId, CURRENT_TIMESTAMP);

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.22                                        *
*/


-- ����
-- SELECT * FROM gpUpdate_MovementDate_Message (ioId:= 275079, inSession:= '2')
