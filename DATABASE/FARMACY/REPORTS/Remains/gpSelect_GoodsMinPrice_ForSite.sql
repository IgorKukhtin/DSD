-- Function: gpSelect_GoodsMinPrice_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsMinPrice_ForSite (Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsMinPrice_ForSite(
    IN inUnitId_list      Text     ,  -- Список Подразделений, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Article           Integer
             , Price             TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSiteDiscount TFloat;

   DECLARE vbIndex Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId)
           SELECT tmp.UnitId
                , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
                LEFT JOIN ObjectLink AS OL_Unit_Area
                                     ON OL_Unit_Area.ObjectId = tmp.UnitId
                                    AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    RETURN QUERY
       WITH tmpM_Container AS
               (SELECT DISTINCT
                       Container.WhereObjectId  AS UnitId
                     , Container.ObjectId       AS GoodsId
                FROM Container
                                    INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = Container.WhereObjectId
                WHERE Container.DescId = zc_Container_Count()
                  AND Container.Amount <> 0
                 -- AND Container.WhereObjectId = 183292
               )
          , Price_Unit AS
               (SELECT ObjectLink_Price_Unit.ChildObjectId                      AS UnitId
                     , Price_Goods.ChildObjectId                                AS GoodsId
                     , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                             AND ObjectFloat_Goods_Price.ValueData > 0
                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                            END :: TFloat                                       AS Price
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                T JOIN ObjectFloat AS Price_Value
                                         LEF                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId in (SELECT DISTINCT tmpM_Container.UnitId FROM tmpM_Container)
               )

    SELECT Object_Goods.ObjectCode          AS Article
         , min(Price_Unit.Price)::TFloat    AS Price
    FROM tmpM_Container
         INNER JOIN Price_Unit ON tmpM_Container.UnitId = Price_Unit.UnitId
                              AND tmpM_Container.GoodsId = Price_Unit.GoodsId
         INNER JOIN Object AS Object_Goods on Object_Goods.ID = tmpM_Container.GoodsId
    GROUP BY Object_Goods.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 13.06.19                                                                    *
 10.06.19                                                                    *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsMinPrice_ForSite(inUnitId_list := '183292,183288,377605,375627,394426,472116,494882,1529734,1781716,377606,377595,183290,183289,183294,377613,377574,377594,377610,183293,375626,183291', inSession:= zfCalc_UserSite());
