-- Function: gpReport_Check_PromoBonusDisco()

DROP FUNCTION IF EXISTS gpReport_Check_PromoBonusDisco (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_PromoBonusDisco(
    IN inOperDate       TDateTime , --
    IN inDateComparison TDateTime ,
    IN inUnitId         Integer   ,
    IN inGoodsId        Integer   ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , AmountCheck TFloat, AmountCheckSum TFloat
             , AmountCheckComparison TFloat, AmountCheckSumComparison TFloat
             , ProcAmount TFloat, ProcAmountSum TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbStartDateComparison TDateTime;
   DECLARE vbEndDateComparison TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     vbStartDate := DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     vbStartDateComparison := DATE_TRUNC ('MONTH', inDateComparison);
     vbEndDateComparison := vbStartDateComparison + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     RETURN QUERY
       WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId         AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

                        WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND (ObjectLink_Unit_Juridical.ObjectId = inUnitId  OR COALESCE(inUnitId, 0) = 0)
                        )
          , tmpMovement AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , MovementLinkObject_Unit.ObjectId                      AS UnitId
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                             WHERE Movement.DescId = zc_Movement_Reprice()
                               AND Movement.OperDate BETWEEN '22.02.2021'::TDateTime AND vbEndDate)

          , tmpMIAll AS (SELECT Movement.Id
                              , Movement.OperDate + INTERVAL '1 DAY'                AS OperDate
                              , Movement.UnitId                                     AS UnitId
                              , MovementItem.ObjectId                               AS GoodsId
                              , MIFloat_Price.ValueData                             AS PriceOld
                              , MIFloat_PriceSale.ValueData                         AS PriceNew
                              , COALESCE(MIBoolean_PromoBonus.ValueData, False)     AS isPromoBonus
                              , COALESCE(MIBoolean_ClippedReprice.ValueData, False) AS isClippedReprice
                              , Row_Number() OVER (PARTITION BY Movement.UnitId, MovementItem.ObjectId ORDER BY Movement.OperDate) AS Ord
                          FROM tmpMovement AS Movement

                               INNER JOIN MovementItem AS MovementItem
                                                       ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId = zc_MI_Master()
                                                      AND (MovementItem.ObjectId = inGoodsId OR COALESCE(inGoodsId, 0) = 0)

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                           ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                               LEFT JOIN MovementItemBoolean AS MIBoolean_PromoBonus
                                                             ON MIBoolean_PromoBonus.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_PromoBonus.DescId         = zc_MIBoolean_PromoBonus()

                               LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                             ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()
                          )
          , tmpUnitGoods AS (SELECT DISTINCT tmpMIAll.UnitId, tmpMIAll.GoodsId
                             FROM tmpMIAll
                             WHERE tmpMIAll.isPromoBonus = True)
          , tmpMIAllNoBonus AS (SELECT Movement.Id
                              , Movement.OperDate                                 AS OperDate
                              , Movement.UnitId                                   AS UnitId
                              , Movement.GoodsId                                  AS GoodsId
                              , Movement.PriceOld                                 AS PriceOld
                              , Movement.PriceNew                                 AS PriceNew
                              , Row_Number() OVER (PARTITION BY Movement.UnitId, Movement.GoodsId ORDER BY Movement.OperDate) AS Ord
                          FROM tmpMIAll AS Movement
                          WHERE Movement.isPromoBonus = False
                            AND Movement.isClippedReprice = False)
          , tmpPriceNoBonus AS (SELECT Movement.Id
                                     , Movement.OperDate                             AS OperDate
                                     , COALESCE(MovementNext.OperDate, zc_DateEnd()) AS DateEnd
                                     , Movement.UnitId                               AS UnitId
                                     , Movement.GoodsId                              AS GoodsId
                                     , Movement.PriceOld                             AS PriceOld
                                     , Movement.PriceNew                             AS PriceNew
                                 FROM tmpMIAllNoBonus AS Movement
                                      LEFT JOIN tmpMIAllNoBonus AS MovementNext
                                                                ON MovementNext.UnitId = Movement.UnitId
                                                               AND MovementNext.GoodsId = Movement.GoodsId
                                                               AND MovementNext.Ord =  Movement.Ord + 1
                                  )
          , tmpPriceStart AS (SELECT Movement.Id
                                   , Movement.OperDate                             AS OperDate
                                   , Movement.UnitId                               AS UnitId
                                   , Movement.GoodsId                              AS GoodsId
                                   , Movement.PriceOld                             AS PriceOld
                                   , Movement.PriceNew                             AS PriceNew
                               FROM tmpMIAll AS Movement
                               WHERE Movement.Ord = 1
                               )

          , tmpPrice AS (SELECT Movement.Id
                              , Movement.OperDate                             AS OperDate
                              , COALESCE(MovementNext.OperDate, zc_DateEnd()) AS DateEnd
                              , Movement.UnitId                               AS UnitId
                              , Movement.GoodsId                              AS GoodsId
                              ,  COALESCE(tmpPriceNoBonus.PriceNew, MovementStart.PriceOld) AS PriceOld
                              , Movement.PriceNew                             AS PriceNew
                              , Movement.isPromoBonus                         AS isPromoBonus
                              , Movement.Ord                                  AS Ord
                          FROM tmpMIAll AS Movement
                               LEFT JOIN tmpMIAll AS MovementNext
                                                  ON MovementNext.UnitId = Movement.UnitId
                                                 AND MovementNext.GoodsId = Movement.GoodsId
                                                 AND MovementNext.Ord =  Movement.Ord + 1
                               LEFT JOIN tmpMIAll AS MovementStart
                                                  ON MovementStart.UnitId = Movement.UnitId
                                                 AND MovementStart.GoodsId = Movement.GoodsId
                                                 AND MovementStart.Ord = 1
                               LEFT JOIN tmpPriceNoBonus ON tmpPriceNoBonus.UnitId = Movement.UnitId
                                                        AND tmpPriceNoBonus.GoodsId = Movement.GoodsId
                                                        AND tmpPriceNoBonus.OperDate <= Movement.OperDate
                                                        AND tmpPriceNoBonus.DateEnd > Movement.OperDate
                          )
          , tmpUnitGoodsPromo AS (SELECT tmpUnitGoods.UnitId
                            , tmpUnitGoods.GoodsId
                       FROM tmpUnitGoods

                            INNER JOIN AnalysisContainerItem  AS ACI
                                                              ON ACI.UnitId  = tmpUnitGoods.UnitId
                                                             AND ACI.GoodsId  = tmpUnitGoods.GoodsId
                                                             AND ACI.AmountCheck > 0
                                                             AND ACI.OperDate >= vbStartDate
                                                             AND ACI.OperDate <= vbEndDate
                                                             AND (ACI.GoodsId = inGoodsId OR COALESCE(inGoodsId, 0) = 0)

                            INNER JOIN tmpPrice ON tmpPrice.UnitId = tmpUnitGoods.UnitId
                                               AND tmpPrice.GoodsId =  tmpUnitGoods.GoodsId
                                               AND tmpPrice.OperDate <=  ACI.OperDate
                                               AND tmpPrice.DateEnd > ACI.OperDate
                                               AND tmpPrice.isPromoBonus = True

                       GROUP BY tmpUnitGoods.UnitId
                              , tmpUnitGoods.GoodsId)
          , tnpMICCurrent AS (SELECT tmpUnitGoodsPromo.UnitId
                                   , SUM(ACI.AmountCheck)       AS AmountCheck
                                   , SUM(ACI.AmountCheckSum)    AS AmountCheckSum
                              FROM tmpUnitGoodsPromo

                                   INNER JOIN AnalysisContainerItem  AS ACI
                                                                     ON ACI.UnitId  = tmpUnitGoodsPromo.UnitId
                                                                    AND ACI.GoodsId  = tmpUnitGoodsPromo.GoodsId
                                                                    AND ACI.AmountCheck > 0
                                                                    AND ACI.OperDate >= vbStartDate
                                                                    AND ACI.OperDate <= vbEndDate
                              GROUP BY tmpUnitGoodsPromo.UnitId
                              )
          , tnpMICComparison AS (SELECT tmpUnitGoodsPromo.UnitId
                                      , SUM(ACI.AmountCheck)       AS AmountCheck
                                      , SUM(ACI.AmountCheckSum)    AS AmountCheckSum
                                 FROM tmpUnitGoodsPromo

                                      INNER JOIN AnalysisContainerItem  AS ACI
                                                                        ON ACI.UnitId  = tmpUnitGoodsPromo.UnitId
                                                                       AND ACI.GoodsId  = tmpUnitGoodsPromo.GoodsId
                                                                       AND ACI.AmountCheck > 0
                                                                       AND ACI.OperDate >= vbStartDateComparison
                                                                       AND ACI.OperDate <= vbEndDateComparison
                                 GROUP BY tmpUnitGoodsPromo.UnitId
                                 )



    SELECT tnpMICCurrent.UnitId                                          AS UnitId
         , Object_Unit.ValueData                                         AS UnitName
         , tnpMICCurrent.AmountCheck::TFloat                             AS AmountCheck
         , tnpMICCurrent.AmountCheckSum::TFloat                          AS AmountCheckSum
         , tnpMICComparison.AmountCheck::TFloat                          AS AmountCheckComparison
         , tnpMICComparison.AmountCheckSum::TFloat                       AS AmountCheckSumComparison
         , CASE WHEN COALESCE (tnpMICComparison.AmountCheck, 0) <> 0
                THEN (tnpMICCurrent.AmountCheck - tnpMICComparison.AmountCheck) * 100 / tnpMICComparison.AmountCheck
                ELSE 0 END::TFloat AS ProcAmount
         , CASE WHEN COALESCE (tnpMICComparison.AmountCheckSum, 0) <> 0
                THEN (tnpMICCurrent.AmountCheckSum - tnpMICComparison.AmountCheckSum) * 100 / tnpMICComparison.AmountCheckSum
                ELSE 0 END::TFloat AS ProcAmountSum
    FROM tnpMICCurrent

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tnpMICCurrent.UnitId

         LEFT JOIN tnpMICComparison ON tnpMICComparison.UnitId = tnpMICCurrent.UnitId
    ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.03.21                                                       *
*/

-- тест
--

select * from gpReport_Check_PromoBonusDisco(inOperDate := ('01.03.2021')::TDateTime , inDateComparison := ('01.03.2021')::TDateTime ,  inUnitId := 0 /*183292*/, inGoodsId := 0 /*373*/ ,  inSession := '3');
