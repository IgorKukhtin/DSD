-- Function: gpInsertUpdate_Movement_OrderExternal_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_Sybase (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternal_Sybase(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ������ � �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� �������� ������ �� �����������
    IN inOperDateMark        TDateTime , -- ���� ����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inPersonalId          Integer   , -- ��������� (����������)
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) OR inOperDateMark <> DATE_TRUNC ('DAY', inOperDateMark)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;
     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateMark(), ioId, inOperDateMark);
     -- ��������� �������� <���� �������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
     -- ��������� ����� � <���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- ��������� ����� � <��������� (����������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);

     -- ���������� ���� ��� ������
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- ����� ������ � ��������� �������: 0.1) ��������� � �������� 0.2) ������� � �������� 1) ��������� � ����������� 2) ������� � ����������� 3) ��������� � ��.���� 4) ������� � ��.���� 5) zc_PriceList_Basis
         SELECT tmp.PriceListName, tmp.PriceListId
                INTO outPriceListName, ioPriceListId
         FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= inOperDate) AS tmp;
     ELSE
         -- ����� ����� �� ���������, ���� ������� ������ ��� ��������
         SELECT Object.valuedata INTO outPriceListName FROM Object WHERE Object.Id = ioPriceListId;
     END IF;

     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.14                                                        *
 25.08.14                                        * all
 18.08.14                                                        *
 06.06.14                                                        *
 01.08.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_Sybase (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
