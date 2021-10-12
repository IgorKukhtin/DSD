-- Function: lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummTestingTuning(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount          TFloat;
  DECLARE vbQuestion            TFloat;
  DECLARE vbQuestionStorekeeper TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;


    SELECT SUM(MovementItem.Amount)
         , SUM(MIFloat_TestQuestionsStorekeeper.ValueData)
    INTO vbQuestion, vbQuestionStorekeeper
    FROM MovementItem
  
         LEFT JOIN MovementItemFloat AS MIFloat_TestQuestionsStorekeeper
                                     ON MIFloat_TestQuestionsStorekeeper.MovementItemId = MovementItem.Id
                                    AND MIFloat_TestQuestionsStorekeeper.DescId = zc_MIFloat_AmountStorekeeper()
                                    
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;                         
          
    SELECT COUNT(*)
    INTO vbTotalCount
    FROM MovementItem 

         INNER JOIN MovementItem AS MovementItemChild
                                 ON MovementItemChild.MovementId = inMovementId
                                AND MovementItemChild.ParentId = MovementItem.Id
                                AND MovementItemChild.DescId = zc_MI_Child()
                                AND MovementItemChild.isErased = FALSE

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;                         

    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TestingUser_Question(), inMovementId, vbQuestion);
    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_QuestionStorekeeper(), inMovementId, vbQuestionStorekeeper);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.21                                                       *
*/