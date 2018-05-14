-- Function: lpUpdate_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_MemberExp (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ReturnIn_MemberExp(
    IN inMovementId          Integer   , -- ключ Документа
    IN inUserId              Integer     -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Sale  Integer;
   DECLARE vbMemberExpId      Integer;
BEGIN
     -- находим 1 не пустое основание (Док. продажи) из мастера
     vbMovementId_Sale := (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_Sale
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                                            AND MIFloat_MovementId.ValueData > 0
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           ORDER BY MovementItem.Id DESC
                           LIMIT 1
                          );

     -- если пустое находим по Чайлду
     IF COALESCE (vbMovementId_Sale, 0) = 0 
     THEN
         vbMovementId_Sale := (SELECT MIFloat_MovementId.ValueData      :: Integer AS MovementId_Sale
                               FROM MovementItem  
                                    INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()   
                                                                AND MIFloat_MovementId.ValueData > 0                      
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Child()
                                 AND MovementItem.isErased   = FALSE
                               LIMIT 1
                               );
     END IF;
     
     -- для Продажи получаем Экспедитора из "Заявка сторонняя от покупателя"
     vbMemberExpId := (SELECT MovementLinkObject_Personal.ObjectId AS MemberExpId
                       FROM MovementLinkMovement AS MovementLinkMovement_Order
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                         ON MovementLinkObject_Personal.MovementId = MovementLinkMovement_Order.MovementChildId
                                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                       WHERE MovementLinkMovement_Order.MovementId = vbMovementId_Sale
                         AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                       );
                       
     -- сохраняем свойство <Физические лица (Экспедитор)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberExp(), inMovementId, vbMemberExpId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.18         *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ReturnIn_MemberExp (5605163, 5)
