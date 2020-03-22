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
   DECLARE vbSumma      TFloat;
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

     -- сохранили свойство <Копилка по результатам СУН1 за предыдущий месяц>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxMonth(), vbId, inSumma);
    
    vbSumma := (SELECT sum(MIF_SummaMoneyBoxMonth.ValueData)
                FROM Movement
                     INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                            AND MovementItem.MovementId = Movement.Id
                                            AND MovementItem.ObjectId = inUnitID
                     INNER JOIN MovementItemFloat AS MIF_SummaMoneyBoxMonth
                                                  ON MIF_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                                 AND MIF_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()
                WHERE Movement.OperDate <=   date_trunc('month', inOparDate)
                  AND Movement.DescId = zc_Movement_Wages());   

     -- сохранили свойство <Копилка по результатам СУН1>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBox(), vbId, COALESCE (vbSumma, 0)::TFloat);

    vbSumma := (SELECT sum(MIF_SummaMoneyBoxMonth.ValueData)
                FROM Movement
                     INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                            AND MovementItem.MovementId = Movement.Id
                                            AND MovementItem.ObjectId = inUnitID
                     INNER JOIN MovementItemFloat AS MIF_SummaMoneyBoxMonth
                                                  ON MIF_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                                 AND MIF_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()
                WHERE Movement.DescId = zc_Movement_Wages());   

     -- сохранили свойство <Копилка по результатам СУН1>
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_MoneyBoxSun(), inUnitID, COALESCE (vbSumma, 0)::TFloat);

    IF vbIsInsert = FALSE
    THEN
        vbSumma := (SELECT SUM(MIFloat_SummaSUN1.ValueData)
                    FROM MovementItemFloat AS MIFloat_SummaSUN1
                    WHERE MIFloat_SummaSUN1.MovementItemId = vbId
                      AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                                       zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1(),
                                                       zc_MIFloat_SummaTechnicalRediscount()));
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, COALESCE (vbSumma, 0)::TFloat, 0);
    END IF;


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
