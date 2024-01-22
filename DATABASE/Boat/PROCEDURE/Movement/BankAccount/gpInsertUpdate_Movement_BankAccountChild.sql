-- Function: gpInsertUpdate_Movement_BankAccountChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccountChild (Integer, Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccountChild(
 INOUT ioId                   Integer   , -- ���� ������� <��������> 
    IN inMovementItemId_child Integer   , -- �����
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inInvNumberPartner     TVarChar  , -- ����� ��������� (�������)
    IN inOperDate             TDateTime , -- ���� ���������
    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� ������� 
    IN inAmount               TFloat    , -- ����� ������ �� �����
    IN inBankAccountId        Integer   , -- ��������� ���� 	
    IN inMoneyPlaceId         Integer   , -- �� ����, ����, �����  	
    IN inMovementId_Invoice   Integer   , -- ����    
    IN inInvoiceKindId        Integer   , -- ��� �����
    IN inMovementId_Parent    Integer   , -- ����� �������
    IN inComment              TVarChar  , -- �����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- ��������
     IF COALESCE (inBankAccountId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������ ��������� ����';
     END IF;

     -- ��������
     IF COALESCE (inAmountIn, 0) = 0 AND COALESCE (inAmountOut, 0) = 0 
     THEN
        RAISE EXCEPTION '������.������� ����� ������� ��� �������';
     END IF;
     -- ��������
     IF COALESCE (inAmountIn, 0) <> 0 AND COALESCE (inAmountOut, 0) <> 0
     THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� ����� - ��� <������> ��� <������>.';
     END IF;

     -- ��������
     /*IF COALESCE (inMovementId_Invoice, 0) = 0 AND COALESCE (inMovementId_Parent, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ������ �������� ����.';
     END IF;*/


     -- !!!����� ������ ������!!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- ���� ���. ���� ����� ����� ��� �������
     IF COALESCE (inMovementId_Invoice, 0) = 0
     THEN
         -- ��������� <��������> + ��� inMovementId_Parent ����������� ����� �� ���� inMovementId_Invoice
         inMovementId_Invoice := gpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                                , inParentId         := inMovementId_Parent                 ::Integer
                                                                , inInvNumber        := NEXTVAL ('movement_Invoice_seq')    ::TVarChar
                                                                , inOperDate         := inOperDate
                                                                , inPlanDate         := NULL                                ::TDateTime
                                                                  -- ��� ��-�� � ������
                                                                , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Parent AND MF.DescId = zc_MovementFloat_VATPercent())
                                                                  -- 
                                                                , inAmountIn         := CASE WHEN vbAmount > 0 THEN  1 * vbAmount ELSE 0 END
                                                                , inAmountOut        := CASE WHEN vbAmount < 0 THEN -1 * vbAmount ELSE 0 END
                                                                , inInvNumberPartner := ''                                  ::TVarChar
                                                                , inReceiptNumber    := (1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                                                                                        FROM MovementString
                                                                                                             JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                                                                                          AND Movement.DescId   = zc_Movement_Invoice()
                                                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                        WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                                                                                       ), 0)
                                                                                        ) :: TVarChar
                                                                , inComment          := ''                                  ::TVarChar
                                                                , inObjectId         := inMoneyPlaceId
                                                                , inUnitId           := NULL                                ::Integer
                                                                , inInfoMoneyId      := ObjectLink_InfoMoney.ChildObjectId  ::Integer
                                                                , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                                                , inInvoiceKindId    := CASE WHEN COALESCE (inInvoiceKindId,0) = 0 THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END :: Integer
                                                                , inSession          := inSession
                                                                 )
         FROM Object AS Object_Client
              LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                   ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                  AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
         WHERE Object_Client.Id = inMoneyPlaceId;

         -- �������� ��������
         /*IF vbUserId = lpCheckRight (vbUserId :: TVarChar, zc_Enum_Process_Complete_Invoice())
         THEN
              PERFORM lpComplete_Movement_Invoice (inMovementId := inMovementId_Invoice
                                                 , inUserId     := vbUserId);
         END IF;*/

     END IF;
     

     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������> + ������
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inInvNumberPartner     := inInvNumberPartner
                                               , inOperDate             := inOperDate
                                               , inAmount               := vbAmount
                                               , inAmount_Invoice       := vbAmount
                                               , inBankAccountId        := inBankAccountId
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inMovementId_Invoice   := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioId)--inMovementId_Invoice
                                               , inComment              := (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = ioId AND MS.DescId = zc_MovementString_Comment())
                                               , inUserId               := vbUserId
                                                );
                                                
          
     --��������� �����   
     PERFORM gpInsertUpdate_MI_BankAccount_Child(ioId                  := COALESCE (inMovementItemId_child,0)::Integer    -- ���� ������� <> 
                                               , inParentId            := (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master())::Integer   
                                               , inMovementId          := ioId                   ::Integer     
                                               , inMovementId_OrderClient := inMovementId_Parent ::Integer
                                               , inMovementId_invoice  := inMovementId_Invoice   ::Integer    -- 
                                               , inInvoiceKindId       := inInvoiceKindId        ::Integer   --
                                               , inObjectId            := inMoneyPlaceId         ::Integer    -- 
                                               , inAmount              := inAmount               ::TFloat     --
                                               , inAmount_invoice      := inAmount               ::TFloat     --
                                               , inComment             := inComment              ::TVarChar   --
                                               , inSession             := inSession              ::TVarChar    -- ������ ������������ 
                                               );
                                               

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     --PERFORM lpComplete_Movement_Finance_CreateTemp();

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
 19.01.24         * 
*/

-- ����
--
