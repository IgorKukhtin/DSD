-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_BankAccount(
 INOUT ioId                    Integer   , -- ���� ������� <��������>
    IN inInvNumber             TVarChar  , -- ����� ���������
    IN inOperDate              TDateTime , -- ���� ���������
    IN inAmount                TFloat    , -- ����� �������� 
    IN inAmountSumm            TFloat    , -- C���� ���, �����
    IN inAmountCurrency        TFloat    , -- ����� � ������
    IN inBankAccountId         Integer   , -- ��������� ���� 	
    IN inComment               TVarChar  , -- ����������� 
    IN inMoneyPlaceId          Integer   , -- �� ����, ����, �����  	
    IN inContractId            Integer   , -- ��������
    IN inInfoMoneyId           Integer   , -- ������ ���������� 
    IN inUnitId                Integer   , -- �������������
    IN inCurrencyId            Integer   , -- ������ 
    IN inCurrencyValue         TFloat    , -- ���� ��� �������� � ������ �������
    IN inParValue              TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue  TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue       TFloat    , -- ������� ��� ������� ����� ��������
    IN inParentId              Integer   , -- 
    IN inBankAccountPartnerId  Integer   , -- � ������ ����� ��� �������
    IN inUserId                Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� (��� ��.���� ������)
     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
     THEN
        RAISE EXCEPTION '������.�� ������� �������� <� ��������>.';
     END IF;

     -- ��������
     IF COALESCE (inCurrencyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������� �������� <������>.';
     END IF;

     -- ��������
     IF inAmountSumm < 0
     THEN
        RAISE EXCEPTION '������.�������� �������� <C���� ���, �����>.';
     END IF;
     -- ��������
     IF /*inCurrencyId = zc_Enum_Currency_Basis() AND */ inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000())  -- �������/������� ������
        AND COALESCE (inAmountSumm, 0) = 0
     THEN
        RAISE EXCEPTION '������.��� <%> �� ������� �������� <C���� ���, �����>.', lfGet_Object_ValueData (inInfoMoneyId);
     END IF;
     -- ��������
     IF NOT (/*inCurrencyId = zc_Enum_Currency_Basis() AND */inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000()))  -- �������/������� ������
        AND inAmountSumm > 0
     THEN
        RAISE EXCEPTION '������.��� <%> � ������ <%> �������� <C���� ���, �����> ������ ���� ����� ����.', lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inCurrencyId);
     END IF;



     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, inParentId);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, ioId, inAmount, NULL);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
     -- C���� ���, �����
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmountSumm);
     -- ����� � ������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), ioId, inAmountCurrency);
     -- ���� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ������� ��� �������� � ������ �������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);
     -- ���� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ������� ��� ������� ����� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), vbMovementItemId, inCurrencyId);
     -- 
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), vbMovementItemId, inBankAccountPartnerId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.05.14                                        * add lpInsert_MovementItemProtocol
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 13.03.14                                        * add lpInsert_MovementProtocol
 13.03.14                                        * err inParentId NOT NULL
 13.03.14                                        * add �������� ��������� ��������
 15.01.14                         *
 06.12.13                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
