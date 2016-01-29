-- Function: gpMovementItem_IncomeFuel_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_IncomeFuel_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_IncomeFuel_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
   OUT outStartOdometre_calc TFloat    , --
   OUT outEndOdometre_calc   TFloat    , --
   OUT outDistanceDiff       TFloat    , --
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS record
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbDistance Tfloat;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel());

  -- устанавливаем новое значение
  outIsErased := FALSE;

  -- Обязательно меняем
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;
  
  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;


     -- пересчитываем для ВСЕХ MovementItem
     SELECT SUM (COALESCE (MIFloat_EndOdometre.ValueData, 0) - COALESCE (MIFloat_StartOdometre.ValueData, 0))      -- пробег факт ,км
          , MIN (COALESCE (MIFloat_StartOdometre.ValueData, 0)), MAX (COALESCE (MIFloat_EndOdometre.ValueData, 0)) -- нач. и кон. показания спидометра
            INTO vbDistance, outStartOdometre_calc, outEndOdometre_calc 
     FROM MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                        ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
            LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                        ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
     WHERE MovementItem.MovementId = vbMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = False;
     -- сохранение
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_Distance(), vbMovementId, vbDistance);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_StartOdometre(), vbMovementId, outStartOdometre_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_EndOdometre(), vbMovementId, outEndOdometre_calc);

     -- рассчитываем Пробег итог, км - для ВСЕХ MovementItem
     outDistanceDiff:= outEndOdometre_calc - outStartOdometre_calc;



  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.01.16         *

*/

-- тест
-- SELECT * FROM gpMovementItem_Sale_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
