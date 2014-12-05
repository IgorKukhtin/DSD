-- Function: gpInsertUpdate_Movement_Income()

-- DROP FUNCTION gpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inContractId          Integer   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     vbUserId := inSession;

     ioId := lpInsertUpdate_Movement_Income(ioId, inInvNumber, inOperDate, inPriceWithVAT
                                          , inFromId, inToId, inNDSKindId, inContractId, vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.14                                                        *
 10.07.14                                                        *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
