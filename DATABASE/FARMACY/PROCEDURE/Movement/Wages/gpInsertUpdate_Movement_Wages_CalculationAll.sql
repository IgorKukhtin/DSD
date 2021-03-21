-- Function: gpInsertUpdate_Movement_Wages_CalculationAll()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Wages_CalculationAll (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Wages_CalculationAll(
    IN inMovementId            Integer    , -- Ключ объекта <Документ продажи>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbStatusId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- Провкряем элемент по документу
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не сохранен';
    END IF;

      -- Получаем данные
    SELECT Movement.OperDate, Movement.StatusId
    INTO vbOperDate, vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- таблица
    CREATE TEMP TABLE tmpCalculation (UnitId Integer
                                    , UnitUserId Integer
                                    , OperDate TDateTime
                                    , UserId Integer
                                    , PayrollTypeID Integer
                                    , SummaBase TFloat
                                    , SummaCalc TFloat
                                    , FormulaCalc TVarChar) ON COMMIT DROP;

    IF vbOperDate < '01.09.2019'
    THEN
      INSERT INTO tmpCalculation (UnitId, UnitUserId, OperDate, UserId, PayrollTypeID, SummaBase, SummaCalc, FormulaCalc)
      SELECT UnitId, UnitUserId, OperDate, UserId, PayrollTypeID, SummaBase, SummaCalc, FormulaCalc
      FROM gpSelect_Calculation_WagesBoard (vbOperDate, 0, '3') AS Calculation
      WHERE COALESCE (Calculation.UserId, 0) <> 0
        AND Calculation.UserId not in (SELECT MovementItem.ObjectID
                                       FROM  MovementItem
                                             LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                                                           ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                                                          AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                       WHERE MovementItem.MovementId = inMovementId 
                                         AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = TRUE);    
    ELSE
      INSERT INTO tmpCalculation (UnitId, UnitUserId, OperDate, UserId, PayrollTypeID, SummaBase, SummaCalc, FormulaCalc)
      SELECT UnitId, UnitUserId, OperDate, UserId, PayrollTypeID, SummaBase, SummaCalc, FormulaCalc
      FROM gpSelect_Calculation_Wages (vbOperDate, 0, '3') AS Calculation
      WHERE COALESCE (Calculation.UserId, 0) <> 0 
        AND Calculation.UserId not in (SELECT MovementItem.ObjectID
                                       FROM  MovementItem
                                             LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                                                           ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                                                          AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                       WHERE MovementItem.MovementId = inMovementId 
                                         AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = TRUE);    
    END IF;

      -- Востанавливаем удаленные
    IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.isErased =   TRUE
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectID IN (SELECT DISTINCT Calculation.UserId
                                                FROM tmpCalculation AS Calculation))
    THEN
      PERFORM gpSetUnErased_MovementItem (inMovementItemId:= MovementItem.ID
                                       , inSession:= inSession)
      FROM MovementItem
      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased =   TRUE
        AND MovementItem.ObjectID IN (SELECT DISTINCT Calculation.UserId
                                      FROM tmpCalculation AS Calculation);
    END IF;

      -- Добавляем мастера
    PERFORM gpInsertUpdate_MovementItem_Wages (ioId         := 0
                                             , inMovementId := inMovementId
                                             , inUserId     := Calculation.UserId
                                             , inUnitId     := MAX(Calculation.UnitUserId)
                                             , inSession    := inSession)
    FROM tmpCalculation AS Calculation
    GROUP BY Calculation.UserId;

      -- Удаляем лишних
/*    IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID NOT IN (SELECT DISTINCT Calculation.UserId
                                                    FROM tmpCalculation AS Calculation))
    THEN
      PERFORM gpSetErased_MovementItem (inMovementItemId:= MovementItem.ID
                                      , inSession:= inSession)
      FROM MovementItem
      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.ObjectID NOT IN (SELECT DISTINCT Calculation.UserId
                                          FROM tmpCalculation AS Calculation);
    END IF;
*/
      -- Удаляем автоматические чилдр
    IF EXISTS(SELECT 1 FROM MovementItem

                     INNER JOIN MovementItemBoolean AS MIB_isAuto
                                                    ON MIB_isAuto.MovementItemId = MovementItem.Id
                                                   AND MIB_isAuto.DescId = zc_MIBoolean_isAuto()
                                                   AND MIB_isAuto.ValueData = True

                     LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                                   ON MIB_isIssuedBy.MovementItemId = MovementItem.ParentId
                                                  AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
              WHERE MovementItem.MovementID = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.isErased = False
                AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = FALSE)
    THEN
      UPDATE MovementItem SET isErased = TRUE WHERE Id IN
          (SELECT MovementItem.ID
          FROM MovementItem

               INNER JOIN MovementItemBoolean AS MIB_isAuto
                                              ON MIB_isAuto.MovementItemId = MovementItem.Id
                                             AND MIB_isAuto.DescId = zc_MIBoolean_isAuto()
                                             AND MIB_isAuto.ValueData = True

               LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                             ON MIB_isIssuedBy.MovementItemId = MovementItem.ParentId
                                            AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

          WHERE MovementItem.MovementID = inMovementId
            AND MovementItem.DescId = zc_MI_Child()
            AND MovementItem.isErased = False
            AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = FALSE);
    END IF;

      -- Добавляем чилдр
    PERFORM gpInsertUpdate_MovementItem_Wages_Child (ioId                  := 0                     -- Ключ объекта <Элемент документа>
                                                   , inMovementId          := inMovementId          -- ключ Документа
                                                   , inParentId            := MIMaster.ID
                                                   , inAuto                := True
                                                   , inUnitId              := Calculation.UnitId
                                                   , inAmount              := COALESCE (Calculation.SummaCalc, 0)
                                                   , inDateCalculation     := Calculation.OperDate
                                                   , inSummaBase           := COALESCE (Calculation.SummaBase, 0)
                                                   , inPayrollTypeID       := Calculation.PayrollTypeID
                                                   , inComment             := Calculation.FormulaCalc
                                                   , inSession             := inSession              -- пользователь
                                                   )
    FROM tmpCalculation AS Calculation
         INNER JOIN MovementItem AS MIMaster
                   ON MIMaster.MovementID = inMovementId
                  AND MIMaster.ObjectID = Calculation.UserId
                  AND MIMaster.DescId = zc_MI_Master()
    ORDER BY Calculation.UserId, Calculation.OperDate;
    
    -- сохранили свойство <Дата расчета>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Calculation(), inMovementId, CURRENT_TIMESTAMP);    

      -- Пересчитали итоговые суммы
    PERFORM lpInsertUpdate_Movement_Wages_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/

-- select * from gpInsertUpdate_Movement_Wages_CalculationAll(inMovementId := 15414488 ,  inSession := '3');
