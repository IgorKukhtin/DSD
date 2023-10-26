 -- Function: gpUpdate_Goods_MainPriceSip()

DROP FUNCTION IF EXISTS gpUpdate_Goods_MainPriceSip (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_MainPriceSip(
    IN inGoodsId           Integer  ,  -- Подразделение
    IN inMakerID           Integer,    -- 
    IN inPriceSip          TFloat,     -- Цена сип
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
        
    UPDATE Object_Goods_Main SET PriceSip = inPriceSip
    WHERE Object_Goods_Main.Id = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsId);

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.10.23                                                       *
*/

-- тест
-- select * from gpUpdate_Goods_MainPriceSip(inSession := '3');