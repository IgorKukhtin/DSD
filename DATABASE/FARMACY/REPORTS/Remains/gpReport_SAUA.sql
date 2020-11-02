-- Function: gpReport_SAUA()

DROP FUNCTION IF EXISTS gpReport_SAUA (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SAUA(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               UnitId_Master Integer, UnitName_Master TVarChar

             , UnitId_Slave Integer, UnitName_Slave TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PercentSAUA TFloat, AmountSAUA TFloat
             , MCS TFloat, GoodsCategory TFloat
              )
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;

     vbEndDate := DATE_TRUNC ('MONTH', CURRENT_DATE) ;
     vbStartDate := DATE_TRUNC ('MONTH', vbEndDate - INTERVAL '1 DAY');

     -- все парзделения для SAUA
     CREATE TEMP TABLE _tmpUnit_SAUA   (UnitId_Master Integer, UnitId_Slave Integer, PercentSAUA TFloat) ON COMMIT DROP;

     -- Получили в се пары с подразделениями
     INSERT INTO _tmpUnit_SAUA (UnitId_Master, UnitId_Slave, PercentSAUA)
     SELECT ObjectLink.ChildObjectId
          , ObjectLink.ObjectId
          , COALESCE (ObjectFloat_PercentSAUA.ValueData,0) ::TFloat
     FROM ObjectLink

          LEFT JOIN ObjectFloat AS ObjectFloat_PercentSAUA
                                ON ObjectFloat_PercentSAUA.ObjectId = ObjectLink.ObjectId
                               AND ObjectFloat_PercentSAUA.DescId = zc_ObjectFloat_Unit_PercentSAUA()

     WHERE ObjectLink.DescId = zc_ObjectLink_Unit_UnitSAUA()
       AND COALESCE (ObjectLink.ChildObjectId, 0) <> 0
       AND COALESCE (ObjectFloat_PercentSAUA.ValueData,0) > 0;

     -- 1. Вся реализация за месяц по мастеру
     CREATE TEMP TABLE _tmpRemains_SAUA   (UnitId_Master Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- Получили все продажи мастера
     INSERT INTO _tmpRemains_SAUA (UnitId_Master, GoodsId, Amount)
     SELECT AnalysisContainerItem.UnitID                       AS UnitID
          , AnalysisContainerItem.GoodsId                      AS GoodsId
          , SUM(AnalysisContainerItem.AmountCheck)             AS AmountCheck              -- Кассовый чек
     FROM AnalysisContainerItem AS AnalysisContainerItem
     WHERE AnalysisContainerItem.Operdate >= vbStartDate
       AND AnalysisContainerItem.Operdate < vbEndDate
       AND AnalysisContainerItem.AmountCheck > 0
       AND AnalysisContainerItem.UnitID IN (SELECT DISTINCT _tmpUnit_SAUA.UnitId_Master FROM _tmpUnit_SAUA)
     GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsId;

      -- 3. резултат
     CREATE TEMP TABLE _tmpResult_SAUA   (UnitId_Master Integer, UnitId_Slave Integer, GoodsId Integer, Amount TFloat, PercentSAUA TFloat, AmountSAUA TFloat, MCS TFloat, GoodsCategory TFloat) ON COMMIT DROP;

     WITH tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SAUA ON _tmpUnit_SAUA.UnitId_Slave = OL_Price_Unit.ChildObjectId
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                   AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                             AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         -- товары "убит код"
                         AND MCS_isClose.ObjectId IS NULL
                      )
          -- данные из ассорт. матрицы
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!только для таких Аптек!!!
                                   INNER JOIN _tmpUnit_SAUA ON _tmpUnit_SAUA.UnitId_Slave = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- выходим на товар сети
                                   INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                         ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                         ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                        AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                         ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                        AND ObjectLink_Goods_Object.ChildObjectId = 4
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )

     INSERT INTO _tmpResult_SAUA (UnitId_Master, UnitId_Slave, GoodsId, Amount, PercentSAUA, AmountSAUA, MCS, GoodsCategory)
     SELECT _tmpUnit_SAUA.UnitId_Master
          , _tmpUnit_SAUA.UnitId_Slave
          , _tmpRemains_SAUA.GoodsId
          , _tmpRemains_SAUA.Amount
          , _tmpUnit_SAUA.PercentSAUA
          , ROUND(_tmpRemains_SAUA.Amount * _tmpUnit_SAUA.PercentSAUA / 100, 0) ::TFloat
          , tmpPrice.MCSValue
          , tmpGoodsCategory.Value
     FROM _tmpUnit_SAUA

          INNER JOIN _tmpRemains_SAUA ON _tmpRemains_SAUA.UnitId_Master = _tmpUnit_SAUA.UnitId_Master

          LEFT JOIN tmpPrice ON tmpPrice.UnitId = _tmpUnit_SAUA.UnitId_Slave
                            AND tmpPrice.GoodsId = _tmpRemains_SAUA.GoodsId

          LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.UnitId = _tmpUnit_SAUA.UnitId_Slave
                                    AND tmpGoodsCategory.GoodsId = _tmpRemains_SAUA.GoodsId

     WHERE ROUND(_tmpRemains_SAUA.Amount * _tmpUnit_SAUA.PercentSAUA / 1000, 0) >= 1;

     RETURN QUERY
         SELECT
                Result.UnitId_Master
              , Object_Unit_Master.ValueData               AS UnitName_Master
              , Result.UnitId_Slave
              , Object_Unit_Slave.ValueData                AS UnitName_Slave
              , Result.GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData                     AS GoodsName
              , Result.Amount
              , Result.PercentSAUA
              , Result.AmountSAUA
              , Result.MCS
              , Result.GoodsCategory
         FROM _tmpResult_SAUA AS Result

            LEFT JOIN Object AS Object_Unit_Master  ON Object_Unit_Master.Id  = Result.UnitId_Master

            LEFT JOIN Object AS Object_Unit_Slave  ON Object_Unit_Slave.Id  = Result.UnitId_Slave

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Result.GoodsId
         ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.10.20                                                       *
*/

-- тест
--
SELECT * FROM gpReport_SAUA (inSession:= '3');
