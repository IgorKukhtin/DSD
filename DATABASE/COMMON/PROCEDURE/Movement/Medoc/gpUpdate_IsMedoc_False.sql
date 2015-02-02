-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc_False (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc_False(
   OUT onisMedoc             Boolean   , -- �� �����
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar     -- ������������
)                              
RETURNS Boolean AS --VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Medoc(), inMovementId, false);
   
   onisMedoc := False;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.15         *

*/

-- ����
-- SELECT * FROM gpUpdate_IsMedoc_False (ioId:= 0, inSession:= '2')
