-- Function: lpInsert_Movement_Send_RemainsSun_UKTZED

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_UKTZED (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_UKTZED(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inUserId              Integer     -- пользователь
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
             , Price_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat

             , AmountUse_To TFloat
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
   DECLARE vbKoeffSUN TFloat;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     -- все Товары для схемы SUN UKTZED
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_UKTZED   (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;
     END IF;

     -- все Подразделения для схемы SUN UKTZED
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_UKTZED (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer, isOutUKTZED_SUN1 Boolean) ON COMMIT DROP;
     END IF;

     -- Товары дисконтных проектов
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_UKTZED  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_UKTZED   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Уже использовано в текущем СУН
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_UKTZED   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_UKTZED   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, AmountUse TFloat) ON COMMIT DROP;
     END IF;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_UKTZED   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 3. распределяем-1 остатки - по всем аптекам
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpResult_UKTZED   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- все Товары для схемы SUN UKTZED
     DELETE FROM _tmpGoods_SUN_UKTZED;
     -- все Подразделения для схемы SUN
     DELETE FROM _tmpUnit_SUN_UKTZED;
     -- Товары дисконтных проектов
     DELETE FROM _tmpGoods_DiscountExternal_UKTZED;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     DELETE FROM _tmpGoods_TP_exception_UKTZED;
     -- Уже использовано в текущем СУН
     DELETE FROM _tmpGoods_Sun_exception_UKTZED;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     DELETE FROM _tmpRemains_all_UKTZED;
     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     DELETE FROM _tmpStockRatio_all_UKTZED;
     -- 3. распределяем-1 остатки - по всем аптекам
     DELETE FROM _tmpResult_UKTZED;

     -- все Подразделения для схемы SUN
     INSERT INTO _tmpUnit_SUN_UKTZED (UnitId, DeySupplSun1, MonthSupplSun1, isOutUKTZED_SUN1 /*isSUN_UKTZED_in, isSUN_UKTZED_out*/)
        SELECT OB.ObjectId
             , COALESCE (NULLIF(OF_DeySupplSun1.ValueData, 0), 30)::Integer              AS DeySupplSun1
             , COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer             AS MonthSupplSun1
             , COALESCE (ObjectBoolean_OutUKTZED_SUN1.ValueData, FALSE)  :: Boolean      AS isOutUKTZED_SUN1
/*             , COALESCE (ObjectBoolean_SUN_UKTZED_in.ValueData, FALSE)  :: Boolean   AS isSUN_UKTZED_in
             , COALESCE (ObjectBoolean_SUN_UKTZED_out.ValueData, FALSE) :: Boolean   AS isSUN_UKTZED_out*/
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_DeySupplSun1  ON OF_DeySupplSun1.ObjectId  = OB.ObjectId AND OF_DeySupplSun1.DescId     = zc_ObjectFloat_Unit_DeySupplSun1()
             LEFT JOIN ObjectFloat   AS OF_MonthSupplSun1 ON OF_MonthSupplSun1.ObjectId = OB.ObjectId AND OF_MonthSupplSun1.DescId = zc_ObjectFloat_Unit_MonthSupplSun1()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
/*             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_UKTZED_in
                                     ON ObjectBoolean_SUN_UKTZED_in.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_UKTZED_in.DescId = zc_ObjectBoolean_Unit_SUN_UKTZED_in()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_UKTZED_out
                                     ON ObjectBoolean_SUN_UKTZED_out.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_UKTZED_out.DescId = zc_ObjectBoolean_Unit_SUN_UKTZED_out() */
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OutUKTZED_SUN1
                                     ON ObjectBoolean_OutUKTZED_SUN1.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_OutUKTZED_SUN1.DescId = zc_ObjectBoolean_Unit_OutUKTZED_SUN1()
             -- !!!только для этого водителя!!!
             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Driver
                                   ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                  AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                                  AND ObjectLink_Unit_Driver.ChildObjectId = inDriverId*/
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
/*          AND (COALESCE (ObjectBoolean_SUN_UKTZED_in.ValueData, FALSE) = TRUE
            OR COALESCE (ObjectBoolean_SUN_UKTZED_out.ValueData, FALSE) = TRUE)*/
       ;


     -- Товары дисконтных проектов
     
      WITH tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId 
                                    , ObjectLink_Unit.ChildObjectId                 AS UnitId
                               FROM Object AS Object_DiscountExternalTools
                                     LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                          ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                     LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                          ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                  AND Object_DiscountExternalTools.isErased = False
                                )
      INSERT INTO _tmpGoods_DiscountExternal_UKTZED 
      SELECT 
             tmpUnitDiscount.UnitId  
           , ObjectLink_BarCode_Goods.ChildObjectId AS GoodsId
                                               
      FROM Object AS Object_BarCode
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                     
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

           LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

      WHERE Object_BarCode.DescId = zc_Object_BarCode()
        AND Object_BarCode.isErased = False
        AND Object_Object.isErased = False
        AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
      GROUP BY ObjectLink_BarCode_Goods.ChildObjectId
             , tmpUnitDiscount.UnitId;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     WITH
         tmpMovement AS (SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                         WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete())
      , tmpGoods AS (SELECT Movement.UnitId
                          , MovementItem.ObjectId       AS GoodsId
                          , SUM(MovementItem.Amount)    AS Amount
                     FROM _tmpUnit_SUN_UKTZED

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_UKTZED.UnitId

                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased  = FALSE
                                         AND MovementItem.Amount < 0
                          INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                            ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                          INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_BlockFormSUN
                                                   ON ObjectBoolean_CommentTR_BlockFormSUN.ObjectId = MILinkObject_CommentTR.ObjectId
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.DescId = zc_ObjectFloat_CommentTR_BlockFormSUN()
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.ValueData = True
                     GROUP BY Movement.UnitId
                            , MovementItem.ObjectId
                     )

     INSERT INTO _tmpGoods_TP_exception_UKTZED   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

     -- Уже использовано в текущем СУН
     WITH
          tmpSUN AS (SELECT MovementLinkObject_From.ObjectId AS UnitId
                          , MovementItem.ObjectId            AS GoodsId
                          , SUM (MovementItem.Amount)        AS Amount
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                    AND MovementBoolean_SUN.ValueData  = TRUE
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND MovementItem.Amount     > 0
                     WHERE Movement.OperDate = inOperDate
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                     GROUP BY MovementLinkObject_From.ObjectId
                            , MovementItem.ObjectId
                    )
     -- Результат-1
     INSERT INTO _tmpGoods_Sun_exception_UKTZED (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;

     -- все Товары для схемы SUN UKTZED
     WITH tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                         FROM Container

                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                            ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                           AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                    
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                      ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                     AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
                              

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND Container.WhereObjectId in (SELECT UnitId FROM _tmpUnit_SUN_UKTZED WHERE isOutUKTZED_SUN1 = TRUE)
                           AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True
                         GROUP BY Container.ObjectId)

     INSERT INTO _tmpGoods_SUN_UKTZED (GoodsId, KoeffSUN)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_SupplementV1
        FROM tmpRemains
             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpRemains.GoodsId;

     -- 1. все остатки
     --
     WITH tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = Container.ObjectId
                              INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = Container.WhereObjectId
                              LEFT JOIN _tmpGoods_TP_exception_UKTZED ON _tmpGoods_TP_exception_UKTZED.GoodsId = Container.ObjectId
                                                              AND _tmpGoods_TP_exception_UKTZED.UnitId = Container.WhereObjectId
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                            ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                           AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                      ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                     AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND COALESCE (_tmpGoods_TP_exception_UKTZED.GoodsId, 0) = 0
                           AND (_tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = False OR _tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- Продажи
        , tmpSalesDay AS (SELECT _tmpUnit_SUN_UKTZED.UnitId
                               , _tmpGoods_SUN_UKTZED.GoodsId
                               , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) AS AmountSalesDay
                          FROM  _tmpGoods_SUN_UKTZED
                               INNER JOIN _tmpUnit_SUN_UKTZED ON 1 = 1

                               INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_UKTZED.GoodsId
                                                               AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_UKTZED.UnitId
                          WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_UKTZED.DeySupplSun1::TVarChar ||' DAY') :: INTERVAL
                            AND AnalysisContainerItem.AmountCheck <> 0
                          GROUP BY _tmpUnit_SUN_UKTZED.UnitId
                                 , _tmpGoods_SUN_UKTZED.GoodsId
                      )
        , tmpSalesMonth AS (SELECT _tmpUnit_SUN_UKTZED.UnitId
                                 , _tmpGoods_SUN_UKTZED.GoodsId
                                 , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) AS AmountSalesMonth
                            FROM  _tmpGoods_SUN_UKTZED
                                 INNER JOIN _tmpUnit_SUN_UKTZED ON 1 = 1

                                 INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_UKTZED.GoodsId
                                                                 AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_UKTZED.UnitId
                            WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_UKTZED.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL
                              AND AnalysisContainerItem.AmountCheck <> 0
                            GROUP BY _tmpUnit_SUN_UKTZED.UnitId
                                   , _tmpGoods_SUN_UKTZED.GoodsId
                        )
          -- цены
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = OL_Price_Goods.ChildObjectId
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            -- AND Object_Goods.isErased = FALSE
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
          -- данные из ассорт. матрицы
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!только для таких Аптек!!!
                                   INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
                                                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                               --    INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = ObjectLink_Child_retail.ChildObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- подменяем НТЗ на значение из ассорт. матрицы, если в ассотр. матрице значение больше
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
     -- 1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all_UKTZED (UnitId, GoodsId, Price, MCS, AmountRemains, AmountSalesDay, AmountSalesMonth)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue

               -- остаток
             , CASE WHEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_UKTZED.Amount, 0), 0) > 0
                    THEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_UKTZED.Amount, 0), 0) ELSE 0 END AS AmountRemains
               -- реализация
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

             LEFT JOIN _tmpGoods_Sun_exception_UKTZED ON _tmpGoods_Sun_exception_UKTZED.UnitId  = tmpObject_Price.UnitId
                                              AND _tmpGoods_Sun_exception_UKTZED.GoodsId = tmpObject_Price.GoodsId

       ;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     --
     WITH tmpResult AS (SELECT _tmpRemains_all_UKTZED.GoodsId                               AS GoodsId
                             , SUM(_tmpRemains_all_UKTZED.MCS)                              AS MCS

                               -- остаток
                             , SUM(COALESCE (_tmpRemains_all_UKTZED.AmountRemains, 0))      AS AmountRemains
                               -- реализация
                             , SUM(COALESCE (_tmpRemains_all_UKTZED.AmountSalesDay, 0))     AS AmountSalesDay

                        FROM _tmpRemains_all_UKTZED
                        GROUP BY _tmpRemains_all_UKTZED.GoodsId
                        )
        , tmpUnit AS (SELECT max(_tmpUnit_SUN_UKTZED.DeySupplSun1)  AS DeySupplSun1
                      FROM _tmpUnit_SUN_UKTZED
                      )

     -- 2. Результат: все остатки, все остатки, НТЗ, и коэф. товарного запаса
     INSERT INTO  _tmpStockRatio_all_UKTZED (GoodsId, MCS, AmountRemains, AmountSalesDay, AverageSales, StockRatio)
        SELECT tmpResult.GoodsId
             , tmpResult.MCS

               -- остаток
             , tmpResult.AmountRemains
               -- реализация
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

     -- 2.1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     UPDATE _tmpRemains_all_UKTZED SET AverageSalesMonth =(COALESCE (_tmpRemains_all_UKTZED.AmountSalesMonth, 0) / extract('DAY' from CURRENT_DATE -
                                                              (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL)))
                                         , Need = CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0 THEN - _tmpRemains_all_UKTZED.AmountRemains
                                                  ELSE (_tmpRemains_all_UKTZED.AmountSalesMonth / extract('DAY' from CURRENT_DATE -
                                                       (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL))) *
                                                       T1.StockRatio END
                                         , AmountUse = 0
     FROM (SELECT _tmpStockRatio_all_UKTZED.GoodsId
                , _tmpUnit_SUN_UKTZED.UnitId
                , _tmpStockRatio_all_UKTZED.StockRatio
                , _tmpUnit_SUN_UKTZED.MonthSupplSun1
           FROM _tmpStockRatio_all_UKTZED
                LEFT JOIN _tmpUnit_SUN_UKTZED ON 1 = 1) AS T1
     WHERE _tmpRemains_all_UKTZED.GoodsId = T1.GoodsId
       AND _tmpRemains_all_UKTZED.UnitId = T1.UnitId;

     -- 2.2. Подправили места где передача после округление больше чем остаток
     UPDATE _tmpRemains_all_UKTZED SET Need = - floor(_tmpRemains_all_UKTZED.AmountRemains)
     WHERE (_tmpRemains_all_UKTZED.AmountRemains + _tmpRemains_all_UKTZED.Need) < 0;


     -- 3. распределяем
     --
     -- курсор1 - все что можно распределить
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_UKTZED.UnitId
             , _tmpRemains_all_UKTZED.GoodsId
             , _tmpRemains_all_UKTZED.AmountRemains AS Need
             , COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)
       FROM _tmpRemains_all_UKTZED

            LEFT JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsID = _tmpRemains_all_UKTZED.GoodsId

            LEFT JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = _tmpRemains_all_UKTZED.UnitId

       WHERE _tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = True
       ORDER BY _tmpRemains_all_UKTZED.UnitId
              , _tmpRemains_all_UKTZED.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - Потребность для vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_UKTZED.UnitId
                  , CASE WHEN COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0) <= 1 THEN
                    CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0
                         THEN - _tmpRemains_all_UKTZED.AmountRemains
                         ELSE (_tmpRemains_all_UKTZED.Need - _tmpRemains_all_UKTZED.AmountRemains)::Integer
                         END  - _tmpRemains_all_UKTZED.AmountUse
                    ELSE
                    FLOOR ((CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0
                                 THEN - _tmpRemains_all_UKTZED.AmountRemains
                                 ELSE (_tmpRemains_all_UKTZED.Need - _tmpRemains_all_UKTZED.AmountRemains)::Integer
                                 END  - _tmpRemains_all_UKTZED.AmountUse) / COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)

                    END
             FROM _tmpRemains_all_UKTZED

                  LEFT JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsID = _tmpRemains_all_UKTZED.GoodsId

                  LEFT JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = _tmpRemains_all_UKTZED.UnitId

                  -- найдем дисконтній товар
                  LEFT JOIN _tmpGoods_DiscountExternal_UKTZED AS _tmpGoods_DiscountExternal
                                                              ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_UKTZED.UnitId
                                                             AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_UKTZED.GoodsId

             WHERE (CASE WHEN COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0) <= 1 THEN
                    CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0
                         THEN - _tmpRemains_all_UKTZED.AmountRemains
                         ELSE (_tmpRemains_all_UKTZED.Need - _tmpRemains_all_UKTZED.AmountRemains)::Integer
                         END  - _tmpRemains_all_UKTZED.AmountUse
                    ELSE
                    FLOOR ((CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0
                                 THEN - _tmpRemains_all_UKTZED.AmountRemains
                                 ELSE (_tmpRemains_all_UKTZED.Need - _tmpRemains_all_UKTZED.AmountRemains)::Integer
                                 END  - _tmpRemains_all_UKTZED.AmountUse) / COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)

                    END) > 0
               AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId
               AND _tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = False
               AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
             ORDER BY (CASE WHEN _tmpRemains_all_UKTZED.AmountSalesMonth = 0
                            THEN - _tmpRemains_all_UKTZED.AmountRemains
                            ELSE (_tmpRemains_all_UKTZED.Need  -_tmpRemains_all_UKTZED.AmountRemains)::Integer
                            END - _tmpRemains_all_UKTZED.AmountUse) DESC
                    , _tmpRemains_all_UKTZED.UnitId
                    , _tmpRemains_all_UKTZED.GoodsId;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbSurplus = 0 THEN EXIT; END IF;

--             IF vbUnitId_to = 8393158 AND vbGoodsId = 21310
--             THEN
--               raise notice 'Value 05: % % % % % % %', vbUnitId_from, vbUnitId_to, vbGoodsId, vbKoeffSUN, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;
--             END IF;

             IF COALESCE(vbKoeffSUN, 0) <= 1 OR vbSurplus >= vbNeed
             THEN
               INSERT INTO _tmpResult_UKTZED (UnitId_from, UnitId_to, GoodsId, Amount)
                 VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END);

               UPDATE _tmpRemains_all_UKTZED SET AmountUse = AmountUse + CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END
               WHERE _tmpRemains_all_UKTZED.UnitId = vbUnitId_to
                 AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId;

               vbSurplus := vbSurplus - CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;
             ELSEIF vbKoeffSUN > 1 AND (FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN) > 0
             THEN
               INSERT INTO _tmpResult_UKTZED (UnitId_from, UnitId_to, GoodsId, Amount)
                 VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN);

               UPDATE _tmpRemains_all_UKTZED SET AmountUse = AmountUse + FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN
               WHERE _tmpRemains_all_UKTZED.UnitId = vbUnitId_to
                 AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId;

               vbSurplus := vbSurplus - FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN;             
             END IF;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult_next; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion_next; -- закрыли курсор1



     -- Результат
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_UKTZED.Amount               AS Amount

            , _tmpStockRatio_all_UKTZED.MCS
            , _tmpStockRatio_all_UKTZED.AmountRemains
            , _tmpStockRatio_all_UKTZED.AmountSalesDay
            , _tmpStockRatio_all_UKTZED.AverageSales
            , _tmpStockRatio_all_UKTZED.StockRatio

            , tmpRemains_all_From.MCS                    AS MCS_From
            , tmpRemains_all_From.Price                  AS Price_From
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
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , tmpRemains_all_To.AmountSalesDay           AS AmountSalesDay_To
            , tmpRemains_all_To.AmountSalesMonth         AS AmountSalesMonth_To

            , tmpRemains_all_To.AverageSalesMonth        AS AverageSalesMonth_To
            , tmpRemains_all_To.Need                     AS Surplus_To
            , CASE WHEN tmpRemains_all_To.AmountSalesMonth = 0
                   THEN - tmpRemains_all_To.AmountRemains
                   ELSE (tmpRemains_all_To.Need -tmpRemains_all_To.AmountRemains)::Integer
              END::TFloat                                       AS Delta_To
            , tmpRemains_all_To.AmountUse                       AS AmountUse_To

       FROM _tmpResult_UKTZED

            INNER JOIN _tmpStockRatio_all_UKTZED ON _tmpStockRatio_all_UKTZED.GoodsId = _tmpResult_UKTZED.GoodsId

            LEFT JOIN _tmpRemains_all_UKTZED AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_UKTZED.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_UKTZED.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_UKTZED AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_UKTZED.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_UKTZED.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 30.01.21                                                     *
*/

--SELECT * FROM lpInsert_Movement_Send_RemainsSun_UKTZED (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inDriverId:= 0, inUserId:= 3); -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ

-- select * from gpReport_Movement_Send_RemainsSun_UKTZED(inOperDate := ('28.12.2020')::TDateTime ,  inSession := '3');

-- select * from gpReport_Movement_Send_RemainsSun_UKTZED(inOperDate := ('08.02.2021')::TDateTime ,  inSession := '3');