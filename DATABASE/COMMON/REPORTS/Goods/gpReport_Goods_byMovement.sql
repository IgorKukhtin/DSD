-- FunctiON: gpReport_Goods_byMovement ()

DROP FUNCTION IF EXISTS gpReport_Goods_byMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_byMovement (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inUnitId              Integer   , --
    IN inUnitGroupId         Integer   ,
    IN inGoodsGroupGPId      Integer   ,
    IN inGoodsGroupId        Integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor  
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE vbCountDays TFloat;
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpGoods (GroupNum Integer, GoodsId Integer, MeasureId Integer, Weight TFloat, GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpData (OperDate TDateTime
                                   , GroupNum Integer, GoodsId Integer, SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat
                                                                      , SaleAmountDay TFloat, SaleAmountPartnerDay TFloat, ReturnAmountDay TFloat, ReturnAmountPartnerDay TFloat
                                                                      , SaleAmountSh TFloat, SaleAmountPartnerSh TFloat, ReturnAmountSh TFloat, ReturnAmountPartnerSh TFloat
                                                                      , SaleAmountDaySh TFloat, SaleAmountPartnerDaySh TFloat, ReturnAmountDaySh TFloat, ReturnAmountPartnerDaySh TFloat
                                                                      , GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer
                                   , ColorRecord_TradeMark Integer, ColorRecord_GoodsTag Integer) ON COMMIT DROP;
        
     END IF;
    
     vbCountDays := (SELECT EXTRACT (DAY  FROM (inEndDate - inStartDate)) +1 )   ::TFloat ;
     
     IF COALESCE (inUnitGroupId,0) <> 0 
     THEN
         INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect
          UNION 
           SELECT inUnitId;
     END IF;


    -- Ограничения по товару
    IF inGoodsGroupGPId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GroupNum, GoodsId, MeasureId, Weight, GoodsPlatformId, TradeMarkId, GoodsTagId)
          WITH tmpGoods AS(
           SELECT 1 AS GroupNum, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupGPId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          UNION
           SELECT 2, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                           )
               SELECT tmpGoods.GroupNum
                    , tmpGoods.GoodsId
                    , tmpGoods.MeasureId
                    , tmpGoods.Weight
                    , ObjectLink_Goods_GoodsPlatform.ChildObjectId AS GoodsPlatformName
                    , ObjectLink_Goods_TradeMark.ChildObjectId     AS TradeMarkId
                    , ObjectLink_Goods_GoodsTag.ChildObjectId      AS GoodsTagId
               FROM tmpGoods
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                         ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId 
                                        AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                         ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                         ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                    ;
    END IF;
    
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;


    WITH -- Документы - что считаем "продажей"
         tmpMovSale AS (SELECT Movement.DescId    AS MovementDescId
                             , Movement.Id        AS MovementId
                             , Movement.OperDate  AS OperDate
                        FROM Movement 
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    AND MovementLinkObject_From.ObjectId = inUnitId                    -- Склад Реализации
                        WHERE Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                        )
        -- Документы - что считаем "возвратом"
      , tmpMovRet AS (SELECT Movement.DescId        AS MovementDescId
                           , Movement.Id            AS MovementId
                           , Movement.OperDate      AS OperDate
                      FROM Movement 
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId   -- ограничили складами возврата
                      WHERE Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                      )

        -- Элементы - что считаем "продажей"
      , tmpMI_Sale AS (SELECT MovementItem.ObjectId AS GoodsId
                            , tmp.OperDate
                            , SUM (COALESCE (MIFloat_AmountChangePercent.ValueData /*MovementItem.Amount*/, 0))  AS Amount
                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner

                            , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountChangePercent.ValueData /*MovementItem.Amount*/, 0) ELSE 0 END)  AS DayAmount
                            , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS DayAmountPartner
                       FROM tmpMovSale AS tmp 
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId 

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                       ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       GROUP BY MovementItem.ObjectId, tmp.OperDate
                       )
        -- Элементы - что считаем "возвратом"
      , tmpMI_Ret AS (SELECT MovementItem.ObjectId AS GoodsId
                           , tmp.OperDate
                           , SUM (COALESCE (CASE WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0))  AS Amount
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner

                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END)  AS DayAmount
                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS DayAmountPartner
                      FROM tmpMovRet AS tmp 
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId 

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      GROUP BY MovementItem.ObjectId, tmp.OperDate
                      )
          -- Элементы - что считаем "возвратом"
        , tmpData  AS (SELECT tmp.GoodsId
                            , tmp.OperDate
                            , SUM (tmp.SaleAmount)           AS SaleAmount
                            , SUM (tmp.SaleAmountPartner)    AS SaleAmountPartner
                            , SUM (tmp.ReturnAmount)         AS ReturnAmount
                            , SUM (tmp.ReturnAmountPartner)  AS ReturnAmountPartner

                            , SUM (tmp.SaleAmountDay)           AS SaleAmountDay
                            , SUM (tmp.SaleAmountPartnerDay)    AS SaleAmountPartnerDay
                            , SUM (tmp.ReturnAmountDay)         AS ReturnAmountDay
                            , SUM (tmp.ReturnAmountPartnerDay)  AS ReturnAmountPartnerDay
                       FROM (SELECT tmp.GoodsId
                                  , tmp.OperDate
                                  , tmp.Amount              AS SaleAmount
                                  , tmp.AmountPartner       AS SaleAmountPartner
                                  , tmp.DayAmount           AS SaleAmountDay
                                  , tmp.DayAmountPartner    AS SaleAmountPartnerDay
                                  , 0 AS ReturnAmount
                                  , 0 AS ReturnAmountPartner
                                  , 0 AS ReturnAmountDay
                                  , 0 AS ReturnAmountPartnerDay
                             FROM tmpMI_Sale AS tmp
                           UNION
                             SELECT tmp.GoodsId
                                  , tmp.OperDate
                                  , 0 AS SaleAmount
                                  , 0 AS SaleAmountPartner
                                  , 0 AS SaleAmountDay
                                  , 0 AS SaleAmountPartnerDay
                                  , tmp.Amount           AS ReturnAmount
                                  , tmp.AmountPartner    AS ReturnAmountPartner
                                  , tmp.DayAmount        AS ReturnAmountDay
                                  , tmp.DayAmountPartner AS ReturnAmountPartnerDay
                             FROM tmpMI_Ret AS tmp
                             ) AS tmp
                       GROUP BY tmp.GoodsId, tmp.OperDate
                      )  
          -- Результат
          INSERT INTO _tmpData (OperDate
                               ,GroupNum, GoodsPlatformId, TradeMarkId, GoodsTagId, GoodsId, SaleAmount,      SaleAmountPartner,      ReturnAmount,      ReturnAmountPartner
                                                                                           , SaleAmountDay,   SaleAmountPartnerDay,   ReturnAmountDay,   ReturnAmountPartnerDay
                                                                                           , SaleAmountSh,    SaleAmountPartnerSh,    ReturnAmountSh,    ReturnAmountPartnerSh
                                                                                           , SaleAmountDaySh, SaleAmountPartnerDaySh, ReturnAmountDaySh, ReturnAmountPartnerDaySh
                                )

                       SELECT tmp.OperDate
                            , _tmpGoods.GroupNum
                            , _tmpGoods.GoodsPlatformId
                            , _tmpGoods.TradeMarkId
                            , _tmpGoods.GoodsTagId
                            , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmp.GoodsId ELSE 0 END AS GoodsId
                            , (SUM (tmp.SaleAmount          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmount
                            , (SUM (tmp.SaleAmountPartner   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountPartner
                            , (SUM (tmp.ReturnAmount        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmount
                            , (SUM (tmp.ReturnAmountPartner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountPartner

                            , (SUM (tmp.SaleAmountDay          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountDay
                            , (SUM (tmp.SaleAmountPartnerDay   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountPartnerDay
                            , (SUM (tmp.ReturnAmountDay        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountDay
                            , (SUM (tmp.ReturnAmountPartnerDay * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountPartnerDay

                            , (SUM (tmp.SaleAmount)             ) AS SaleAmountSh
                            , (SUM (tmp.SaleAmountPartner)      ) AS SaleAmountPartnerSh
                            , (SUM (tmp.ReturnAmount)           ) AS ReturnAmountSh
                            , (SUM (tmp.ReturnAmountPartner)    ) AS ReturnAmountPartnerSh

                            , (SUM (tmp.SaleAmountDay)          ) AS SaleAmountDaySh
                            , (SUM (tmp.SaleAmountPartnerDay)   ) AS SaleAmountPartnerDaySh
                            , (SUM (tmp.ReturnAmountDay)        ) AS ReturnAmountDaySh
                            , (SUM (tmp.ReturnAmountPartnerDay) ) AS ReturnAmountPartnerDaySh

                      FROM tmpData AS tmp
                           LEFT JOIN _tmpGoods  ON _tmpGoods.GoodsId = tmp.GoodsId
                      GROUP BY _tmpGoods.GroupNum
                             , _tmpGoods.GoodsPlatformId
                             , _tmpGoods.TradeMarkId
                             , _tmpGoods.GoodsTagId
                             , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmp.GoodsId ELSE 0 END
                             , tmp.OperDate
                     ;
          

    -- Результат для 1-ой страницы
    OPEN Cursor1 FOR
       WITH tmpData AS (SELECT _tmpData.* FROM _tmpData  WHERE _tmpData.GroupNum = 1)

       SELECT *
            , CAST (ROW_NUMBER() OVER ( ORDER BY tmp.Num, tmp.Num2) AS Integer) AS NumLine
            , FALSE AS BoldRecord
       FROM
         (-- 1.1.
          SELECT '    Итого продано колбасы'        :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 1 AS Num2
          FROM tmpData

        UNION ALL
          -- 1.2.
          SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Black()  :: Integer AS ColorRecord
               , 1 AS Num
               , 2 AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
          GROUP BY Object_GoodsPlatform.ValueData

        UNION ALL
          -- 1.3.
          SELECT 'за сутки Алан'             :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmountDay)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartnerDay)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmountDay)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartnerDay)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmountDay - tmpData.ReturnAmountDay)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartnerDay - tmpData.ReturnAmountPartnerDay) :: TFloat AS AmountPartner

               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 3 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 1.4.
          SELECT 'сред. Кг/сутки Алан'                             :: TVarChar AS GroupName
               , (SUM (tmpData.SaleAmount)          / vbCountDays) :: TFloat   AS SaleAmount
               , (SUM (tmpData.SaleAmountPartner)   / vbCountDays) :: TFloat   AS SaleAmountPartner 
               , (SUM (tmpData.ReturnAmount)        / vbCountDays) :: TFloat   AS ReturnAmount
               , (SUM (tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat   AS ReturnAmountPartner
               , (SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               / vbCountDays) :: TFloat AS Amount
               , (SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 4 AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 2.1.
          SELECT '    В разрезе торговых марок'     :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue() :: Integer AS ColorRecord
               , 2 AS Num
               , 0 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 2.2.
          SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
               , 2 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_TradeMark.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()         
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
          GROUP BY Object_TradeMark.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 3.1.
          SELECT '    В разрезе групп товаров'      :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 3 AS Num
               , 0 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 3.2.
          SELECT Object_GoodsTag.ValueData          :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
               , 3 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsTag.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport() 
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
          GROUP BY Object_GoodsTag.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

          ) AS tmp;

    RETURN NEXT Cursor1;


    -- Результат для 2-ой страницы
    OPEN Cursor2 FOR
       WITH tmpData AS (SELECT _tmpData.* FROM _tmpData  WHERE _tmpData.GroupNum = 2)

       SELECT * 
            , CAST (ROW_NUMBER() OVER (ORDER BY tmp.Num, tmp.Num2) AS Integer) AS NumLine
            , FALSE AS BoldRecord
       FROM
          -- 1.1.
         (SELECT '    Итого продано Чапли'                  :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
               , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
               , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
               , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
               , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
               , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red()  :: Integer AS ColorRecord
               , 1 AS Num
               , 1 AS Num2
          FROM tmpData

      UNION ALL
          -- 1.2.
          SELECT 'за сутки Чапли'             :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountDaySh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerDaySh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountDaySh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerDaySh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountDaySh - tmpData.ReturnAmountDaySh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerDaySh - tmpData.ReturnAmountPartnerDaySh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmountDay)           :: TFloat   AS SaleAmount 
                , SUM (tmpData.SaleAmountPartnerDay)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmountDay)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartnerDay)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmountDay - tmpData.ReturnAmountDay)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartnerDay - tmpData.ReturnAmountPartnerDay) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Red()  :: Integer AS ColorRecord
                , 1 AS Num
                , 2 AS Num2
          FROM tmpData

      UNION ALL
          -- 1.3.
          SELECT 'сред. шт/сутки Чапли'                                 :: TVarChar AS GroupName
                , (SUM (tmpData.SaleAmountSh) / vbCountDays           ) :: TFloat   AS SaleAmountSh
                , (SUM (tmpData.SaleAmountPartnerSh) / vbCountDays    ) :: TFloat   AS SaleAmountPartnerSh
                , (SUM (tmpData.ReturnAmountSh) / vbCountDays         ) :: TFloat   AS ReturnAmountSh
                , (SUM (tmpData.ReturnAmountPartnerSh) / vbCountDays  ) :: TFloat   AS ReturnAmountPartnerSh
                , (SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh) / vbCountDays)                :: TFloat AS AmountSh
                , (SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) / vbCountDays)  :: TFloat AS AmountPartnerSh

                , (SUM (tmpData.SaleAmount) / vbCountDays           ) :: TFloat   AS SaleAmount
                , (SUM (tmpData.SaleAmountPartner) / vbCountDays    ) :: TFloat   AS SaleAmountPartner 
                , (SUM (tmpData.ReturnAmount) / vbCountDays         ) :: TFloat   AS ReturnAmount
                , (SUM (tmpData.ReturnAmountPartner) / vbCountDays  ) :: TFloat   AS ReturnAmountPartner
                , (SUM (tmpData.SaleAmount - tmpData.ReturnAmount) / vbCountDays              ) :: TFloat AS Amount
                , (SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Red()  :: Integer AS ColorRecord
                , 1 AS Num
                , 3 AS Num2
           FROM tmpData

        UNION ALL
          -- 2.1.
          SELECT '    В разрезе торговых марок'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 2 AS Num
               , 0 AS Num2
          FROM tmpData

        UNION ALL
           -- 2.2.
           SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
                , 2 AS Num        
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_TradeMark.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport() 
           GROUP BY Object_TradeMark.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 3.1.
          SELECT '    В разрезе групп товаров'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 3 AS Num
               , 0 AS Num2
           FROM tmpData

        UNION ALL
          -- 3.2.
           SELECT Object_GoodsTag.ValueData           :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
                , 3 AS Num
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsTag.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport() 
           GROUP BY Object_GoodsTag.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 4.1.
          SELECT '    В разрезе товаров'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 4 AS Num
               , 0 AS Num2
           FROM tmpData

        UNION ALL
          -- 4.2.
           SELECT Object_Goods.ValueData              :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Black()  :: Integer AS ColorRecord
                , 4 AS Num
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_Goods.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
           GROUP BY Object_Goods.ValueData

           ) AS tmp
    ;

  RETURN NEXT Cursor2;

    -- Результат для 3-ой страницы
    OPEN Cursor3 FOR
       --WITH tmpData AS (SELECT _tmpData.* FROM _tmpData  WHERE _tmpData.GroupNum = 1)

           SELECT tmpData.OperDate
                , Object_GoodsTag.ValueData           :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner 
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)                :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner)  :: TFloat AS AmountPartner
                , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
                , CAST (ROW_NUMBER() OVER (PARTITION BY tmpData.GroupNum  ORDER BY tmpData.GroupNum, Object_GoodsTag.ValueData, tmpData.OperDate ) AS Integer) AS NumLine
           FROM _tmpData AS tmpData
                LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport() 
           GROUP BY Object_GoodsTag.ValueData
                  , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())
                  , tmpData.OperDate
                  , tmpData.GroupNum
    ;

  RETURN NEXT Cursor3;

       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.16         *
*/

-- тест
-- SELECT * FROM gpReport_Goods_byMovement(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('06.12.2016')::TDateTime , inUnitId := 8459 , inUnitGroupId := 8460 , inGoodsGroupGPId := 1832 , inGoodsGroupId := 1979 ,  inSession := '5');
