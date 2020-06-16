-- Function: lpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_Supplement (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbDOW_curr        TVarChar;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     -- ��� ������ ��� ����� SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_Supplement   (GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������������� ��� ����� SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_Supplement   (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer) ON COMMIT DROP;
     END IF;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_Supplement   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, AmountUse TFloat) ON COMMIT DROP;
     END IF;

     -- 2. ��� �������, ���, � ����. ��������� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_Supplement   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 3. ������������-1 ������� - �� ���� �������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpResult_Supplement   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������ ��� ����� SUN Supplement
     DELETE FROM _tmpGoods_SUN_Supplement;
     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN_Supplement;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all_Supplement;
     -- 2. ��� �������, ���, � ����. ��������� ������
     DELETE FROM _tmpStockRatio_all_Supplement;
     -- 3. ������������-1 ������� - �� ���� �������
     DELETE FROM _tmpResult_Supplement;



     -- ��� ������ ��� ����� SUN Supplement
     INSERT INTO _tmpGoods_SUN_Supplement (GoodsId)
        SELECT Object_Goods_Retail.ID
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                         AND Object_Goods_Main.isSupplementSUN1 = TRUE
        WHERE Object_Goods_Retail.RetailID = vbObjectId;

     -- ��� ������������� ��� ����� SUN
     INSERT INTO _tmpUnit_SUN_Supplement (UnitId, DeySupplSun1, MonthSupplSun1)
        SELECT OB.ObjectId
             , COALESCE (NULLIF(OF_DeySupplSun1.ValueData, 0), 30)::Integer  AS DeySupplSun1
             , COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer AS MonthSupplSun1
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_DeySupplSun1  ON OF_DeySupplSun1.ObjectId  = OB.ObjectId AND OF_DeySupplSun1.DescId     = zc_ObjectFloat_Unit_DeySupplSun1()
             LEFT JOIN ObjectFloat   AS OF_MonthSupplSun1 ON OF_MonthSupplSun1.ObjectId = OB.ObjectId AND OF_MonthSupplSun1.DescId = zc_ObjectFloat_Unit_MonthSupplSun1()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             -- !!!������ ��� ����� ��������!!!
             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Driver
                                   ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                  AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                                  AND ObjectLink_Unit_Driver.ChildObjectId = inDriverId*/
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = ''
          --OR inUserId = 3 -- ����� - �������
              )
       ;


     -- 1. ��� �������, ��� => �������� ���-�� ����������
     --
     WITH tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Container.ObjectId
                              INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = Container.WhereObjectId
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- �������
        , tmpSalesDay AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                               , _tmpGoods_SUN_Supplement.GoodsId
                               , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) AS AmountSalesDay
                          FROM  _tmpGoods_SUN_Supplement
                               INNER JOIN _tmpUnit_SUN_Supplement ON 1 = 1

                               INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                                               AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_Supplement.UnitId
                          WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_Supplement.DeySupplSun1::TVarChar ||' DAY') :: INTERVAL
                            AND AnalysisContainerItem.AmountCheck <> 0
                          GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                      )
        , tmpSalesMonth AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                                 , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) AS AmountSalesMonth
                            FROM  _tmpGoods_SUN_Supplement
                                 INNER JOIN _tmpUnit_SUN_Supplement ON 1 = 1

                                 INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                                                 AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_Supplement.UnitId
                            WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_Supplement.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL
                              AND AnalysisContainerItem.AmountCheck <> 0
                            GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                   , _tmpGoods_SUN_Supplement.GoodsId
                        )
          -- ����
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!������ ��� ����� �����!!!
                            INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = OL_Price_Goods.ChildObjectId
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                             AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                  ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                       --  AND COALESCE(MCS_isClose.ValueData, FALSE) = TRUE
                      )
          -- ������ �� ������. �������
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!������ ��� ����� �����!!!
                                   INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- ������� �� ����� ����
                                   INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                         ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                         ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                        AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                         ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                               --    INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = ObjectLink_Child_retail.ChildObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- ��������� ��� �� �������� �� ������. �������, ���� � ������. ������� �������� ������
        , tmpObject_Price AS (SELECT COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                                   , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                   , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                   , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0.0) <= COALESCE (tmpPrice.MCSValue, 0.0)
                                          THEN COALESCE (tmpPrice.MCSValue, 0.0)
                                          ELSE tmpGoodsCategory.Value
                                     END                                         :: TFloat AS MCSValue
                                   , COALESCE (tmpPrice.MCSValue_min, 0.0)       :: TFloat AS MCSValue_min
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all_Supplement (UnitId, GoodsId, Price, MCS, AmountRemains, AmountSalesDay, AmountSalesMonth)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue

               -- �������
             , COALESCE (tmpRemains.Amount, 0)               AS AmountRemains
               -- ����������
             , COALESCE (tmpSalesDay.AmountSalesDay, 0)      AS AmountSalesDay
             , COALESCE (tmpSalesMonth.AmountSalesMonth, 0)  AS AmountSalesMonth

        FROM tmpPrice AS tmpObject_Price

             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId

             LEFT JOIN tmpSalesDay AS tmpSalesDay
                                   ON tmpSalesDay.UnitId  = tmpObject_Price.UnitId
                                  AND tmpSalesDay.GoodsId = tmpObject_Price.GoodsId

             LEFT JOIN tmpSalesMonth AS tmpSalesMonth
                                     ON tmpSalesMonth.UnitId  = tmpObject_Price.UnitId
                                    AND tmpSalesMonth.GoodsId = tmpObject_Price.GoodsId
       ;

     -- 2. ��� �������, ���, � ����. ��������� ������
     --
     WITH tmpResult AS (SELECT _tmpRemains_all_Supplement.GoodsId                               AS GoodsId
                             , SUM(_tmpRemains_all_Supplement.MCS)                              AS MCS

                               -- �������
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountRemains, 0))      AS AmountRemains
                               -- ����������
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountSalesDay, 0))     AS AmountSalesDay

                        FROM _tmpRemains_all_Supplement
                        GROUP BY _tmpRemains_all_Supplement.GoodsId
                        )
        , tmpUnit AS (SELECT max(_tmpUnit_SUN_Supplement.DeySupplSun1)  AS DeySupplSun1
                      FROM _tmpUnit_SUN_Supplement
                      )

     -- 2. ���������: ��� �������, ��� �������, ���, � ����. ��������� ������
     INSERT INTO  _tmpStockRatio_all_Supplement (GoodsId, MCS, AmountRemains, AmountSalesDay, AverageSales, StockRatio)
        SELECT tmpResult.GoodsId
             , tmpResult.MCS

               -- �������
             , tmpResult.AmountRemains
               -- ����������
             , tmpResult.AmountSalesDay

             , CASE WHEN tmpResult.AmountSalesDay > 0
                    THEN (tmpResult.AmountRemains - tmpResult.MCS)/ tmpResult.AmountSalesDay
                    ELSE 0 END ::TFloat AS  AverageSales
             , CASE WHEN tmpResult.AmountSalesDay > 0
                    THEN (tmpResult.AmountRemains - tmpResult.MCS)/ tmpResult.AmountSalesDay * tmpUnit.DeySupplSun1
                    ELSE 0 END ::TFloat AS  StockRatio

        FROM tmpResult

             LEFT JOIN tmpUnit ON 1 = 1

       ;

     -- 2.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     UPDATE _tmpRemains_all_Supplement SET AverageSalesMonth =(COALESCE (_tmpRemains_all_Supplement.AmountSalesMonth, 0) / extract('DAY' from CURRENT_DATE -
                                                              (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL)))
                                         , Need = CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 THEN - _tmpRemains_all_Supplement.AmountRemains
                                                  ELSE (_tmpRemains_all_Supplement.AmountSalesMonth / extract('DAY' from CURRENT_DATE -
                                                       (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL))) *
                                                       T1.StockRatio END
                                         , AmountUse = 0
     FROM (SELECT _tmpStockRatio_all_Supplement.GoodsId
                , _tmpUnit_SUN_Supplement.UnitId
                , _tmpStockRatio_all_Supplement.StockRatio
                , _tmpUnit_SUN_Supplement.MonthSupplSun1
           FROM _tmpStockRatio_all_Supplement
                LEFT JOIN _tmpUnit_SUN_Supplement ON 1 = 1) AS T1
     WHERE _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
       AND _tmpRemains_all_Supplement.UnitId = T1.UnitId;

     -- 2.2. ���������� ����� ��� �������� ����� ���������� ������ ��� �������
     UPDATE _tmpRemains_all_Supplement SET Need = - floor(_tmpRemains_all_Supplement.AmountRemains)
     WHERE (_tmpRemains_all_Supplement.AmountRemains + _tmpRemains_all_Supplement.Need) < 0;


     -- 3. ������������
     --
     -- ������1 - ��� ��� ����� ������������
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_Supplement.UnitId
             , _tmpRemains_all_Supplement.GoodsId
             , - CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                      THEN - _tmpRemains_all_Supplement.AmountRemains
                      ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                      END AS Need
       FROM _tmpRemains_all_Supplement
       WHERE CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                  THEN - _tmpRemains_all_Supplement.AmountRemains
                  ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                  END < 0
       ORDER BY CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                      THEN - _tmpRemains_all_Supplement.AmountRemains
                      ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                      END
              , _tmpRemains_all_Supplement.UnitId
              , _tmpRemains_all_Supplement.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ����������� ��� vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_Supplement.UnitId
                  , CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                         THEN - _tmpRemains_all_Supplement.AmountRemains
                         ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                         END  - _tmpRemains_all_Supplement.AmountUse
             FROM _tmpRemains_all_Supplement
             WHERE (CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                         THEN - _tmpRemains_all_Supplement.AmountRemains
                         ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                         END - _tmpRemains_all_Supplement.AmountUse) > 0
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId
             ORDER BY (CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                            THEN - _tmpRemains_all_Supplement.AmountRemains
                            ELSE (_tmpRemains_all_Supplement.Need  -_tmpRemains_all_Supplement.AmountRemains)::Integer
                            END - _tmpRemains_all_Supplement.AmountUse) DESC
                    , _tmpRemains_all_Supplement.UnitId
                    , _tmpRemains_all_Supplement.GoodsId;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbSurplus = 0 THEN EXIT; END IF;

             INSERT INTO _tmpResult_Supplement (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END);

             UPDATE _tmpRemains_all_Supplement SET AmountUse = AmountUse + CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END
             WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1



     -- ���������
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_Supplement.Amount               AS Amount

            , _tmpStockRatio_all_Supplement.MCS
            , _tmpStockRatio_all_Supplement.AmountRemains
            , _tmpStockRatio_all_Supplement.AmountSalesDay
            , _tmpStockRatio_all_Supplement.AverageSales
            , _tmpStockRatio_all_Supplement.StockRatio

            , tmpRemains_all_From.MCS                    AS MCS_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From
            , tmpRemains_all_From.AmountSalesDay         AS AmountSalesDay_From
            , tmpRemains_all_From.AmountSalesMonth       AS AmountSalesMonth_From

            , tmpRemains_all_From.AverageSalesMonth      AS AverageSalesMonth_From
            , tmpRemains_all_From.Need                   AS Surplus_From
            , CASE WHEN tmpRemains_all_From.AmountSalesMonth = 0
                   THEN - tmpRemains_all_From.AmountRemains
                   ELSE (tmpRemains_all_From.Need -tmpRemains_all_From.AmountRemains)::Integer
              END::TFloat                                       AS Delta_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , tmpRemains_all_To.AmountSalesDay           AS AmountSalesDay_To
            , tmpRemains_all_To.AmountSalesMonth         AS AmountSalesMonth_To

            , tmpRemains_all_To.AverageSalesMonth        AS AverageSalesMonth_To
            , tmpRemains_all_To.Need                     AS Surplus_To
            , CASE WHEN tmpRemains_all_To.AmountSalesMonth = 0
                   THEN - tmpRemains_all_To.AmountRemains
                   ELSE (tmpRemains_all_To.Need -tmpRemains_all_To.AmountRemains)::Integer
              END::TFloat                                       AS Delta_To

       FROM _tmpResult_Supplement

            INNER JOIN _tmpStockRatio_all_Supplement ON _tmpStockRatio_all_Supplement.GoodsId = _tmpResult_Supplement.GoodsId

            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_Supplement.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_Supplement.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;


/*     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName

            , Object_Unit.Id                        AS UnitId_From
            , Object_Unit.ValueData                 AS UnitName_From

            , _tmpStockRatio_all_Supplement.MCS
            , _tmpStockRatio_all_Supplement.AmountRemains
            , _tmpStockRatio_all_Supplement.AmountSalesDay
            , _tmpStockRatio_all_Supplement.AverageSales
            , _tmpStockRatio_all_Supplement.StockRatio

            , _tmpRemains_all_Supplement.MCS                    AS MCS
            , _tmpRemains_all_Supplement.AmountRemains          AS AmountRemains
            , _tmpRemains_all_Supplement.AmountSalesDay         AS AmountSalesDay
            , _tmpRemains_all_Supplement.AmountSalesMonth       AS AmountSalesMonth

            , _tmpRemains_all_Supplement.AverageSalesMonth      AS AverageSalesMonth
            , _tmpRemains_all_Supplement.Need                   AS Need
            , CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                   THEN - _tmpRemains_all_Supplement.AmountRemains
                   ELSE (_tmpRemains_all_Supplement.Need -_tmpRemains_all_Supplement.AmountRemains)::Integer
              END::TFloat                                       AS Delta

       FROM _tmpRemains_all_Supplement

            LEFT JOIN _tmpStockRatio_all_Supplement ON _tmpStockRatio_all_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_all_Supplement.UnitId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_all_Supplement.GoodsId
       ORDER BY Object_Goods.Id
              , Object_Unit.ValueData
              , Object_Unit.ValueData
       ;
*/
/* if  inUserId = 3 then
    RAISE EXCEPTION '<ok>  % % % % %'
      , (SELECT Count(*)   FROM _tmpGoods_SUN_Supplement)
      , (SELECT Count(*)   FROM _tmpUnit_SUN_Supplement)
      , (SELECT Count(*)   FROM _tmpRemains_all_Supplement)
      , (SELECT Count(*)   FROM _tmpStockRatio_all_Supplement)
      , (SELECT Count(*)   FROM _tmpResult_Supplement)
   ;
 end if;*/


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 10.06.20                                                     *
*/

--
SELECT * FROM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inDriverId:= 0, inUserId:= 3); -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ




