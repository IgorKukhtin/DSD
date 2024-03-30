-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementItemId Integer, InvNumber Integer, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountChild_diff TFloat
             , AmountChild TFloat
             , isError Boolean

             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
              -- Счет
             , MovementId_Invoice Integer, InvNumber_Invoice_Full TVarChar, InvNumber_Invoice TVarChar

             , InvNumber_Invoice_child TVarChar
             , ReceiptNumber_Invoice_child TVarChar
             , InvoiceKindName_child TVarChar
             , InfoMoneyName_child TVarChar
             , InfoMoneyName_all_child TVarChar
             , InvNumberFull_parent_child TVarChar
             , InvNumber_parent_child TVarChar
             , Comment_Product_child TVarChar

              -- Заказ Клиента / Заказ Поставщику
             , MovementId_parent Integer, InvNumberFull_parent TVarChar, InvNumber_parent TVarChar, MovementDescName_parent TVarChar
               --
             , Amount_Invoice TFloat

               --
             , Amount_Invoice_all TFloat
             , Amount_Pay_all     TFloat
             , Amount_diff        TFloat
             , isDiff             Boolean

             , ObjectName_Invoice TVarChar
             , ObjectDescName_Invoice TVarChar
             , InfoMoneyCode_Invoice Integer, InfoMoneyGroupName_Invoice TVarChar, InfoMoneyDestinationName_Invoice TVarChar, InfoMoneyName_Invoice TVarChar, InfoMoneyName_all_Invoice TVarChar

             , ProductCode_Invoice Integer
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar
             , PaidKindName_Invoice TVarChar
             , UnitName_Invoice TVarChar
             , ReceiptNumber_Invoice Integer
             , Comment_Invoice TVarChar
             , InvoiceKindName TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             --
             , String_1     TVarChar  --Bezeichnung Auftragskonto;                           имя счета заказа;
             , String_2     TVarChar  --IBAN Auftragskonto;                                  счет заказа IBAN;
             , String_3     TVarChar  --BIC Auf3ragskonto;                                   счет заказа BIC;
             , String_4     TVarChar  --Bankname Auftragskonto;                              Счет заказа на имя банка;
             , TDateTime_5  TVarChar  --Buchungstag;                                         день бронирования;
              --Movement - OperDate - 6TVarChar  --Valutadatum;                                         дата валютирования;
             , String_7     TVarChar  --Name Zahlungsbeteiligter;                            наименование плательщика;
             , String_8     TVarChar  --IBAN Zahlungsbeteiligter;                            сторона платежа IBAN;
             , String_9     TVarChar  --BIC (SWIFT-Code)Zahlungsbeteiligter;                 BIC (код SWIFT) стороны платежа;
             , String_10    TVarChar  --Buchungstext;                                        текст бронирования;
             , Blob_11      Text      --Verwendungszweck;                                    Цель использования;
             --zc_MI_Master.Amount - 12TVarChar  --Betrag;                                              Количество;
             , String_13    TVarChar  --Waehrung;                                            Валюта;
             , TFloat_14    TVarChar  --Saldo nach Buchung;                                  баланс после бронирования;
             , String_15    TVarChar  --Bemerkung;                                           Примечание;
             , String_16    TVarChar  --Kategorie;                                           Категория;
             , String_17    TVarChar  --Steuerrelevant;                                      Налоговый релевантный;
             , String_18    TVarChar  --Glaeubiger ID;                                       идентификатор кредитора;
             , String_19    TVarChar  --Mandatsreferenz                                      Ссылка на мандат
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

        -- Документы BankAccount
      , tmpMovement AS (SELECT Movement.*
                               -- здесь только ОДИН
                             , MLM_Invoice.MovementChildId AS MovementId_invoice
                        FROM tmpStatus
                             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.DescId = zc_Movement_BankAccount()
                                          AND Movement.StatusId = tmpStatus.StatusId
                             LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                                            ON MLM_Invoice.MovementId = Movement.Id
                                                           AND MLM_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
                        )
    -- все чайды
  , tmpMI_Child_all AS (SELECT MovementItem.MovementId
                               -- ВСЕ Счета
                             , MIFloat_MovementId.ValueData ::Integer AS MovementId_invoice
                               --
                             , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
                             , MovementString_ReceiptNumber.ValueData AS ReceiptNumber_Invoice
                             , Object_InvoiceKind.ValueData           AS InvoiceKindName

                             , Object_InfoMoney_View.InfoMoneyName
                             , Object_InfoMoney_View.InfoMoneyName_all

                             , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
                             , Movement_Parent.InvNumber AS InvNumber_parent
                             , ObjectString_Product_Comment.ValueData AS Comment_Product

                               -- Сумма Оплаты
                             , COALESCE (MovementItem.Amount, 0) AS Amount
                               -- Сумма по счету
                             , MovementFloat_Amount.ValueData AS Amount_invoice

                        FROM MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MIFloat_MovementId.ValueData ::Integer

                             -- тип счета
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                                         AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                             LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                             -- Официальный номер документа Счет
                             LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                      ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                                     AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                          ON MovementLinkObject_InfoMoney.MovementId = Movement_Invoice.Id
                                                         AND MovementLinkObject_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                             -- сумма счета
                             LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                     ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                                    AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()

                             -- Parent для Movement_Invoice - Документ Заказ или ?Заказ поставщику?
                             LEFT JOIN Movement AS Movement_Parent
                                                ON Movement_Parent.Id = Movement_Invoice.ParentId
                                               AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                          ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                                         AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
                             LEFT JOIN ObjectString AS ObjectString_Product_Comment
                                                    ON ObjectString_Product_Comment.ObjectId = MovementLinkObject_Product.ObjectId
                                                   AND ObjectString_Product_Comment.DescId   = zc_ObjectString_Product_Comment()

                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementItem.DescId   = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                       )
        --
      , tmpMovementString AS (SELECT MovementString.MovementId, MovementString.DescId, MovementString.ValueData
                              FROM MovementString
                              WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementString.DescId IN (zc_MovementString_1()
                                                            , zc_MovementString_2()
                                                            , zc_MovementString_3()
                                                            , zc_MovementString_4()
                                                            , zc_MovementString_7()
                                                            , zc_MovementString_8()
                                                            , zc_MovementString_9()
                                                            , zc_MovementString_10()
                                                            , zc_MovementString_13()
                                                            , zc_MovementString_15()
                                                            , zc_MovementString_16()
                                                            , zc_MovementString_17()
                                                            , zc_MovementString_18()
                                                            , zc_MovementString_19()
                                                            )
                              )
      , tmpMovementFloat AS (SELECT MovementFloat.*
                             FROM MovementFloat
                             WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementFloat.DescId IN (zc_MovementFloat_14())
                             )
      , tmpMovementDate AS (SELECT MovementDate.*
                                FROM MovementDate
                                WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementDate.DescId IN (zc_MovementDate_5())
                                )


        -- данные ОДНОГО Invoice
      , tmpInvoice_Params AS (SELECT tmp.MovementId_Invoice                              AS MovementId_Invoice
                                   , MovementFloat_Amount.ValueData            :: TFloat AS Amount
                                   , Object_Object.Id                                    AS ObjectId
                                   , Object_Object.ValueData                             AS ObjectName
                                   , ObjectDesc.ItemName                                 AS DescName_object
                                   , Object_InfoMoney_View.InfoMoneyId
                                   , Object_InfoMoney_View.InfoMoneyCode
                                   , Object_InfoMoney_View.InfoMoneyGroupName
                                   , Object_InfoMoney_View.InfoMoneyDestinationName
                                   , Object_InfoMoney_View.InfoMoneyName
                                   , Object_InfoMoney_View.InfoMoneyName_all

                                   , Object_PaidKind.Id                         AS PaidKindId
                                   , Object_PaidKind.ValueData                  AS PaidKindName
                                   , Object_Unit.Id                             AS UnitId
                                   , Object_Unit.ValueData                      AS UnitName
                                   , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber
                                   , MovementString_Comment.ValueData           AS Comment

                                   , Object_InvoiceKind.Id                      AS InvoiceKindId
                                   , Object_InvoiceKind.ValueData               AS InvoiceKindName

                              FROM (SELECT DISTINCT tmpMovement.MovementId_invoice FROM tmpMovement) AS tmp
                                    LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                            ON MovementFloat_Amount.MovementId = tmp.MovementId_Invoice
                                                           AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                                    LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                             ON MovementString_ReceiptNumber.MovementId = tmp.MovementId_Invoice
                                                            AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                                    LEFT JOIN MovementString AS MovementString_Comment
                                                             ON MovementString_Comment.MovementId = tmp.MovementId_Invoice
                                                            AND MovementString_Comment.DescId = zc_MovementString_Comment()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                                 ON MovementLinkObject_Object.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                                    LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId
                                    LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                                 ON MovementLinkObject_InfoMoney.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                    LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                 ON MovementLinkObject_InvoiceKind.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                    LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId
                              )
        -- все чайды
      , tmpMI_Child AS (SELECT tmpMI_Child_all.MovementId
                             , STRING_AGG (DISTINCT tmpMI_Child_all.InvNumber_Invoice, '; ')     AS InvNumber_Invoice
                             , STRING_AGG (DISTINCT tmpMI_Child_all.ReceiptNumber_Invoice, '; ') AS ReceiptNumber_Invoice
                             , STRING_AGG (DISTINCT tmpMI_Child_all.InvoiceKindName, '; ')       AS InvoiceKindName

                             , STRING_AGG (DISTINCT tmpMI_Child_all.InfoMoneyName, '; ')         AS InfoMoneyName
                             , STRING_AGG (DISTINCT tmpMI_Child_all.InfoMoneyName_all, '; ')     AS InfoMoneyName_all

                             , STRING_AGG (DISTINCT tmpMI_Child_all.InvNumberFull_parent, '; ')  AS InvNumberFull_parent
                             , STRING_AGG (DISTINCT tmpMI_Child_all.InvNumber_parent, '; ')      AS InvNumber_parent
                             , STRING_AGG (DISTINCT tmpMI_Child_all.Comment_Product, '; ')       AS Comment_Product_parent

                               -- Сумма Оплаты
                             , SUM (tmpMI_Child_all.Amount) AS Amount
                               -- Сумма по счетам
                             , SUM (tmpMI_Child_all.Amount_invoice) AS Amount_invoice

                        FROM tmpMI_Child_all
                        GROUP BY tmpMI_Child_all.MovementId
                       )
    -- у ВСЕХ Invoice нашли ВСЕ BankAccount
  , tmpInvoice_pay_all AS (SELECT tmp.MovementId_Invoice :: Integer AS MovementId_Invoice
                                  -- итого ВСЕ оплаты
                                , SUM (MovementItem.Amount) AS Summ
                           FROM (SELECT DISTINCT tmpMI_Child_all.MovementId_invoice :: TFloat AS MovementId_invoice FROM tmpMI_Child_all) AS tmp
                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.ValueData = tmp.MovementId_Invoice
                                                            AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                       AND MovementItem.DescId   = zc_MI_Child()
                                                       AND MovementItem.isErased = FALSE
                                INNER JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.Id       = MovementItem.MovementId
                                                                           AND Movement_BankAccount.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                                                                           AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                           GROUP BY tmp.MovementId_Invoice
                          )
                 -- у BankAccount нашли ВСЕ его Invoice - и все оплаты по ним
               , tmpInvoice_pay AS (SELECT tmpMovement.Id AS MovementId
                                         , SUM (tmpInvoice_pay_all.Summ) AS Summ
                                         --, COALESCE (tmpMI_Child_all.MovementId_invoice, tmpMovement.MovementId_invoice) AS MovementId_invoice
                                           -- № п/п - только в последнем платеже покажем Сумма по ВСЕМ Счетам
                                         /*, ROW_NUMBER() OVER (PARTITION BY COALESCE (tmpMI_Child_all.MovementId_invoice, tmpMovement.MovementId_invoice)
                                                              ORDER BY tmpMovement.OperDate DESC, tmpMovement.MovementId DESC
                                                             ) AS Ord*/
                                    FROM tmpMovement
                                         LEFT JOIN (SELECT DISTINCT tmpMI_Child_all.MovementId, tmpMI_Child_all.MovementId_invoice FROM tmpMI_Child_all
                                                   ) AS tmpMI_Child_all
                                                     ON tmpMI_Child_all.MovementId = tmpMovement.Id
                                         LEFT JOIN tmpInvoice_pay_all ON tmpInvoice_pay_all.MovementId_invoice = COALESCE (tmpMI_Child_all.MovementId_invoice, tmpMovement.MovementId_invoice)
                                    GROUP BY tmpMovement.Id
                                   )
       -- Результат
       SELECT
             Movement.Id
           , MovementItem.Id AS MovementItemId
           , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CASE WHEN MovementItem.Amount > 0 THEN  1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountOut
             -- Разница с Child
           , (MovementItem.Amount - COALESCE (tmpMI_Child.Amount,0)) ::TFloat AS AmountChild_diff
             -- Сумма Оплаты - Child
           , ABS (tmpMI_Child.Amount) ::TFloat AS AmountChild
             --
           , CASE WHEN MovementItem.Amount <> COALESCE (tmpMI_Child.Amount,0) THEN TRUE ELSE FALSE END ::Boolean AS isError


           , (CASE WHEN LENGTH (MovementBlob_11.ValueData) > 0 THEN '(' || LENGTH (MovementBlob_11.ValueData)  :: TVarChar || ') - ' 
                   WHEN MIString_Comment.ValueData <> '' THEN '(0) - (' || LENGTH (MIString_Comment.ValueData) :: TVarChar || ') - ' 
                   ELSE ''
              END || MIString_Comment.ValueData) :: TVarChar AS Comment
           , MovementItem.ObjectId             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.ValueData             AS BankName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectDesc.ItemName

           , Movement_Invoice.Id AS MovementId_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, tmpInvoice_Params.ReceiptNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full
           , Movement_Invoice.InvNumber        AS InvNumber_Invoice

           , tmpMI_Child.InvNumber_Invoice     ::TVarChar AS InvNumber_Invoice_child
           , tmpMI_Child.ReceiptNumber_Invoice ::TVarChar AS ReceiptNumber_Invoice_child
           , tmpMI_Child.InvoiceKindName       ::TVarChar AS InvoiceKindName_child
           , tmpMI_Child.InfoMoneyName         ::TVarChar AS InfoMoneyName_child
           , tmpMI_Child.InfoMoneyName_all     ::TVarChar AS InfoMoneyName_all_child
           , tmpMI_Child.InvNumberFull_parent  ::TVarChar AS InvNumberFull_parent_child
           , tmpMI_Child.InvNumber_parent      ::TVarChar AS InvNumber_parent_child
           , tmpMI_Child.Comment_Product_parent::TVarChar AS Comment_Product_child
           

             -- Заказ Клиента / Заказ Поставщику
           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
           , Movement_Parent.InvNumber                 AS InvNumber_parent
           , MovementDesc_Parent.ItemName              AS MovementDescName_parent

             -- Сумма по Счету - только в последнем платеже
           , 0 :: TFloat AS Amount_Invoice
             -- Сумма по ВСЕМ Счетам - в КАЖДОМ платеже
           , tmpMI_Child.Amount_Invoice     :: TFloat AS Amount_Invoice_all
             -- Сумма по ВСЕМ Счетам - в КАЖДОМ платеже
           , tmpInvoice_pay.Summ            :: TFloat AS Amount_Pay_all
             -- Разница с суммой по Счету - только в КАЖДОМ платеже покажем
           , (COALESCE (tmpMI_Child.Amount_Invoice, 0) - COALESCE (tmpInvoice_pay.Summ, 0)) :: TFloat AS Amount_diff

           , CASE WHEN COALESCE (tmpMI_Child.Amount_Invoice, 0) <> COALESCE (tmpInvoice_pay.Summ, 0)
                  THEN TRUE
                  WHEN COALESCE (tmpMI_Child.Amount_Invoice, 0) = 0 AND COALESCE (tmpInvoice_pay.Summ, 0) = 0
                  THEN TRUE
                  ELSE FALSE
             END ::Boolean AS isDiff

           , tmpInvoice_Params.ObjectName               AS ObjectName_Invoice
           , tmpInvoice_Params.DescName_object          AS ObjectDescName_Invoice
           , tmpInvoice_Params.InfoMoneyCode            AS InfoMoneyCode_Invoice
           , tmpInvoice_Params.InfoMoneyGroupName       AS InfoMoneyGroupName_Invoice
           , tmpInvoice_Params.InfoMoneyDestinationName AS InfoMoneyDestinationName_Invoice
           , tmpInvoice_Params.InfoMoneyName            AS InfoMoneyName_Invoice
           , tmpInvoice_Params.InfoMoneyName_all        AS InfoMoneyName_all_Invoice

           , Object_Product.ObjectCode                                                       AS ProductCode_Invoice
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName_Invoice
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN_Invoice


           , tmpInvoice_Params.PaidKindName        AS PaidKindName_Invoice
           , tmpInvoice_Params.UnitName            AS UnitName_Invoice
           , zfConvert_StringToNumber (tmpInvoice_Params.ReceiptNumber) AS ReceiptNumber_Invoice
           , tmpInvoice_Params.Comment             AS Comment_Invoice
           , tmpInvoice_Params.InvoiceKindName     AS InvoiceKindName

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

           --
           , MovementString_1.ValueData   ::TVarChar AS String_1
           , MovementString_2.ValueData   ::TVarChar AS String_2
           , MovementString_3.ValueData   ::TVarChar AS String_3
           , MovementString_4.ValueData   ::TVarChar AS String_4
           , MovementDate_5.ValueData     ::TVarChar AS TDateTime_5
           , MovementString_7.ValueData   ::TVarChar AS String_7
           , MovementString_8.ValueData   ::TVarChar AS String_8
           , MovementString_9.ValueData   ::TVarChar AS String_9
           , MovementString_10.ValueData  ::TVarChar AS String_10
           , MovementBlob_11.ValueData    ::Text     AS Blob_11
           , MovementString_13.ValueData  ::TVarChar AS String_13
           , MovementFloat_14.ValueData   ::TVarChar AS TFloat_14
           , MovementString_15.ValueData  ::TVarChar AS String_15
           , MovementString_16.ValueData  ::TVarChar AS String_16
           , MovementString_17.ValueData  ::TVarChar AS String_17
           , MovementString_18.ValueData  ::TVarChar AS String_18
           , MovementString_19.ValueData  ::TVarChar AS String_19
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement.MovementId_invoice
            -- данные ОДНОГО Invoice
            LEFT JOIN tmpInvoice_Params ON tmpInvoice_Params.MovementId_Invoice = Movement_Invoice.Id

            -- итого Child
            LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = Movement.Id

            -- у BankAccount нашли ВСЕ его Invoice - и ВСЕ оплаты по ним
            LEFT JOIN tmpInvoice_pay ON tmpInvoice_pay.MovementId = Movement.Id

            -- Parent для Movement_Invoice - Документ Заказ или Приход
            LEFT JOIN Movement AS Movement_Parent
                               ON Movement_Parent.Id = Movement_Invoice.ParentId
                              AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()

            -- данные BankAccount
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementItem.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId


            --
            LEFT JOIN tmpMovementString AS MovementString_1
                                        ON MovementString_1.MovementId = Movement.Id
                                       AND MovementString_1.DescId = zc_MovementString_1()
            LEFT JOIN tmpMovementString AS MovementString_2
                                        ON MovementString_2.MovementId = Movement.Id
                                       AND MovementString_2.DescId = zc_MovementString_2()
            LEFT JOIN tmpMovementString AS MovementString_3
                                        ON MovementString_3.MovementId = Movement.Id
                                       AND MovementString_3.DescId = zc_MovementString_3()
            LEFT JOIN tmpMovementString AS MovementString_4
                                        ON MovementString_4.MovementId = Movement.Id
                                       AND MovementString_4.DescId = zc_MovementString_4()
            LEFT JOIN tmpMovementString AS MovementString_7
                                        ON MovementString_7.MovementId = Movement.Id
                                       AND MovementString_7.DescId = zc_MovementString_7()
            LEFT JOIN tmpMovementString AS MovementString_8
                                        ON MovementString_8.MovementId = Movement.Id
                                       AND MovementString_8.DescId = zc_MovementString_8()
            LEFT JOIN tmpMovementString AS MovementString_9
                                        ON MovementString_9.MovementId = Movement.Id
                                       AND MovementString_9.DescId = zc_MovementString_9()
            LEFT JOIN tmpMovementString AS MovementString_10
                                        ON MovementString_10.MovementId = Movement.Id
                                       AND MovementString_10.DescId = zc_MovementString_10()

            LEFT JOIN MovementBlob AS MovementBlob_11
                                   ON MovementBlob_11.MovementId = Movement.Id
                                  AND MovementBlob_11.DescId = zc_MovementBlob_11()

            LEFT JOIN tmpMovementString AS MovementString_13
                                        ON MovementString_13.MovementId = Movement.Id
                                       AND MovementString_13.DescId = zc_MovementString_13()
            LEFT JOIN tmpMovementString AS MovementString_15
                                        ON MovementString_15.MovementId = Movement.Id
                                       AND MovementString_15.DescId = zc_MovementString_15()
            LEFT JOIN tmpMovementString AS MovementString_16
                                        ON MovementString_16.MovementId = Movement.Id
                                       AND MovementString_16.DescId = zc_MovementString_16()
            LEFT JOIN tmpMovementString AS MovementString_17
                                        ON MovementString_17.MovementId = Movement.Id
                                       AND MovementString_17.DescId = zc_MovementString_17()
            LEFT JOIN tmpMovementString AS MovementString_18
                                        ON MovementString_18.MovementId = Movement.Id
                                       AND MovementString_18.DescId = zc_MovementString_18()
            LEFT JOIN tmpMovementString AS MovementString_19
                                        ON MovementString_19.MovementId = Movement.Id
                                       AND MovementString_19.DescId = zc_MovementString_19()

            LEFT JOIN tmpMovementDate AS MovementDate_5
                                      ON MovementDate_5.MovementId = Movement.Id
                                     AND MovementDate_5.DescId = zc_MovementDate_5()
            LEFT JOIN tmpMovementFloat AS MovementFloat_14
                                       ON MovementFloat_14.MovementId = Movement.Id
                                      AND MovementFloat_14.DescId = zc_MovementFloat_14()
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.24         *
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_BankAccount (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
