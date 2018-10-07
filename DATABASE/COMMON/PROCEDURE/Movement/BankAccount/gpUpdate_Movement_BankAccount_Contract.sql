-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankAccount_Contract(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankAccount_Contract(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inContractId           Integer   , -- ������� 
   OUT outContractName        TVarChar  , -- �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankAccount_Contract());


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