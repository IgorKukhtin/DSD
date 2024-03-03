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
                                                              , inComment          := (WITH tmpProduct AS (SELECT gpSelect.*
                                                                                                           FROM gpSelect_Object_Product (inMovementId_OrderClient:= inParentId, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
                                                                                                          )
                                                                                            -- Все Счета предоплата
                                                                                         , tmpMov_Invoice AS (SELECT Movement.Id
                                                                                                                   , MovementString_ReceiptNumber.ValueData AS ReceiptNumber
                                                                                                                   , MovementFloat_Amount.ValueData AS Amount
                                                                                                                   , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.Id) AS ord
                                                                                                              FROM Movement
                                                                                                                   INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                                                                                 ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                                                                                                AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                                                                                                                -- только предоплата
                                                                                                                                                AND MovementLinkObject_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_PrePay()
                                                                                                                   LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                                                                                                           ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                                                          AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                                                                                   LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                                                                                                            ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                                                                                                           AND MovementString_ReceiptNumber.DescId     = zc_MovementString_ReceiptNumber()
                                                                                                              WHERE Movement.DescId   = zc_Movement_Invoice()
                                                                                                                -- этот док Заказ Клиента
                                                                                                                AND Movement.ParentId = inParentId
                                                                                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                                             )
                                                                                         , tmpRes AS (SELECT tmpMov_Invoice.Ord
                                                                                                           , CASE WHEN tmpMov_Invoice.Ord = 1
                                                                                                                       THEN 'Storno invoice ' || tmpMov_Invoice.ReceiptNumber || ' Reservation Fee '
                                                                                                                  WHEN tmpMov_Invoice.Ord = 2
                                                                                                                       THEN 'Storno invoice ' || tmpMov_Invoice.ReceiptNumber || ' First Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount *100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                                                                                  WHEN tmpMov_Invoice.Ord = 3
                                                                                                                       THEN 'Storno invoice ' || tmpMov_Invoice.ReceiptNumber||' First and Second Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                                                                                  ELSE 'Storno invoice ' || tmpMov_Invoice.ReceiptNumber||' First, Second and Third Advance-payment '
                                                                                                                    || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                    || '% for ' || tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                                                                             END AS Comment

                                                                                                      FROM tmpMov_Invoice
                                                                                                           LEFT JOIN tmpProduct ON 1=1
                                                                                                      ORDER BY tmpMov_Invoice.Ord
                                                                                                     )
                                                                                       -- Результат
                                                                                       SELECT STRING_AGG (tmpRes.Comment, CHR (13)) FROM tmpRes
                                                                                      )
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
                                           , inComment          := CASE WHEN inComment = '*' THEN '' ELSE inComment END
                                           , inObjectId         := inObjectId
                                           , inUnitId           := inUnitId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           --, inProductId        := inProductId
                                           , inPaidKindId       := inPaidKindId
                                           , inInvoiceKindId    := inInvoiceKindId
                                           , inUserId           := vbUserId
                                            );


     -- Примечание
     IF NOT EXISTS (SELECT 1 FROM MovementString WHERE MovementString.MovementId = ioId AND MovementString.DescId = zc_MovementString_Comment() AND MovementString.ValueData <> '')
        AND inParentId > 0
        AND inComment <> '*'
     THEN
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment()
                                              , ioId
                                              , (WITH tmpProduct AS (SELECT *
                                                                     FROM gpSelect_Object_Product (inMovementId_OrderClient:= inParentId, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                                    )
                                                      -- Все документы заказа, в которых указан этот Счет, возьмем первый
                                                    , tmpInvoice AS (SELECT tmp.*
                                                                          , Object_Insert.ValueData AS InsertName
                                                                          , Object.ObjectCode
                                                                     FROM gpGet_Movement_Invoice (ioId, 0 , 0 , 0 ,  CURRENT_DATE, '', inSession) AS tmp
                                                                          LEFT JOIN MovementLinkObject AS MLO_Insert
                                                                                                       ON MLO_Insert.MovementId = tmp.Id
                                                                                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                                                          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
                                                                          LEFT JOIN Object ON Object.Id = tmp.ObjectId
                                                                    )
                                                      -- данные по оплате счета
                                                    , tmpBankAccount AS (SELECT SUM (MovementItem.Amount)   ::TFloat AS AmountIn
                                                                         FROM MovementLinkMovement
                                                                             INNER JOIN Movement AS Movement_BankAccount
                                                                                                 ON Movement_BankAccount.Id = MovementLinkMovement.MovementId
                                                                                                AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                                                                                AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                                                                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                                                                    AND MovementItem.DescId = zc_MI_Master()
                                                                                                    AND MovementItem.isErased = FALSE
                                                                                                    AND COALESCE (MovementItem.Amount,0) > 0
                                                                         WHERE MovementLinkMovement.MovementChildId = ioId
                                                                           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                                                                         GROUP BY MovementLinkMovement.MovementChildId
                                                                        )
                                                      -- Все документы предоплаты, в которых указан этот док заказ (нужна итого сумма для счета показать сумму счетов предоплаты)
                                                    , tmpMov_PrePay AS (SELECT Movement.Id
                                                                             , (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                                                                             , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.InvNumber) AS Ord
                                                                        FROM Movement
                                                                           INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                                                        AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                                                                        AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()
                                                                           LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                                                                   ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                  AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                                        WHERE Movement.DescId   = zc_Movement_Invoice()
                                                                          AND Movement.ParentId = inParentId
                                                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                       )
                                                 -- Результат
                                                 SELECT CASE WHEN tmpPrePay.Ord = 1 THEN 'Reservation Fee '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                             WHEN tmpPrePay.Ord = 2 THEN 'First Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                             WHEN tmpPrePay.Ord = 3 THEN 'First and Second Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                             ELSE /*WHEN tmpPrePay.Ord = 4 THEN*/ 'First, Second and Third Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| tmpProduct.invnumber_orderclient
                                                        END
                                                 FROM tmpInvoice
                                                      LEFT JOIN tmpProduct ON tmpProduct.Id = tmpInvoice.ProductId
                                                      --итого сумма предоплат
                                                      LEFT JOIN (SELECT SUM (tmpMov_PrePay.Total_PrePay) AS Total_PrePay FROM  tmpMov_PrePay) AS tmpMov_PrePay ON 1 = 1
                                                      --номер предоплаты
                                                      LEFT JOIN tmpMov_PrePay AS tmpPrePay ON tmpPrePay.Id = tmpInvoice.Id

                                                 ));
     END IF;


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