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
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , Amount TFloat, MIPromoId Integer, MovementPromoId Integer
             , GoodsGroupPromoID Integer, GoodsGroupPromoName TVarChar
             , DateUpdate TDateTime, BonusInetOrder TFloat, isLearnWeek Boolean
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
                                      , MovementItem.Amount                        AS Amount
                                      , MIFloat_MovementItemId.ValueData::Integer  AS MIPromoId
                                      , MIPromo.MovementId                         AS MovementPromoId
                                      , MovementLinkObject_Maker.ObjectId          AS MakerId 
                                      , MIDate_Update.ValueData                    AS DateUpdate
                                      , MIFloat_BonusInetOrder.ValueData           AS BonusInetOrder
                                      , MovementItem.isErased                      AS isErased
                                 FROM MovementItem


                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                 ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                                
                                     LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                                                 ON MIFloat_BonusInetOrder.MovementItemId = MovementItem.Id
                                                                AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()

                                     LEFT JOIN MovementItemDate AS MIDate_Update
                                                                ON MIDate_Update.MovementItemId = MovementItem.Id
                                                               AND MIDate_Update.DescId = zc_MIDate_Update()

                                     LEFT JOIN MovementItem AS MIPromo ON MIPromo.ID = MIFloat_MovementItemId.ValueData::Integer

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                                  ON MovementLinkObject_Maker.MovementId = MIPromo.MovementId
                                                                 AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 ),
                   tmpPromoBonus_GoodsWeek AS (SELECT * FROM gpSelect_PromoBonus_GoodsWeek(inSession := inSession))



               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , Object_Goods.ObjectCode                           AS GoodsCode
                    , Object_Goods.ValueData                            AS GoodsName
                    , Object_Maker.Id                                   AS MakerId
                    , Object_Maker.ObjectCode                           AS MakerCode
                    , Object_Maker.ValueData                            AS MakerName
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.MIPromoId                               AS MIPromoId
                    , MI_Master.MovementPromoId                         AS MovementPromoId
                    , Object_GoodsGroupPromo.ID              AS GoodsGroupPromoID
                    , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
                    , date_trunc('day',MI_Master.DateUpdate)::TDateTime AS DateUpdate
                    , MI_Master.BonusInetOrder                          AS BonusInetOrder
                    , COALESCE (tmpPromoBonus_GoodsWeek.ID, 0) <> 0     AS isLearnWeek
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
                   LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MI_Master.MakerId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                                        ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
                   LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
                   
                   LEFT JOIN tmpPromoBonus_GoodsWeek ON tmpPromoBonus_GoodsWeek.ID = MI_Master.Id

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
select * from gpSelect_MovementItem_PromoBonus(inMovementId := 22188745   , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');