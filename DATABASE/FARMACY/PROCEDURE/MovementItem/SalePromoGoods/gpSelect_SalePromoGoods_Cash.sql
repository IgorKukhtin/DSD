 -- Function: gpSelect_SalePromoGoods_Cash()

DROP FUNCTION IF EXISTS gpSelect_SalePromoGoods_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SalePromoGoods_Cash(
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS TABLE (EndPromo         TDateTime
             , GoodsId          Integer
             , Amount           TFloat 
             , isAmountCheck    Boolean
             , isDiscountInformation Boolean
             , AmountCheck      TFloat
             , GoodsPresentId   Integer
             , AmountPresent    TFloat
             , Price            TFloat
             , Discount         TFloat
             , GoodsPresentCode Integer
             , GoodsPresentName TVarChar
             , PriceSale        TFloat
             , AmountSale       TFloat
             , Remains          TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
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
    WITH -- ���������
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
                                AND Movement.StatusId = zc_Enum_Status_Complete()
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
                                , COALESCE (MovementBoolean_AmountCheck.ValueData, False)           AS isAmountCheck
                                , COALESCE (MovementBoolean_DiscountInformation.ValueData, False)   AS isDiscountInformation
                                , MovementFloat_AmountCheck.ValueData                               AS AmountCheck
                           FROM tmpMovementAll AS Movement

                                LEFT JOIN tmpMIUnit ON tmpMIUnit.Id = Movement.Id

                                LEFT JOIN tmpMIUnitGroup ON tmpMIUnitGroup.Id = Movement.Id
                                
                                LEFT JOIN MovementBoolean AS MovementBoolean_AmountCheck
                                                          ON MovementBoolean_AmountCheck.MovementId = Movement.Id
                                                         AND MovementBoolean_AmountCheck.DescId = zc_MovementBoolean_AmountCheck()
                                LEFT JOIN MovementBoolean AS MovementBoolean_DiscountInformation
                                                          ON MovementBoolean_DiscountInformation.MovementId = Movement.Id
                                                         AND MovementBoolean_DiscountInformation.DescId = zc_MovementBoolean_DiscountInformation()
                                LEFT JOIN MovementFloat AS MovementFloat_AmountCheck
                                                        ON MovementFloat_AmountCheck.MovementId = Movement.Id
                                                       AND MovementFloat_AmountCheck.DescId = zc_MovementFloat_AmountCheck()
                                                       
                           WHERE COALESCE (tmpMIUnit.Id, 0) <> 0 OR COALESCE (tmpMIUnitGroup.Id, 0) = 0
                           ),
           tmpMI AS (SELECT Movement.EndPromo                             AS EndPromo
                          , Goods_Retail.Id                               AS GoodsId
                          , MI_SalePromoGoods.Amount                      AS Amount
                          , Movement.isAmountCheck
                          , Movement.isDiscountInformation
                          , Movement.AmountCheck
                          , Goods_RetailPresent.Id                        AS GoodsPresentId
                          , Object_Goods_Main.ObjectCode                  AS GoodsPresentCode
                          , Object_Goods_Main.Name                        AS GoodsPresentName
                          , MI_SalePromoGoodsPresent.Amount               AS AmountPresent
                          , COALESCE(MIFloat_Price.ValueData, 0)::TFloat  AS Price
                          , COALESCE(MIFloat_Discount.ValueData, 0)::TFloat AS Discount
                          , ROW_NUMBER() OVER (PARTITION BY MI_SalePromoGoods.ObjectId, MI_SalePromoGoodsPresent.ObjectId ORDER BY Movement.EndPromo DESC) AS Ord
                     FROM tmpMovement AS Movement

                          LEFT JOIN MovementItem AS MI_SalePromoGoods
                                                 ON MI_SalePromoGoods.MovementId = Movement.Id
                                                AND MI_SalePromoGoods.DescId = zc_MI_Master()
                                                AND MI_SalePromoGoods.isErased = FALSE
                                                AND MI_SalePromoGoods.Amount > 0
                          LEFT JOIN Object_Goods_Retail AS Goods_Retail 
                                                        ON Goods_Retail.GoodsMainId = MI_SalePromoGoods.ObjectId 
                                                       AND Goods_Retail.RetailId = vbRetailId

                          INNER JOIN MovementItem AS MI_SalePromoGoodsPresent
                                                  ON MI_SalePromoGoodsPresent.MovementId = Movement.Id
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
                          LEFT JOIN MovementItemFloat AS MIFloat_Discount
                                                      ON MIFloat_Discount.MovementItemId =  MI_SalePromoGoodsPresent.Id
                                                     AND MIFloat_Discount.DescId = zc_MIFloat_Discount()
                     )
                          
        SELECT MovementIten.EndPromo                             AS EndPromo
             , MovementIten.GoodsId
             , MovementIten.Amount
             , MovementIten.isAmountCheck
             , MovementIten.isDiscountInformation
             , MovementIten.AmountCheck
             , MovementIten.GoodsPresentId
             , MovementIten.AmountPresent
             , MovementIten.Price
             , MovementIten.Discount
             , MovementIten.GoodsPresentCode
             , MovementIten.GoodsPresentName
             , 0::TFloat   AS PriceSale
             , 0::TFloat   AS AmountSale
             , 0::TFloat   AS Remains
        FROM tmpMI AS MovementIten
        WHERE MovementIten.ORD = 1
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 08.09.22                                                      *
*/

--����
--

SELECT * FROM gpSelect_SalePromoGoods_Cash (inSession:= '3997056')