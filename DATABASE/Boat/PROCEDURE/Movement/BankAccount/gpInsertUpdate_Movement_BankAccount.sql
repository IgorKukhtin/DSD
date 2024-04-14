-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Text, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inInvNumberPartner     TVarChar  , -- ����� ��������� (�������)
    IN inOperDate             TDateTime , -- ���� ���������
    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� �������
    IN inAmount_Invoice       TFloat    , -- ����� ����
    IN inBankAccountId        Integer   , -- ��������� ����
    IN inMoneyPlaceId         Integer   , -- �� ����, ����, �����
    IN inMovementId_Invoice   Integer   , -- ����
    IN inInvoiceKindId        Integer   , -- ��� �����
    IN inInfoMoneyId          Integer   , -- InfoMoney - ����
    IN inMovementId_Parent    Integer   , -- ����� �������
    IN inComment              Text      , -- ���������� (���� �������������)
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

     -- �������� - InfoMoney
     IF inMovementId_Invoice > 0 AND COALESCE (inInfoMoneyId, 0) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InfoMoney()), 0)
     THEN
         RAISE EXCEPTION '������.�������� ���������� ������ ���� ������� ��� � ����� = <%>.', lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InfoMoney()));
     END IF;
     -- �������� - ��� �����
     IF inMovementId_Invoice > 0 AND COALESCE (inInvoiceKindId, 0) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InvoiceKind()), 0)
     THEN
         RAISE EXCEPTION '������.��� ����� ������ ���� ������ ��� � ����� = <%>.', lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InvoiceKind()));
     END IF;
     -- �������� - ����� �����
     /*IF inMovementId_Invoice > 0 AND COALESCE (inAmount_Invoice, 0) <> COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()), 0)
     THEN
         RAISE EXCEPTION '������.����� ����� ������ ���� ��� � ����� = <%>.', zfConvert_FloatToString((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()));
     END IF;*/


     -- !!!����� ������ ������!!!
     IF inAmountIn <> 0
     THEN
         vbAmount := inAmountIn;
     ELSE
         vbAmount := -1 * inAmountOut;
     END IF;

     -- !!!������!!!
     IF COALESCE (inAmount_Invoice, 0) = 0
     THEN
         inAmount_Invoice := ABS (vbAmount);
     END IF;

     -- ���� ���. ���� ����� ����� ��� �������
     IF (COALESCE (inMovementId_Invoice, 0) = 0
        -- �������� ����� �����
        OR NOT EXISTS (SELECT 1 FROM MovementFloat WHERE  MovementFloat.MovementId = inMovementId_Invoice AND MovementFloat.DescId = zc_MovementFloat_Amount() AND MovementFloat.ValueData = inAmount_Invoice)
        -- ��� �������� �����
        OR NOT EXISTS (SELECT 1 FROM Movement WHERE  Movement.Id = inMovementId_Invoice AND Movement.ParentId = inMovementId_Parent)
       )
       -- ���� Child ���� ��� ��� ���
       AND 1 >= (SELECT COUNT(*) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
     THEN
         -- ��������� <��������> + ��� inMovementId_Parent ����������� ����� �� ���� inMovementId_Invoice
         inMovementId_Invoice := gpInsertUpdate_Movement_Invoice (ioId               := inMovementId_Invoice
                                                                , inParentId         := inMovementId_Parent                 ::Integer
                                                                , inInvNumber        := NEXTVAL ('movement_Invoice_seq')    ::TVarChar
                                                                , inOperDate         := inOperDate
                                                                , inPlanDate         := NULL                                ::TDateTime
                                                                  -- ��� ��-�� � ������
                                                                , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Parent AND MF.DescId = zc_MovementFloat_VATPercent())
                                                                  --
                                                                , inAmountIn         := CASE WHEN vbAmount > 0 THEN 1 * ABS (inAmount_Invoice) ELSE 0 END
                                                                , inAmountOut        := CASE WHEN vbAmount < 0 THEN 1 * ABS (inAmount_Invoice) ELSE 0 END
                                                                , inInvNumberPartner := ''                                  ::TVarChar
                                                                , inReceiptNumber    := '0'                                 ::TVarChar
                                                                , inComment          := ''                                  ::TVarChar
                                                                , inObjectId         := inMoneyPlaceId
                                                                , inUnitId           := NULL                                ::Integer
                                                                , inInfoMoneyId      := inInfoMoneyId
                                                                , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                                                , inInvoiceKindId    := CASE WHEN COALESCE (inInvoiceKindId,0) = 0 THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END 
                                                                , inTaxKindId        := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_TaxKind())
                                                                                                , (SELECT ObjectLink_TaxKind.ChildObjectId AS TaxKindId
                                                                                                   FROM MovementLinkObject AS MovementLinkObject_From
                                                                                                        LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                                                                                             ON ObjectLink_TaxKind.ObjectId = MovementLinkObject_From.ObjectId
                                                                                                                            AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
                                                                                                   WHERE MovementLinkObject_From.MovementId = inMovementId_Parent
                                                                                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                                                   )
                                                                                                , (SELECT ObjectLink_TaxKind.ChildObjectId AS TaxKindId
                                                                                                   FROM ObjectLink AS ObjectLink_TaxKind
                                                                                                   WHERE ObjectLink_TaxKind.ObjectId = inMoneyPlaceId
                                                                                                     AND ObjectLink_TaxKind.DescId   IN (zc_ObjectLink_Client_TaxKind(), zc_ObjectLink_Partner_TaxKind())
                                                                                                   )
                                                                                                 )
                                                                , inSession          := inSession
                                                                 );

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

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inInvNumberPartner     := inInvNumberPartner
                                               , inOperDate             := inOperDate
                                               , inAmount               := vbAmount
                                               , inAmount_Invoice       := CASE WHEN vbAmount < 0 THEN  -1 * ABS (inAmount_Invoice) ELSE 1 * ABS (inAmount_Invoice) END
                                               , inBankAccountId        := inBankAccountId
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inMovementId_Invoice   := inMovementId_Invoice
                                               , inComment              := inComment :: TVarChar
                                               , inUserId               := vbUserId
                                                );

     -- ���������� (���� �������������)
     PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_11(), ioId, inComment);

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
 04.02.21         *
*/

-- ����
--