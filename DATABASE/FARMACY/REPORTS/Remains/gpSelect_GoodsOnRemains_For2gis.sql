-- Function: gpSelect_GoodsOnRemains_For2gis

DROP FUNCTION IF EXISTS gpSelect_GoodsOnRemains_For2gis (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnRemains_For2gis(
    IN inUnitId  Integer,   -- Подразделение
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (ProductId           Integer
             , ProductName         TVarChar
             , Producer            TVarChar
             , Price               TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
    -- сразу запомнили время начала выполнения Проц.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
       tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.Amount        <> 0
                      AND Container.WhereObjectId = inUnitId
                   )
     , tmpPartionMI AS
                     (SELECT CLO.ContainerId
                           , MILinkObject_Goods.ObjectId AS GoodsId_find
                           , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                      FROM ContainerLinkObject AS CLO
                          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                           ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                          AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                          -- элемент прихода
                          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                      WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                        AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                     )
     , tmpRemains AS (SELECT Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                           , SUM (Container.Amount)  AS Amount
                      FROM tmpContainer AS Container
                          LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                  ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                                 AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()
                      WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                      GROUP BY Container.ObjectId
                             , tmpPartionMI.GoodsId_find
                     )
     , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                      FROM ObjectString
                      WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                        AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                     )
     , Remains AS (SELECT tmpRemains.ObjectId
                        , MAX (tmpGoods.MakerName)         AS MakerName
                        , SUM (tmpRemains.Amount)          AS Amount
                     FROM
                         tmpRemains
                         LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                     GROUP BY tmpRemains.ObjectId
                     HAVING SUM (tmpRemains.Amount) > 0
                   )
     , tmpPrice_View AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                      THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                      ELSE ROUND (Price_Value.ValueData, 2)
                                 END :: TFloat                           AS Price
                               , Price_Goods.ChildObjectId               AS GoodsId
                          FROM ObjectLink AS ObjectLink_Price_Unit
                             LEFT JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                             LEFT JOIN ObjectFloat AS Price_Value
                                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                             -- Фикс цена для всей Сети
                             LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                    ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                   AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                     ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                    AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                          WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                            AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                          )

      SELECT Object_Goods_Main.ObjectCode                                         AS ProductId
           , REPLACE(Object_Goods_Main.Name, ';', ',')::TVarChar                  AS ProductName
           , REPLACE(Remains.MakerName, ';', ',')::TVarChar                       AS Producer
--           , to_char(Object_Price.Price,'FM9999990.00')::TVarChar                 AS Price
           , Object_Price.Price                                                   AS Price
      FROM Remains

           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                         AND Object_Goods_Retail.RetailId = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId


           LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId

      WHERE Remains.Amount > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnRemains_For2gis (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.04.20                                                                     *
*/

-- тест
--
SELECT * FROM gpSelect_GoodsOnRemains_For2gis (inUnitId := 183289, inSession:= '3')