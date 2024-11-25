-- FunctiON: gpReport_Goods_byMovementSaleReturn ()

DROP FUNCTION IF EXISTS gpReport_Goods_byMovementSaleReturn (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_byMovementSaleReturn (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    --IN inUnitId              Integer   , --
    --IN inUnitGroupId         Integer   ,
    IN inGoodsGroupGPId      Integer   ,
    IN inGoodsGroupId        Integer   ,
    IN inWeek                Boolean   , -- график по неделям
    IN inMonth               Boolean   , -- график по месяцам
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE Cursor4 refcursor;
    DECLARE Cursor5 refcursor;
    DECLARE vbCountDays TFloat;

    DECLARE vbIsCost Boolean;

    DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GroupNum Integer, GoodsId Integer, MeasureId Integer, Weight TFloat, GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer, GoodsGroupPropertyId_Parent Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpData (OperDate TDateTime
                                   , GroupNum Integer, GoodsId Integer, SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat
                                                                      , SaleAmountDay TFloat, SaleAmountPartnerDay TFloat, ReturnAmountDay TFloat, ReturnAmountPartnerDay TFloat
                                                                      , SaleAmountSh TFloat, SaleAmountPartnerSh TFloat, ReturnAmountSh TFloat, ReturnAmountPartnerSh TFloat
                                                                      , SaleAmountDaySh TFloat, SaleAmountPartnerDaySh TFloat, ReturnAmountDaySh TFloat, ReturnAmountPartnerDaySh TFloat
                                                                      , OrderAmount TFloat, MoreAmount TFloat, UnderAmount TFloat, DiffAmount TFloat
                                                                      , OrderAmountSh TFloat, MoreAmountSh TFloat, UnderAmountSh TFloat, DiffAmountSh TFloat
                                                                      , GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer, GoodsGroupPropertyId_Parent Integer
                                   , ColorRecord_TradeMark Integer, ColorRecord_GoodsTag Integer) ON COMMIT DROP;

     END IF;

     vbCountDays := (SELECT EXTRACT (DAY  FROM (inEndDate - inStartDate)) +1 )   ::TFloat ;


    -- Ограничения по товару
    IF inGoodsGroupGPId <> 0
    THEN
        INSERT INTO _tmpGoods (GroupNum, GoodsId, MeasureId, Weight, GoodsPlatformId, TradeMarkId, GoodsTagId, GoodsGroupPropertyId_Parent)
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
                    , ObjectLink_GoodsGroupProperty_Parent.ChildObjectId AS GoodsGroupPropertyId_Parent
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

                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                         ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                    --LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
       
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                         ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
                                        AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                   -- LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
                    ;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;

          -- Результат
          INSERT INTO _tmpData (OperDate
                               ,GroupNum, GoodsPlatformId, TradeMarkId, GoodsTagId, GoodsGroupPropertyId_Parent, GoodsId
                               , SaleAmount,      SaleAmountPartner,      ReturnAmount,      ReturnAmountPartner
                               , SaleAmountDay,   SaleAmountPartnerDay,   ReturnAmountDay,   ReturnAmountPartnerDay
                               , SaleAmountSh,    SaleAmountPartnerSh,    ReturnAmountSh,    ReturnAmountPartnerSh
                               , SaleAmountDaySh, SaleAmountPartnerDaySh, ReturnAmountDaySh, ReturnAmountPartnerDaySh
                               --, OrderAmount,     MoreAmount,             UnderAmount,       DiffAmount
                               --, OrderAmountSh,   MoreAmountSh,           UnderAmountSh,     DiffAmountSh
                                )
                    SELECT tmpReport.OperDate
                         , _tmpGoods.GroupNum
                         , CASE WHEN _tmpGoods.GoodsPlatformId > 0 THEN _tmpGoods.GoodsPlatformId WHEN vbUserId = 5 OR 1=1 THEN tmpReport.GoodsId ELSE _tmpGoods.GoodsPlatformId END AS GoodsPlatformId
                         , _tmpGoods.TradeMarkId
                         , _tmpGoods.GoodsTagId
                         , _tmpGoods.GoodsGroupPropertyId_Parent
                         , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmpReport.GoodsId ELSE 0 END AS GoodsId
                         , SUM (tmpReport.Sale_Amount_Weight)          AS SaleAmount
                         , SUM (tmpReport.Sale_AmountPartnerR_Weight)  AS SaleAmountPartner
                         , SUM (tmpReport.Return_Amount_Weight)        AS ReturnAmount
                         , SUM (tmpReport.Return_AmountPartner_Weight) AS ReturnAmountPartner

                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate THEN COALESCE (tmpReport.Sale_Amount_Weight, 0) ELSE 0 END)           AS SaleAmountDay
                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate THEN COALESCE (tmpReport.Sale_AmountPartnerR_Weight, 0) ELSE 0 END)   AS SaleAmountPartnerDay
                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate THEN COALESCE (tmpReport.Return_Amount_Weight, 0) ELSE 0 END)         AS ReturnAmountDay
                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate THEN COALESCE (tmpReport.Return_AmountPartner_Weight, 0) ELSE 0 END)  AS ReturnAmountPartnerDay

                         , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                     THEN tmpReport.Sale_Amount_Sh
                                     -- перевод в шт. для Тушенки
                                     WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                     THEN tmpReport.Sale_Amount_Weight / _tmpGoods.Weight
                                     ELSE 0
                                END
                               ) AS SaleAmountSh

                         , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                     THEN tmpReport.Sale_AmountPartnerR_Sh
                                     -- перевод в шт. для Тушенки
                                     WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                     THEN tmpReport.Sale_AmountPartnerR_Weight / _tmpGoods.Weight
                                     ELSE 0
                                END
                               ) AS SaleAmountPartnerSh

                         , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                     THEN tmpReport.Return_Amount_Sh
                                     -- перевод в шт. для Тушенки
                                     WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                     THEN tmpReport.Return_Amount_Weight / _tmpGoods.Weight
                                     ELSE 0
                                END
                               ) AS ReturnAmountSh

                         , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                     THEN tmpReport.Return_AmountPartner_Sh
                                     -- перевод в шт. для Тушенки
                                     WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                     THEN tmpReport.Return_AmountPartner_Weight / _tmpGoods.Weight
                                     ELSE 0
                                END
                               ) AS ReturnAmountPartnerSh

                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate
                                     THEN CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                               THEN COALESCE (tmpReport.Sale_Amount_Sh, 0)
                                               -- перевод в шт. для Тушенки
                                               WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                               THEN COALESCE (tmpReport.Sale_Amount_Weight, 0) / _tmpGoods.Weight
                                               ELSE 0
                                          END
                                     ELSE 0
                                END) AS DayAmountDaySh

                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate
                                     THEN CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                               THEN COALESCE (tmpReport.Sale_AmountPartnerR_Sh, 0)
                                               -- перевод в шт. для Тушенки
                                               WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                               THEN COALESCE (tmpReport.Sale_AmountPartnerR_Weight, 0) / _tmpGoods.Weight
                                               ELSE 0
                                          END
                                     ELSE 0
                                END) AS DayAmountPartnerDaySh

                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate
                                     THEN CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                               THEN COALESCE (tmpReport.Return_Amount_Sh, 0)
                                               -- перевод в шт. для Тушенки
                                               WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                               THEN COALESCE (tmpReport.Return_Amount_Weight, 0) / _tmpGoods.Weight
                                               ELSE 0
                                          END
                                     ELSE 0
                                END) AS ReturnAmountDaySh

                         , SUM (CASE WHEN tmpReport.OperDate = inEndDate
                                     THEN CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                               THEN COALESCE (tmpReport.Return_AmountPartner_Sh, 0)
                                               -- перевод в шт. для Тушенки
                                               WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                               THEN COALESCE (tmpReport.Return_AmountPartner_Weight, 0) / _tmpGoods.Weight
                                               ELSE 0
                                          END
                                     ELSE 0
                                END) AS ReturnAmountPartnerDaySh

                    FROM gpReport_GoodsMI_SaleReturnIn (inStartDate    := inStartDate
                                                      , inEndDate      := inEndDate
                                                      , inBranchId     := 0
                                                      , inAreaId       := 0
                                                      , inRetailId     := 0
                                                      , inJuridicalId  := 0
                                                      , inPaidKindId   := 0     --zc_Enum_PaidKind_FirstForm()
                                                      , inTradeMarkId  := 0
                                                      , inGoodsGroupId := 0 --inGoodsGroupId
                                                      , inInfoMoneyId  := 0
                                                      , inIsPartner    := FALSE
                                                      , inIsTradeMark  := FALSE
                                                      , inIsGoods      := TRUE                
                                                      , inIsGoodsKind  := TRUE
                                                      , inIsContract   := FALSE
                                                      , inIsOLAP       := TRUE
                                                      , inIsDate       := TRUE
                                                      , inisMonth      := FALSE
                                                      , inSession      := inSession
                                                       ) AS tmpReport
                         INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpReport.GoodsId
                    GROUP BY tmpReport.OperDate
                          , _tmpGoods.GroupNum
                          , CASE WHEN _tmpGoods.GoodsPlatformId > 0 THEN _tmpGoods.GoodsPlatformId WHEN vbUserId = 5 OR 1=1 THEN tmpReport.GoodsId ELSE _tmpGoods.GoodsPlatformId END
                          , _tmpGoods.TradeMarkId
                          , _tmpGoods.GoodsTagId
                          , _tmpGoods.GoodsGroupPropertyId_Parent
                          , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmpReport.GoodsId ELSE 0 END
                    ;


    -- Результат для 1-ой страницы
    OPEN Cursor1 FOR
    -- Результат для 4-ой страницы      /*аналог 1-ой стр*/
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
          SELECT Object_GoodsPlatform.ValueData     :: TVarChar AS GroupName
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
          SELECT 'за сутки'                           :: TVarChar AS GroupName
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

        UNION ALL
          -- 1.4.
          SELECT 'сред. Кг/сутки'                             :: TVarChar AS GroupName
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

        UNION ALL
          -- 3.2.
          SELECT Object_GoodsGroupPropertyParent.ValueData          :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord    
               , 3 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsGroupPropertyParent.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = tmpData.GoodsGroupPropertyId_Parent
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_GoodsGroupPropertyParent.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsGroupProperty_ColorReport()
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'
          GROUP BY Object_GoodsGroupPropertyParent.ValueData
                 , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

          ) AS tmp;

    RETURN NEXT Cursor1;


    -- Результат для 2-ой страницы
    OPEN Cursor2 FOR
    -- Результат для 5-ой страницы     /*аналог 2-ой стр*/
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
           SELECT Object_GoodsGroupPropertyParent.ValueData  :: TVarChar AS GroupName
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
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsGroupPropertyParent.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = tmpData.GoodsGroupPropertyId_Parent 
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_GoodsGroupPropertyParent.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsGroupProperty_ColorReport()
           GROUP BY Object_GoodsGroupPropertyParent.ValueData
                  , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

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


    -- Результат для 3-ой страницы Данные для графика
    OPEN Cursor3 FOR

       WITH tmpData AS (SELECT _tmpData.*
                             , CASE WHEN inMonth = TRUE THEN DATE_TRUNC ('MONTH', _tmpData.OperDate)
                                    WHEN inWeek  = TRUE THEN (_tmpData.OperDate - (((DATE_PART ('DoW', _tmpData.OperDate)::int)-1)|| 'day')::interval)
                                    ELSE _tmpData.OperDate
                               END  :: tdatetime AS StartDate
                             , CASE WHEN inMonth = TRUE THEN (DATE_TRUNC ('MONTH', _tmpData.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                    WHEN inWeek  = TRUE THEN (_tmpData.OperDate + ((7-(DATE_PART ('DoW', _tmpData.OperDate)::int))|| 'day')::interval)
                                    ELSE _tmpData.OperDate
                               END  :: tdatetime AS EndDate
                        FROM _tmpData)
     , tmp_All AS (
                    SELECT tmp.*
                         , CAST (ROW_NUMBER() OVER (PARTITION BY tmp.GroupNum, tmp.StartDate, tmp.EndDate  ORDER BY tmp.StartDate, tmp.EndDate, tmp.GroupNum, tmp.Num, tmp.Num2 , GroupName) AS Integer) AS NumLine

                    FROM
                        (-- 1.1.
                        SELECT '    Итого продано '        :: TVarChar AS GroupName
                             , tmpData.StartDate
                             , tmpData.EndDate
                             , tmpData.GroupNum
                             , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                             , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                             , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                             , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                             , 1 AS Num
                             , 1 AS Num2
                       FROM tmpData
                       GROUP BY tmpData.StartDate
                              , tmpData.EndDate
                              , tmpData.GroupNum
                     UNION ALL
                       -- 1.2.
                       SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
                            , tmpData.StartDate
                            , tmpData.EndDate
                            , tmpData.GroupNum
                            , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                            , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                            , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                            , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                            , 1 AS Num
                            , 2 AS Num2
                       FROM tmpData
                            LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
                       WHERE COALESCE (Object_GoodsPlatform.ValueData,'')<>''
                         AND tmpData.GroupNum = 1
                       GROUP BY Object_GoodsPlatform.ValueData
                            , tmpData.StartDate
                            , tmpData.EndDate
                            , tmpData.GroupNum
                     UNION ALL
                        -- 2.2.--
                        SELECT trim(Object_TradeMark.ObjectCode :: TVarChar )  :: TVarChar AS GroupName
                             , tmpData.StartDate
                             , tmpData.EndDate
                             , tmpData.GroupNum
                             , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                             , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                             , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                             , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                             , 2 AS Num
                             , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ObjectCode)   AS Integer) AS Num2
                        FROM tmpData
                             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
                        WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'
                           OR tmpData.GroupNum = 2             --- тушенка
                        GROUP BY Object_TradeMark.ObjectCode
                               , tmpData.StartDate
                               , tmpData.EndDate
                               , tmpData.GroupNum
                        ) as tmp
                )

         SELECT --tmp.OperDate
                tmp.StartDate
              , tmp.EndDate
              , tmpWeekDay_Start.DayOfWeekName AS DOW_StartDate
              , tmpWeekDay_End.DayOfWeekName   AS DOW_EndDate
              -- итого колбаса
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.SaleAmount ELSE 0 END)    AS SaleAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.ReturnAmount ELSE 0 END)  AS ReturnAmount_11
              -- алан
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 2 THEN tmp.SaleAmount ELSE 0 END)   AS SaleAmount_12
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 2 THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_12
              -- ирна
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 3 THEN tmp.SaleAmount ELSE 0 END)   AS SaleAmount_13
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 3 THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_13
              -- торговые марки колбаса
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '1' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Alan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '1' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Alan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '2' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_SpecCeh
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '2' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_SpecCeh
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '3' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Varto
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '3' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Varto
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '4' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '4' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '5' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Amstor
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '5' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Amstor
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '6' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Fitness
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '6' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Fitness
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '7' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_PovnaChasha
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '7' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_PovnaChasha
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '8' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Premiya
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '8' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Premiya
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '9' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Irna
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '9' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Irna
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '10' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Ashan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '10' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Ashan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '11' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Horeca
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '11' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Horeca
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '12' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Aro
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '12' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Aro
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '13' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Hit
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '13' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Hit
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '14' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Num1
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '14' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Num1

              -- итого тушенка
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.SaleAmountSh ELSE 0 END)   AS SaleAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_21


              -- торговые марки тушенка
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '1' THEN tmp.SaleAmountSh ELSE 0 END) AS SaleAmount_2_Alan
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '1' THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_2_Alan
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '4' THEN tmp.SaleAmountSh ELSE 0 END) AS SaleAmount_2_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '4' THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_2_Nashi

         FROM tmp_All AS tmp
              LEFT JOIN zfCalc_DayOfWeekName(tmp.StartDate) AS tmpWeekDay_Start ON 1=1
              LEFT JOIN zfCalc_DayOfWeekName(tmp.EndDate) AS tmpWeekDay_End ON 1=1
         GROUP BY tmp.StartDate, tmp.EndDate
                , tmpWeekDay_Start.DayOfWeekName
                , tmpWeekDay_End.DayOfWeekName
;

  RETURN NEXT Cursor3;

/*                      */
    -- Результат для 4-ой страницы      /*аналог 1-ой стр*/
    OPEN Cursor4 FOR
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
          SELECT Object_GoodsPlatform.ValueData     :: TVarChar AS GroupName
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
          SELECT 'за сутки'             :: TVarChar AS GroupName
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

        UNION ALL
          -- 1.4.
          SELECT 'сред. Кг/сутки'                             :: TVarChar AS GroupName
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'
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
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'

        UNION ALL
          -- 3.2.
          SELECT Object_GoodsGroupPropertyParent.ValueData          :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord    
               , 3 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsGroupPropertyParent.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = tmpData.GoodsGroupPropertyId_Parent
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_GoodsGroupPropertyParent.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsGroupProperty_ColorReport()
          WHERE tmpData.GoodsPlatformId IN (416935, 416936) ---'%Алан%'
          GROUP BY Object_GoodsGroupPropertyParent.ValueData
                 , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

          ) AS tmp;

    RETURN NEXT Cursor4;


    -- Результат для 5-ой страницы     /*аналог 2-ой стр*/
    OPEN Cursor5 FOR
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
           SELECT Object_GoodsGroupPropertyParent.ValueData  :: TVarChar AS GroupName
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
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsGroupPropertyParent.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = tmpData.GoodsGroupPropertyId_Parent 
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_GoodsGroupPropertyParent.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsGroupProperty_ColorReport()
           GROUP BY Object_GoodsGroupPropertyParent.ValueData
                  , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

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

  RETURN NEXT Cursor5;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpReport_Goods_byMovementReal'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
    || ', ' || zfConvert_DateToString (inEndDate)
    --|| ', ' || inUnitId           :: TVarChar
    --|| ', ' || inUnitGroupId      :: TVarChar
    || ', ' || inGoodsGroupGPId   :: TVarChar
    || ', ' || inGoodsGroupId     :: TVarChar
    || ', ' || inWeek             :: TVarChar
    || ', ' || inMonth            :: TVarChar
    || ', ' || inSession
              ;*/
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.24         *  в GroupName вернуть данные из группы для Zc_Object_GoodsGroupProperty
 31.03.23         * 
 */

-- тест
-- SELECT * FROM gpReport_Goods_byMovementSaleReturnGGP (inStartDate := ('01.12.2023')::TDateTime , inEndDate := ('05.12.2023')::TDateTime , inGoodsGroupGPId := 1832 , inGoodsGroupId := 1979 , inWeek := 'False' ::Boolean, inMonth := 'False'::Boolean ,  inSession := '5' ::TVarChar);
-- select * from gpReport_Goods_byMovementSaleReturn(inStartDate := ('01.01.2024')::TDateTime , inEndDate := ('15.01.2024')::TDateTime , inGoodsGroupGPId := 1832 , inGoodsGroupId := 1979 , inWeek := 'False' , inMonth := 'False' ,  inSession := '9457');
