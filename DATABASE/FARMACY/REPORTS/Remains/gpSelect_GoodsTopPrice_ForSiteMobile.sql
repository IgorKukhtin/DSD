-- Function: gpSelect_GoodsTopPrice_ForSiteMobile()

DROP FUNCTION IF EXISTS gpSelect_GoodsTopPrice_ForSiteMobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsTopPrice_ForSiteMobile(
    IN inGoodsId       Integer  ,  -- Список товаров, через зпт
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId            Integer -- Аптека
             , Price_unit        TFloat -- цена аптеки
             , Price_unit_sale   TFloat -- цена аптеки со скидкой
             , Remains           TFloat -- Остаток (с учетом резерва)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    SELECT p.UnitId 
         , p.Price_unit
         , p.Price_unit_sale
         , p.Remains
    FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
    WHERE COALESCE(p.Remains, 0) > 0
    ORDER BY p.Price_unit, p.Remains DESC
    LIMIT 3
    ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.08.22                                                       *
*/

-- тест

SELECT p.* FROM gpSelect_GoodsTopPrice_ForSiteMobile (6307, zfCalc_UserSite()) AS p
