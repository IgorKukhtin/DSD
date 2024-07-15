-- Function: lpInsertUpdate_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IncomeAsset(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � �����������

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 

    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inContractId          Integer   , -- ��������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
   OUT outCurrencyPartnerName TVarChar ,
 INOUT ioCurrencyValue       TFloat    , -- ���� ������
 INOUT ioParValue            TFloat    , -- �������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId Integer;
   DECLARE vbCurrencyUser Boolean;
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

     -- ��������
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <����� ������>.';
     END IF;

     -- �������� - ��������� ��������� �������� ������
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= '���������');

     -- ����������� ������ ���������
     vbCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
     -- ����������� ������ (�����������)
     vbCurrencyPartnerId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());    

     --������ ���� �����
     vbCurrencyUser := COALESCE( (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = ioId AND MB.DescId = zc_MovementBoolean_CurrencyUser()), FALSE);


     -- ���������� ���� �������
     -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_IncomeAsset());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_IncomeAsset(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <���� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� �������� <����� ��������� � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ���������� � �������� <���� ��� �������� � ������ �������>
     --outCurrencyValue := 1.00; 
     --���� ������ ���� ����� �� ������ ������ �����
     IF COALESCE (vbCurrencyUser, FALSE) = FALSE         --���� ������ ���� �� ������������� ����
     THEN
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
                                                               , inPaidKindId     := CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END
                                                                )            AS tmp;
                     ELSE 
                         SELECT tmp.Amount, tmp.ParValue
                         INTO ioCurrencyValue, ioParValue
                         FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                               , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                               , inCurrencyToId   := inCurrencyPartnerId
                                                               , inPaidKindId     := CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END
                                                                )            AS tmp;
                     END IF;    
                 END IF;
             ELSE IF (inCurrencyDocumentId = inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
                  THEN
                      SELECT tmp.Amount, tmp.ParValue
                      INTO ioCurrencyValue, ioParValue
                      FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                            , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                            , inCurrencyToId   := inCurrencyDocumentId
                                                            , inPaidKindId     := CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END
                                                             )            AS tmp;
                  END IF;
             END IF;
         ELSE ioCurrencyValue := 1.00; ioParValue := 1.00;
         END IF;
     ELSE 
         --���������� ����������� ��������
         ioCurrencyValue := COALESCE( (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_CurrencyValue()), 1);
         ioParValue      := COALESCE( (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_ParValue()), 1);
         inCurrencyDocumentId := vbCurrencyDocumentId;
         inCurrencyPartnerId  := vbCurrencyPartnerId;
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

     outCurrencyPartnerName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inCurrencyPartnerId);

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
 06.10.16         * parce
 25.07.16         *
*/

-- ����
-- 