-- Function: gpReport_SendSUNLoss()

DROP FUNCTION IF EXISTS gpReport_SendSUNLoss (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SendSUNLoss (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Двта конца
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar
             , Price TFloat

             , AmountLoss TFloat
             , SummaLoss TFloat
             , ArticleLossName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpMovement  AS (SELECT Movement.Id                            AS ID
                               , MovementLinkObject_Unit.ObjectId       AS UnitId
                               , Object_ArticleLoss.ValueData           AS ArticleLossName
                          FROM Movement

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                            ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                           AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                               LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

                          WHERE Movement.DescId = zc_Movement_Loss()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.OperDate >= inStartDate
                            AND Movement.OperDate <= inEndDate
                            AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0))

       , tmpMovementItem  AS (SELECT tmpMovement.UnitID
                                   , MovementItem.ObjectId                              AS GoodsID
                                   , tmpMovement.ArticleLossName
                                   , Sum(MovementItem.Amount)::TFloat                   AS AmountLoss

                                FROM tmpMovement

                                     INNER JOIN MovementItem ON MovementItem.MovementID = tmpMovement.Id
                                                            AND MovementItem.Amount > 0
                                                            AND MovementItem.isErased = False


                                GROUP BY tmpMovement.UnitID
                                       , MovementItem.ObjectId
                                       , tmpMovement.ArticleLossName)

       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitID
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId in (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)
                        )

    SELECT Object_Unit.ValueData                  AS UnitName
         , Object_Goods.objectcode
         , Object_Goods.valuedata
         , tmpObject_Price.Price

         , tmpMovementItem.AmountLoss                                                    AS AmountLoss
         , Round(tmpMovementItem.AmountLoss * tmpObject_Price.Price, 2)::TFloat          AS SummaLoss
         , tmpMovementItem.ArticleLossName                                               AS ArticleLossName

    FROM tmpMovementItem

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementItem.GoodsID
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovementItem.UnitId

         LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Object_Goods.Id
                                  AND tmpObject_Price.UnitId = tmpMovementItem.UnitId
    ORDER BY Object_Unit.ValueData, Object_Goods.objectcode;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.02.20                                                       *
*/

-- тест SELECT * FROM gpReport_SendSUNLoss (inStartDate := ('01.02.2020')::TDateTime , inEndDate := ('11.02.2020')::TDateTime , inUnitId := 0, inSession := '3')