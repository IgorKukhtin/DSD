-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpinsertupdate_movement_bankaccount(integer, tvarchar, tdatetime, tfloat, tfloat, tfloat, integer, tvarchar, integer, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpinsertupdate_movement_bankaccount(INOUT ioid integer, IN ininvnumber tvarchar, IN inoperdate tdatetime, IN inamount tfloat, IN inamountsumm tfloat, IN inamountcurrency tfloat, IN inbankaccountid integer, IN incomment tvarchar, IN inmoneyplaceid integer, IN inincomemovementid integer, IN incontractid integer, IN ininfomoneyid integer, IN inunitid integer, IN incurrencyid integer, IN incurrencyvalue tfloat, IN inparvalue tfloat, IN incurrencypartnervalue tfloat, IN inparpartnervalue tfloat, IN inparentid integer, IN inbankaccountpartnerid integer, IN inuserid integer)
  RETURNS integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� (��� ��.���� ������)
--     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
  --   THEN
    --    RAISE EXCEPTION '������.�� ������� �������� <� ��������>.';
   --  END IF;

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
     -- -- ��������
     -- IF /*inCurrencyId = zc_Enum_Currency_Basis() AND */ inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000())  -- �������/������� ������
        -- AND COALESCE (inAmountSumm, 0) = 0
     -- THEN
        -- RAISE EXCEPTION '������.��� <%> �� ������� �������� <C���� ���, �����>.', lfGet_Object_ValueData (inInfoMoneyId);
     -- END IF;
     -- -- ��������
     -- IF NOT (/*inCurrencyId = zc_Enum_Currency_Basis() AND */inAmount > 0 AND inInfoMoneyId IN (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000()))  -- �������/������� ������
        -- AND inAmountSumm > 0
     -- THEN
        -- RAISE EXCEPTION '������.��� <%> � ������ <%> �������� <C���� ���, �����> ������ ���� ����� ����.', lfGet_Object_ValueData (inInfoMoneyId), lfGet_Object_ValueData (inCurrencyId);
     -- END IF;



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
     -- ������ �� �������� �������
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inIncomeMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpinsertupdate_movement_bankaccount(integer, tvarchar, tdatetime, tfloat, tfloat, tfloat, integer, tvarchar, integer, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, integer)
  OWNER TO postgres;
