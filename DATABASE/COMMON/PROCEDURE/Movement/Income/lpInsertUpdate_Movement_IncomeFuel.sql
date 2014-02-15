-- Function: lpInsertUpdate_Movement_IncomeFuel()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeFuel (Integer, Integer, TVarChar, TVarChar, TDateTime, boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeFuel (Integer, Integer, TVarChar, TDateTime, TDateTime, TVarChar, boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeFuel (Integer, Integer, TVarChar, TDateTime, TDateTime, TVarChar, boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IncomeFuel(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ���� Master <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ����
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inAccessKeyId         Integer   , -- 
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, inParentId, inAccessKeyId);

     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <������ � ����>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePrice(), ioId, inChangePrice);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
     -- ��������� ����� � <��������� (��������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalDriver(), ioId, inPersonalDriverId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_Movement_IncomeFuel (Integer, Integer, TVarChar, TDateTime, TDateTime, TVarChar, boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.13                                        * add inAccessKeyId
 31.10.13                                        * add inOperDatePartner
 19.10.13                                        * add inChangePrice
 05.10.13                                        * add inInvNumberPartner
 04.10.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inAccessKeyId:= 1, inSession:= '2')
