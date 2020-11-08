-- Function: gpReport_PriceCheck()

DROP FUNCTION IF EXISTS gpReport_PriceCheck (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceCheck(
    IN inPercent       TFloat    , -- Процент отклонения
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE curUnit refcursor;
   DECLARE vbQueryText Text;
   DECLARE vbID Integer;
   DECLARE vbUnitID Integer;
BEGIN

      -- Цены по подразделениям
    CREATE TEMP TABLE tmpUnitPrice (
            UnitId          Integer,
            GoodsId         Integer,
            Price           TFloat ,
            Ord             Integer
      ) ON COMMIT DROP;

    WITH tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId           AS UnitId
                     FROM Movement

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     WHERE Movement.DescId = zc_Movement_Check()
                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY'),
         tmpContainerAll AS (SELECT DISTINCT
                                    Container.WhereObjectId                 AS UnitID
                                  , Container.ObjectId                      AS GoodsId
                             FROM Container

                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount > 0
                               AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                            ),

         tmpPrice AS (SELECT ObjectLink_Price_Unit.ChildObjectId                        AS UnitId
                           , Object_Goods_Retail.GoodsMainId                       AS GoodsId
                           , ROUND (Price_Value.ValueData, 2):: TFloat             AS Price
                           , ROW_NUMBER() OVER (PARTITION BY Price_Goods.ChildObjectId ORDER BY Price_Value.ValueData) AS Ord

                    FROM ObjectLink AS ObjectLink_Price_Unit
                       INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                       INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Price_Goods.ChildObjectId

                       INNER JOIN tmpContainerAll ON tmpContainerAll.UnitID = ObjectLink_Price_Unit.ChildObjectId
                                                 AND tmpContainerAll.GoodsId = Price_Goods.ChildObjectId

                       LEFT JOIN ObjectFloat AS Price_Value
                                             ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                    WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                      AND ROUND (Price_Value.ValueData, 2) > 0)

    INSERT INTO tmpUnitPrice (UnitId, GoodsId, Price, Ord)
    SELECT tmpPrice.UnitId
         , tmpPrice.GoodsId
         , tmpPrice.Price
         , tmpPrice.Ord
    FROM tmpPrice;


      -- Pезультат
    CREATE TEMP TABLE tmpResult (
            GoodsId         Integer,
            GoodsCode       Integer,
            GoodsName       TVarChar,
            UnitCount       TFLoat,
            PriceAverage    TFLoat,
            PriceMin        TFLoat,
            PriceMax        TFLoat

      ) ON COMMIT DROP;

    -- Собираем товары
    INSERT INTO tmpResult (GoodsId, GoodsCode, GoodsName, UnitCount, PriceAverage, PriceMin, PriceMax)
    SELECT tmpUnitPrice.GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName
         , COUNT(*)
         , 0
         , MIN(tmpUnitPrice.Price)
         , MAX(tmpUnitPrice.Price)
    FROM tmpUnitPrice
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpUnitPrice.GoodsId
    GROUP BY tmpUnitPrice.GoodsId, Object_Goods.ObjectCode, Object_Goods.ValueData
    HAVING (MIN(tmpUnitPrice.Price) * (100.0 + inPercent) / 100.0) < MAX(tmpUnitPrice.Price)
    ORDER BY tmpUnitPrice.GoodsId;

    -- Расчитываем среднюю цену
    UPDATE tmpResult SET PriceAverage = T1.PriceAverage
    FROM (SELECT tmpUnitPrice.GoodsId
               , ROUND(SUM(tmpUnitPrice.Price) / COUNT(*), 2) AS PriceAverage
          FROM tmpUnitPrice
               INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
          WHERE tmpResult.UnitCount <= 2
             OR tmpResult.UnitCount > 2 AND tmpResult.UnitCount <= 5 AND tmpUnitPrice.Ord > 1 AND tmpUnitPrice.Ord < tmpResult.UnitCount
             OR tmpResult.UnitCount > 5 AND tmpUnitPrice.Ord > 2 AND tmpUnitPrice.Ord < tmpResult.UnitCount - 2
          GROUP BY tmpUnitPrice.GoodsId) AS T1
    WHERE tmpResult.GoodsId = T1.GoodsId;

    -- Удаляем что номально
    DELETE FROM tmpResult
    WHERE tmpResult.PriceAverage * (100.0 + inPercent) / 100.0 <= tmpResult.PriceMax
       AND tmpResult.PriceAverage * (100.0 - inPercent) / 100.0 >= tmpResult.PriceMin;

      -- Подразделения
    CREATE TEMP TABLE tmpUnit (
            Id              Integer,
            UnitId          Integer
      ) ON COMMIT DROP;

    INSERT INTO tmpUnit (Id, UnitId)
    SELECT ROW_NUMBER() OVER (ORDER BY tmpUnitPrice.UnitID) AS Id
         , tmpUnitPrice.UnitID
    FROM tmpUnitPrice
         INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
    GROUP BY tmpUnitPrice.UnitID
    ORDER BY tmpUnitPrice.UnitID;

      -- Заполняем подразделение

    OPEN curUnit FOR SELECT * FROM tmpUnit ORDER BY tmpUnit;
    LOOP
        FETCH curUnit INTO vbID, vbUnitID;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Price' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
          ' , ADD COLUMN Color_calc' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT zc_Color_Black() ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult set Price' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.T_Price, 0)' ||
          ', Color_calc' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.T_Color_calc, 0)' ||
          ' FROM (SELECT
             tmpUnitPrice.GoodsID AS GoodsID,
             tmpUnitPrice.Price AS T_Price,
             CASE WHEN tmpResult.PriceAverage * (100.0 + '||inPercent::Text||') / 100.0 < tmpUnitPrice.Price
                    OR tmpResult.PriceAverage * (100.0 - '||inPercent::Text||') / 100.0 > tmpUnitPrice.Price
                  THEN zc_Color_Red() ELSE zc_Color_Black() END AS T_Color_calc
           FROM tmpUnitPrice
                INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
           WHERE tmpUnitPrice.UnitID = ' || COALESCE (vbUnitID, 0)::Text || ') AS T1
           WHERE tmpResult.GoodsId = T1.GoodsId';
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curUnit;

       -- Вывод результата
       -- Подразделения для кросса
    OPEN cur1 FOR
    SELECT tmpUnit.ID
         , tmpUnit.UnitID
         , Object_Unit.ValueData  AS UnitName
    FROM tmpUnit
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitID
    ORDER BY tmpUnit.UnitID;
    RETURN NEXT cur1;


    OPEN cur2 FOR
    SELECT *
    FROM tmpResult
    ORDER BY tmpResult.GoodsName;
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.11.20                                                       *
*/

-- тест
--
select * from gpReport_PriceCheck(inPercent := 5, inSession := '3');               