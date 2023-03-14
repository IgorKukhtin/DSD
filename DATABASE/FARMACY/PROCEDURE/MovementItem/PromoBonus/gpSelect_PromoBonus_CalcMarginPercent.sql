-- Function: gpSelect_PromoBonus_CalcMarginPercent()

DROP FUNCTION IF EXISTS gpSelect_PromoBonus_CalcMarginPercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoBonus_CalcMarginPercent(
    IN inMovementId    Integer ,   --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsID Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitID Integer, UnitName TVarChar
             , OperDate TDateTime
             , MarginPercent TFloat
             , PriceSale TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     
     vbUnitId := 377610;
                        
     --raise notice 'Value 1: %', CLOCK_TIMESTAMP();     

     CREATE TEMP TABLE tmpMI_Master_MarginPercent ON COMMIT DROP AS
       SELECT DISTINCT MovementItem.ObjectId             AS GoodsId
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master();
     
     ANALYSE tmpMI_Master_MarginPercent;
     
     --raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMI_Master_MarginPercent);  
     
     CREATE TEMP TABLE tmpMovement_MarginPercent ON COMMIT DROP AS
     SELECT Movement.Id 
          , Movement.OperDate
          , MovementLinkObject_Unit.ObjectId                AS UnitId
     FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                                                   
     WHERE Movement.DescId = zc_Movement_Reprice()
       AND Movement.StatusId <> zc_Enum_Status_Erased();
     
     ANALYSE tmpMovement_MarginPercent;
     
     --raise notice 'Value 3: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMovement_MarginPercent);  

     CREATE TEMP TABLE tmpMIAll_MarginPercent ON COMMIT DROP AS
     SELECT Movement.OperDate
          , Movement.UnitId
          , MovementItem.Id                                 AS ID
          , MovementItem.ObjectId                           AS GoodsID
          , MIFloat_JuridicalPrice.ValueData                AS JuridicalPrice
     FROM tmpMovement_MarginPercent AS Movement

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                 AND MovementItem.DescId = zc_MI_Master()
                                               
          INNER JOIN tmpMI_Master_MarginPercent ON tmpMI_Master_MarginPercent.GoodsId = MovementItem.ObjectId
          
          INNER JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                       ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                      AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                      AND MIFloat_JuridicalPrice.ValueData > 0

     ;
     
     ANALYSE tmpMIAll_MarginPercent;
     
     --raise notice 'Value 31: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMIAll_MarginPercent);  

/*     CREATE TEMP TABLE tmpMI_MarginPercent ON COMMIT DROP AS
     SELECT MovementItem.OperDate
                        , MovementItem.UnitId
                        , MovementItem.Id
                        , MovementItem.GoodsID
                        , MovementItem.JuridicalPrice
                        , ROW_NUMBER() OVER (PARTITION BY MovementItem.UnitId, MovementItem.GoodsID  ORDER BY MovementItem.OperDate DESC) AS Ord
                   FROM tmpMIAll_MarginPercent AS MovementItem

                        LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                      ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()
                                                                   
                   WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, False) = FALSE;*/
     

     CREATE TEMP TABLE tmpMI_MarginPercent ON COMMIT DROP AS
     WITH tmpMI AS(SELECT MovementItem.OperDate
                        , MovementItem.UnitId
                        , MovementItem.Id
                        , MovementItem.GoodsID
                        , MovementItem.JuridicalPrice
                        , ROW_NUMBER() OVER (PARTITION BY MovementItem.UnitId, MovementItem.GoodsID  ORDER BY MovementItem.OperDate DESC) AS Ord
                   FROM tmpMIAll_MarginPercent AS MovementItem

                        LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                      ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()
                                                                   
                   WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, False) = FALSE)
                     
     SELECT tmpMI.OperDate
          , tmpMI.UnitId
          , tmpMI.Id
          , tmpMI.GoodsID
          , tmpMI.JuridicalPrice
     FROM tmpMI
     WHERE tmpMI.Ord = 1;
     
     ANALYSE tmpMI_MarginPercent;
     
     --raise notice 'Value 4: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMI_MarginPercent);  
                             
     RETURN QUERY
      WITH DD AS(
                  SELECT DISTINCT
                      Object_MarginCategoryItem_View.MarginPercent,
                      Object_MarginCategoryItem_View.MinPrice,
                      Object_MarginCategoryItem_View.MarginCategoryId,
                      ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
                  FROM Object_MarginCategoryItem_View
                       INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                     AND Object_MarginCategoryItem.isErased = FALSE
                      )
               , MarginCondition AS (
                  SELECT
                      D1.MarginCategoryId,
                      D1.MarginPercent,
                      D1.MinPrice,
                      COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                  FROM DD AS D1
                      LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                      )

     SELECT tmpMI.GoodsID                 AS GoodsID
          , Object_Goods_Main.ObjectCode  AS GoodsCode
          , Object_Goods_Main.Name        AS GoodsName
          , tmpMI.UnitID                  AS UnitID
          , Object_Unit.ValueData         AS UnitName
          , tmpMI.OperDate                AS OperDate
          , CASE WHEN COALESCE (MIFloat_ContractPercent.ValueData, 0) <> 0
                 THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_ContractPercent.ValueData, 0)
                 ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_JuridicalPercent.ValueData, 0)
                 END::TFloat              AS MarginPercent
          , MIFloat_PriceSale.ValueData   AS PriceSale
     FROM tmpMI_MarginPercent AS tmpMI
     
          LEFT JOIN Object_Goods_Retail AS Object_Goods
                                        ON Object_Goods.Id = tmpMI.GoodsID
          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
          
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitID

          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

          LEFT JOIN MovementItemLinkObject AS MI_Juridical
                                           ON MI_Juridical.MovementItemId = tmpMI.Id
                                          AND MI_Juridical.DescId = zc_MILinkObject_Juridical()

          LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                   ON Object_MarginCategoryLink_unit.UnitId = tmpMI.UnitID  
                                                  AND Object_MarginCategoryLink_unit.JuridicalId = MI_Juridical.ObjectId
          LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                   ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                  AND Object_MarginCategoryLink_all.JuridicalId = MI_Juridical.ObjectId
                                                  AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPercent
                                      ON MIFloat_JuridicalPercent.MovementItemId = tmpMI.Id
                                     AND MIFloat_JuridicalPercent.DescId = zc_MIFloat_JuridicalPercent()
          LEFT JOIN MovementItemFloat AS MIFloat_ContractPercent
                                      ON MIFloat_ContractPercent.MovementItemId = tmpMI.Id
                                     AND MIFloat_ContractPercent.DescId = zc_MIFloat_ContractPercent()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                      ON MIFloat_PriceSale.MovementItemId = tmpMI.Id
                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                     

          LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                  AND (tmpMI.JuridicalPrice  * (100 + ObjectFloat_NDSKind_NDS.ValueData  )/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
     WHERE COALESCE(Object_Goods.isTop, FALSE) = FALSE
      -- AND tmpMI.Ord = 1

     ;

     --raise notice 'Value 6: %', CLOCK_TIMESTAMP();  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PromoBonus_CalcMarginPercent (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 11.03.23                                                                          *
*/

-- ТЕСТ
--

select * from gpSelect_PromoBonus_CalcMarginPercent(inMovementId := 22188745 ,  inSession := '3');