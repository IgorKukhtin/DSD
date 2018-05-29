-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������
   -- IN inOperDatePartner     TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inParentId            Integer   , -- ��������� ���������
    IN inReturnTypeId        Integer   , -- ��� ��������
    IN inLegalAddressId      Integer   , -- ����������� ����� ����������
    IN inActualAddressId     Integer   , -- ����������� ����� ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnOut(), inInvNumber, inOperDate, inParentId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <���� ���>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NDSKind(), ioId, inNDSKindId);
     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, (Select ValueData from ObjectFloat Where ObjectID = inNDSKindId AND DescId = zc_ObjectFloat_NDSKind_NDS()));

     -- ��������� ����� � <����� ��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReturnType(), ioId, inReturnTypeId);

     -- ��������� ����� � <����������� ����� ����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_LegalAddress(), ioId, inLegalAddressId);

     -- ��������� ����� � <����������� ����� ����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ActualAddress(), ioId, inActualAddressId);

     -- ����������� � ��������� ���������
     --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 28.05.18                                                                     * 
 15.09.16         *
 06.02.15                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
