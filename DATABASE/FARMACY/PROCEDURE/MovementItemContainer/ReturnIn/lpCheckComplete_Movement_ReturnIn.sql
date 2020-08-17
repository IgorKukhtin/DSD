-- Function: lpCheckComplete_Movement_ReturnIn (Integer, Integer)

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_ReturnIn (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- Пользователь
)
RETURNS Text
AS
$BODY$
  DECLARE vbParentId Integer;
  DECLARE vbUnitId Integer;
BEGIN

    --Определили подразделение для розничной цены и дату для остатка
    SELECT
        MovementFloat_MovementId.ValueData::Integer, MovementLinkObject_Unit.ObjectId
    INTO
        vbParentId, vbUnitId
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                ON MovementFloat_MovementId.MovementId = Movement.Id
                               AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
    WHERE Movement.Id = inMovementId;


     -- Проверим чтоб сроковый товар был прикреплен к партиям и был остаток
     IF EXISTS(WITH
                      tmpContainer AS (SELECT MovementItemContainer.ContainerId                    AS ContainerId
                                            , (-1 * MovementItemContainer.Amount)::TFloat          AS Amount
                                        FROM MovementItemContainer
                                        WHERE MovementItemContainer.DescId = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = vbParentId
                                          )

                 SELECT 1
                 FROM MovementItem AS MI

                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                  ON MIFloat_ContainerId.MovementItemId = MI.Id
                                                 AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                      LEFT JOIN tmpContainer AS Container ON Container.ContainerId = MIFloat_ContainerId.ValueData::Integer
                      LEFT JOIN Object ON Object.Id = MI.ObjectId
                      LEFT JOIN ObjectLink ON ObjectLink.ObjectId = MI.ObjectId
                                          AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                      LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId = zc_MI_Master()
                   AND MI.Amount > 0
                   AND MI.isErased = FALSE
                 GROUP BY MI.ObjectId
                        , MIFloat_ContainerId.ValueData
                        , Container.Amount
                        , Object_Measure.ValueData
                        , Object.ObjectCode
                        , Object.ValueData
                 HAVING COALESCE(Container.Amount, 0) < COALESCE(SUM(MI.Amount), 0))
     THEN
           -- Ошибка расч/факт остаток :
           SELECT STRING_AGG (tmp.Value, ' (***) ')
           INTO outMessageText
           FROM (WITH
                      tmpContainer AS (SELECT MovementItemContainer.ContainerId                    AS ContainerId
                                            , (-1 * MovementItemContainer.Amount)::TFloat          AS Amount
                                        FROM MovementItemContainer
                                        WHERE MovementItemContainer.DescId = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = vbParentId
                                          )

                 SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') ||
                        ' по партии '||MIFloat_ContainerId.ValueData::Integer::TVarChar||
                        ' в возврате: ' || zfConvert_FloatToString (COALESCE(SUM(MI.Amount), 0)) || COALESCE (Object_Measure.ValueData, '') ||
                        '; продажа: ' || zfConvert_FloatToString (COALESCE(Container.Amount, 0)) || COALESCE (Object_Measure.ValueData, '') AS Value
                 FROM MovementItem AS MI

                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                  ON MIFloat_ContainerId.MovementItemId = MI.Id
                                                 AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                      LEFT JOIN tmpContainer AS Container ON Container.ContainerId = MIFloat_ContainerId.ValueData::Integer
                      LEFT JOIN Object ON Object.Id = MI.ObjectId
                      LEFT JOIN ObjectLink ON ObjectLink.ObjectId = MI.ObjectId
                                          AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                      LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId = zc_MI_Master()
                   AND MI.Amount > 0
                   AND MI.isErased = FALSE
                 GROUP BY MI.ObjectId
                        , MIFloat_ContainerId.ValueData
                        , Container.Amount
                        , Object_Measure.ValueData
                        , Object.ObjectCode
                        , Object.ValueData
                 HAVING COALESCE(Container.Amount, 0) < COALESCE(SUM(MI.Amount), 0)) AS tmp;

           -- Ошибка расч/факт остаток :
           RAISE EXCEPTION 'Ошибка.Товар: %', outMessageText;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Шаблий О.В.
 10.08.20                                                                   *
*/

-- тест
-- SELECT * FROM lpCheckComplete_Movement_ReturnIn (inMovementId:= 19806544 , inUserId:= zfCalc_UserAdmin()::Integer)