-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCurrencyPartnerValue TFloat    ,
    IN inParPartnerValue      TFloat    ,
 
    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� �������

    IN inCurrencyValue        TFloat    , --
    IN inParValue             TFloat    , --
    
    IN inCashId               Integer   , --+
    IN inCurrencyId           Integer   ,
    IN inMoneyPlaceId         Integer   , --
    IN inInfoMoneyId          Integer   ,
    IN inUnitId               Integer   ,
    IN inComment              TVarChar  , -- ����������
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert       Boolean;
   DECLARE vbAmount         TFloat;
   DECLARE vbMovementItemId Integer;
   DECLARE vbCurrencyPartnerId Integer;
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
/*
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
*/

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


     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;


     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);
    
     
----     
     -- ����� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ������
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- ����������
     vbCurrencyPartnerId:= zc_Currency_Basis();
                                   
     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId, Null::integer, ioId, vbAmount, Null, inUserId);


     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
      -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
    
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);


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
 06.07.18         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
