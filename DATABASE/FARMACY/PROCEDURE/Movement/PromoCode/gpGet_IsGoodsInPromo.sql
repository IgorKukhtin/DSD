-- проверка разрешен ли препарат в акции
DROP FUNCTION IF EXISTS gpGet_IsGoodsInPromo(Integer, Integer, out Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_IsGoodsInPromo (
    IN  inPromoCodeId  				Integer,		  	-- промо код
    IN  inGoodsId   				Integer,		  	-- препарат
    OUT outResult 					Boolean,			-- разрешен
    IN  inSession     				TVarChar        	-- сессия пользователя
)
AS
$BODY$
BEGIN

    outResult := False;
    
    -- если есть хотя бы один препарат в списке участвующих в акции, то проверяем входит ли наш в этот список
    IF EXISTS(SELECT  * 
              FROM MovementItem PromoCode
                  INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                  INNER JOIN MovementItem PromoGoods ON Promo.id = PromoGoods.movementid AND PromoGoods.descid = zc_MI_Master()                  
              WHERE PromoCode.id = inPromoCodeId) THEN
    	IF EXISTS(SELECT  * 
              FROM MovementItem PromoCode
                  INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                  INNER JOIN MovementItem PromoGoods ON Promo.id = PromoGoods.movementid AND PromoGoods.descid = zc_MI_Master()                  
              WHERE PromoCode.id = inPromoCodeId AND PromoGoods.objectid = inGoodsId) THEN
        	outResult := True;
        END IF;
    ELSE
    	outResult := True;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Подмогильный В.В.
 02.02.18                                                                                        *
*/