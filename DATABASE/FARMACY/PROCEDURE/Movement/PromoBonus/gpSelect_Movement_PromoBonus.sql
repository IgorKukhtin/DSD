-- Function: gpSelect_MovementItem_PromoBonus()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoBonus (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoBonus(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , Amount TFloat, MIPromoId Integer, MovementPromoId Integer
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoBonus());
    vbUserId:= lpGetUserBySession (inSession);

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                            AS Id
                                      , MovementItem.ObjectId                      AS GoodsId
                                      , MILinkObject_Juridical.ObjectId            AS JuridicalId
                                      , MovementItem.Amount                        AS Amount
                                      , MIFloat_MovementItemId.ValueData::Integer  AS MIPromoId
                                      , MIPromo.MovementId                         AS MovementPromoId
                                      , MovementItem.isErased                      AS isErased
                                 FROM MovementItem

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                                      ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                 ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                                
                                     LEFT JOIN MovementItem AS MIPromo ON MIPromo.ID = MIFloat_MovementItemId.ValueData::Integer

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 )


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , Object_Goods.ObjectCode                           AS GoodsCode
                    , Object_Goods.ValueData                            AS GoodsName
                    , Object_Juridical.Id                               AS JuridicalId
                    , Object_Juridical.ObjectCode                       AS JuridicalCode
                    , Object_Juridical.ValueData                        AS JuridicalName
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.MIPromoId                               AS MIPromoId
                    , MI_Master.MovementPromoId                         AS MovementPromoId
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MI_Master.JuridicalId


                   ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.02.21                                                      *
*/
-- 
select * from gpSelect_MovementItem_PromoBonus(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');