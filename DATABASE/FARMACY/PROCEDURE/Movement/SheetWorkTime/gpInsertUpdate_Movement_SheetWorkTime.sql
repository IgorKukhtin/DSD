-- Function: gpInsertUpdate_Movement_SheetWorkTime(Integer, TVarChar, TDateTime, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Movement_SheetWorkTime (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTime(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime());
     vbUserId := inSession;

     PERFORM lpInsertUpdate_Movement_SheetWorkTime(ioId, inInvNumber, inOperDate, inUnitId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.13                         *
 01.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SheetWorkTime (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inSession:= '2')
