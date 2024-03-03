-- Function: gpGet_Movement_Invoice_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_ReportName (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inMovementId_Parent  Integer  , -- Заказ Клиента / Заказ Поставщику
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (gpGet_Movement_Invoice_ReportName               TVarChar
             , InvoiceFileName                                 TVarChar)
AS
$BODY$
   DECLARE vbPrintFormName    TVarChar;
   DECLARE vbInvoiceFileName  TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Invoice());

     vbPrintFormName:=
      (WITH
       -- Все Счета Предоплаты для Заказ Клиента, проверим нужный
       tmpMov_Parent AS (SELECT Movement.Id
                                -- № предоплаты
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

     -- Названия файла - для сохранения PDF
     vbInvoiceFileName := 'Invoice_'||COALESCE((SELECT COALESCE (MovementString_ReceiptNumber.ValueData, 'XXX')||'_'||
                                                       zfConvert_DateShortToString (Movement.OperDate)
                                                FROM Movement
                                                     -- Официальный номер квитанции - Quittung Nr
                                                     LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                                              ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                                             AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
                                                WHERE Movement.Id = inMovementId), 'XXXX_XXXX');

     /*IF vbInvoiceFileName NOT ILIKE '%.pdf'
     THEN
          vbInvoiceFileName:= vbInvoiceFileName || '.pdf';
     END IF;*/


     -- Результат
     RETURN QUERY
        SELECT vbPrintFormName    -- Печатная форма
             , vbInvoiceFileName  -- Названия файла - для сохранения PDF
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.02.24                                                       *
 08.12.23         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Invoice_ReportName (inMovementId := 1808 , inMovementId_parent := 890 ,  inSession := zfCalc_UserAdmin());
