-- Function: gpReport_NomenclaturePeriod()

DROP FUNCTION IF EXISTS gpReport_NomenclaturePeriod (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_NomenclaturePeriod(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,

              Coming TFloat,  ComingSum TFloat,
              Consumption TFloat,  ConsumptionSum TFloat,
              Remains TFloat,  RemainsSum TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- Результат
     RETURN QUERY
    WITH
       tmpMovement AS (SELECT Movement.Id
                        FROM Movement

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()

                             LEFT JOIN MovementDate AS MovementDate_Branch
                                                    ON MovementDate_Branch.MovementId = Movement.Id
                                                   AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                        WHERE (MovementDate_Branch.ValueData >= DATE_TRUNC ('DAY', inStartDate)
                          AND MovementDate_Branch.ValueData < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY')
                          AND Movement.DescId = zc_Movement_Income()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND MovementLinkObject_Unit.ObjectId = zc_DirectorPartner_UnitID()
                     )
     , tmpContener AS (SELECT Container.ObjectId                                                            AS GoodsId
                            , MovementItemContainer.Amount                                                  AS Coming
                            , MovementItemContainer.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0)   AS ComingSum
                            , (MovementItemContainer.Amount - Container.Amount)                             AS Consumption
                            , (MovementItemContainer.Amount - Container.Amount) * COALESCE (MIFloat_PriceWithVAT.ValueData, 0) AS ConsumptionSum
                            , Container.Amount                                                              AS Remains
                            , Container.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0)               AS RemainsSum
                       FROM tmpMovement
                            INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpMovement.Id
                                                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItemContainer.MovementItemId
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId)


     SELECT Object_Goods.Id
          , Object_Goods.ObjectCode
          , Object_Goods.ValueData

          , Sum(tmpContener.Coming)::TFloat            AS Coming
          , Sum(tmpContener.ComingSum)::TFloat         AS ComingSum
          , Sum(tmpContener.Consumption)::TFloat       AS Consumption
          , Sum(tmpContener.ConsumptionSum)::TFloat    AS ConsumptionSum
          , Sum(tmpContener.Remains)::TFloat           AS Remains
          , Sum(tmpContener.RemainsSum)::TFloat        AS RemainsSum

     FROM tmpContener
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContener.GoodsId
     GROUP BY Object_Goods.Id
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.20                                                       *
*/

-- тест
-- select * from gpReport_NomenclaturePeriod(inStartDate := ('01.03.2020')::TDateTime , inEndDate := ('31.03.2020')::TDateTime ,  inSession := '3');