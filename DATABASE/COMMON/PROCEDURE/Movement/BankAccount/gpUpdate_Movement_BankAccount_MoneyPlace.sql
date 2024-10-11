-- Function: gpUpdate_Movement_BankAccount_MoneyPlace()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankAccount_MoneyPlace(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankAccount_MoneyPlace(
    IN inId                    Integer   , -- ���� ������� <��������>
    IN inMoneyPlaceId          Integer   , -- �� ����, ����, �����, ��������� ����������
    IN inContractId            Integer   , -- ��������
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankAccount_MoneyPlace());


     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.DescId = zc_Movement_BankAccount() AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������. �������� � <%> �� <%> ������ ���� ��������.'
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inId)
                        , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inId));
     END IF;

     -- 1. ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inId
                                  , inUserId     := vbUserId);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = inId AND MovementItem.DescId = zc_MI_Master();

     -- ��������� ����� � <�� ����, ����, �����, ��������� ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
     

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_InfoMoney()));


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inId
                                            , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.19         *
*/

-- ����
--