-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                      Integer   , -- ���� ������� <>
    IN inParentId                Integer   ,
    IN inMovementId              Integer   ,
    IN inMovementId_OrderClient  Integer ,
    IN inMovementId_invoice      Integer   , --
    IN inInvoiceKindId           Integer  ,  --
    IN inObjectId                Integer   , --
    IN inInfoMoneyId             Integer   , -- InfoMoney - ����
    IN inAmount                  TFloat    , --
    IN inAmount_invoice          TFloat    , --
    IN inComment                 TVarChar  , --
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbAmount_master TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);


     -- �����
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- �����
     vbAmount_master:= (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inParentId);

     -- !!!������!!!
     IF COALESCE (inAmount_Invoice, 0) = 0
     THEN
         inAmount_Invoice := ABS (inAmount);
     END IF;


     -- ��������
     IF COALESCE (vbAmount_master, 0) = 0
     THEN
        RAISE EXCEPTION '������.����� � ��������� <��������� ����> = 0.';
     END IF;


     -- ��������
     IF ABS (vbAmount_master) < ABS (inAmount) + COALESCE ((SELECT SUM (ABS (MovementItem.Amount))
                                                            FROM MovementItem
                                                            WHERE MovementItem.MovementId = inMovementId
                                                              AND MovementItem.DescId     = zc_MI_Child()
                                                              AND MovementItem.isErased   = FALSE
                                                              AND MovementItem.Id         <> COALESCE (ioId, 0)
                                                           ), 0)
     THEN
        RAISE EXCEPTION '������.����� �� ������ = <%> �� ����� ���� ������ ��� ����� � ��������� <��������� ����> = <%>.'
                       , zfConvert_FloatToString (ABS (inAmount) + COALESCE ((SELECT SUM (ABS (MovementItem.Amount))
                                                                              FROM MovementItem
                                                                              WHERE MovementItem.MovementId = inMovementId
                                                                                AND MovementItem.DescId     = zc_MI_Child()
                                                                                AND MovementItem.isErased   = FALSE
                                                                                AND MovementItem.Id         <> COALESCE (ioId, 0)
                                                                             ), 0))
                       , zfConvert_FloatToString (vbAmount_master)
                        ;
     END IF;

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
     IF inMovementId_Invoice > 0 AND COALESCE (inAmount_Invoice, 0) <> COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()), 0)
     THEN
         RAISE EXCEPTION '������.����� ����� ������ ���� ��� � ����� = <%>.', zfConvert_FloatToString((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()));
     END IF;


     IF COALESCE (inMovementId_invoice,0) = 0
     THEN
          -- ��������� <��������>
        vbInvNumber:= NEXTVAL ('movement_Invoice_seq')    :: TVarChar;

        inMovementId_invoice := gpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                               , inParentId         := inMovementId_OrderClient
                                                               , inInvNumber        := vbInvNumber                         :: TVarChar
                                                               , inOperDate         := vbOperDate
                                                               , inPlanDate         := NULL                                ::TDateTime
                                                                 -- ��� ��-�� � ������
                                                               , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_OrderClient AND MF.DescId = zc_MovementFloat_VATPercent())
                                                                 --
                                                               , inAmountIn         := CASE WHEN vbAmount_master > 0 THEN  1 * ABS (inAmount_Invoice) ELSE 0 END
                                                               , inAmountOut        := CASE WHEN vbAmount_master < 0 THEN -1 * ABS (inAmount_Invoice) ELSE 0 END
                                                               , inInvNumberPartner := ''                                  ::TVarChar
                                                               , inReceiptNumber    := CASE WHEN vbAmount_master < 0
                                                                                                  THEN ''
                                                                                             WHEN inInvoiceKindId = zc_Enum_InvoiceKind_Proforma()
                                                                                                  THEN ''
                                                                                             ELSE (1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                                                                                       FROM MovementString
                                                                                                            JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                                                                                         AND Movement.DescId   = zc_Movement_Invoice()
                                                                                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                       WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                                                                                      ), 0)
                                                                                                  ) :: TVarChar
                                                                                       END
                                                               , inComment          := ''
                                                               , inObjectId         := inObjectId
                                                               , inUnitId           := NULL
                                                               , inInfoMoneyId      := inInfoMoneyId
                                                               , inPaidKindId       := zc_Enum_PaidKind_FirstForm()
                                                               , inInvoiceKindId    := CASE WHEN COALESCE (inInvoiceKindId,0) = 0 THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END
                                                               , inTaxKindId        := (SELECT ObjectLink_TaxKind.ChildObjectId AS TaxKindId
                                                                                        FROM MovementLinkObject AS MovementLinkObject_From   
                                                                                          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                                                                               ON ObjectLink_TaxKind.ObjectId = MovementLinkObject_From.ObjectId
                                                                                                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
                                                                                        WHERE MovementLinkObject_From.MovementId = inMovementId_OrderClient
                                                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                                        ) ::Integer
                                                               , inSession          := inSession
                                                                );

     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MI_BankAccount_Child (ioId
                                                , inParentId
                                                , inMovementId
                                                , inMovementId_invoice
                                                , inObjectId
                                                , inAmount
                                                , inComment
                                                , vbUserId
                                                 );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.24         *
*/

-- ����
--