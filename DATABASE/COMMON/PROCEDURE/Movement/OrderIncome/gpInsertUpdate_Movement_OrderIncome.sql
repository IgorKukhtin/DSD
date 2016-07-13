-- Function: gpInsertUpdate_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderIncome(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� (������������ ������)
    IN inPartnerId           Integer   , -- ���������
    IN inContractId          Integer   , -- ������� 
    IN inPaidKindId          Integer   , -- ����� ������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 
   OUT outCurrencyValue      TFloat    , -- ���� ������

    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderIncome(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <���� ������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_InsertDate(), ioId, outInsertDate);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);


     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ���������� � �������� <���� ��� �������� � ������ �������>
     outCurrencyValue := 1.00;
  /*   outCurrencyValue:= (SELECT MovementItem.Amount
                         FROM (SELECT MAX (Movement.OperDate) as maxOperDate
                               FROM Movement 
                                    JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.ObjectId = inCurrencyDocumentId
                                    JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                                               AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
                               WHERE Movement.DescId = zc_Movement_Currency()
                                 AND Movement.OperDate <= inOperDate
                                 AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())   
                              ) AS tmpDate
                                INNER JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                                                   AND Movement.OperDate = tmpDate.maxOperDate
                                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()/*, zc_Enum_Status_UnComplete()*/)
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                       AND MovementItem.DescId = zc_MI_Master()
                            );
     END IF;
*/    
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);



     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
         END IF;

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
 12.07.16         *
*/

-- ����
-- 