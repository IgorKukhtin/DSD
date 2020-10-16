-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- определяем <Статус>
    SELECT Movement.StatusId, Movement.OperDate 
    INTO vbStatusId, vbOperDate   
    FROM Movement 
    WHERE Movement.Id = inMovementId;

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    SELECT Movement.ID
    INTO vbMovementId  
    FROM Movement 
    WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH' 
      AND Movement.DescId = zc_Movement_Wages();
    
    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy (ioId                      := COALESCE(MovementItemCurr.Id, 0)             -- Ключ объекта <Элемент документа>
                                                                    , inMovementId              := inMovementId                                 -- ключ Документа
                                                                    , inUnitID                  := MovementItem.ObjectID                        -- Подразделение
                                                                    , inSummaCleaning           := COALESCE(MIFloat_SummaCleaning.ValueData, 0) -- Уборка
                                                                    , inSummaOther              := COALESCE(MIFloat_SummaOther.ValueData, 0)    -- Прочее
                                                                    , inComment                 := COALESCE(MIS_Comment.ValueData, '')          -- Примечание
                                                                    , inUserId                  := vbUserId                                     -- пользователь
                                                                      )
    FROM MovementItem
    
         LEFT JOIN MovementItem AS MovementItemCurr 
                                ON MovementItemCurr.MovementID = inMovementId
                               AND MovementItemCurr.ObjectID = MovementItem.ObjectID
                               AND MovementItemCurr.DescId = zc_MI_Sign()

         LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                     ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                    AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

         LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                     ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                    AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

         LEFT JOIN MovementItemString AS MIS_Comment
                                      ON MIS_Comment.MovementItemId = MovementItem.Id
                                     AND MIS_Comment.DescId = zc_MIString_Comment()
    
         LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaningCurr
                                     ON MIFloat_SummaCleaningCurr.MovementItemId = MovementItemCurr.Id
                                    AND MIFloat_SummaCleaningCurr.DescId = zc_MIFloat_SummaCleaning()

         LEFT JOIN MovementItemFloat AS MIFloat_SummaOtherCurr
                                     ON MIFloat_SummaOtherCurr.MovementItemId = MovementItemCurr.Id
                                    AND MIFloat_SummaOtherCurr.DescId = zc_MIFloat_SummaOther()

    WHERE MovementItem.MovementID = vbMovementId
      AND MovementItem.DescId = zc_MI_Sign()
      AND (COALESCE(MIFloat_SummaCleaning.ValueData, 0) <> COALESCE(MIFloat_SummaCleaningCurr.ValueData, 0)
        OR COALESCE(MIFloat_SummaOther.ValueData, 0) <> COALESCE(MIFloat_SummaOtherCurr.ValueData, 0));
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.10.20                                                        *
 02.10.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy (, inSession:= '2')
