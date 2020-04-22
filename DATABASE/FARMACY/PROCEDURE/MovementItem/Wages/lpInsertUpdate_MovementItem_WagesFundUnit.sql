-- Function: lpInsertUpdate_MovementItem_WagesFundUnit ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesFundUnit (TDateTime, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesFundUnit(
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

     -- сохранили свойство <Фонд за предыдущий месяц>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFundMonth(), vbId, inSumma);


    IF vbIsInsert = FALSE
    THEN
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, inUserId), 0);
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
-- select * from gpSelect_Calculation_FundMonth('01.05.2020', 183292, '3');

-- SELECT * FROM lpInsertUpdate_MovementItem_WagesFundUnit (inOparDate := '01.05.2020', inUnitID := 183292 , inSumma := 0 , inUserId := 3)