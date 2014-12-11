-- Function: gpInsertUpdate_Movement_OrderInternal()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inOrderKindId         Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
     vbUserId := inSession;

     IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('movement_OrderInternal_seq'))::TVarChar;
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ��������� ����� � ��� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_OrderKind(), ioId, inOrderKindId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.14                         * add InvNumber
 04.12.14                         *
 11.09.14                         *
 03.07.14                                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
