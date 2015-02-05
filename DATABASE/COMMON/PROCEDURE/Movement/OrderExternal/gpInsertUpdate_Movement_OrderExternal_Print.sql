-- Function: gpInsertUpdate_Movement_OrderExternal_Print()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternal_Print(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Print(), inId, True);

     RETURN True;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.02.15                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_Print (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')