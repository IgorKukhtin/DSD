-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_MI_BankAccount_Child (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_BankAccount_Child (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_BankAccount_Child(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementItemId    Integer  ,
    IN inAmount            TFloat   ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , ObjectId Integer, ObjectName TVarChar
             , Comment TVarChar
             , Comment_master Text
             , Amount TFloat, Amount_pay TFloat
             , MovementId_Invoice Integer, InvNumber_Invoice_Full TVarChar
             , InvoiceKindId Integer, InvoiceKindName  TVarChar
             , InfoMoneyId     Integer
             , InfoMoneyName_all TVarChar
             , Amount_Invoice TFloat
             , MovementId_parent Integer, InvNumberFull_parent TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.Документ не сохранен';
     END IF;

     IF COALESCE (inMovementItemId, 0) = 0
     THEN
         -- Результат
         RETURN QUERY
             SELECT Movement.Id                               AS MovementId
                  , Movement.InvNumber                        AS InvNumber
                  , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                  , Movement.OperDate                         AS OperDate

                  , Object_MoneyPlace.Id                      AS ObjectId
                  , Object_MoneyPlace.ValueData   :: TVarChar AS ObjectName
                  , ''                            :: TVarChar AS Comment
                  , MovementBlob_Comment.ValueData:: Text     AS Comment_master

                    -- всегда ABS расчетное значение - Разница оплаты и Итого по Счетам
                  , ABS ((SELECT MovementItem.Amount - SUM (COALESCE (MI_Child.Amount, 0))
                          FROM MovementItem
                               LEFT JOIN MovementItem AS MI_Child
                                                      ON MI_Child.MovementId = inMovementId
                                                     AND MI_Child.DescId     = zc_MI_Child()
                                                     AND MI_Child.isErased   = FALSE
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                          GROUP BY MovementItem.Amount
                        )) ::TFloat AS Amount

                    -- всегда ABS
                  , ABS (MovementItem.Amount)     :: TFloat   AS Amount_pay
                    --
                  , 0               AS MovementId_Invoice
                  , ''::TVarChar    AS InvNumber_Invoice_Full
                  , 0               AS InvoiceKindId
                  , ''::TVarChar    AS InvoiceKindName
                  , Object_InfoMoney_View.InfoMoneyId
                  , Object_InfoMoney_View.InfoMoneyName
                  , 0 ::TFloat      AS Amount_Invoice
                  , 0               AS MovementId_parent
                  , NULL ::TVarChar AS InvNumberFull_parent
             FROM Movement
                  LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                           ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                          AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                  -- Примечание (Цель использования)
                  LEFT JOIN MovementBlob AS MovementBlob_Comment
                                         ON MovementBlob_Comment.MovementId = Movement.Id
                                        AND MovementBlob_Comment.DescId     = zc_MovementBlob_11()

                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId    = zc_MI_Master()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                  LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                 ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                                AND MovementLinkMovement_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                               ON MovementLinkObject_InfoMoney.MovementId = MovementLinkMovement_Invoice.MovementChildId
                                              AND MovementLinkObject_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

             WHERE Movement.Id = inMovementId
             ;
     ELSE
         -- Результат
         RETURN QUERY
           SELECT
                 Movement.Id                               AS MovementId
               , Movement.InvNumber                        AS InvNumber
               , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
               , Movement.OperDate                         AS OperDate

               , Object_MoneyPlace.Id                      AS ObjectId
               , Object_MoneyPlace.ValueData               AS ObjectName
               , MIString_Comment.ValueData                AS Comment
               , MovementBlob_Comment.ValueData :: Text    AS Comment_master
                 -- всегда ABS
               , ABS (MI_Child.Amount)          :: TFloat  AS Amount
                 -- всегда ABS
               , ABS (MovementItem.Amount)     :: TFloat   AS Amount_pay

               , Movement_Invoice.Id AS MovementId_Invoice
               , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full
               --, zfConvert_StringToNumber (MovementString_ReceiptNumber.ValueData) ::Integer AS ReceiptNumber_Invoice

               , Object_InvoiceKind.Id                     AS InvoiceKindId
               , Object_InvoiceKind.ValueData              AS InvoiceKindName
               , Object_InfoMoney_View.InfoMoneyId
               , Object_InfoMoney_View.InfoMoneyName

                 -- всегда ABS
               , ABS (MovementFloat_Amount.ValueData) :: TFloat AS Amount_Invoice

                 -- Заказ Клиента / Заказ Поставщику
               , Movement_Parent.Id                        AS MovementId_parent
               , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent

           FROM Movement
                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                         ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                -- Примечание (Цель использования)
                LEFT JOIN MovementBlob AS MovementBlob_Comment
                                       ON MovementBlob_Comment.MovementId = Movement.Id
                                      AND MovementBlob_Comment.DescId     = zc_MovementBlob_11()

                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                      AND MovementItem.DescId    = zc_MI_Master()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                 ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                INNER JOIN MovementItem AS MI_Child
                                        ON MI_Child.MovementId = Movement.Id
                                       AND MI_Child.DescId     = zc_MI_Child()
                                       AND MI_Child.Id         = inMovementItemId

                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MI_Child.Id
                                            AND MIString_Comment.DescId         = zc_MIString_Comment()

                LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                            ON MIFloat_MovementId.MovementItemId = MI_Child.Id
                                           AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MIFloat_MovementId.ValueData ::Integer
                -- Официальный номер документа Счет
                LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                         ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                        AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
                -- тип счета
                LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                             ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                            AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                             ON MovementLinkObject_InfoMoney.MovementId = Movement_Invoice.Id
                                            AND MovementLinkObject_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                -- Сумма счета
                LEFT JOIN MovementFloat AS MovementFloat_Amount
                                        ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                       AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                -- Parent для Movement_Invoice - Документ Заказ или Приход
                LEFT JOIN Movement AS Movement_Parent
                                   ON Movement_Parent.Id       = Movement_Invoice.ParentId
                                  AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()

           WHERE Movement.Id = inMovementId;

      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
-- SELECT * FROM gpGet_MI_BankAccount_Child (inMovementId:= 271, inMovementItemId:= 0 , inAmount:= 0, inSession:= zfCalc_UserAdmin());
