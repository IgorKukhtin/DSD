-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                      Integer   , -- Ключ объекта <>
    IN inParentId                Integer   ,
    IN inMovementId              Integer   ,
    IN inMovementId_OrderClient  Integer ,
    IN inMovementId_invoice      Integer   , --
    IN inInvoiceKindId           Integer  ,  --
    IN inObjectId                Integer   , --
    IN inInfoMoneyId             Integer   , -- InfoMoney - Счет
    IN inAmount                  TFloat    , --
    IN inAmount_invoice          TFloat    , --
    IN inComment                 TVarChar  , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbAmount_master TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);


     -- нашли
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- нашли
     vbAmount_master:= (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inParentId);

     -- !!!замена!!!
     IF COALESCE (inAmount_Invoice, 0) = 0
     THEN
         inAmount_Invoice := ABS (inAmount);
     END IF;


     -- проверка
     IF COALESCE (vbAmount_master, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма в документе <Расчетный счет> = 0.';
     END IF;


     -- проверка
     IF ABS (vbAmount_master) < ABS (inAmount) + COALESCE ((SELECT SUM (ABS (MovementItem.Amount))
                                                            FROM MovementItem
                                                            WHERE MovementItem.MovementId = inMovementId
                                                              AND MovementItem.DescId     = zc_MI_Child()
                                                              AND MovementItem.isErased   = FALSE
                                                              AND MovementItem.Id         <> COALESCE (ioId, 0)
                                                           ), 0)
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма по счетам = <%> не может быть больше чем сумма в документе <Расчетный счет> = <%>.'
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

     -- проверка - InfoMoney
     IF inMovementId_Invoice > 0 AND COALESCE (inInfoMoneyId, 0) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InfoMoney()), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Название назначения должно быть выбрано как в Счете = <%>.', lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InfoMoney()));
     END IF;
     -- проверка - Тип счета
     IF inMovementId_Invoice > 0 AND COALESCE (inInvoiceKindId, 0) <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InvoiceKind()), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Тип счета должен быть выбран как в Счете = <%>.', lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Invoice AND MLO.DescId = zc_MovementLinkObject_InvoiceKind()));
     END IF;
     -- проверка - Сумма счета
     IF inMovementId_Invoice > 0 AND COALESCE (inAmount_Invoice, 0) <> COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Сумма счета должна быть как в Счете = <%>.', zfConvert_FloatToString((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Invoice AND MF.DescId = zc_MovementFloat_Amount()));
     END IF;


     IF COALESCE (inMovementId_invoice,0) = 0
     THEN
          -- сохранили <Документ>
        vbInvNumber:= NEXTVAL ('movement_Invoice_seq')    :: TVarChar;

        inMovementId_invoice := gpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                               , inParentId         := inMovementId_OrderClient
                                                               , inInvNumber        := vbInvNumber                         :: TVarChar
                                                               , inOperDate         := vbOperDate
                                                               , inPlanDate         := NULL                                ::TDateTime
                                                                 -- это св-во в Заказе
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

     -- сохранили <Элемент документа>
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
--