-- Function: gpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� (������������ ������)
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� � ����������
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- ������� 
    IN inPaidKindId          Integer   , -- ����� ������
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 
   OUT outCurrencyValue      TFloat    , -- ���� ������
   OUT outParValue           TFloat    , -- ������� ��� �������� � ������ �������

 INOUT ioTotalSumm_f1        TFloat    , --
 INOUT ioTotalSumm_f2        TFloat    , --
 
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());

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

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);

     -- ��������� �������� <����� ��������� � ����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ������� ����� ��� �������
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId, inPaidKindId:= CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);
     ELSE outCurrencyValue:= 0;
          outParValue:=0;
     END IF;
  
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);


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
                 THEN CASE WHEN inCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
                           THEN MovementFloat_TotalSumm.ValueData         - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                           ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                      END 
                 ELSE ioTotalSumm_f1
            END AS TotalSumm_f1

             -- ������ ���
          , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm()
                 THEN CASE WHEN inCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
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