-- Function: gpSelect_Movement_MobileRemains()

DROP FUNCTION IF EXISTS gpSelect_Movement_MobileRemains (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MobileRemains(
    IN inShowAll          Boolean,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, PartNumber TVarChar
             , Remains TFloat, Remains_curr TFloat
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Данные для остатков
     SELECT Movement.OperDate, Movement.StatusId, MLO_Unit.ObjectId
            INTO vbOperDate, vbStatusId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
       AND Movement.DescId = zc_Movement_Inventory()
       AND Movement.StatusId = zc_Enum_Status_UnComplete();     

     -- Результат такой
     RETURN QUERY
           WITH
           tmpRemains AS (SELECT Container.Id       AS ContainerId
                               , Container.ObjectId AS GoodsId
                               , Container.Amount
                               , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) AS Remains
                               , COALESCE (MIString_PartNumber.ValueData, '')::TVarChar AS PartNumber
                          FROM Container
                               LEFT JOIN MovementItemString AS MIString_PartNumber
                                                            ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                           AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId =  Container.Id
                                                              AND MIContainer.OperDate    >= vbOperDate
                                                              AND vbStatusId              =  zc_Enum_Status_Complete()
                          WHERE Container.WhereObjectId = vbUnitId
                            AND Container.DescId        = zc_Container_Count()
                          GROUP BY Container.Id
                                 , Container.ObjectId
                                 , Container.Amount
                                 , COALESCE (MIString_PartNumber.ValueData, '')
                          HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) <> 0
                              OR Container.Amount <> 0
                         )

       -- Результат
       SELECT tmpRemains.GoodsId
            , tmpRemains.PartNumber
            , SUM (tmpRemains.Amount)::TFloat    AS AmountRemains
            , SUM (tmpRemains.Remains)::TFloat   AS AmountRemains_curr
       FROM tmpRemains
       GROUP BY tmpRemains.GoodsId, tmpRemains.PartNumber;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_MobileRemains (inShowAll := False, inSession := zfCalc_UserAdmin());