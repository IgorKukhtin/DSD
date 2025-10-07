-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- ����� ���������
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- �������� ���� ������ �� �����
    IN inVATPercent       TFloat   ,  --
    IN inAmountIn         TFloat   ,  --
    IN inAmountOut        TFloat   ,  --
    IN inInvNumberPartner TVarChar ,  -- ����� ��������� - External Nr
    IN inReceiptNumber    TVarChar ,  -- ����������� ����� ��������� - Quittung Nr, ����������� ������ ��� Amount>0
    IN inComment          TVarChar ,  --
    IN inObjectId         Integer  ,  --
    IN inUnitId           Integer  ,  --
    IN inInfoMoneyId      Integer  ,  --
    --IN inProductId        Integer  ,  --
    IN inPaidKindId       Integer  ,  --
    IN inInvoiceKindId    Integer  ,  -- 
    IN inTaxKindId        Integer  ,  --
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbMovementId_return Integer;
   DECLARE vbBasisWVAT_summ_transport TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

     -- !!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;
     

     -- ����
     IF ioId > 0
        AND (inVATPercent <> COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_VATPercent()), 0)
        -- OR ioId = 6288
            )
        AND EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Master())
     THEN
         -- �������� ��-��
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPVAT(), MovementItem.Id
                                                 , zfCalc_SummWVAT_4 ((MovementItem.Amount * COALESCE (MIF_OperPrice.ValueData, 0)) ::TFloat
                                                                    , inVATPercent
                                                                     ))
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIF_OperPrice
                                          ON MIF_OperPrice.MovementItemId = MovementItem.Id
                                         AND MIF_OperPrice.DescId         = zc_MIFloat_OperPrice()
         WHERE MovementItem.MovementId = ioId
           AND MovementItem.isErased   = FALSE
           AND MovementItem.DescId   = zc_MI_Master()
         ;

         -- ��������� �������� <% ���>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

         -- !!!��������!!! - ����������� ����� � ��� ��������� � ���������� � zc_MovementFloat_Amount
         vbAmount:= lpInsertUpdate_Movement_Invoice_Amount (ioId, vbUserId);

     END IF;


     -- ���� ��� ����
     IF inInvoiceKindId = zc_Enum_InvoiceKind_Pay() AND inAmountIn > 0 AND inParentId > 0
     THEN
         -- 5. Total LP + Vat - ����� ����� ������� � ��� - �� ����� �������� (Basis+options) + TRANSPORT
         vbBasisWVAT_summ_transport:= (SELECT  gpSelect.BasisWVAT_summ_transport
                                       FROM gpSelect_Object_Product (inParentId, FALSE, FALSE, '') AS gpSelect
                                       WHERE gpSelect.MovementId_OrderClient = inParentId
                                      );
         -- �������� - ������ �����
         IF vbBasisWVAT_summ_transport > 0 AND inAmountIn <> vbBasisWVAT_summ_transport
         THEN
             RAISE EXCEPTION '������.����� �� ����� = <%>%������ ��������������� ����� ������ = <%>.'
                            , zfConvert_FloatToString (inAmountIn)
                            , CHR (13)
                            , zfConvert_FloatToString (vbBasisWVAT_summ_transport)
                             ;
         END IF;

         -- ������ - ������ �����
         vbAmount:= gpGet_Movement_Invoice_Prepay (inMovementId_invoice      := ioId
                                                 , inMovementId_order        := inParentId
                                                 , inInvoiceKindId           := zc_Enum_InvoiceKind_PrePay() -- !!! �� ������, ���� ��������� ������� � ������!!!
                                                 , inBasisWVAT_summ_transport:= vbBasisWVAT_summ_transport
                                                 , ioAmountIn                := 0 :: TFloat
                                                 , inSession                 := inSession
                                                  );

     END IF;



     -- ���� ��� ����
     IF inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
        -- ��� ����� �� �������
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
        -- ���� ����� ����������
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
         -- ������� �������
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
                                                                                            -- ��� ����� ����������
                                                                                         , tmpMov_Invoice AS (SELECT Movement.Id
                                                                                                                   , MovementString_ReceiptNumber.ValueData AS ReceiptNumber
                                                                                                                   , CASE WHEN MovementLinkObject_InvoiceKind.ObjectId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN 'receipt'  ELSE 'invoice' END AS InvoiceName
                                                                                                                   , MovementFloat_Amount.ValueData AS Amount
                                                                                                                   , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.Id) AS ord
                                                                                                              FROM Movement
                                                                                                                   INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                                                                                 ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                                                                                                AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                                                                                                                -- ������ ����������
                                                                                                                                                AND MovementLinkObject_InvoiceKind.ObjectId   = CASE WHEN inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END
                                                                                                                   LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                                                                                                           ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                                                          AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                                                                                   LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                                                                                                            ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                                                                                                           AND MovementString_ReceiptNumber.DescId     = zc_MovementString_ReceiptNumber()
                                                                                                              WHERE Movement.DescId   = zc_Movement_Invoice()
                                                                                                                -- ���� ��� ����� �������
                                                                                                                AND Movement.ParentId = inParentId
                                                                                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                                                AND MovementFloat_Amount.ValueData > 0
                                                                                                             )
                                                                                         , tmpRes AS (SELECT tmpMov_Invoice.Ord
                                                                                                           , CASE WHEN tmpMov_Invoice.Ord = 1
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)
                                                                                                                                      || CASE WHEN inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN ' Reservation Fee ' ELSE '' END
                                                                                                                  WHEN tmpMov_Invoice.Ord = 2
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber) || ' First Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount *100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                                  WHEN tmpMov_Invoice.Ord = 3
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)||' First and Second Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                                  ELSE 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)||' First, Second and Third Advance-payment '
                                                                                                                    || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                    || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                             END AS Comment

                                                                                                      FROM tmpMov_Invoice
                                                                                                           LEFT JOIN tmpProduct ON 1=1
                                                                                                      ORDER BY tmpMov_Invoice.Ord
                                                                                                     )
                                                                                       -- ���������
                                                                                       SELECT STRING_AGG (tmpRes.Comment, CHR (13)) FROM tmpRes
                                                                                      )
                                                              , inObjectId         := inObjectId
                                                              , inUnitId           := inUnitId
                                                              , inInfoMoneyId      := inInfoMoneyId
                                                              , inPaidKindId       := inPaidKindId
                                                              , inInvoiceKindId    := zc_Enum_InvoiceKind_Return()   
                                                              , inTaxKindId        := inTaxKindId
                                                              , inSession          := inSession
                                                               );

         -- �������� ��-��
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Auto(), vbMovementId_return, TRUE);

     END IF;

     -- ����������� ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Invoice (ioId               := ioId
                                           , inParentId         := CASE WHEN inParentId > 0 THEN inParentId ELSE NULL END
                                           , inInvNumber        := inInvNumber
                                           , inOperDate         := inOperDate
                                           , inPlanDate         := inPlanDate
                                           , inVATPercent       := inVATPercent
                                           , inAmount           := vbAmount :: TFloat
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inReceiptNumber    := inReceiptNumber
                                           , inComment          := CASE WHEN inComment = '*' THEN '' ELSE inComment END
                                           , inObjectId         := inObjectId
                                           , inUnitId           := inUnitId
                                           , inInfoMoneyId      := inInfoMoneyId
                                           --, inProductId        := inProductId
                                           , inPaidKindId       := inPaidKindId
                                           , inInvoiceKindId    := inInvoiceKindId 
                                           , inTaxKindId        := inTaxKindId
                                           , inUserId           := vbUserId
                                            );


     -- ����������
     IF NOT EXISTS (SELECT 1 FROM MovementString WHERE MovementString.MovementId = ioId AND MovementString.DescId = zc_MovementString_Comment() AND MovementString.ValueData <> '')
        AND inParentId > 0
        AND inComment <> '*'
     THEN
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment()
                                              , ioId
                                              , CASE WHEN inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Pay(), zc_Enum_InvoiceKind_Return()) AND vbAmount < 0
                                                          THEN
                                                                                      (WITH tmpProduct AS (SELECT gpSelect.*
                                                                                                           FROM gpSelect_Object_Product (inMovementId_OrderClient:= inParentId, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
                                                                                                          )
                                                                                            -- ��� ����� ����������
                                                                                         , tmpMov_Invoice AS (SELECT Movement.Id
                                                                                                                   , MovementString_ReceiptNumber.ValueData AS ReceiptNumber
                                                                                                                   , CASE WHEN MovementLinkObject_InvoiceKind.ObjectId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN 'receipt'  ELSE 'invoice' END AS InvoiceName
                                                                                                                   , MovementFloat_Amount.ValueData AS Amount
                                                                                                                   , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.Id) AS ord
                                                                                                              FROM Movement
                                                                                                                   INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                                                                                 ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                                                                                                AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                                                                                                                -- ������ ����������
                                                                                                                                                AND MovementLinkObject_InvoiceKind.ObjectId   = CASE WHEN inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END
                                                                                                                   LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                                                                                                           ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                                                          AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                                                                                   LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                                                                                                            ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                                                                                                           AND MovementString_ReceiptNumber.DescId     = zc_MovementString_ReceiptNumber()
                                                                                                              WHERE Movement.DescId   = zc_Movement_Invoice()
                                                                                                                -- ���� ��� ����� �������
                                                                                                                AND Movement.ParentId = inParentId
                                                                                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                                                AND MovementFloat_Amount.ValueData > 0
                                                                                                             )
                                                                                         , tmpRes AS (SELECT tmpMov_Invoice.Ord
                                                                                                           , CASE WHEN tmpMov_Invoice.Ord = 1
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)
                                                                                                                                      || CASE WHEN inInvoiceKindId IN (zc_Enum_InvoiceKind_PrePay(), zc_Enum_InvoiceKind_Return()) THEN ' Reservation Fee ' ELSE '' END
                                                                                                                  WHEN tmpMov_Invoice.Ord = 2
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber) || ' First Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount *100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                                  WHEN tmpMov_Invoice.Ord = 3
                                                                                                                       THEN 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)||' First and Second Advance-payment '
                                                                                                                         || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                         || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                                  ELSE 'Storno ' || tmpMov_Invoice.InvoiceName || '  ' || zfCalc_ReceiptNumber_print (tmpMov_Invoice.ReceiptNumber)||' First, Second and Third Advance-payment '
                                                                                                                    || ROUND (CASE WHEN COALESCE (tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpMov_Invoice.Amount * 100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                                                                                    || '% for ' || tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                                                                             END AS Comment

                                                                                                      FROM tmpMov_Invoice
                                                                                                           LEFT JOIN tmpProduct ON 1=1
                                                                                                      ORDER BY tmpMov_Invoice.Ord
                                                                                                     )
                                                                                       -- ���������
                                                                                       SELECT STRING_AGG (tmpRes.Comment, CHR (13)) FROM tmpRes
                                                                                      )  
                                              
                                           ELSE (WITH tmpProduct AS (SELECT *
                                                                     FROM gpSelect_Object_Product (inMovementId_OrderClient:= inParentId, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                                    )
                                                      -- ��� ��������� ������, � ������� ������ ���� ����, ������� ������
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
                                                      -- ������ �� ������ �����
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
                                                      -- ��� ��������� ����������, � ������� ������ ���� ��� ����� (����� ����� ����� ��� ����� �������� ����� ������ ����������)
                                                    , tmpMov_PrePay AS (SELECT Movement.Id
                                                                             , (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                                                                             , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.InvNumber) AS Ord
                                                                        FROM Movement
                                                                             INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                                                           ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                                                                          AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                                                                          AND MovementLinkObject_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_PrePay()
                                                                             LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                                                                     ON MovementFloat_Amount.MovementId = Movement.Id
                                                                                                    AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                                        WHERE Movement.DescId   = zc_Movement_Invoice()
                                                                          AND Movement.ParentId = inParentId
                                                                          AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.Id = ioId)
                                                                       )
                                                 -- ���������
                                                 SELECT CASE WHEN tmpPrePay.Ord = 1 THEN 'Reservation Fee '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                             WHEN tmpPrePay.Ord = 2 THEN 'First Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                             WHEN tmpPrePay.Ord = 3 THEN 'First and Second Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                             ELSE /*WHEN tmpPrePay.Ord = 4 THEN*/ 'First, Second and Third Advance-payment '
                                                               || ROUND (CASE WHEN COALESCE(tmpProduct.BasisWVAT_summ_transport,0) <> 0 THEN tmpInvoice.AmountIn*100 / tmpProduct.BasisWVAT_summ_transport ELSE 0 END, 0)
                                                               || '% for '||tmpProduct.modelname_full || ' Order: '|| zfCalc_InvNumber_print (tmpProduct.invnumber_orderclient)
                                                        END
                                                 FROM tmpInvoice
                                                      LEFT JOIN tmpProduct ON tmpProduct.Id = tmpInvoice.ProductId
                                                      --����� ����� ���������
                                                      LEFT JOIN (SELECT SUM (tmpMov_PrePay.Total_PrePay) AS Total_PrePay FROM  tmpMov_PrePay) AS tmpMov_PrePay ON 1 = 1
                                                      --����� ����������
                                                      LEFT JOIN tmpMov_PrePay AS tmpPrePay ON tmpPrePay.Id = tmpInvoice.Id

                                                 )
                                           END);
     END IF;


     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice())
     THEN
          PERFORM lpComplete_Movement_Invoice (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21         *

*/