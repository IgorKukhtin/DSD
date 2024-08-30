-- Function: gpMovementItem_Promo_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Promo_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Promo_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_Promo());


     -- нашли
     vbMovementId:= (SELECT MI.MovementId FROM MovementItem AS MI WHERE MI.Id = inMovementItemId);

     -- восстановление
     outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


     -- если это Состояние Акции
     IF EXISTS (SELECT 1
                FROM MovementItem AS MI
                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                WHERE MI.Id        = inMovementItemId
                  AND MI.DescId    = zc_MI_Message()
               )
     THEN
         -- если НЕ последний
         IF inMovementItemId <> (SELECT MAX (MI.Id)
                                 FROM MovementItem AS MI
                                      JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                 WHERE MI.MovementId = vbMovementId
                                   AND MI.DescId     = zc_MI_Message()
                                   AND MI.isErased   = FALSE
                                )
         THEN
             RAISE EXCEPTION 'Ошибка.Восстанавливать можно только последнее состояние.';
         END IF;

         -- !!!пересчитали кто подписал/отменил + изменение модели!!!
         PERFORM lpUpdate_MI_Sign_Promo_recalc (vbMovementId, MI.ObjectId, vbUserId)
         FROM MovementItem AS MI
         WHERE MI.Id = inMovementItemId;

         -- нашли последний - и сохранили в шапку
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoStateKind(), vbMovementId, tmp.ObjectId)
               , lpInsertUpdate_MovementFloat (zc_MovementFloat_PromoStateKind(), vbMovementId, tmp.Amount)
                  -- сохранили свойство <Дата согласования>
               , lpInsertUpdate_MovementDate (zc_MovementDate_Check(), vbMovementId
                                            , CASE WHEN tmp.ObjectId = zc_Enum_PromoStateKind_Complete() THEN CURRENT_DATE ELSE NULL END
                                             )
                  -- сохранили свойство <Согласовано>
               , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbMovementId
                                               , CASE WHEN tmp.ObjectId = zc_Enum_PromoStateKind_Complete() THEN TRUE ELSE FALSE END
                                                )
         FROM (SELECT MI.ObjectId, MI.Amount
               FROM MovementItem AS MI
                    JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
               WHERE MI.MovementId = vbMovementId
                 AND MI.DescId     = zc_MI_Message()
                 AND MI.isErased   = FALSE
               ORDER BY MI.Id DESC
               LIMIT 1
              ) AS tmp;
     ELSE
         -- проверка - если есть подписи, корректировать нельзя
         PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= vbMovementId
                                            , inIsComplete:= FALSE
                                            , inIsUpdate  := TRUE
                                            , inUserId    := vbUserId
                                             );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.  Воробкало А.А.
 13.10.15                                                                      *
*/
