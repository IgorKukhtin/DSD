-- Function: gpReport_Check_PromoBonusEstimate()

DROP FUNCTION IF EXISTS gpReport_Check_PromoBonusEstimate (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_PromoBonusEstimate(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountCheck TFloat, AmountCheckSum TFloat, PriceOld TFloat,  PriceNew TFloat
             , AmountCheckSumOld TFloat, AmountCheckSumNew TFloat, Delta TFloat
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

                        WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
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
                               AND Movement.OperDate BETWEEN '22.02.2021'::TDateTime AND CURRENT_DATE)

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
          , tmpProcent AS (SELECT SUM(tmpMIAll.PriceNew) / SUM(tmpMIAll.PriceOld) AS Proc
                           FROM tmpMIAll
                           WHERE tmpMIAll.isPromoBonus = True
                             AND tmpMIAll.PriceNew < tmpMIAll.PriceOld)
          , tmpPromoBonus AS (SELECT MovementItem.Id
                                  , MovementItem.ObjectId                      AS GoodsId
                                  , Object_Maker.ValueData                     AS MakerName
                                  , MovementItem.Amount                        AS Amount
                                  , ROW_NUMBER() OVER (ORDER BY Object_Maker.ValueData, MovementItem.Id) AS Ord
                             FROM MovementItem

                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                              ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                                  LEFT JOIN MovementItem AS MIPromo ON MIPromo.ID = MIFloat_MovementItemId.ValueData::Integer

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                               ON MovementLinkObject_Maker.MovementId = MIPromo.MovementId
                                                              AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                  LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId

                             WHERE MovementItem.MovementId = (SELECT MAX(Movement.id) FROM Movement
                                                              WHERE Movement.OperDate <= CURRENT_DATE
                                                                AND Movement.DescId = zc_Movement_PromoBonus()
                                                                AND Movement.StatusId = zc_Enum_Status_Complete())
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = False
                               AND MovementItem.Amount > 0
                             ORDER BY Object_Maker.ValueData)
          , tmpMaxOrd AS (SELECT max(tmpPromoBonus.Ord) AS MaxOrd FROM tmpPromoBonus)
          , tmpGoodsWeek AS (SELECT MovementItem.Id
                                  , MovementItem.GoodsId                               AS GoodsId
                                  , MovementItem.MakerName
                                  , MovementItem.Ord::Integer
                                  , mod(date_part('week',  CURRENT_DATE)::TFloat, 2.0) AS WeekUse
                                  , MovementItem.Amount                                AS Amount
                             FROM tmpPromoBonus AS MovementItem
                                  INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
                                  INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                  INNER JOIN tmpMaxOrd ON 1 = 1
                             WHERE CASE WHEN mod(date_part('week',  CURRENT_DATE)::TFloat, 2.0) = 0
                                        THEN tmpMaxOrd.MaxOrd / 2 <= MovementItem.Ord
                                        ELSE tmpMaxOrd.MaxOrd / 2 + 1 >= MovementItem.Ord END = TRUE
                             UNION ALL
                             SELECT MovementItem.Id
                                  , MovementItem.GoodsId                               AS GoodsId
                                  , MovementItem.MakerName
                                  , MovementItem.Ord::Integer
                                  , mod(date_part('week',  CURRENT_DATE + Interval '7 DAY')::TFloat, 2.0) AS WeekUse
                                  , MovementItem.Amount                                AS Amount
                             FROM tmpPromoBonus AS MovementItem
                                  INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
                                  INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                  INNER JOIN tmpMaxOrd ON 1 = 1
                             WHERE CASE WHEN mod(date_part('week',  CURRENT_DATE + Interval '7 DAY')::TFloat, 2.0) = 0
                                        THEN tmpMaxOrd.MaxOrd / 2 <= MovementItem.Ord
                                        ELSE tmpMaxOrd.MaxOrd / 2 + 1 >= MovementItem.Ord END = TRUE)
          , tmpUnitGoods AS (SELECT DISTINCT tmpUnit.UnitId, tmpGoodsWeek.GoodsId
                             FROM tmpGoodsWeek
                                  LEFT JOIN tmpUnit ON 1 = 1
                             )
          , tmpMIC AS (SELECT tmpUnitGoods.UnitId
                            , tmpUnitGoods.GoodsId
                            , ACI.OperDate
                            , SUM(ACI.AmountCheck)       AS AmountCheck
                            , SUM(ACI.AmountCheckSum)    AS AmountCheckSum
                            , ROUND(SUM(ACI.AmountCheckSum) / SUM(ACI.AmountCheck), 2)   AS Price
                       FROM tmpUnitGoods

                            INNER JOIN AnalysisContainerItem  AS ACI
                                                              ON ACI.UnitId  = tmpUnitGoods.UnitId
                                                             AND ACI.GoodsId  = tmpUnitGoods.GoodsId
                                                             AND ACI.AmountCheck > 0
                                                             AND ACI.OperDate >= inStartDate
                                                             AND ACI.OperDate <= inEndDate

                            INNER JOIN tmpGoodsWeek ON tmpGoodsWeek.GoodsId = tmpUnitGoods.GoodsId
                                                   AND tmpGoodsWeek.WeekUse = mod(date_part('week', ACI.OperDate)::TFloat, 2.0)

                      -- WHERE  tmpUnitGoods.UnitId = 183292
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

    SELECT tmpMIC.OperDate                                             AS OperDate
         , tmpMIC.UnitId                                               AS UnitId
         , Object_Unit.ValueData                                       AS UnitName
         , tmpMIC.GoodsId                                              AS GoodsId
         , Object_Goods_Main.ObjectCode                                AS GoodsCode
         , Object_Goods_Main.Name                                      AS GoodsName
         , tmpMIC.AmountCheck::TFloat                                  AS AmountCheck
         , tmpMIC.AmountCheckSum::TFloat                               AS AmountCheckSum
         , Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price), 2)::TFloat AS PriceOld
         , Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price) * CASE WHEN tmpProcent.Proc < 1 THEN tmpProcent.Proc ELSE 1 END, 2)::TFloat

         , Round(tmpMIC.AmountCheck * Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price), 2), 2)::TFloat    AS AmountCheckSumOld
         , Round(tmpMIC.AmountCheck * Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price) * CASE WHEN tmpProcent.Proc < 1 THEN tmpProcent.Proc ELSE 1 END, 2), 2)::TFloat AS AmountCheckSumNew
         , (Round(tmpMIC.AmountCheck * Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price) * CASE WHEN tmpProcent.Proc < 1 THEN tmpProcent.Proc ELSE 1 END, 2), 2) -
            Round(tmpMIC.AmountCheck * Round(COALESCE(tmpPrice.PriceOld, tmpMIC.Price), 2), 2))::TFloat   AS Delta
    FROM tmpMIC

         LEFT JOIN tmpPrice ON tmpPrice.UnitId = tmpMIC.UnitId
                           AND tmpPrice.GoodsId =  tmpMIC.GoodsId
                           AND tmpPrice.OperDate <=  tmpMIC.OperDate
                           AND tmpPrice.DateEnd >  tmpMIC.OperDate

         LEFT JOIN tmpProcent ON 1 = 1

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMIC.UnitId

         LEFT JOIN Object_Goods_Retail AS Object_Goods
                                       ON Object_Goods.Id = tmpMIC.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

    ORDER BY tmpMIC.OperDate
           , tmpMIC.UnitId
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
select * from gpReport_Check_PromoBonusEstimate(inStartDate:= '01.02.2021', inEndDate:= '10.02.2021', inSession := '3');