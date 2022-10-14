-- Function: gpSelect_GoodsTopPrice_ForSiteMobile()

-- DROP FUNCTION IF EXISTS gpSelect_GoodsTopPrice_ForSiteMobile (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsTopPrice_ForSiteMobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsTopPrice_ForSiteMobile(
    IN inGoodsId            Integer  ,  -- Список товаров, через зпт
    IN inPartionDateKindId  Integer  ,  -- Id Срока
    IN inSession            TVarChar    -- сессия пользователя
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

    IF COALESCE (inPartionDateKindId, 0) = zc_Enum_PartionDateKind_1()
    THEN
    
      RETURN QUERY
      SELECT p.UnitId 
           , p.Price_unit
           , p.Price_unit_sale_1
           , p.Remains_1
      FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
      WHERE /*COALESCE(p.Remains_1, 0) >= 1
        AND */COALESCE(p.Price_unit, 0) > 0
        AND COALESCE(p.Price_unit_sale_1, 0) > 0
      ORDER BY p.Price_unit_sale_1, p.Remains_1 DESC
      LIMIT 3;
    
    ELSEIF COALESCE (inPartionDateKindId, 0) = zc_Enum_PartionDateKind_3()
    THEN
    
      RETURN QUERY
      SELECT p.UnitId 
           , p.Price_unit
           , p.Price_unit_sale_3
           , p.Remains_3
      FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
      WHERE /*COALESCE(p.Remains_3, 0) >= 1
        AND */COALESCE(p.Price_unit, 0) > 0
        AND COALESCE(p.Price_unit_sale_3, 0) > 0
      ORDER BY p.Price_unit_sale_3, p.Remains_3 DESC
      LIMIT 3;
    
    ELSEIF COALESCE (inPartionDateKindId, 0) = zc_Enum_PartionDateKind_6()
    THEN
    
      RETURN QUERY
      SELECT p.UnitId 
           , p.Price_unit
           , p.Price_unit_sale_6
           , p.Remains_6
      FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
      WHERE /*COALESCE(p.Remains_6, 0) >= 1
        AND */COALESCE(p.Price_unit, 0) > 0
        AND COALESCE(p.Price_unit_sale_6, 0) > 0
      ORDER BY p.Price_unit_sale_6, p.Remains_6 DESC
      LIMIT 3;
    
    ELSE
          
      RETURN QUERY
      SELECT p.UnitId 
           , p.Price_unit
           , p.Price_unit_sale
           , p.Remains
      FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::TVarChar, zfCalc_UserSite()) AS p
      WHERE /*COALESCE(p.Remains, 0) >= 1
        AND */COALESCE(p.Price_unit, 0) > 0
      ORDER BY p.Price_unit_sale, p.Remains DESC
      LIMIT 3;
    END IF;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.08.22                                                       *
*/

-- тест

SELECT p.* FROM gpSelect_GoodsTopPrice_ForSiteMobile (2984945, zc_Enum_PartionDateKind_1(), zfCalc_UserSite()) AS p