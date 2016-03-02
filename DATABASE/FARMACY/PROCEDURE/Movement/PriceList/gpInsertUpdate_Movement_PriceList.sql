-- Function: gpInsertUpdate_Movement_PriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceList (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceList (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceList(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId          Integer   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PriceList());
     vbUserId := inSession;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PriceList(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <����������� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert=True 
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
     END IF;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.07.14                                                        *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PriceList (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
