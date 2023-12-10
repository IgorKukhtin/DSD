-- Function: gpGet_Movement_Invoice_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inMovementId_Parent  Integer  , -- 
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Invoice());

     vbPrintFormName:=
      (WITH
        -- Все документы, в которых указан этот Счет, возьмем первый
       tmpMov_Parent AS (SELECT Movement.Id
                              , ROW_NUMBER() OVER (ORDER BY Movement.OperDate, Movement.InvNumber) AS ord
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                            ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                           AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.ParentId = inMovementId_Parent
                           AND Movement.StatusId = zc_Enum_Status_Complete() --zc_Enum_Status_Erased()
                         )

       -- Результат
       SELECT CASE WHEN COALESCE (MovementItem.Id,0) <> 0                                        ---если заполнен zc_MI_Master
                        THEN 'PrintMovement_Invoice_Master'

                   WHEN MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()       --первую предоплата
                        THEN CASE WHEN tmpMov_Parent.Ord = 1 THEN 'PrintMovement_Invoice_PrePay'
                                  WHEN tmpMov_Parent.Ord = 2 THEN 'PrintMovement_Invoice_PrePay2'   -- 2 предоплата
                                  ELSE 'PrintMovement_Invoice_PrePay'
                             END

                   WHEN MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_Return()   -- возврат
                        THEN 'PrintMovement_Invoice_Return'

                   WHEN MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_Pay()       --счет
                        THEN 'PrintMovement_Invoice_Pay'

                   ELSE 'PrintMovement_Invoice'
              END AS PrintFormName

       FROM Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                        ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                       AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
           LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = False  
           LEFT JOIN tmpMov_Parent ON tmpMov_Parent.Id = Movement.Id

       WHERE Movement.Id = inMovementId
       LIMIT 1
      );

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.23         *
*/

-- тест
-- SELECT gpGet_Movement_Invoice_ReportName FROM gpGet_Movement_Invoice_ReportName(inMovementId := 891,  inSession := zfCalc_UserAdmin()); -- все
