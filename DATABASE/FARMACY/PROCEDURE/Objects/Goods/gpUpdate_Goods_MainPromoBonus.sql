 -- Function: gpUpdate_Goods_MainPromoBonus()

DROP FUNCTION IF EXISTS gpUpdate_Goods_MainPromoBonus (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_MainPromoBonus(
    IN inGoodsId           Integer  ,  -- Подразделение
    IN inMakerID           Integer,    -- 
    IN inPromoBonus        TFloat,     -- Промо бонус
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inMakerID, 0) = 0
    THEN
      Return;
    END IF;
    
    IF COALESCE(inPromoBonus, 0) <> COALESCE((SELECT Object_Goods_Main.PromoBonus FROM Object_Goods_Retail 
                                              INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                              WHERE Object_Goods_Retail.Id = inGoodsId), -1)
    THEN
      UPDATE Object_Goods_Main SET PromoBonus = inPromoBonus
      WHERE Object_Goods_Main.Id = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsId);
    END IF;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.10.23                                                       *
*/

-- тест
-- select * from gpUpdate_Goods_MainPromoBonus(inSession := '3');