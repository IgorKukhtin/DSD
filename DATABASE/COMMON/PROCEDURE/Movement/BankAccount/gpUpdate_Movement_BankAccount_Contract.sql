-- Function: gpUpdate_Movement_BankAccount_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankAccount_Contract(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankAccount_Contract(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inContractId           Integer   , -- ������� 
   OUT outContractName        TVarChar  , -- �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbInfoMoneyId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankAccount_Contract());


     -- ��������
     vbInfoMoneyId:= (SELECT MILinkObject_InfoMoney.ObjectId
                      FROM MovementItem
                           JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                       ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_InfoMoney.DescId        = zc_MILinkObject_InfoMoney()
                      WHERE MovementItem.MovementId = inId
                        AND MovementItem.DescId     = zc_MI_Master()
                     );

     -- ��������
     IF COALESCE ((SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inId AND MLM.DescId = zc_MovementLinkMovement_Invoice()), 0) = 0
        AND EXISTS (SELECT 1 FROM Object_InfoMoney_View AS View_InfoMoney WHERE View_InfoMoney.InfoMoneyId = vbInfoMoneyId AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()) -- ����������
     THEN
        RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <� ���. ����>.', lfGet_Object_ValueData (vbInfoMoneyId);
     END IF;

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

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_InfoMoney()));


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inId
                                            , inUserId     := vbUserId);

     outContractName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inContractId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.18         *
*/

-- ����
--