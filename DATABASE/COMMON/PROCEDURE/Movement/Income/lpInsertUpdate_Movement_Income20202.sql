-- Function: lpInsertUpdate_Movement_Income20202()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income20202 (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income20202(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������

    IN inis20202             Boolean   , -- ����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
 INOUT ioCurrencyValue       TFloat    , -- ���� ������
 INOUT ioParValue            TFloat    , -- �������
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyValue TFloat;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF 1 = 0 AND COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;
     
     -- ����������� ������ ���������
     vbCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
     -- ����������� ������ (�����������)
     vbCurrencyPartnerId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());    

     -- �������� - ��������� ��������� �������� ������
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= '���������');


     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Income());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_is20202(), ioId, inis20202);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ���������� � �������� <���� ��� �������� � ������ �������>   -- �� ���-�� ���
     --outCurrencyValue := 1.00;
     IF (inCurrencyDocumentId <> inCurrencyPartnerId) OR (inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyPartnerId <> zc_Enum_Currency_Basis())
     THEN
         IF (inCurrencyDocumentId <> inCurrencyPartnerId)
         THEN
             -- ���� ���������� ������ ��������� ��� ���� �������� ����� = 0
             IF (vbCurrencyDocumentId <> inCurrencyDocumentId OR vbCurrencyPartnerId <> inCurrencyPartnerId OR COALESCE (ioCurrencyValue, 0) = 0) 
             OR (inCurrencyDocumentId <> inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
             THEN
                 IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
                 THEN
                     SELECT tmp.Amount, tmp.ParValue
                     INTO ioCurrencyValue, ioParValue
                     FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                           , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                           , inCurrencyToId   := inCurrencyDocumentId
                                                           , inPaidKindId     := inPaidKindId)            AS tmp;
                 ELSE 
                     SELECT tmp.Amount, tmp.ParValue
                     INTO ioCurrencyValue, ioParValue
                     FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                           , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                           , inCurrencyToId   := inCurrencyPartnerId
                                                           , inPaidKindId     := inPaidKindId)            AS tmp;
                 END IF;    
             END IF;
         ELSE IF (inCurrencyDocumentId = inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
              THEN
                  SELECT tmp.Amount, tmp.ParValue
                  INTO ioCurrencyValue, ioParValue
                  FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                        , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                        , inCurrencyToId   := inCurrencyDocumentId
                                                        , inPaidKindId     := inPaidKindId)            AS tmp;
              END IF;
         END IF;
     ELSE ioCurrencyValue := 1.00; ioParValue := 1.00;
     END IF; 
     
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, ioCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, ioParValue);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- ��������� ����� � <������ (�����������) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.21         * 20202
 22.11.18         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Income20202 (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
