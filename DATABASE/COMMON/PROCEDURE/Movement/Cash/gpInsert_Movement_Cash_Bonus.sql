-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Cash_Bonus (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Cash_Bonus(
    IN inCashId               Integer   , -- �����
    IN inCurrencyId           Integer   , -- ������
    IN inInfoMoneyId          Integer   , -- �������������� ������
    IN inMoneyPlaceId         Integer   , -- ������� ������ � ��������
    IN inContractId           Integer   , -- ��������
    IN inRemainsToPay         TFloat    , -- ����� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- 
     IF COALESCE (inRemainsToPay, 0) <= 0 
     THEN
        RETURN;
     END IF;

     -- �������� - 
     IF inInfoMoneyId NOT IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502()) -- ������ ������
     THEN
        RAISE EXCEPTION '������.��������� ������ <%> �� �������� ����������� �������.', lfGet_Object_ValueData_sh (inInfoMoneyId);
     END IF;

     -- �������� - �����
     IF COALESCE (inCashId,0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������� �����.';
     END IF;

     -- ���������
     vbId := lpInsertUpdate_Movement_Cash (ioId          := 0
                                         , inParentId    := NULL
                                         , inInvNumber   := CAST (NEXTVAL ('Movement_Cash_seq') AS TVarChar)
                                         , inOperDate    := CAST (CURRENT_DATE AS TDateTime)
                                         , inServiceDate := NULL           :: TDateTime
                                         , inAmountIn    := 0              :: TFloat
                                         , inAmountOut   := inRemainsToPay :: TFloat
                                         , inAmountSumm  := 0              :: TFloat
                                         , inAmountCurrency := 0           :: TFloat
                                         , inComment     := '������'
                                         , inCarId       := 0
                                         , inCashId      := inCashId
                                         , inMoneyPlaceId:= inMoneyPlaceId
                                         , inPositionId  := 0
                                         , inContractId  := inContractId
                                         , inInfoMoneyId := inInfoMoneyId
                                         , inMemberId    := 0
                                         , inUnitId      := 0
                                         , inCurrencyId           := COALESCE (inCurrencyId, zc_Enum_Currency_Basis())
                                         , inCurrencyValue        := 0
                                         , inParValue             := 0
                                         , inCurrencyPartnerId    := 0
                                         , inCurrencyPartnerValue := 0
                                         , inParPartnerValue      := 0
                                         , inMovementId_Partion   := 0
                                         , inUserId      := vbUserId
                                          );

    -- PERFORM lpSetErased_Movement (vbId, vbUserId);

   /*  -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();



     --PERFORM lpSetErased_Movement (vbId, vbUserId);

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := vbId
                                          , inUserId     := vbUserId);
     END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.08.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
