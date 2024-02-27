-- Function: gpUpdateMovement_Close()

DROP FUNCTION IF EXISTS gpUpdateMovement_SheetWorkTimeClose_CloseAll (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_SheetWorkTimeClose_CloseAll(
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inisClosedAll         Boolean   , -- ��� ������ �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_SheetWorkTimeClose_CloseAll());

     -- ���������� �������
     inisClosedAll:= NOT inisClosedAll;

     -- ��������� ��������
    -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAll(), ioId, inisClosedAll);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.24         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_SheetWorkTimeClose_CloseAll (ioId:= 275079, inClose:= 'False', inSession:= '2')
