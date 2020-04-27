-- Function: lpInsertUpdate_MovementItem_WagesSUN1 ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesSUN1 (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesSUN1(
    IN inOparDate            TDateTime , -- Дата расчета
    IN inUnitID              Integer ,   -- Дата расчета
    IN inUserId              Integer     -- пользователь
 )
RETURNS VOID AS
$BODY$
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbSummaSUN1  TFloat;
   DECLARE vbSumma      TFloat;
   DECLARE vbWeek       Integer;
BEGIN

    IF date_part('DOW', inOparDate)::Integer = 4
    THEN
      vbSummaSUN1 := - 200;
    ELSEIF  date_part('DOW', inOparDate)::Integer = 5
    THEN
      vbSummaSUN1 := - 400;
      inOparDate := inOparDate - INTERVAL '1 day';
    ELSEIF  date_part('DOW', inOparDate)::Integer = 1
    THEN
      vbSummaSUN1 := - 750;
      inOparDate := inOparDate - INTERVAL '4 day';
    ELSE
      RETURN;
    END IF;

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

    vbWeek := date_part('DAY', inOparDate)::Integer / 7 + 1;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, COALESCE (vbSummaSUN1, 0)::TFloat, 0);
    END IF;

     -- сохранили свойство <По неделям>
    IF vbWeek = 1
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek1(), vbId, vbSummaSUN1);
    ELSEIF vbWeek = 2
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek2(), vbId, vbSummaSUN1);
    ELSEIF vbWeek = 3
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek3(), vbId, vbSummaSUN1);
    ELSEIF vbWeek = 4
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek4(), vbId, vbSummaSUN1);
    ELSEIF vbWeek = 5
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek5(), vbId, vbSummaSUN1);
    ELSE
      RAISE EXCEPTION 'Ошибка.Определения номера дня %', vbWeek;
    END IF;

    vbSummaSUN1 := (SELECT SUM(MIFloat_SummaSUN1.ValueData)
                    FROM MovementItemFloat AS MIFloat_SummaSUN1
                    WHERE MIFloat_SummaSUN1.MovementItemId = vbId
                      AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaWeek1(), zc_MIFloat_SummaWeek2(), zc_MIFloat_SummaWeek3(),
                                                       zc_MIFloat_SummaWeek4(), zc_MIFloat_SummaWeek5()));
     -- сохранили свойство <Итог по СУН1>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSUN1(), vbId, vbSummaSUN1);


    IF vbIsInsert = FALSE
    THEN
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, inUserId), 0);
    END IF;


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, inUserId, vbIsInsert);


--    RAISE EXCEPTION 'Прошло. % % % % % %', inOparDate, vbMovementId, vbId, vbSummaSUN1, vbSumma, vbWeek;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.20                                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_WagesSUN1 (inOparDate := '13.02.2020', inUnitID := 183292 , inUserId := 3)
