-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- Номер документа
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- Плановая дата оплаты по Счету
    IN inVATPercent       TFloat   ,  --
    IN inAmountIn         TFloat   ,  --
    IN inAmountOut        TFloat   ,  --
    IN inInvNumberPartner TVarChar ,  -- Номер документа - External Nr
    IN inReceiptNumber    TVarChar ,  -- Официальный номер квитанции - Quittung Nr, формируется только для Amount>0
    IN inComment          TVarChar ,  --
    IN inObjectId         Integer  ,  --
    IN inUnitId           Integer  ,  --
    IN inInfoMoneyId      Integer  ,  --
    --IN inProductId        Integer  ,  --
    IN inPaidKindId       Integer  ,  --
    IN inInvoiceKindId    Integer  ,  --
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbMovementId_return Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     -- !!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;
     
     
     -- Если это Счет
     IF inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
        -- нет Счета на Возврат
        AND NOT EXISTS (SELECT 1
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                           ON MLO_InvoiceKind.MovementId = Movement.Id
                                                          AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                          AND MLO_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_Return()
                        WHERE Movement.ParentId = inParentId
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                          AND Movement.DescId   = zc_Movement_Invoice()
                       )
        -- есть Счета Предоплата
        AND EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                       ON MLO_InvoiceKind.MovementId = Movement.Id
                                                      AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                      AND MLO_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_PrePay()
                         INNER JOIN MovementFloat AS MovementFloat_Amount
                                                  ON MovementFloat_Amount.MovementId = Movement.Id
                                                 AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
                                                 AND MovementFloat_Amount.ValueData  > 0
                    WHERE Movement.ParentId = inParentId
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                      AND Movement.DescId   = zc_Movement_Invoice()
                   )
     THEN
         -- создали Возврат
         vbMovementId_return:= gpInsertUpdate_Movement_Invoice (ioId               := 0
                                                              , inParentId         := inParentId
                                                              , inInvNumber        := CAST (NEXTVAL ('movement_Invoice_seq') AS TVarChar)
                                                              , inOperDate         := inOperDate
                                                              , inPlanDate         := inOperDate
                                                              , inVATPercent       := inVATPercent
                                                              , inAmountIn         := 0 :: TFloat
                                                              , inAmountOut        := (SELECT SUM (MovementFloat_Amount.ValueData)
                                                                                       FROM Movement
                                                                                            INNER JOIN MovementLinkObject AS MLO_InvoiceKind
                                                                                                                          ON MLO_InvoiceKind.MovementId = Movement.Id
                                                                                                                         AND MLO_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                                                                                         AND MLO_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_PrePay()
                                                                                            INNER JOIN MovementFloat AS MovementFloat_Amount
                                                                                                                     ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                                    AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
                                                                                                                    AND MovementFloat_Amount.ValueData  > 0
                                                                                       WHERE Movement.ParentId = inParentId
                                                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                         AND Movement.DescId   = zc_Movement_Invoice()
                                                                                      ) :: TFloat
                                                              , inInvNumberPartner := ''
                                                              , inReceiptNumber    := (1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                                                                                      FROM MovementString
                                                                                                           JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                                                                                        AND Movement.DescId   = zc_Movement_Invoice()
                                                                                                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                      WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                                                                                     ), 0)
                                                                                      ) :: TVarChar
                                                              , inComment          := ''
                                                              , inObjectId         := inObjectId
                                                              , inUnitId           := inUnitId
                                                              , inInfoMoneyId      := inInfoMoneyId
                                                              , inPaidKindId       := inPaidKindId
                                                              , inInvoiceKindId    := zc_Enum_InvoiceKind_Return()
                                                              , inSession          := inSession
                                                               );
    
         -- дописали св-во
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Auto(), vbMovementId_return, TRUE);

     END IF;

     -- Распроводим Документ
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Invoice (ioId               := ioId
                                           , inParentId         := CASE WHEN inParentId > 0 THEN inParentId ELSE NULL END
                                           , inInvNumber        := inInvNumber
                                           , inOperDate         := inOperDate
                                           , inPlanDate         := inPlanDate
                                           , inVATPercent       := inVATPercent
                                           , inAmount           := vbAmount :: Tfloat
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inReceiptNumber    := inReceiptNumber
                                           , inComment          := inComment
                                           , inObjectId         := inObjectId
                                           , inUnitId           := inUnitId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           --, inProductId        := inProductId
                                           , inPaidKindId       := inPaidKindId
                                           , inInvoiceKindId    := inInvoiceKindId
                                           , inUserId           := vbUserId
                                           );


     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice())
     THEN
          PERFORM lpComplete_Movement_Invoice (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         *

*/