-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_BankAccount(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inAmount              TFloat    , -- ����� �������� 

    IN inBankAccountId       Integer   , -- ��������� ���� 	
    IN inComment             TVarChar  , -- ����������� 
    IN inMoneyPlaceId        Integer   , -- �� ����, ����, �����  	
    IN inContractId          Integer   , -- ��������
    IN inInfoMoneyId         Integer   , -- ������ ���������� 
    IN inUnitId              Integer   , -- �������������
    IN inCurrencyId          Integer   , -- ������ 
    IN inParentId            Integer   , -- 
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     -- �������� (��� ��.���� ������)
     IF COALESCE (inContractId, 0) = 0 AND EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId = zc_Object_Juridical())
     THEN
        RAISE EXCEPTION '������.<� ��������> �� ������.';
     END IF;

     -- �������� ��������� ��������
     IF NOT EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND (InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500() -- ���������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_30500() -- ������ ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_40100() -- ������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40200() -- ������ �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40300() -- ���������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40400() -- �������� �� ��������
                                                                                                                                 -- , zc_Enum_InfoMoneyDestination_40500() -- �����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40600() -- ��������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40700() -- ����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40800() -- ���������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40900() -- ���������� ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_50100() -- ��������� ������� �� ��
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50200() -- ��������� �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50300() -- ��������� ������� (������)
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50400() -- ������ � ������
                                                                                                                                  )
                                                                                                         OR InfoMoneyId = zc_Enum_InfoMoney_21419() -- ������ �� �������
                                                                                                        )
                    )
        -- AND EXISTS (SELECT Id FROM gpGet_Movement_BankStatementItem (inMovementId:= ioId, inSession:= inSession) WHERE ContractId = inContractId)
        AND NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = inInfoMoneyId)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inMoneyPlaceId AND DescId = zc_ObjectLink_Juridical_InfoMoney() AND ChildObjectId IN (zc_Enum_InfoMoney_20801(), zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_21101())) -- ���� + ���� + ����� + �������
        AND inContractId > 0
     THEN
         RAISE EXCEPTION '������.��� <� ��������> = <%> �������� �������� <�� ������ ����������> = <%>.', (SELECT InvNumber FROM Object_Contract_InvNumber_View WHERE ContractId = inContractId), lfGet_Object_ValueData (inInfoMoneyId);
     END IF;

     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.<�� ������ ����������> �� �������.';
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, inParentId);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, ioId, inAmount, NULL);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
    
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

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 07.03.14                                        * add zc_Enum_InfoMoney_21419
 13.03.14                                        * add lpInsert_MovementProtocol
 13.03.14                                        * err inParentId NOT NULL
 13.03.14                                        * add �������� ��������� ��������
 15.01.14                         *
 06.12.13                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
