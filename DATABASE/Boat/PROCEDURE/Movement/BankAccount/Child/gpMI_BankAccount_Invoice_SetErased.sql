-- Function: gpMI_BankAccount_Invoice_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMI_BankAccount_Invoice_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMI_BankAccount_Invoice_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbMovementId_Invoice TFloat;
BEGIN
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Invoice());
     vbUserId:= inSession;


     -- документ Счет
     vbMovementId_Invoice:= (SELECT MIFloat_MovementId.ValueData FROM MovementItemFloat AS MIFloat_MovementId WHERE MIFloat_MovementId.MovementItemId = inMovementItemId AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId());

     -- проверка
     IF COALESCE (vbMovementId_Invoice, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Счет> не установлен.';
     END IF;

     -- проверка
     IF EXISTS (SELECT 1
                FROM MovementItemFloat AS MIFloat_MovementId
                     INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                            AND MovementItem.DescId   = zc_MI_Child()
                                            AND MovementItem.isErased = FALSE
                                            -- Не текущий элемент
                                            AND MovementItem.Id       <> inMovementItemId
                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                        AND Movement.DescId   = zc_Movement_BankAccount()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                WHERE MIFloat_MovementId.ValueData = vbMovementId_Invoice
                  AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Нельзя удалить документ <Счет> %.%По нему найдена сумма оплаты = <%> %в документе <Расчетный счет> % %на сумму <%>.'
                         , (SELECT zfCalc_InvNumber_two_isErased ('', Movement.InvNumber, MovementString_ReceiptNumber.ValueData, Movement.OperDate, Movement.StatusId)
                            FROM Movement
                                 -- Официальный номер документа Счет
                                 LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                          ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                         AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
                            WHERE Movement.Id = vbMovementId_Invoice
                           )
                         , CHR (13)
                         , (SELECT zfConvert_FloatToString (ABS (MovementItem.Amount)) -- всегда ABS
                            FROM MovementItemFloat AS MIFloat_MovementId
                                 INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MovementItem.DescId   = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        -- Не текущий элемент
                                                        AND MovementItem.Id       <> inMovementItemId
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_BankAccount()
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                            WHERE MIFloat_MovementId.ValueData = vbMovementId_Invoice
                              AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                            ORDER BY Movement.OperDate DESC
                                   , Movement.Id       DESC
                                   , MovementItem.Id   DESC
                            LIMIT 1
                           )
                         , CHR (13)
                         , (SELECT zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId)
                            FROM MovementItemFloat AS MIFloat_MovementId
                                 INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MovementItem.DescId   = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        -- Не текущий элемент
                                                        AND MovementItem.Id       <> inMovementItemId
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_BankAccount()
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                            WHERE MIFloat_MovementId.ValueData = vbMovementId_Invoice
                              AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                            ORDER BY Movement.OperDate DESC
                                   , Movement.Id       DESC
                                   , MovementItem.Id   DESC
                            LIMIT 1
                           )
                         , CHR (13)
                         , (SELECT zfConvert_FloatToString (ABS (MI_Master.Amount)) -- всегда ABS
                            FROM MovementItemFloat AS MIFloat_MovementId
                                 INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MovementItem.DescId   = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        -- Не текущий элемент
                                                        AND MovementItem.Id       <> inMovementItemId
                                 INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                    AND Movement.DescId   = zc_Movement_BankAccount()
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.isErased   = FALSE
                            WHERE MIFloat_MovementId.ValueData = vbMovementId_Invoice
                              AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                            ORDER BY Movement.OperDate DESC
                                   , Movement.Id       DESC
                                   , MovementItem.Id   DESC
                            LIMIT 1
                           )
                         ;
     END IF;



     -- Удаляем Документ
     PERFORM gpSetErased_Movement_Invoice (inMovementId := vbMovementId_Invoice :: Integer
                                         , inSession    := inSession
                                          );

     -- устанавливаем новое значение
     outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.24                                        *
*/

-- тест
--