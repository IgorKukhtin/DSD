-- Function: gpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId                  Integer   , -- ���� ������� <�������� >
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� (������������ ������)
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � ����������
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- ������� 
    IN inPaidKindId          Integer   , -- ����� ������
 INOUT ioCurrencyDocumentId  Integer   , -- ������ (���������)
   OUT outCurrencyDocumentName TVarChar , -- ������ (���������)
    
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 
 INOUT ioCurrencyValue       TFloat    , -- ���� ������
 INOUT ioParValue            TFloat    , -- ������� ��� �������� � ������ �������

 INOUT ioTotalSumm_f1        TFloat    , --
 INOUT ioTotalSumm_f2        TFloat    , --
 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyDocumentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());


     -- ��������
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <����� ������>.';
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     --������ ��������� ����� �� 1) �� ������, ���� ��� ����� 2) �� �������� , ���� � ��� �����, ����� �� ��� ������ � ��������
     vbCurrencyDocumentId := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                              FROM MovementItem
                                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementItemId()
                                                               AND MIFloat_MovementId.ValueData      > 0
                                   INNER JOIN MovementItem AS MI_OrderIncome ON MI_OrderIncome.Id = MIFloat_MovementId.ValueData :: Integer
                                                                            AND MI_OrderIncome.isErased = FALSE
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                                 ON MovementLinkObject_CurrencyDocument.MovementId = MI_OrderIncome.MovementId
                                                                AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                              WHERE MovementItem.MovementId = ioId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.Amount     > 0
                              ORDER BY MovementItem.Id DESC
                              LIMIT 1);
     
     IF COALESCE (inContractId,0) <> 0 AND COALESCE (vbCurrencyDocumentId,0) = 0
     THEN
         vbCurrencyDocumentId := (SELECT ObjectLink_Contract_Currency.ChildObjectId
                                  FROM ObjectLink AS ObjectLink_Contract_Currency
                                  WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
                                    AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
                                  );
     END IF;
     --���������� 
     ioCurrencyDocumentId := COALESCE (vbCurrencyDocumentId,ioCurrencyDocumentId);
     outCurrencyDocumentName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioCurrencyDocumentId);
     
     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, ioCurrencyDocumentId);
          

     -- ��������� �������� <����� ��������� � ����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ������� ����� ��� �������
     IF (ioCurrencyDocumentId <> zc_Enum_Currency_Basis()) /*AND COALESCE (ioId, 0) = 0*/ AND COALESCE (ioCurrencyValue,0) = 0
     THEN 
         SELECT Amount, ParValue 
      INTO ioCurrencyValue, ioParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= ioCurrencyDocumentId, inPaidKindId:= CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);
   --  ELSE outCurrencyValue:= 0;
   --       outParValue:=0;
     END IF;
  
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, ioCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, ioParValue);


     -- ����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     --
     IF inPaidKindId = zc_Enum_PaidKind_FirstForm()
     THEN
         -- ��������� �������� <����� ����� ������ �� ������ ����� ������> ���
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), ioId, COALESCE (ioTotalSumm_f2,0));
     ELSE 
         -- ��������� �������� <����� ����� ������ �� ������ ����� ������> �/�
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), ioId, COALESCE (ioTotalSumm_f1,0));
     END IF;     

     IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
         END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     SELECT -- ������ �/�
            CASE WHEN inPaidKindId = zc_Enum_PaidKind_FirstForm()
                 THEN CASE WHEN ioCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
                           THEN MovementFloat_TotalSumm.ValueData         - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                           ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                      END 
                 ELSE ioTotalSumm_f1
            END AS TotalSumm_f1

             -- ������ ���
          , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm()
                 THEN CASE WHEN ioCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
                           THEN MovementFloat_TotalSumm.ValueData         - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                           ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                      END 
                 ELSE ioTotalSumm_f2
            END AS TotalSumm_f2

            INTO ioTotalSumm_f1, ioTotalSumm_f2

     FROM MovementFloat AS MovementFloat_TotalSumm
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                  ON MovementFloat_TotalSummPayOth.MovementId = MovementFloat_TotalSumm.MovementId
                                 AND MovementFloat_TotalSummPayOth.DescId = zc_MovementFloat_TotalSummPayOth()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCurrency
                                  ON MovementFloat_TotalSummCurrency.MovementId =  MovementFloat_TotalSumm.MovementId
                                 AND MovementFloat_TotalSummCurrency.DescId = zc_MovementFloat_AmountCurrency()
     WHERE MovementFloat_TotalSumm.MovementId = ioId
       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();

     IF COALESCE (ioTotalSumm_f1,0) < 0 OR COALESCE (ioTotalSumm_f2,0) < 0
     THEN
          RAISE EXCEPTION '������.����� (�/��� - ���) �� ����� ���� ������ 0.';
     END IF;
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.03.19         * 
 25.07.16         * inInvNumberPartner
 15.07.16         *
*/

-- ����
-- 