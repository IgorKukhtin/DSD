-- Function: gpReport_Check_PromoBonusLosses()

DROP FUNCTION IF EXISTS gpReport_Check_PromoBonusLosses (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_PromoBonusLosses(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountCheck TFloat, AmountCheckSum TFloat, AmountCheckSumOld TFloat, Delta TFloat
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
       WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId         AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
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
                               AND Movement.OperDate BETWEEN '22.02.2021'::TDateTime AND inEndDate)

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
          , tnpMIC AS (SELECT tmpUnitGoods.UnitId
                            , tmpUnitGoods.GoodsId
                            , ACI.OperDate
                            , SUM(ACI.AmountCheck)       AS AmountCheck
                            , SUM(ACI.AmountCheckSum)    AS AmountCheckSum
                       FROM tmpUnitGoods

                            INNER JOIN AnalysisContainerItem  AS ACI
                                                              ON ACI.UnitId  = tmpUnitGoods.UnitId
                                                             AND ACI.GoodsId  = tmpUnitGoods.GoodsId
                                                             AND ACI.AmountCheck > 0
                                                             AND ACI.OperDate >= inStartDate
                                                             AND ACI.OperDate <= inEndDate
                       GROUP BY tmpUnitGoods.UnitId
                              , tmpUnitGoods.GoodsId
                              , ACI.OperDate)
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


    SELECT tnpMIC.OperDate                                        AS OperDate
         , tnpMIC.UnitId                                          AS UnitId
         , Object_Unit.ValueData                                  AS UnitName
         , tnpMIC.GoodsId                                         AS GoodsId
         , Object_Goods_Main.ObjectCode                           AS GoodsCode
         , Object_Goods_Main.Name                                 AS GoodsName
         , tnpMIC.AmountCheck::TFloat                             AS AmountCheck
         , tnpMIC.AmountCheckSum::TFloat                          AS AmountCheckSum
         , Round(tnpMIC.AmountCheck * tmpPrice.PriceOld, 2)::TFloat    AS AmountCheckSumOld
         , (tnpMIC.AmountCheckSum -
           Round(tnpMIC.AmountCheck * tmpPrice.PriceOld, 2))::TFloat   AS Delta
    FROM tnpMIC

         INNER JOIN tmpPrice ON tmpPrice.UnitId = tnpMIC.UnitId
                            AND tmpPrice.GoodsId =  tnpMIC.GoodsId
                            AND tmpPrice.OperDate <=  tnpMIC.OperDate
                            AND tmpPrice.DateEnd >  tnpMIC.OperDate
                            AND tmpPrice.isPromoBonus = True

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tnpMIC.UnitId

         LEFT JOIN Object_Goods_Retail AS Object_Goods
                                       ON Object_Goods.Id = tnpMIC.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.21                                                       *
*/

-- тест
--
select * from gpReport_Check_PromoBonusLosses(inStartDate:= '22.02.2021', inEndDate:= '22.03.2021', inSession := '3');                   