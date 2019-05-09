-- Function: gpSelect_MovementItem_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPromo (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPromo(
    IN inMovementId  Integer      , -- ключ Документа
    --IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , AmountManual TFloat
             , Price TFloat, Summ TFloat
             , MovementId_Promo Integer, InvNumber_Promo_Full TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , isReport Boolean
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

        -- Результат
        RETURN QUERY
        WITH
        tmpPartner AS (SELECT DISTINCT MovementLinkObject_Juridical.ObjectId AS JuridicalId
                       FROM Movement 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                       WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
                         AND Movement.ParentId = inMovementId
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                       )
      , tmpChild AS (SELECT MovementItem.ParentId
                          , SUM (COALESCE (MIFloat_AmountManual.ValueData,0)) AS AmountManual
                     FROM MovementItem
                          INNER JOIN MovementItemFloat AS MIFloat_AmountManual
                                                       ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId = zc_MI_Child()
                       AND MovementItem.isErased = FALSE
                     GROUP BY MovementItem.ParentId
                     )

           ----
           SELECT MovementItem.Id
                , MovementItem.ObjectId                    AS GoodsId
                , Object_Goods.ObjectCode                  AS GoodsCode
                , Object_Goods.ValueData                   AS GoodsName
                , MovementItem.Amount             ::TFloat AS Amount
                , tmpChild.AmountManual           ::TFloat AS AmountManual
                , MIFloat_Price.ValueData         ::TFloat AS Price
                , (COALESCE(MovementItem.Amount,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS Summ

                , Movement_Promo.Id           AS MovementId_Promo
                , ('№ ' || Movement_Promo.InvNumber || ' от ' || Movement_Promo.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Promo_Full
                
                , Object_Juridical.Id         AS JuridicalId
                , Object_Juridical.ValueData  AS JuridicalName

                , Object_Contract.Id          AS ContractId
                , Object_Contract.ValueData   AS ContractName

                , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN TRUE ELSE FALSE END AS isReport
                , MovementItem.IsErased       AS IsErased
           FROM MovementItem
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId    

              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MIFloat_PromoMovement.ValueData :: Integer
            
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                               ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId

              LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                               ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
              LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

              LEFT JOIN tmpPartner ON tmpPartner.JuridicalId = MILinkObject_Juridical.ObjectId

              LEFT JOIN tmpChild ON tmpChild.ParentId = MovementItem.Id
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND (MovementItem.isErased = FALSE or inIsErased = TRUE);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.19         * AmountManual
 15.04.19         *
*/

--select * from gpSelect_MovementItem_OrderInternalPromo(inMovementId := 0, inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_OrderInternalPromoChild(inMovementId := 0, inIsErased := 'False' ,  inSession := '3');

-- select * from gpSelect_MI_OrderInternalPromo(inMovementId := 13840564 , inIsErased := 'False' ,  inSession := '3');