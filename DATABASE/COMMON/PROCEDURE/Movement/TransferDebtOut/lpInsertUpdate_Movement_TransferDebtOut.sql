-- Function: lpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);



CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransferDebtOut(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������
    IN inInvNumberOrder      TVarChar  , -- ����� ������ �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inChecked             Boolean   , -- ��������
 INOUT ioPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
 INOUT ioVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindFromId      Integer   , -- ���� ���� ������
    IN inPaidKindToId        Integer   , -- ���� ���� ������
    IN inContractFromId      Integer   , -- ��������
    IN inContractToId        Integer   , -- ��������
    IN inPartnerId           Integer   , -- ���������� (����)
    IN inPartnerFromId       Integer   , -- ���������� (�� ����)
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceListId Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractFromId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <������� (�� ����)>.';
     END IF;

     -- ��������
     IF COALESCE (inContractToId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <������� (����)>.';
     END IF;

     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- �����-����
     -- !!!������!!!
     SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
            INTO vbPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractToId
                                               , inPartnerId      := inToId
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := NULL
                                               , inOperDatePartner:= inOperDate
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE  -- !!!�������� ����� �� �����!!!
                                               , inOperDatePartner_order:= NULL
                                                ) AS tmp;
/*   IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- !!!������!!!
         SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
                INTO ioPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractToId
                                                   , inPartnerId      := inToId
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := NULL
                                                   , inOperDatePartner:= inOperDate
                                                   , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                                   , inIsPrior        := FALSE  -- !!!�������� ����� �� �����!!!
                                                   , inOperDatePartner_order:= NULL
                                                    ) AS tmp;
     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , ObjectFloat_VATPercent.ValueData                       AS VATPercent
                INTO outPriceListName, ioPriceWithVAT, ioVATPercent
         FROM Object AS Object_PriceList
              LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                      ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                     AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
              LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                    ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                   AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
         WHERE Object_PriceList.Id = ioPriceListId;
     END IF;
     */
     -- -----


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtOut(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, ioPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, ioVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� �������� <�����>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- ��������� ����� � <���������� (����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- ��������� ����� � <���������� (�� ����)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerFrom(), ioId, inPartnerFromId);
     -- ��������� ����� � <�����-����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, vbPriceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.08.21         *
 02.02.16         * add inPartnerFromId
 17.12.14         * add inInvNumberOrder
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add vbAccessKeyId
 07.05.14                                        * add inPartnerId
 03.05.14                                        * del inMasterId, ioPriceListId, outPriceListName
 24.04.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_TransferDebtOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', ioPriceWithVAT:= true, ioVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
--