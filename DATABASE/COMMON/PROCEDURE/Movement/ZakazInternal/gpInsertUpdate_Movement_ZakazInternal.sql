-- Function: gpInsertUpdate_Movement_ZakazInternal()

-- DROP FUNCTION gpInsertUpdate_Movement_ZakazInternal (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ZakazInternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ZakazInternal());
     vbUserId := inSession;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ZakazInternal(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ZakazInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
