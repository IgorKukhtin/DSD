-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCurrencyPartnerValue TFloat    ,
    IN inParPartnerValue      TFloat    ,
    IN inAmountCurrency       TFloat    ,
    IN inAmount               TFloat    ,

    IN inAmount_MI            TFloat    ,    
    IN inCashId               Integer   , --
    IN inMoneyPlaceId         Integer   , --
    IN inInfoMoneyId          Integer   ,
    IN inUnitId               Integer   ,
    IN inCurrencyId           Integer   , --
    IN inCurrencyValue        TFloat    , --
    IN inParValue             TFloat    , --
    IN inComment              TVarChar  , -- ����������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert     Boolean;
   DECLARE vbId_sale_part Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- �������� - ���������
     IF COALESCE (inCashId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <�����>.';
     END IF;

     -- ��������
     IF COALESCE (inCurrencyId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     -- ���� �� ������� ������
     IF inCurrencyId <> zc_Currency_Basis() THEN
        -- ��������
        IF COALESCE (inCurrencyValue, 0) = 0 THEN
           RAISE EXCEPTION '������.�� ���������� �������� <����>.';
        END IF;
        -- ��������
        IF COALESCE (inParValue, 0) = 0 THEN
           RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
        END IF;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement (ioId        := ioId
                                   , inDescId    := zc_Movement_Cash()
                                   , inInvNumber := inInvNumber
                                   , inOperDate  := inOperDate
                                   , inParentId  := NULL
                                   , inUserId    := inUserId
                                    );

     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 09.06.17                                                       *  add inUserId in lpInsertUpdate_Movement
 10.04.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
