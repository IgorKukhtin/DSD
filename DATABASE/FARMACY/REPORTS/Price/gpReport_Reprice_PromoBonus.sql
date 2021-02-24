-- Function: gpReport_Reprice_PromoBonus()

DROP FUNCTION IF EXISTS gpReport_Reprice_PromoBonus (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Reprice_PromoBonus(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PriceOld TFloat, PriceNew TFloat, Juridical_Price TFloat
             , MarginPercent TFloat, SummReprice TFloat
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
           tmpMovement AS (SELECT
                                  Movement.Id
                                , Movement.InvNumber
                                , Movement.OperDate
                                , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
                                , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent

                                , MovementLinkObject_Unit.ObjectId                      AS UnitId
                                , Object_Unit.ValueData                                 AS UnitName
                                , Object_Area.ValueData                                 AS AreaName
                                , Object_Juridical.ValueData                            AS JuridicalName
                                , Object_ProvinceCity.ValueData                         AS ProvinceCityName

                                , Object_UnitForwarding.Id                              AS UnitForwardingId
                                , Object_UnitForwarding.ValueData                       AS UnitForwardingName

                                , MovementString_GUID.ValueData                         AS GUID

                                , Object_Insert.ValueData                               AS InsertName
                                , MovementDate_Insert.ValueData                         AS InsertDate

                              FROM Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                  LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                          ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                                         AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpUnit.JuridicalId
                                  LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = tmpUnit.ProvinceCityId
                                  LEFT JOIN Object AS Object_Area ON Object_Area.Id = tmpUnit.AreaId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                                               ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                                              AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                                  LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

                                  LEFT OUTER JOIN MovementString AS MovementString_GUID
                                                                 ON MovementString_GUID.MovementId = Movement.Id
                                                                AND MovementString_GUID.DescId = zc_MovementString_Comment()

                                  LEFT JOIN MovementDate AS MovementDate_Insert
                                                         ON MovementDate_Insert.MovementId = Movement.Id
                                                        AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                                  LEFT JOIN MovementLinkObject AS MLO_Insert
                                                               ON MLO_Insert.MovementId = Movement.Id
                                                              AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                  LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                              WHERE Movement.DescId = zc_Movement_Reprice()
                                AND Movement.OperDate = inOperDate
                                --AND COALESCE (MovementLinkObject_UnitForwarding.ObjectId, 0) = 0
                              ORDER BY Movement.InvNumber),
           tmpPriceRise AS (SELECT tmpMovement.UnitId
                                 , MovementItem.ObjectId                             AS GoodsId
                            FROM tmpMovement

                                INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.ID
                                                       AND MovementItem.DescId = zc_MI_Master()

                                LEFT JOIN Object_Goods_Retail AS Object_Goods
                                                              ON Object_Goods.Id = MovementItem.ObjectId
                                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                                LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                              ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

                             WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, FALSE) <> True
                               AND COALESCE(Object_Goods.IsTop, false) = False
                               AND MIFloat_Price.ValueData < MIFloat_PriceSale.ValueData
                               AND COALESCE (tmpMovement.UnitForwardingId, 0) <> 0)


        SELECT tmpMovement.UnitId
             , tmpMovement.UnitName
             , MovementItem.Id                                   AS Id
             , MovementItem.ObjectId                             AS GoodsId
             , Object_Goods_Main.ObjectCode                      AS GoodsCode
             , Object_Goods_Main.Name                            AS GoodsName
             , COALESCE(MovementItem.Amount,0)::TFloat           AS Amount
             , MIFloat_Price.ValueData                           AS PriceOld
             , MIFloat_PriceSale.ValueData                       AS PriceNew
             , MIFloat_JuridicalPrice.ValueData                  AS Juridical_Price
             , Round((MIFloat_PriceSale.ValueData / MIFloat_JuridicalPrice.ValueData - 1) * 100, 2) ::TFloat AS MarginPercent
             , (MovementItem.Amount*
                 (COALESCE(MIFloat_PriceSale.ValueData, 0)
                  -COALESCE(MIFloat_Price.ValueData, 0)))   ::TFloat            AS SummReprice
        FROM  tmpMovement

            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.ID
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object_Goods_Retail AS Object_Goods
                                          ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                    ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                   AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()


            LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                          ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                         AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

            LEFT JOIN MovementItemBoolean AS MIBoolean_PromoBonus
                                          ON MIBoolean_PromoBonus.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PromoBonus.DescId         = zc_MIBoolean_PromoBonus()

            LEFT JOIN tmpPriceRise ON tmpPriceRise.UnitId = tmpMovement.UnitId
                                  AND tmpPriceRise.GoodsId = MovementItem.ObjectId

         WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, FALSE) <> True
           AND COALESCE(MIBoolean_PromoBonus.ValueData, FALSE) = True
           AND COALESCE(Object_Goods.IsTop, false) = False
         --  AND MIFloat_Price.ValueData > MIFloat_PriceSale.ValueData
           AND COALESCE (tmpPriceRise.UnitId, 0) = 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Reprice_PromoBonus (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.03.18                                                       *
*/

--
select * from gpReport_Reprice_PromoBonus(inOperDate := ('22.02.2021')::TDateTime ,  inSession := '3');