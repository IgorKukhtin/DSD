-- Function: lpSetUnErased_MovementItem (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetUnErased_MovementItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inUserId              Integer
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId     Integer;
BEGIN
   -- устанавливаем новое значение
   outIsErased := FALSE;
 
   -- Обязательно меняем 
   UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
          RETURNING MovementId, DescId INTO vbMovementId, vbDescId;
 
   -- проверка - связанные документы Изменять нельзя
   -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= 'изменение');
 
   -- определяем <Статус>
   vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
 
   -- проверка - проведенные/удаленные документы Изменять нельзя
   IF vbStatusId <> zc_Enum_Status_UnComplete() AND vbDescId <> zc_MI_Sign()
   THEN
       RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

   -- 
   /*IF vbDescId <> zc_MI_Sign()
   THEN
       -- пересчитали Итоговые суммы по накладной
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
   END IF;*/


   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetUnErased_MovementItem (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        * set lp
 06.10.13                                        * add vbStatusId
 06.10.13                                        * add lfCheck_Movement_Parent
 06.10.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 06.10.13                                        * add outIsErased
 01.10.13                                        *
*/

-- тест
-- SELECT * FROM lpSetUnErased_MovementItem (inMovementItemId:= 0, inUserId:= '5')
