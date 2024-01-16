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
             , Amount TFloat
             , MovementId_Invoice Integer, InvNumber_Invoice_Full TVarChar
             , InvoiceKindId Integer, InvoiceKindName  TVarChar
             , Amount_Invoice TFloat
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

     IF COALESCE (inMovementItemId,0) = 0
     THEN
     RETURN QUERY
         SELECT Movement.Id        AS MovementId
              , Movement.InvNumber AS InvNumber
              , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
              , Movement.OperDate  AS OperDate
              , Object_MoneyPlace.Id                   AS ObjectId
              , Object_MoneyPlace.ValueData ::TVarChar AS ObjectName
              , ''::TVarChar AS Comment
              , inAmount ::TFloat AS Amount
              , 0            AS MovementId_Invoice
              , ''::TVarChar AS InvNumber_Invoice_Full
              --, NULL :: Integer AS ReceiptNumber_Invoice
              , 0            AS InvoiceKindId
              , ''::TVarChar AS InvoiceKindName 
              , 0 ::TFloat   AS Amount_Invoice
         FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

         WHERE Movement.Id = inMovementId
         ;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id        AS MovementId
           , Movement.InvNumber AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , Movement.OperDate  AS OperDate

           , Object_Object.Id              AS ObjectId
           , Object_Object.ValueData       AS ObjectName
           , MIString_Comment.ValueData    AS Comment

           , MovementItem.Amount  ::TFloat AS Amount

           , Movement_Invoice.Id AS MovementId_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full
           --, zfConvert_StringToNumber (MovementString_ReceiptNumber.ValueData) ::Integer AS ReceiptNumber_Invoice

           , Object_InvoiceKind.Id             AS InvoiceKindId
           , Object_InvoiceKind.ValueData      AS InvoiceKindName 
           , MovementFloat_Amount.ValueData ::TFloat AS Amount_Invoice

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Child()
                                   AND MovementItem.Id = inMovementItemId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MIFloat_MovementId.ValueData ::Integer
            --номер счета
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
            --тип счета
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId  
            -- Сумма счета
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
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
