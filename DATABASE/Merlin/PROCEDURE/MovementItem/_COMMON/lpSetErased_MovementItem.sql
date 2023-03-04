 -- Function: lpSetErased_MovementItem (Integer, Integer)
 
 DROP FUNCTION IF EXISTS lpSetErased_MovementItem (Integer, Integer);
 
 CREATE OR REPLACE FUNCTION lpSetErased_MovementItem(
     IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
    OUT outIsErased           Boolean              , -- новое значение
     IN inUserId              Integer
 )                              
   RETURNS Boolean
 AS
 $BODY$
    DECLARE vbMovementId Integer;
    DECLARE vbStatusId   Integer;
    DECLARE vbDescId     Integer;
    DECLARE vbMovementDescId Integer;
 BEGIN
   -- устанавливаем новое значение
   outIsErased := TRUE;
 
   -- Обязательно меняем 
   UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
          RETURNING MovementId, DescId INTO vbMovementId, vbDescId;
 
   -- проверка - связанные документы Изменять нельзя
   -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= 'изменение');
 
   -- определяем <Статус>
   SELECT StatusId, DescId INTO vbStatusId, vbMovementDescId FROM Movement WHERE Id = vbMovementId;

   -- проверка - проведенные/удаленные документы Изменять нельзя
   IF vbStatusId <> zc_Enum_Status_UnComplete() AND vbDescId <> zc_MI_Sign()
      AND (vbMovementDescId <> zc_Movement_Cash() OR vbDescId <> zc_MI_Child())
   THEN

       RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
   END IF;
 
   IF vbMovementDescId = zc_Movement_Cash() AND vbDescId = zc_MI_Child()
   THEN
       -- Если Корректировка подтверждена
       IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = vbMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
       THEN
           RAISE EXCEPTION 'Ошибка.Нельзя удалять, корректировка уже подтверждена.';
       ELSE
           -- Удаляем ВСЕ подписи
           PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
           FROM MovementItem
           WHERE MovementItem.MovementId = vbMovementId
             AND MovementItem.DescId     = zc_MI_Sign()
             AND MovementItem.isErased   = FALSE
            ;
       END IF;

   END IF;

   -- 
   /*IF vbDescId <> zc_MI_Sign()
   THEN
       -- пересчитали Итоговые суммы по накладной
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
   END IF;*/
 
   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= TRUE);
 
 
 END;
 $BODY$
   LANGUAGE plpgsql VOLATILE;
 
 /*-------------------------------------------------------------------------------
  ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  09.10.14                                        * set lp
  02.04.14                                        * add zc_Enum_Role_Admin
  06.10.13                                        * add vbStatusId
  06.10.13                                        * add lfCheck_Movement_Parent
  06.10.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
  06.10.13                                        * add outIsErased
  01.10.13                                        *
 */
 
 -- тест
 -- SELECT * FROM lpSetErased_MovementItem (inMovementItemId:= 0, inUserId:= '5')
