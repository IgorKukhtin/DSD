-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inParentId             Integer   , -- 
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� �������
    IN inAmountSumm           TFloat    , -- C���� ���, �����

    IN inBankAccountId        Integer   , -- ��������� ����
    IN inInvNumberInvoice     TVarChar  , -- ����(�������)
    IN inComment              TVarChar  , -- �����������
    IN inMoneyPlaceId         Integer   , -- �� ����, ����, �����, ��������� ����������
    IN inPartnerId            Integer   , -- ����������
    IN inContractId           Integer   , -- ��������
    IN inInfoMoneyId          Integer   , -- ������ ����������
    IN inUnitId               Integer   , -- �������������
    IN inMovementId_Invoice   Integer   , -- �������� ����
    IN inCurrencyId           Integer   , -- ������
   OUT outCurrencyValue       TFloat    , -- ���� ��� �������� � ������ �������
   OUT outParValue            TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat    , -- ������� ��� ������� ����� ��������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- ��������
     IF COALESCE (inAmountIn, 0) = 0 AND COALESCE (inAmountOut, 0) = 0 -- AND COALESCE (inCurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION '������.������� ����� ������� ��� �������';
     END IF;
     -- ��������
     IF COALESCE (inAmountIn, 0) <> 0 AND COALESCE (inAmountOut, 0) <> 0 -- AND COALESCE (inCurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� ����� - ��� <������> ��� <������>.';
     END IF;


     -- ������ ����� ��� �������
     IF inCurrencyId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue, Amount, ParValue
                 INTO outCurrencyValue, outParValue
                    , inCurrencyPartnerValue, inParPartnerValue -- !!!�������� ��������!!!
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyId,  inPaidKindId:= zc_Enum_PaidKind_FirstForm());
     END IF;

     -- !!!����� ������ ������!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= inAmountIn;
             vbAmount := CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := inAmountIn;
        END IF;
     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= -1 * inAmountOut;
             vbAmount := CAST (-1 * inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := -1 * inAmountOut;
        END IF;
     END IF;

     -- ��������
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION '������.����� ��������� �� ������ <%> � ������ <%> �� ������ ���� = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inOperDate             := inOperDate
                                               , inServiceDate          := inServiceDate
                                               , inAmount               := vbAmount
                                               , inAmountSumm           := inAmountSumm
                                               , inAmountCurrency       := vbAmountCurrency
                                               , inBankAccountId        := inBankAccountId
                                               , inComment              := inComment
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inPartnerId            := inPartnerId
                                               , inContractId           := inContractId
                                               , inInfoMoneyId          := inInfoMoneyId
                                               , inUnitId               := inUnitId
                                               , inMovementId_Invoice   := inMovementId_Invoice
                                               , inCurrencyId           := inCurrencyId
                                               , inCurrencyValue        := outCurrencyValue
                                               , inParValue             := outParValue
                                               , inCurrencyPartnerValue := inCurrencyPartnerValue
                                               , inParPartnerValue      := inParPartnerValue
                                               , inParentId             := inParentId -- (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId)
                                               , inBankAccountPartnerId := (SELECT MovementItemLinkObject.ObjectId FROM MovementItem 
                                                                             INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id  AND MovementItemLinkObject.DescId = zc_MILinkObject_BankAccount()
                                                                            WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master())
                                               , inUserId               := vbUserId
                                                );


     -- ����(�������)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := ioId
                                                 , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.07.24         *
 18.09.18         *
 21.07.15         *
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 11.05.14                                        * add ioId:=
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 04.04.14                                        * add lpComplete_Movement_BankAccount
 13.03.14                                        * add vbUserId
 13.03.14                                        * err inParentId NOT NULL
 06.12.13                          *
 09.08.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
