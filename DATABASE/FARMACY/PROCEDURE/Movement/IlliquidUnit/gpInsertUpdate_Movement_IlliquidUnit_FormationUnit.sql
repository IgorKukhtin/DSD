-- Function: gpInsertUpdate_Movement_IlliquidUnit_FormationUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit_FormationUnit (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IlliquidUnit_FormationUnit(
    IN inOperDate            TDateTime , -- Месяц формирования
    IN inUnitID              Integer ,   -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDayCount Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    inOperDate := date_trunc('month', inOperDate);

    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = inUnitID

              WHERE Movement.OperDate >= inOperDate
                AND Movement.OperDate < inOperDate + INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_IlliquidUnit())
    THEN

      SELECT Movement.Id, Movement.StatusId
      INTO vbId, vbStatusId
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = inUnitID

      WHERE Movement.OperDate >= inOperDate
        AND Movement.OperDate < inOperDate + INTERVAL '1 MONTH'
        AND Movement.DescId = zc_Movement_IlliquidUnit();

      IF vbStatusId <> zc_Enum_Status_UnComplete()
      THEN
        RETURN;
      END IF;

    ELSE
      vbId := 0;
    END IF;

      -- Создаем изменяем документ
    SELECT lpInsertUpdate_Movement_IlliquidUnit (ioId               := vbId
                                               , inInvNumber        := Movement_IlliquidUnit.InvNumber
                                               , inOperDate         := inOperDate
                                               , inUnitId           := inUnitId
                                               , inDayCount         := Movement_IlliquidUnit.DayCount
                                               , inProcGoods        := Movement_IlliquidUnit.ProcGoods
                                               , inProcUnit         := Movement_IlliquidUnit.ProcUnit
                                               , inPenalty          := Movement_IlliquidUnit.Penalty
                                               , inComment          := Movement_IlliquidUnit.Comment
                                               , inUserId           := vbUserId
                                               )
    INTO vbId
    FROM gpGet_Movement_IlliquidUnit (inMovementId := vbId, inSession := inSession) AS Movement_IlliquidUnit;

    -- Данный для формирования
    SELECT MovementFloat_DayCount.ValueData::Integer AS DayCount
    INTO vbDayCount
    FROM Movement

         LEFT OUTER JOIN MovementFloat AS MovementFloat_DayCount
                                       ON MovementFloat_DayCount.MovementId = Movement.Id
                                      AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()

    WHERE Movement.Id = vbId
      AND Movement.DescId = zc_Movement_IlliquidUnit();


      -- Товары без продаж
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'tmpgoods')
    THEN
      CREATE TEMP TABLE tmpGoods (
              GoodsID         Integer,
              Remains         TFloat
        ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpGoods;
    END IF;

    WITH tmpContainer AS (SELECT AnalysisContainer.UnitID         AS UnitID
                               , AnalysisContainer.GoodsID        AS GoodsID
                               , SUM(AnalysisContainer.Saldo)     AS Saldo
                          FROM AnalysisContainer
                          WHERE AnalysisContainer.UnitID = inUnitID
                          GROUP BY AnalysisContainer.UnitID, AnalysisContainer.GoodsID
                         )
       , tmpMovementItemContainer AS (SELECT AnalysisContainerItem.GoodsID                                AS GoodsID
                                           , SUM(AnalysisContainerItem.Saldo)                             AS SaldoIn
                                           , SUM(CASE WHEN AnalysisContainerItem.OperDate >= inOperDate
                                                      THEN AnalysisContainerItem.Saldo END)               AS Saldo
                                           , SUM(CASE WHEN AnalysisContainerItem.OperDate < inOperDate
                                                      THEN AnalysisContainerItem.AmountCheck END)         AS Check
                                      FROM AnalysisContainerItem
                                      WHERE AnalysisContainerItem.OperDate >= inOperDate - (vbDayCount||' DAY')::INTERVAL
                                        AND AnalysisContainerItem.UnitID = inUnitID
                                      GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsID
                                      )
       , tmpRemains AS (SELECT Container.GoodsID
                             , Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0)    AS Remains
                        FROM tmpContainer AS Container

                             LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                ON MovementItemContainer.GoodsID = Container.GoodsID

                        WHERE (Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0)) > 0
                          AND (Container.Saldo - COALESCE(MovementItemContainer.SaldoIn, 0)) > 0
                          AND COALESCE(MovementItemContainer.Check, 0) = 0
                        )

    INSERT INTO tmpGoods
    SELECT
           Container.GoodsID            AS GoodsId
         , Container.Remains::TFloat    AS Remains
    FROM tmpRemains AS Container;

    ANALYSE tmpGoods;

    PERFORM lpInsertUpdate_MovementItem_IlliquidUnit(MovementItem.ID, vbId, tmpGoods.GoodsId, tmpGoods.Remains, vbUserId)
    FROM tmpGoods
         LEFT JOIN MovementItem ON MovementItem.MovementId = vbId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.ObjectId = tmpGoods.GoodsID
    WHERE COALESCE(tmpGoods.Remains, 0) > 0
      AND COALESCE(MovementItem.isErased, FALSE) = FALSE;

      -- Проставляем 0 что ушло
    PERFORM lpInsertUpdate_MovementItem_IlliquidUnit(MovementItem.ID, vbId, 0, tmpGoods.Remains, vbUserId)
    FROM MovementItem

         LEFT JOIN tmpGoods ON MovementItem.ObjectId = tmpGoods.GoodsID

    WHERE MovementItem.MovementId = vbId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.ObjectId = tmpGoods.GoodsID
      AND COALESCE(tmpGoods.Remains, 0) = 0
      AND COALESCE(MovementItem.isErased, FALSE) = FALSE;

      -- Пересчитываем количество
    PERFORM lpUpdate_Movement_IlliquidUnit_TotalCount(vbId);

      -- Проводим
    PERFORM gpComplete_Movement_IlliquidUnit (vbId, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

--
--SELECT * FROM gpInsertUpdate_Movement_IlliquidUnit_FormationUnit (inOperDate := '23.12.2019', inUnitID := 183292, inSession := '3')
--SELECT * FROM gpInsertUpdate_Movement_IlliquidUnit_Formation (inOperDate := '23.12.2019', inSession := '3')