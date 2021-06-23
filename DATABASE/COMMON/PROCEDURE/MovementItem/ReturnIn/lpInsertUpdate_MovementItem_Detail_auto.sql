-- Function: lpInsertUpdate_MovementItem_Detail_auto()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Detail_auto (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Detail_auto(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
     -- перенесли признак "удален"
     UPDATE MovementItem SET isErased = MI_Master.isErased
     FROM MovementItem AS MI_Master
     WHERE MI_Master.MovementId    = inMovementId
       AND MI_Master.DescId        = zc_MI_Master()
       AND MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Detail()
       AND MovementItem.ParentId   = MI_Master.Id
       AND MovementItem.isErased   <> MI_Master.isErased
    ;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (MI_Detail.Id, zc_MI_Detail(), MovementItem.ObjectId, inMovementId, MovementItem.Amount, MovementItem.Id)
     FROM MovementItem
          LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.MovementId = inMovementId
                                             AND MI_Detail.DescId     = zc_MI_Detail()
                                             AND MI_Detail.ParentId   = MovementItem.Id
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MI_Detail.ParentId IS NULL
    ;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, TRUE)
     FROM (-- сохранили свойство - ВСЕМ
           SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Reason(),     MovementItem.Id, COALESCE (MILO_Reason.ObjectId, OB_Reason_ReturnIn.ObjectId, OB_Reason_SendOnPrice.ObjectId))
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReturnKind(), MovementItem.Id, COALESCE (MILO_ReturnKind.ObjectId, OL_Reason_ReturnKind.ChildObjectId))
                , MovementItem.Id AS MovementItemId
           FROM MovementItem
                LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                 ON MILO_Reason.MovementItemId = MovementItem.Id
                                                AND MILO_Reason.DescId         = zc_MILinkObject_Reason()
                LEFT JOIN MovementItemLinkObject AS MILO_ReturnKind
                                                 ON MILO_ReturnKind.MovementItemId = MovementItem.Id
                                                AND MILO_ReturnKind.DescId         = zc_MILinkObject_ReturnKind()

                LEFT JOIN ObjectBoolean AS OB_Reason_ReturnIn
                                        ON OB_Reason_ReturnIn.ValueData = TRUE
                                       AND OB_Reason_ReturnIn.DescId    = zc_ObjectBoolean_Reason_ReturnIn()
                                       AND Movement.DescId              = zc_Movement_ReturnIn()
                LEFT JOIN ObjectBoolean AS OB_Reason_SendOnPrice
                                        ON OB_Reason_SendOnPrice.ValueData = TRUE
                                       AND OB_Reason_SendOnPrice.DescId    = zc_ObjectBoolean_Reason_SendOnPrice()
                                       AND Movement.DescId                 IN (zc_Movement_SendOnPrice(), zc_Movement_Send())
                LEFT JOIN ObjectLink AS OL_Reason_ReturnKind
                                     ON OL_Reason_ReturnKind.ObjectId = COALESCE (OB_Reason_ReturnIn.ObjectId, OB_Reason_SendOnPrice.ObjectId)
                                    AND OL_Reason_ReturnKind.DescId   = zc_ObjectLink_Reason_ReturnKind()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Detail()
           --AND MovementItem.isErased   = FALSE
             AND (MILO_Reason.ObjectId IS NULL OR MILO_ReturnKind.ObjectId IS NULL)
          ) AS tmp
     ;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 20.06.21                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Detail_auto (inMovementId:= 20168624, inUserId:= 5)
