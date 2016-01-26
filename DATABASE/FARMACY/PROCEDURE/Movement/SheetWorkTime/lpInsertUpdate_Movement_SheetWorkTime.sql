-- Function: lpInsertUpdate_Movement_SheetWorkTime(Integer, TVarChar, TDateTime, Integer, TVarChar)

-- DROP FUNCTION lpInsertUpdate_Movement_SheetWorkTime (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SheetWorkTime(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer     -- �������������
)                              
RETURNS Integer AS
$BODY$
BEGIN

     IF inInvNumber = '' THEN
        inInvNumber := lfGet_InvNumber (0, zc_Movement_SheetWorkTime())::TVarChar;
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SheetWorkTime(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <�������������� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.13                        *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_SheetWorkTime (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inSession:= '2')
