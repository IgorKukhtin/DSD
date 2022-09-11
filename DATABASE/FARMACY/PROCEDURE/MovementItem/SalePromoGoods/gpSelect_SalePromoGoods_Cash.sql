 -- Function: gpSelect_SalePromoGoods_Cash()

DROP FUNCTION IF EXISTS gpSelect_SalePromoGoods_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SalePromoGoods_Cash(
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (EndPromo         TDateTime
             , GoodsId          Integer
             , Amount           TFloat 
             , GoodsPresentId   Integer
             , AmountPresent    TFloat
             , Price            TFloat
             , GoodsPresentCode Integer
             , GoodsPresentName TVarChar
             , PriceSale        TFloat
             , AmountSale       TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());


    RETURN QUERY
    WITH -- Документы
           tmpMovementAll AS (SELECT Movement.Id
                                   , MovementDate_EndPromo.ValueData AS EndPromo
                              FROM Movement

                                   INNER JOIN MovementDate AS MovementDate_StartPromo
                                                           ON MovementDate_StartPromo.MovementId = Movement.Id
                                                          AND MovementDate_StartPromo.DescId     = zc_MovementDate_StartPromo()
                                                          AND MovementDate_StartPromo.ValueData  <= CURRENT_DATE

                                   INNER JOIN MovementDate AS MovementDate_EndPromo
                                                           ON MovementDate_EndPromo.MovementId = Movement.Id
                                                          AND MovementDate_EndPromo.DescId     = zc_MovementDate_EndPromo()
                                                          AND MovementDate_EndPromo.ValueData  >= CURRENT_DATE

                              WHERE Movement.DescId = zc_Movement_SalePromoGoods()
                                --AND Movement.StatusId = zc_Enum_Status_Complete()
                              ),
           tmpMIUnitAll AS (SELECT Movement.Id                      AS Id
                                 , MI_SalePromoGoods.ObjectId       AS UnitId
                            FROM tmpMovementAll AS Movement
                            
                                 INNER JOIN MovementItem AS MI_SalePromoGoods
                                                         ON MI_SalePromoGoods.MovementId = Movement.Id
                                                        AND MI_SalePromoGoods.DescId = zc_MI_Sign()
                                                        AND MI_SalePromoGoods.isErased = FALSE
                                                        AND MI_SalePromoGoods.Amount = 1),
           tmpMIUnit AS (SELECT DISTINCT MovementItem.Id   AS Id
                         FROM tmpMIUnitAll AS MovementItem
                         WHERE MovementItem.UnitId = vbUnitId),
           tmpMIUnitGroup AS (SELECT DISTINCT MovementItem.Id   AS Id
                              FROM tmpMIUnitAll AS MovementItem),
           tmpMovement AS (SELECT Movement.Id
                                , Movement.EndPromo
                           FROM tmpMovementAll AS Movement

                                LEFT JOIN tmpMIUnit ON tmpMIUnit.Id = Movement.Id

                                LEFT JOIN tmpMIUnitGroup ON tmpMIUnitGroup.Id = Movement.Id

                           ),
           tmpMI AS (SELECT Movement.EndPromo                             AS EndPromo
                          , Goods_Retail.Id                               AS GoodsId
                          , MI_SalePromoGoods.Amount                      AS Amount
                          , Goods_RetailPresent.Id                        AS GoodsPresentId
                          , Object_Goods_Main.ObjectCode                  AS GoodsPresentCode
                          , Object_Goods_Main.Name                        AS GoodsPresentName
                          , MI_SalePromoGoodsPresent.Amount               AS AmountPresent
                          , COALESCE(MIFloat_Price.ValueData, 0)::TFloat  AS Price
                          , ROW_NUMBER() OVER (PARTITION BY MI_SalePromoGoods.ObjectId, MI_SalePromoGoodsPresent.ObjectId ORDER BY Movement.EndPromo DESC) AS Ord
                     FROM tmpMovement AS Movement

                          INNER JOIN MovementItem AS MI_SalePromoGoods
                                                  ON MI_SalePromoGoods.MovementId = Movement.Id
                                                 AND MI_SalePromoGoods.DescId = zc_MI_Master()
                                                 AND MI_SalePromoGoods.isErased = FALSE
                                                 AND MI_SalePromoGoods.Amount > 0
                          INNER JOIN Object_Goods_Retail AS Goods_Retail 
                                                         ON Goods_Retail.GoodsMainId = MI_SalePromoGoods.ObjectId 
                                                        AND Goods_Retail.RetailId = vbRetailId

                          INNER JOIN MovementItem AS MI_SalePromoGoodsPresent
                                                  ON MI_SalePromoGoodsPresent.MovementId = MI_SalePromoGoods.MovementId
                                                 AND MI_SalePromoGoodsPresent.DescId = zc_MI_Child()
                                                 AND MI_SalePromoGoodsPresent.isErased = FALSE
                                                 AND MI_SalePromoGoodsPresent.Amount > 0
                          INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = MI_SalePromoGoodsPresent.ObjectId 
                          INNER JOIN Object_Goods_Retail AS Goods_RetailPresent 
                                                         ON Goods_RetailPresent.GoodsMainId = MI_SalePromoGoodsPresent.ObjectId 
                                                        AND Goods_RetailPresent.RetailId = vbRetailId
                                                 
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId =  MI_SalePromoGoodsPresent.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     )
                          
        SELECT MovementIten.EndPromo                             AS EndPromo
             , MovementIten.GoodsId
             , MovementIten.Amount
             , MovementIten.GoodsPresentId
             , MovementIten.AmountPresent
             , MovementIten.Price
             , MovementIten.GoodsPresentCode
             , MovementIten.GoodsPresentName
             , 0::TFloat   AS PriceSale
             , 0::TFloat   AS AmountSale
        FROM tmpMI AS MovementIten
        WHERE MovementIten.ORD = 1
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 08.09.22                                                      *
*/

--ТЕСТ
--

SELECT * FROM gpSelect_SalePromoGoods_Cash (inSession:= '3')