 -- Function: gpSelect_GoodsSPRegistry_1303_All()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPRegistry_1303_All (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPRegistry_1303_All(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer
             , GoodsMainId    Integer
             , NDS            TFloat
             , PriceOptSP     TFloat
             , PriceSale      TFloat
             , MovementItemId Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;  
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    RETURN QUERY
    WITH
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovGoodsSP_1303 AS (SELECT Movement.Id                           AS Id
                                    , Movement.OperDate                     AS OperDate
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS ord
                               FROM Movement 
                               WHERE Movement.DescId = zc_Movement_GoodsSP_1303()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                               )
      , tmpMIGoodsSP_1303All AS (SELECT Movement.OperDate                     AS OperDate
                                      , COALESCE (MovementNext.OperDate, zc_DateEnd()) AS DateEnd
                                      , MovementItem.Id                       AS MovementItemId
                                      , MovementItem.ObjectId                 AS GoodsId
                                      , MovementItem.Amount                   AS PriceSale
                                 FROM tmpMovGoodsSP_1303 AS Movement
                                            
                                      INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.isErased = False
                                                                                                                                   
                                      LEFT JOIN tmpMovGoodsSP_1303 AS MovementNext
                                                                   ON MovementNext.Ord =  Movement.Ord + 1
                                  )
      , tmpMIFlot AS (SELECT *
                      FROM  MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId in (SELECT tmpMIGoodsSP_1303All.MovementItemId FROM tmpMIGoodsSP_1303All))
      , tmpMIGoodsSP_1303 AS (SELECT MovementItem.GoodsId
                                   , MovementItem.PriceSale
                                   , MIFloat_PriceOptSP.ValueData          AS PriceOptSP
                                   , ROW_NUMBER()OVER(PARTITION BY MovementItem.GoodsId ORDER BY MovementItem.DateEnd DESC) as ORD

                              FROM tmpMIGoodsSP_1303All AS MovementItem

                                   LEFT JOIN tmpMIFlot AS MIFloat_PriceOptSP
                                                               ON MIFloat_PriceOptSP.MovementItemId = MovementItem.MovementItemId
                                                              AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

                              WHERE MovementItem.OperDate <= CURRENT_DATE
                                AND MovementItem.DateEnd > CURRENT_DATE
                              )
      , tmpGoodsSPRegistry_1303 AS (SELECT MovementItem.Id               AS MovementItemId
                                         , MovementItem.ObjectId         AS GoodsId
                                         , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat       AS NDS
                                         , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                         , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                          -- № п/п - на всякий случай
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, MIDate_OrderDateSP.ValueData DESC) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                                               AND COALESCE (MovementItem.ObjectId, 0) <> 0

                                         LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                     ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                         LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                     ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                         LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                    ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                   AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                         LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                    WHERE Movement.DescId = zc_Movement_GoodsSPRegistry_1303()
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                   )

        SELECT Object_Goods_Retail.Id    AS GoodsId
             , Object_Goods.Id           AS GoodsMainId  
             , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS

             , COALESCE (tmpMIGoodsSP_1303.PriceOptSP,  tmpGoodsSPRegistry_1303.PriceOptSP, 0)::TFloat                                               AS PriceOptSP

             , COALESCE (tmpMIGoodsSP_1303.PriceSale,
               ROUND(tmpGoodsSPRegistry_1303.PriceOptSP  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2), 0)::TFloat AS PriceSale
             , tmpGoodsSPRegistry_1303.MovementItemId

        FROM tmpGoodsSPRegistry_1303
        
             FULL JOIN tmpMIGoodsSP_1303 ON tmpMIGoodsSP_1303.GoodsId = tmpGoodsSPRegistry_1303.GoodsId
                                        AND tmpMIGoodsSP_1303.Ord = 1
        
        
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = COALESCE(tmpGoodsSPRegistry_1303.GoodsId, tmpMIGoodsSP_1303.GoodsId) 
             LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods.Id
                                                                 AND Object_Goods_Retail.RetailId = vbObjectId
            
             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId
                                  
        WHERE COALESCE(tmpGoodsSPRegistry_1303.Ord, 1) = 1
          AND COALESCE (Object_Goods_Retail.Id, 0) <> 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/

--ТЕСТ
-- 
select * from gpSelect_GoodsSPRegistry_1303_All(inSession := '3');