-- Function: gpReport_ClippedReprice_Sale()

DROP FUNCTION IF EXISTS gpReport_ClippedReprice_Sale (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ClippedReprice_Sale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsID Integer, GoodsCode Integer, GoodsName TVarChar
             , OperDate TDateTime
             , Amount TFloat
             , PriceSale TFloat, SummaSale TFloat
             , PriceNew TFloat, SummaNew TFloat
             , Deficit TFloat, Proficit TFloat, Diff TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    RETURN QUERY
     WITH  tmpUnit AS  (SELECT ObjectLink_Unit_Juridical.ObjectId         AS UnitId
                             , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
                             , ObjectLink_Unit_ProvinceCity.ChildObjectId AS ProvinceCityId
                             , ObjectLink_Unit_Area.ChildObjectId         AS AreaId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                                ON ObjectLink_Unit_ProvinceCity.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        ),
           tmpMovementAll AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementLinkObject_Unit.ObjectId                      AS UnitId
                                   , ROW_NUMBER() OVER (PARTITION BY Movement.OperDate, MovementLinkObject_Unit.ObjectId ORDER BY Movement.Id DESC) AS Ord
                              FROM Movement
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                              WHERE Movement.DescId = zc_Movement_Reprice()
                                AND Movement.OperDate BETWEEN inStartDate - INTERVAL '4 DAY' AND inEndDate + INTERVAL '1 DAY'
                              ),
           tmpMovementOrd AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , Movement.UnitId
                                   , ROW_NUMBER() OVER (PARTITION BY Movement.UnitId ORDER BY Movement.OperDate) AS Ord
                              FROM tmpMovementAll AS Movement
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE Movement.Ord = 1
                              ),
           tmpMovement AS (SELECT Movement.Id
                                , Movement.InvNumber
                                , Movement.OperDate                                     AS DateStart
                                , COALESCE(MovementNext.OperDate, inEndDate)            AS DateEnd
                                , Movement.UnitId                                       AS UnitId
                           FROM tmpMovementOrd AS Movement

                                LEFT JOIN tmpMovementOrd AS MovementNext ON MovementNext.UnitId = Movement.UnitId
                                                                        AND MovementNext.Ord = Movement.Ord + 1
                           ),
           tmpMI AS (SELECT Movement.Id
                          , Movement.DateStart
                          , Movement.DateEnd
                          , Movement.UnitId
                          , MovementItem.ObjectId                           AS GoodsID
                          , MIFloat_PriceSale.ValueData                     AS PriceNew
                     FROM tmpMovement AS Movement

                          LEFT JOIN MovementItem AS MovementItem ON MovementItem.MovementId = Movement.Id

                          LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                        ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

                          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                                     
                          LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId 
                          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                     WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, False) = TRUE
                       AND COALESCE(Object_Goods_Main.isResolution_224, FALSE) = FALSE
                       AND COALESCE(Object_Goods_Retail.isTop, FALSE) = FALSE
                     ),
           tmpMIC AS (SELECT MovementItem.Id                                 AS Id
                           , DATE_TRUNC ('DAY', MIC.OperDate)::TDateTime     AS OperDate
                           , MovementItem.GoodsID
                           , MovementItem.PriceNew                           AS PriceNew
                           , MIC.MovementId                                  AS MovementID
                           , MIC.MovementItemId                              AS MovementItemID
                           , (-1.0 *  MIC.Amount)::TFloat                    AS Amount
                           , MIC.Price                                       AS Price
                      FROM tmpMI AS MovementItem

                           INNER JOIN MovementItemContainer AS MIC ON MIC.ObjectId_Analyzer = MovementItem.GoodsID
                                                           AND MIC.WhereObjectId_Analyzer = MovementItem.UnitId
                                                           AND MIC.OperDate > MovementItem.DateStart
                                                           AND MIC.OperDate < MovementItem.DateEnd + INTERVAL '1 DAY'
                                                           AND MIC.MovementDescId = zc_Movement_Check()
                                                           AND MIC.DescId = zc_MIContainer_Count()
                                                           AND MIC.OperDate >= inStartDate
                                                           AND MIC.OperDate < inEndDate + INTERVAL '1 DAY'



                      ),
           tmpResult AS (SELECT
                                Movement.UnitId                                       AS UnitId
                              , MIC.OperDate                                          AS OperDate  
                              , MIC.GoodsID                                           AS GoodsID
                              , SUM(MIC.Amount)::TFloat                               AS Amount
                              , MIC.Price                                             AS Price
                              , MIC.PriceNew                                          AS PriceNew
                         FROM tmpMovement AS Movement

                              INNER JOIN tmpMIC AS MIC ON MIC.Id = Movement.Id

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                           ON MovementLinkObject_SPKind.MovementId = MIC.MovementID
                                                          AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                           ON MovementLinkObject_DiscountCard.MovementId = MIC.MovementID
                                                          AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                                                          
                         WHERE COALESCE (MovementLinkObject_SPKind.ObjectId, 0) = 0
                           AND COALESCE (MovementLinkObject_DiscountCard.ObjectId, 0) = 0
                         GROUP BY Movement.UnitId
                                , MIC.OperDate
                                , MIC.GoodsID
                                , MIC.Price
                                , MIC.PriceNew )


     SELECT
            Result.UnitId                                       AS UnitId
          , Object_Unit.ObjectCode                              AS UnitCode
          , Object_Unit.ValueData                               AS UnitName
          , Result.GoodsID                                      AS GoodsID
          , Object_Goods.ObjectCode                             AS GoodsCode
          , Object_Goods.ValueData                              AS GoodsName

          , Result.OperDate                                     AS OperDate
          , Result.Amount                                       AS Amount
          , Result.Price                                        AS PriceSale
          , Round(Result.Amount * Result.Price, 2)::TFloat      AS SummaSale
          , Result.PriceNew                                     AS PriceNew
          , Round(Result.Amount * Result.PriceNew, 2)::TFloat   AS SummaNew
          , CASE WHEN Round(Result.Amount * Result.Price, 2) <
                      Round(Result.Amount * Result.PriceNew, 2)
                 THEN Round(Result.Amount * Result.PriceNew, 2) -
                       Round(Result.Amount * Result.Price, 2) END::TFloat       AS Deficit
          , CASE WHEN Round(Result.Amount * Result.Price, 2) >
                      Round(Result.Amount * Result.PriceNew, 2)
                 THEN Round(Result.Amount * Result.Price, 2) -
                      Round(Result.Amount * Result.PriceNew, 2) END::TFloat     AS Proficit
          , (Round(Result.Amount * Result.Price, 2) -
                      Round(Result.Amount * Result.PriceNew, 2))::TFloat        AS Diff
     FROM tmpResult AS Result

          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Result.UnitId

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Result.GoodsID
     WHERE Result.Price <> Result.PriceNew
     ORDER BY Result.UnitId, Result.GoodsID, Result.OperDate;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.11.20                                                       *
*/

-- тест
-- SELECT * FROM gpReport_ClippedReprice_Sale (inStartDate:= '01.11.2020', inEndDate:= '10.11.2020', inSession:= '2')