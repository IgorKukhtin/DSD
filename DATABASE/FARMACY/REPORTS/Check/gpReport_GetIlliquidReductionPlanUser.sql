-- Function: gpReport_GetIlliquidReductionPlanUser()

DROP FUNCTION IF EXISTS gpReport_GetIlliquidReductionPlanUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GetIlliquidReductionPlanUser(
    IN inStartDate      TDateTime , -- Дата в месяце
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (DayCount Integer
             , ProcGoods TFloat
             , ProcUnit TFloat
             , PlanAmount TFloat
             , Penalty TFloat
             , PenaltySum TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');
    vbUserId := lpGetUserBySession (inSession);

    IF inSession = '3'
    THEN
      vbUserId := 4036597;
    END IF;

      -- Мовементы по сотруднику
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            OperDate           TDateTime,
            UnitID             Integer,
            ConfirmedKind      Boolean

      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , date_trunc('day', MovementDate_Insert.ValueData) AS OperDate
         , MovementLinkObject_Unit.ObjectId                 AS UnitId
         , False                                            AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

          INNER JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE /*MovementDate_Insert.ValueData >= vbDateStart
      AND MovementDate_Insert.ValueData < vbDateEnd*/
          Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_Insert.ObjectId = vbUserId
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

      -- Добовляем отборы
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                           AS ID
         , date_trunc('day', Movement.OperDate)  AS OperDate
         , MovementLinkObject_Unit.ObjectId      AS UnitId
         , True                                  AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                        ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                       AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_UserConfirmedKind.ObjectId = vbUserId
      AND MovementLinkObject_Insert.ObjectId IS NULL
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

    ANALYSE tmpMovement;

--raise notice 'Value 03: %', (SELECT count(*) FROM tmpMovement);

    IF NOT EXISTS(SELECT * FROM tmpMovement)
    THEN
         RAISE EXCEPTION 'По вам ненайдены чеки.';
    END IF;

    WITH tmpCount AS (SELECT tmpMovement.UnitId
                           , count(*) AS CountCheck
                      FROM tmpMovement
                      GROUP BY tmpMovement.UnitId)
    SELECT tmpCount.UnitId
    INTO vbUnitId
    FROM tmpCount
    ORDER BY tmpCount.CountCheck DESC
    LIMIT 1;

    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId

              WHERE Movement.OperDate >= vbDateStart
                AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_IlliquidUnit()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN

       RETURN QUERY
       SELECT MovementFloat_DayCount.ValueData::Integer            AS DayCount
            , 20::TFloat
            , 10::TFloat
            , 7::TFloat
            , 500::TFloat
            , 250::TFloat
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_DayCount
                                          ON MovementFloat_DayCount.MovementId = Movement.Id
                                         AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcGoods
                                          ON MovementFloat_ProcGoods.MovementId = Movement.Id
                                         AND MovementFloat_ProcGoods.DescId = zc_MovementFloat_ProcGoods()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcUnit
                                          ON MovementFloat_ProcUnit.MovementId = Movement.Id
                                         AND MovementFloat_ProcUnit.DescId = zc_MovementFloat_ProcUnit()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Penalty
                                          ON MovementFloat_Penalty.MovementId = Movement.Id
                                         AND MovementFloat_Penalty.DescId = zc_MovementFloat_Penalty()

       WHERE Movement.OperDate >= vbDateStart
         AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_IlliquidUnit()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       LIMIT 1;

    ELSE
       RAISE EXCEPTION 'Зафиксированные неликвиды по подразделениям не найдены.';
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.12.19                                                       *
*/

-- тест select * from gpReport_GetIlliquidReductionPlanUser(inStartDate := ('27.04.2021')::TDateTime , inSession := '3');