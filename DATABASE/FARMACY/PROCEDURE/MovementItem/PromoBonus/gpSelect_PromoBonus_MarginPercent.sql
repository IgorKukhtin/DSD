-- Function: gpSelect_PromoBonus_MarginPercent()

DROP FUNCTION IF EXISTS gpSelect_PromoBonus_MarginPercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoBonus_MarginPercent(
    IN inUnitId        Integer ,   --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsID Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitID Integer, UnitName TVarChar
             , MarginPercent TFloat
             , PromoBonus TFloat
             , BonusInetOrder TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbMovPromoBonus Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     vbMovPromoBonus := (WITH tmpMovPromoBonus AS 
                              (SELECT Movement.id AS ID FROM Movement
                               WHERE Movement.OperDate <= CURRENT_DATE
                                 AND Movement.DescId = zc_Movement_PromoBonus()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
    							 
                        SELECT MAX(tmpMovPromoBonus.ID) AS ID FROM tmpMovPromoBonus);
                        
     
     RETURN QUERY
      WITH tmpMI AS(SELECT Max(MovementItem.Id)::Integer       AS Id
                    FROM MovementItem

                         LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                                     ON MIFloat_BonusInetOrder.MovementItemId = MovementItem.Id
                                                    AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()

                    WHERE MovementItem.MovementId = vbMovPromoBonus
                      AND MovementItem.DescId = zc_MI_Master()
                      AND (MovementItem.Amount > 0 OR COALESCE (MIFloat_BonusInetOrder.ValueData, 0) > 0)
                      AND MovementItem.isErased = False
                    GROUP BY MovementItem.ObjectId)

     SELECT DISTINCT
            MIMaster.ObjectId             AS GoodsID
          , Object_Goods_Main.ObjectCode  AS GoodsCode
          , Object_Goods_Main.Name        AS GoodsName
          , MIChild.ObjectId              AS UnitID
          , Object_Unit.ValueData         AS UnitName
          , MIChild.Amount                AS MarginPercent
          , MIMaster.Amount               AS PromoBonus
          , COALESCE (MIFloat_BonusInetOrder.ValueData, 0)::TFloat AS BonusInetOrder

     FROM tmpMI 
     
          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = vbMovPromoBonus
                                 AND MIMaster.DescId = zc_MI_Master()
                                 AND MIMaster.Id = tmpMI.ID
                                  
          INNER JOIN MovementItem AS MIChild
                                  ON MIChild.MovementId = vbMovPromoBonus
                                 AND MIChild.ParentId = MIMaster.Id
                                 AND MIChild.DescId = zc_MI_Child()
                                 AND (MIChild.ObjectId =inUnitId OR inUnitId = 0)

          LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                      ON MIFloat_BonusInetOrder.MovementItemId = MIMaster.Id
                                     AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()

          LEFT JOIN Object_Goods_Retail AS Object_Goods
                                        ON Object_Goods.Id = MIMaster.ObjectId
          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
          
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MIChild.ObjectId

     WHERE COALESCE(Object_Goods.isTop, FALSE) = FALSE

     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PromoBonus_MarginPercent (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 11.03.23                                                                          *
*/

-- ТЕСТ
--

select * from gpSelect_PromoBonus_MarginPercent(inUnitId := 183289,  inSession := '3');