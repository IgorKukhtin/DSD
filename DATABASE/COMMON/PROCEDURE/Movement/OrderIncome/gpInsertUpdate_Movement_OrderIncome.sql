-- Function: gpInsertUpdate_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderIncome(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� (������������ ������)
    IN inOperDatePartner     TDateTime , -- 
    IN inUnitId              Integer   , -- �������������
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- ������� 
    IN inPaidKindId          Integer   , -- ����� ������
 INOUT ioCurrencyDocumentId  Integer   , -- ������ (���������)
   OUT outCurrencyDocumentName TVarChar , -- ������ (���������)

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% ������� 
   OUT outCurrencyValue      TFloat    , -- ���� ��� �������� � ������ �������
   OUT outParValue           TFloat    , -- ������� ��� �������� � ������ �������

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

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);


     --������ ��������� ����� �� �������� , ���� ������� ������, ����� �� ��� ������ � ��������
     IF COALESCE (inContractId,0) <> 0
     THEN
         ioCurrencyDocumentId := (SELECT ObjectLink_Contract_Currency.ChildObjectId
                                  FROM ObjectLink AS ObjectLink_Contract_Currency
                                  WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
                                    AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
                                  );
     END IF;
     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, ioCurrencyDocumentId);
     outCurrencyDocumentName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioCurrencyDocumentId);


     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- ������� ����� ��� �������
     IF ioCurrencyDocumentId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= ioCurrencyDocumentId, inPaidKindId:= CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);
     ELSE outCurrencyValue:= 0;
          outParValue:=0;
     END IF;
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);


     -- ����������
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
 14.04.17         *
 12.07.16         *
*/

-- ����
-- 