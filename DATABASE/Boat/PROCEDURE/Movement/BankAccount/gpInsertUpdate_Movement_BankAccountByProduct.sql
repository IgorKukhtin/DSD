-- Function: gpInsertUpdate_Movement_BankAccountByProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccountByProduct (Integer, TDateTime, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccountByProduct(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inOperDate             TDateTime , -- ���� ���������   
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inAmountIn             TFloat    , -- ����� �������
    IN inBankAccountId        Integer   , -- ��������� ���� 	
    IN inMoneyPlaceId         Integer   , -- �� ����, ����, �����  	
    IN inMovementId_Invoice   Integer   , -- ����
    IN inMovementId_Parent    Integer   , -- ����� �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- ��������
     IF COALESCE (inAmountIn, 0) = 0  
     THEN
        RETURN;
     END IF;

     -- ��������
     IF COALESCE (inMovementId_Invoice,0) = 0
     THEN
        RAISE EXCEPTION '������.�������� ���� �� ��������.';
     END IF;

     -- ��������
     IF COALESCE (inBankAccountId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������ ��������� ����';
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := CASE WHEN COALESCE (inInvNumber,'') ='' THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar)  ELSE inInvNumber END  ::TVarChar
                                               , inInvNumberPartner     := (SELECT tmp.ValueData FROM MovementString AS tmp WHERE tmp.DescId = zc_MovementString_InvNumberPartner() AND tmp.MovementId = ioId)
                                               , inOperDate             := inOperDate
                                               , inAmount               := inAmountIn
                                               , inBankAccountId        := inBankAccountId
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inMovementId_Invoice   := inMovementId_Invoice
                                               , inComment              := (SELECT tmp.ValueData FROM MovementString AS tmp WHERE tmp.DescId = zc_MovementString_Comment() AND tmp.MovementId = ioId)
                                               , inUserId               := vbUserId
                                                );
                                                

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
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.06.23         * 
*/

-- ����
--