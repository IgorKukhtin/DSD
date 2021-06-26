-- Function: lpInsertUpdate_MovementItem_WagesMoneyBoxSun ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesMoneyBoxSun (TDateTime, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesMoneyBoxSun(
    IN inOparDate            TDateTime , -- Дата расчета
    IN inUnitID              Integer   , -- Подразделение
    IN inSumma               TFloat    , -- Сумма в месяце
    IN inUserId              Integer     -- пользователь
 )
RETURNS VOID AS
$BODY$
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbIsInsert   Boolean;
BEGIN

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', inOparDate) AND Movement.DescId = zc_Movement_Wages())
    THEN
        SELECT Movement.ID
        INTO vbMovementId
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', inOparDate)
          AND Movement.DescId = zc_Movement_Wages();
    ELSE
        vbMovementId := lpInsertUpdate_Movement_Wages (ioId          := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar)
                                                     , inOperDate        := date_trunc('month', inOparDate)
                                                     , inUserId          := vbUserId
                                                       );

    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Sign()
                                           AND MovementItem.MovementId = vbMovementId
                                           AND MovementItem.ObjectId = inUnitID)
    THEN
        SELECT MovementItem.id
        INTO vbId
        FROM MovementItem
        WHERE MovementItem.DescId = zc_MI_Sign()
          AND MovementItem.MovementId = vbMovementId
          AND MovementItem.ObjectId = inUnitID;
    ELSE
        vbId := 0;
    END IF;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, 0, 0);
    END IF;

      -- Если меньше 0 обнуляем
    IF inSumma < 0 AND inOparDate >= '01.06.2020'::TDateTime
    THEN
      inSumma := 0;
    END IF;
    
     -- сохранили свойство <Копилка по результатам СУН1 за текущий месяц>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxMonth(), vbId, inSumma);

     -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, inUserId), 0);


    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_MoneyBoxSun(), inUnitID, T1.SummaMoneyBoxMonth)
          , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_MoneyBoxSunUsed(), inUnitID, T1.SummaMoneyBoxUsed)
    FROM (SELECT COALESCE(SUM(MIF_SummaMoneyBoxMonth.ValueData), 0)       AS SummaMoneyBoxMonth
               , COALESCE(SUM(MIF_SummaMoneyBoxUsed.ValueData), 0)        AS SummaMoneyBoxUsed
          FROM Movement
               INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                      AND MovementItem.MovementId = Movement.Id
                                      AND MovementItem.ObjectId = inUnitID
               LEFT JOIN MovementItemFloat AS MIF_SummaMoneyBoxMonth
                                           ON MIF_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                          AND MIF_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()
               LEFT JOIN MovementItemFloat AS MIF_SummaMoneyBoxUsed
                                           ON MIF_SummaMoneyBoxUsed.MovementItemId = MovementItem.Id
                                          AND MIF_SummaMoneyBoxUsed.DescId = zc_MIFloat_SummaMoneyBoxUsed()
          WHERE Movement.DescId = zc_Movement_Wages()) AS T1;          


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, inUserId, vbIsInsert);


--    RAISE EXCEPTION 'Прошло. % % %', inOparDate, inUnitID, inSumma;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.20                                                        *
*/

-- тест
-- select * from gpSelect_Calculation_MoneyBoxSun(183292, '3');
-- select * from gpSelect_Calculation_MoneyBoxSun(0, '3');

-- SELECT * FROM lpInsertUpdate_MovementItem_WagesMoneyBoxSun (inOparDate := '01.03.2020', inUnitID := 183292 , inSumma := 1886.92 , inUserId := 3)