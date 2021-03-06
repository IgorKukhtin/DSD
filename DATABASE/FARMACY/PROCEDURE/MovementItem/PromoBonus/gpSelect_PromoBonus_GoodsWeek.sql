-- Function: gpSelect_PromoBonus_GoodsWeek()

DROP FUNCTION IF EXISTS gpSelect_PromoBonus_GoodsWeek (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoBonus_GoodsWeek(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsMainId Integer, GoodsCode Integer, GoodsName TVarChar
             , MakerName TVarChar, Ord Integer
             , Amount TFloat)
 AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoBonus());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат такой
    RETURN QUERY
    WITH tmpMovementItem AS (SELECT MovementItem.Id        
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
                             ORDER BY Object_Maker.ValueData),
         tmpMaxOrd AS (SELECT max(tmpMovementItem.Ord) AS MaxOrd FROM tmpMovementItem)
     
     SELECT MovementItem.Id        
          , MovementItem.GoodsId                       AS GoodsId
          , Object_Goods_Retail.GoodsMainId            AS GoodsMainId
          , Object_Goods_Main.ObjectCode               AS GoodsCode
          , Object_Goods_Main.Name                     AS GoodsName
          , MovementItem.MakerName
          , MovementItem.Ord::Integer
          , MovementItem.Amount                        AS Amount
     FROM tmpMovementItem AS MovementItem
          INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
          INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
          INNER JOIN tmpMaxOrd ON 1 = 1
     WHERE CASE WHEN mod(date_part('week',  CURRENT_DATE)::TFloat, 2.0) = 0  
                THEN tmpMaxOrd.MaxOrd / 2 <= MovementItem.Ord 
                ELSE tmpMaxOrd.MaxOrd / 2 + 1 >= MovementItem.Ord END = TRUE
     
     ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 05.03.21                                                      *
*/
-- select * from gpSelect_PromoBonus_GoodsWeek(inSession := '3');