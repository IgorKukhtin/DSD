-- Function: gpReport_StockTiming_Remainder()

DROP FUNCTION IF EXISTS gpReport_StockTiming_Remainder (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StockTiming_Remainder(
    IN inOperDate     TDateTime,
    IN inUnitID       Integer,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE ( UnitCode        Integer      --Код подразделение откуда
              , UnitName        TVarChar     --Наименование подразделение откуда
              , GoodsCode       Integer      --Код товара
              , GoodsName       TVarChar     --Наименование товара
              , AmountDeferred  TFloat
              , AmountComplete  TFloat
              , Amount          TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     inOperDate := DATE_TRUNC ('DAY', inOperDate) + INTERVAL '1 DAY';

     RETURN QUERY
     SELECT

           Object_Unit.ObjectCode,
           Object_Unit.ValueData,
           Object_Goods.ObjectCode,
           Object_Goods.ValueData,

           SUM(CASE WHEN COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE THEN MovementItem.Amount  END)::TFloat,
           SUM(CASE WHEN COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE THEN MovementItem.Amount  END)::TFloat,
           SUM(MovementItem.Amount)::TFloat


     FROM Movement

          INNER JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                 AND MovementItem.Amount > 0
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.iserased = False

          LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_To
                                       ON MovementLinkObject_Unit_To.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN Object AS Object_Unit
                           ON Object_Unit.ID = MovementLinkObject_Unit.ObjectId

          LEFT JOIN Object AS Object_Goods
                           ON Object_Goods.ID = MovementItem.ObjectId

     WHERE Movement.operdate < inOperDate
       AND Movement.DescId = zc_Movement_Send()
       AND (Movement.statusid = zc_Enum_Status_Complete() OR COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE)
       AND MovementLinkObject_Unit_To.ObjectId = 11299914
       AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0)
     GROUP BY Object_Unit.ObjectCode, Object_Unit.ValueData, Object_Goods.ObjectCode, Object_Goods.ValueData;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.01.20                                                       *
*/

-- тест
-- SELECT * FROM gpReport_StockTiming_Remainder(inOperDate :=  '01.01.2020', inUnitID := 0, inSession := '3')