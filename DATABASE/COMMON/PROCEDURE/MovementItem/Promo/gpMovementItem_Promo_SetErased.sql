-- Function: gpMovementItem_Promo_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Promo_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Promo_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbMovementId      Integer;
   DECLARE vbSignInternalId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Promo());


     -- нашли
     vbMovementId:= (SELECT MI.MovementId FROM MovementItem AS MI WHERE MI.Id = inMovementItemId);

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
             RAISE EXCEPTION 'Ошибка.Удалять можно только последнее состояние.';
         END IF;

         -- Проверка
         IF inMovementItemId = (SELECT MI.Id
                                FROM MovementItem AS MI
                                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                WHERE MI.MovementId = vbMovementId
                                  AND MI.DescId     = zc_MI_Message()
                                  AND MI.isErased   = FALSE
                                ORDER BY MI.Id ASC
                                LIMIT 1
                               )
         THEN
             RAISE EXCEPTION 'Ошибка.Первое состояние <%> не может быть удалено.', lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Start());
         END IF;


         -- удаление
         outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

                                                
         -- Проверка, если после удаления такое состояние
         IF zc_Enum_PromoStateKind_Main() = (SELECT MI.ObjectId
                                             FROM MovementItem AS MI
                                                  JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind()
                                             WHERE MI.MovementId = vbMovementId
                                               AND MI.DescId     = zc_MI_Message()
                                               AND MI.isErased   = FALSE
                                             ORDER BY MI.Id DESC
                                             LIMIT 1
                                            )
         THEN
             RAISE EXCEPTION 'Ошибка.Документ нельзя вернуть состояние <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Main());
         END IF;


         -- если надо убрать подпись
         IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = inMovementItemId AND MI.ObjectId IN (zc_Enum_PromoStateKind_Complete()))
         THEN
             -- убрали подпись
             PERFORM gpInsertUpdate_MI_Sign (vbMovementId, FALSE, vbUserId :: TVarChar);
         END IF;

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
         -- удаление
         outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.  Воробкало А.А.
 13.10.15                                                                      *
*/
