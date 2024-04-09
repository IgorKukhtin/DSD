-- Function: gpReport_Supply_Olap()

DROP FUNCTION IF EXISTS gpReport_Supply_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Supply_Olap(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inUnitGroupId         Integer,    -- группа подразделений / подразделение
    IN inGoodsGroupId        Integer,    -- группа товара
    IN inGoodsId             Integer,    -- товар
    IN inisGoodsKind         Boolean,    -- по видам товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( MonthDate TDateTime
              , GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , Name_Scale TVarChar
              , GoodsKindName TVarChar
              , LocationId Integer
              , LocationCode Integer
              , LocationName TVarChar
              , GoodsGroupId Integer
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar, Weight TFloat
              , InfoMoneyGroupName TVarChar
              , InfoMoneyDestinationName TVarChar
              , InfoMoneyId Integer
              , InfoMoneyCode Integer
              , InfoMoneyName TVarChar
              , InfoMoneyName_all TVarChar
              , NormRem                   TFloat -- Норма
              , NormOut                   TFloat
              , RemainsStart             TFloat -- Остатки на начало каждого периода
              , RemainsStart_Weight      TFloat
              , CountIncome              TFloat -- Приходы за периоды
              , CountIncome_Weight       TFloat
              , CountProduction          TFloat
              , CountProduction_Weight   TFloat -- Потребление за периоды
              , CountOther               TFloat
              , CountOther_Weight        TFloat
              , MoneySumm                TFloat -- Оплата за периоды
              , RemainsStart_summ        TFloat
              , SummIncome               TFloat
              , SummProduction           TFloat
              , SummOther                TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    --проверка период не более 3-х месяцев
    IF inEndDate > inStartDate + INTERVAL '3 MONTH'
    THEN
        inEndDate := inStartDate + INTERVAL '3 MONTH';
    END IF;    
    
    
    CREATE TEMP TABLE _tmpLocation (LocationId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
    -- группа подразделений или подразделение
    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpLocation (LocationId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
          ;
    ELSE
        INSERT INTO _tmpLocation (LocationId)
           SELECT Object.Id AS LocationId
           FROM Object
           WHERE Object.DescId = zc_Object_Unit()
             AND Object.isErased = False
           ;
    END IF;

    -- группа товаров или товар или все товары из проводок
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        INSERT INTO tmpGoods (GoodsId)
           SELECT lfSelect.GoodsId 
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
           ;
    ELSE 
        INSERT INTO tmpGoods (GoodsId)
           SELECT Object.Id
           FROM Object
           WHERE Object.DescId = zc_Object_Goods()
             AND Object.isErased = False
             AND (Object.Id = inGoodsId OR inGoodsId = 0) 
           ;
    END IF;

    --сначала выбираем проводки во временную таблицу
    CREATE TEMP TABLE _tmpContainer (ContainerId Integer, DescId Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpContainer (ContainerId, DescId, LocationId, GoodsId, GoodsKindId, Amount)
           SELECT CLO_Unit.ContainerId
                , Container.DescId
                , _tmpLocation.LocationId
                , tmpGoods.GoodsId
                , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                , COALESCE (Container.Amount,0)        AS Amount
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject AS CLO_Unit
                                               ON CLO_Unit.ObjectId = _tmpLocation.LocationId
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                   --AND Container.DescId = zc_Container_Count()

                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = CLO_Unit.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                          AND Container.DescId = zc_Container_Summ()
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN Container.DescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END
                
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                              ON CLO_GoodsKind.ContainerId = Container.Id
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer;

    -- Результат
    RETURN QUERY
          WITH 
          --
          tmpNorm AS (SELECT Object_GoodsByGoodsKind_View.*
                           , COALESCE (ObjectFloat_NormRem.ValueData,0)         ::TFloat  AS NormRem
                           , COALESCE (ObjectFloat_NormOut.ValueData,0)         ::TFloat  AS NormOut
                      FROM Object_GoodsByGoodsKind_View
                           LEFT JOIN ObjectFloat AS ObjectFloat_NormRem
                                                 ON ObjectFloat_NormRem.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                AND ObjectFloat_NormRem.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormRem()
                           LEFT JOIN ObjectFloat AS ObjectFloat_NormOut
                                                 ON ObjectFloat_NormOut.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                AND ObjectFloat_NormOut.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormOut()
                      WHERE COALESCE (ObjectFloat_NormRem.ValueData,0) <> 0
                         OR COALESCE (ObjectFloat_NormOut.ValueData,0) <> 0
                      )
        --
        , tmpListDate AS (SELECT DISTINCT DATE_TRUNC ('Month', generate_series(inStartDate + INTERVAL '1 Month', inEndDate, '1 Month'::interval)) AS OperDate
                    UNION SELECT DATE_TRUNC ('Month', inStartDate) AS OperDate
                         )

        , tmpMIC AS (SELECT *
                     FROM MovementItemContainer
                     WHERE MovementItemContainer.ContainerId IN (SELECT DISTINCT _tmpContainer.ContainerId FROM _tmpContainer)
                       AND MovementItemContainer.OperDate >= inStartDate
                     )

          -- для остатков
        , tmp_Rem AS (SELECT _tmpContainer.ContainerId
                           , _tmpContainer.LocationId
                           , _tmpContainer.GoodsId
                           , _tmpContainer.GoodsKindId
                           , 0 AS MovementId_income

                             -- ***COUNT***
                           , 0 AS CountIncome
                           , 0 AS SummIncome
                           , 0 AS CountProduction
                           , 0 AS SummProduction
                           , 0 AS CountOther
                           , 0 AS SummOther

                             -- ***REMAINS***
                          , CASE WHEN _tmpContainer.DescId = zc_Container_Count() THEN _tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) ELSE 0 END AS RemainsStart
                          , CASE WHEN _tmpContainer.DescId = zc_Container_Summ()  THEN _tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) ELSE 0 END AS RemainsStart_summ

                      FROM _tmpContainer
                           LEFT JOIN tmpMIC AS MIContainer
                                                           ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                          AND MIContainer.OperDate > inEndDate
                      GROUP BY _tmpContainer.ContainerId
                             , _tmpContainer.LocationId
                             , _tmpContainer.GoodsId
                             , _tmpContainer.GoodsKindId
                             , _tmpContainer.Amount
                             , _tmpContainer.DescId

                      HAVING CASE WHEN _tmpContainer.DescId = zc_Container_Count() THEN _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0
                          OR CASE WHEN _tmpContainer.DescId = zc_Container_Summ()  THEN _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END <> 0
                     )

        --
        , _tmpContainer_1 AS (SELECT _tmpContainer.ContainerId
                                  , _tmpContainer.LocationId
                                  , _tmpContainer.GoodsId
                                  , _tmpContainer.GoodsKindId
                                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END AS MovementId_income
                                  --, MIContainer.MovementId AS MovementId_income
                                  
                                  , DATE_TRUNC ('Month', MIContainer.OperDate)  AS MonthDate

                                   -- Приход
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND _tmpContainer.DescId = zc_Container_Count()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND _tmpContainer.DescId = zc_Container_Summ()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS SummIncome
                                 --потребление
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Count()
                                              --AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProduction
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Summ()
                                              --AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS SummProduction
                                 -- прочее
                                 , SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Count()
                                              --AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountOther
                                 , SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Summ()
                                              --AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS SummOther

                                         -- ***REMAINS***
                                 , -1 * SUM (CASE WHEN _tmpContainer.DescId = zc_Container_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart
                                 , -1 * SUM (CASE WHEN _tmpContainer.DescId = zc_Container_Summ()  THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart_summ
                                 
                             FROM _tmpContainer
                                  INNER JOIN tmpMIC AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END
                                    --, MIContainer.MovementId
                                    , DATE_TRUNC ('Month', MIContainer.OperDate)
                                    , _tmpContainer.DescId

                             HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                               AND _tmpContainer.DescId = zc_Container_Count()
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND _tmpContainer.DescId = zc_Container_Summ()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) <> 0
                                  --потребление
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                 AND _tmpContainer.DescId = zc_Container_Count()
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Summ()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) <> 0
                                  -- прочее
                                 OR SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Count()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND _tmpContainer.DescId = zc_Container_Summ()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) <> 0
                                    -- ***REMAINS***
                                 OR SUM (CASE WHEN _tmpContainer.DescId = zc_Container_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                                 OR SUM (CASE WHEN _tmpContainer.DescId = zc_Container_Summ()  THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                           )
        
        , tmpMIContainer AS (SELECT _tmpContainer.ContainerId
                                  , _tmpContainer.LocationId
                                  , _tmpContainer.GoodsId
                                  , _tmpContainer.GoodsKindId
                                  , _tmpContainer.MovementId_income
                                  --, MIContainer.MovementId AS MovementId_income
                                  
                                  , _tmpContainer.MonthDate

                                    -- Приход
                                  , _tmpContainer.CountIncome
                                  , _tmpContainer.SummIncome
                                  --потребление
                                  , _tmpContainer.CountProduction
                                  , _tmpContainer.SummProduction
                                  -- прочее
                                  , _tmpContainer.CountOther
                                  , _tmpContainer.SummOther
                                          -- ***REMAINS***
                                  , _tmpContainer.RemainsStart     /* + COALESCE (SUM (COALESCE (_tmpContainer_next.RemainsStart, 0)), 0) */     AS RemainsStart
                                  , _tmpContainer.RemainsStart_summ /*+ COALESCE (SUM (COALESCE (_tmpContainer_next.RemainsStart_summ, 0)), 0)*/ AS RemainsStart_summ

                             FROM _tmpContainer_1 AS _tmpContainer
                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , _tmpContainer.MovementId_income
                                    , _tmpContainer.MonthDate
                                      -- Приход
                                    , _tmpContainer.CountIncome
                                    , _tmpContainer.SummIncome
                                    --потребление
                                    , _tmpContainer.CountProduction
                                    , _tmpContainer.SummProduction
                                    -- прочее
                                    , _tmpContainer.CountOther
                                    , _tmpContainer.SummOther
                                            -- ***REMAINS***
                                    , _tmpContainer.RemainsStart
                                    , _tmpContainer.RemainsStart_summ
                            UNION ALL
                            --движение после inEndDate нужно снять со всех периодов
                            SELECT tmp_Rem.ContainerId
                                  , tmp_Rem.LocationId
                                  , tmp_Rem.GoodsId
                                  , tmp_Rem.GoodsKindId
                                  , tmp_Rem.MovementId_income
                                  , tmpListDate.Operdate  AS MonthDate

                                    -- ***COUNT***
                                  , tmp_Rem.CountIncome
                                  , tmp_Rem.SummIncome
                                  , tmp_Rem.CountProduction
                                  , tmp_Rem.SummProduction
                                  , tmp_Rem.CountOther
                                  , tmp_Rem.SummOther

                                    -- ***REMAINS***
                                  , tmp_Rem.RemainsStart
                                  , tmp_Rem.RemainsStart_summ

                            FROM tmp_Rem
                                LEFT JOIN tmpListDate ON 1=1
                            -- 2 мес.
                            UNION ALL
                            SELECT _tmpContainer_1.ContainerId
                                  , _tmpContainer_1.LocationId
                                  , _tmpContainer_1.GoodsId
                                  , _tmpContainer_1.GoodsKindId
                                  , _tmpContainer_1.MovementId_income
                                  , _tmpContainer_1.MonthDate - INTERVAL '1 MONTH'

                                    -- ***COUNT***
                                  , 0 AS CountIncome
                                  , 0 AS SummIncome
                                  , 0 AS CountProduction
                                  , 0 AS SummProduction
                                  , 0 AS CountOther
                                  , 0 AS SummOther

                                    -- ***REMAINS***
                                  , _tmpContainer_1.RemainsStart
                                  , _tmpContainer_1.RemainsStart_summ

                            FROM _tmpContainer_1
                            WHERE _tmpContainer_1.MonthDate > inStartDate
                            -- 3 мес.
                            UNION ALL
                            SELECT _tmpContainer_1.ContainerId
                                  , _tmpContainer_1.LocationId
                                  , _tmpContainer_1.GoodsId
                                  , _tmpContainer_1.GoodsKindId
                                  , _tmpContainer_1.MovementId_income
                                  , _tmpContainer_1.MonthDate - INTERVAL '2 MONTH'

                                    -- ***COUNT***
                                  , 0 AS CountIncome
                                  , 0 AS SummIncome
                                  , 0 AS CountProduction
                                  , 0 AS SummProduction
                                  , 0 AS CountOther
                                  , 0 AS SummOther

                                    -- ***REMAINS***
                                  , _tmpContainer_1.RemainsStart
                                  , _tmpContainer_1.RemainsStart_summ

                            FROM _tmpContainer_1
                            WHERE _tmpContainer_1.MonthDate > inStartDate + INTERVAL '1 MONTH'

                            )

        -- оплата идет по уп статье, у приходов товара есть договор а у него zc_ObjectLink_Contract_InfoMoney  --вот самая верхняя группировка - InfoMoney
        , tmpInfoMoney AS (SELECT tmp.InfoMoneyId
                                , tmp.GoodsId
                                , tmp.MovementId_income
                                , tmp.Summ
                                --, MAX (tmp.Summ) OVER () AS Summ_max
                                , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId ORDER BY tmp.Summ DESC) AS ord
                           FROM (SELECT DISTINCT ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                               , tmp.GoodsId
                                               , tmp.MovementId_income
                                               , SUM (tmp.SummIncome) OVER (PARTITION BY ObjectLink_Contract_InfoMoney.ChildObjectId) AS Summ
                                 FROM (SELECT tmpMIContainer.MovementId_income
                                            , tmpMIContainer.GoodsId
                                            , SUM (tmpMIContainer.SummIncome) AS SummIncome
                                       FROM tmpMIContainer
                                       WHERE tmpMIContainer.MovementId_income <> 0
                                       GROUP BY tmpMIContainer.MovementId_income
                                              , tmpMIContainer.GoodsId
                                       ) AS tmp
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                          ON MovementLinkObject_Contract.MovementId = tmp.MovementId_income
                                                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                                  ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                                 AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                 ) AS tmp
                          )

        , View_InfoMoney AS (SELECT * FROM Object_InfoMoney_View)
         -- оплаты по статьям
        , tmpMoney AS (SELECT tmpInfoMoney.InfoMoneyId
                            , DATE_TRUNC ('Month', MIContainer.OperDate)   AS MonthDate
                            , SUM (COALESCE (MIContainer.Amount, 0) )      AS MoneySumm
                       FROM (SELECT DISTINCT tmpInfoMoney.InfoMoneyId FROM tmpInfoMoney) AS tmpInfoMoney
                           INNER JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                          ON CLO_InfoMoney.ObjectId = tmpInfoMoney.InfoMoneyId
                                                         AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = CLO_InfoMoney.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount())
                       GROUP BY tmpInfoMoney.InfoMoneyId
                              , DATE_TRUNC ('Month', MIContainer.OperDate)

                       HAVING SUM (COALESCE (MIContainer.Amount, 0) ) <> 0
                       )

        --объединяем таблицу товаров с оплатами
        , tmpData AS ( SELECT tmpMIContainer.MonthDate
                            , COALESCE (tmpInfoMoney.InfoMoneyId, tmpInfoMoney_Other.InfoMoneyId) AS InfoMoneyId
                            , tmpMIContainer.LocationId
                            , tmpMIContainer.GoodsId
                            , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END AS GoodsKindId
                            --, STRING_AGG (DISTINCT Object_GoodsKind.ValueData, ',') ::TVarChar AS GoodsKindName
                            , CASE WHEN inisGoodsKind = TRUE THEN Object_GoodsKind.ValueData ELSE '' END AS GoodsKindName
                            
                            , SUM (tmpMIContainer.CountIncome)       AS CountIncome
                            , SUM (tmpMIContainer.CountProduction)   AS CountProduction
                            , SUM (tmpMIContainer.CountOther)        AS CountOther
                            , SUM (tmpMIContainer.RemainsStart)      AS RemainsStart

                            , SUM (tmpMIContainer.SummIncome)        AS SummIncome
                            , SUM (tmpMIContainer.SummProduction)    AS SummProduction
                            , SUM (tmpMIContainer.SummOther)         AS SummOther
                            , SUM (tmpMIContainer.RemainsStart_summ) AS RemainsStart_summ
                            , 0 AS MoneySumm
                       FROM tmpMIContainer
                            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer.GoodsKindId
                            LEFT JOIN tmpInfoMoney ON tmpInfoMoney.GoodsId = tmpMIContainer.GoodsId
                                                  AND tmpInfoMoney.MovementId_income = tmpMIContainer.MovementId_income
                            -- второй раз привязывам к остальным товарам статью по макс сумме
                            LEFT JOIN tmpInfoMoney AS tmpInfoMoney_Other
                                                   ON tmpInfoMoney_Other.GoodsId = tmpMIContainer.GoodsId
                                                  AND tmpInfoMoney_Other.ord = 1
                       GROUP BY tmpMIContainer.LocationId
                              , tmpMIContainer.GoodsId
                              , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END
                              , CASE WHEN inisGoodsKind = TRUE THEN Object_GoodsKind.ValueData ELSE '' END
                              --, tmpInfoMoney.InfoMoneyId
                              , COALESCE (tmpInfoMoney.InfoMoneyId, tmpInfoMoney_Other.InfoMoneyId)
                              , tmpMIContainer.MonthDate
                     UNION ALL
                       SELECT tmpMoney.MonthDate
                            , tmpMoney.InfoMoneyId
                            , 0 AS LocationId
                            , 0 AS GoodsId
                            , 0  AS GoodsKindId
                            , '' AS GoodsKindName
                            
                            , 0 AS CountIncome
                            , 0 AS CountProduction
                            , 0 AS CountOther
                            , 0 AS RemainsStart
                            , 0 AS SummIncome
                            , 0 AS SummProduction
                            , 0 AS SummOther
                            , 0 AS RemainsStart_summ
                            , tmpMoney.MoneySumm
                       FROM tmpMoney
                      )
        
         -- Результат
         SELECT tmpData.MonthDate  :: TDateTime
              , Object_Goods.Id                            AS GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData     :: TVarChar     AS GoodsName
              , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
              --, Object_GoodsKind.ValueData :: TVarChar     AS GoodsKindName
              , tmpData.GoodsKindName      ::TVarChar      AS GoodsKindName

              , Object_Location.Id         :: Integer      AS LocationId
              , Object_Location.ObjectCode :: Integer      AS LocationCode
              , Object_Location.ValueData  :: TVarChar     AS LocationName
              , Object_GoodsGroup.Id                       AS GoodsGroupId
              , Object_GoodsGroup.ValueData                AS GoodsGroupName
              , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

              , Object_Measure.ValueData       :: TVarChar AS MeasureName
              , ObjectFloat_Weight.ValueData   :: TFloat   AS Weight
              , Object_InfoMoney_View.InfoMoneyGroupName
              , Object_InfoMoney_View.InfoMoneyDestinationName
              , Object_InfoMoney_View.InfoMoneyId
              , Object_InfoMoney_View.InfoMoneyCode
              , Object_InfoMoney_View.InfoMoneyName
              , Object_InfoMoney_View.InfoMoneyName_all

              , tmpNorm.NormRem            ::TFloat
              , tmpNorm.NormOut            ::TFloat

              , tmpData.RemainsStart      ::TFloat
              , (tmpData.RemainsStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS RemainsStart_Weight

              , tmpData.CountIncome       ::TFloat
              , (tmpData.CountIncome * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountIncome_Weight

              , tmpData.CountProduction   ::TFloat
              , (tmpData.CountProduction * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction_Weight

              , tmpData.CountOther        ::TFloat
              , (tmpData.CountOther * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountOther_Weight
              
              , tmpData.MoneySumm         ::TFloat
              
              , tmpData.RemainsStart_summ ::TFloat
              , tmpData.SummIncome        ::TFloat
              , tmpData.SummProduction    ::TFloat
              , tmpData.SummOther         ::TFloat
              

        
         FROM tmpData
         
              LEFT JOIN View_InfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpData.InfoMoneyId

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
              --LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
              LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpData.LocationId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

              LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                     ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
              LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                     ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

              LEFT JOIN tmpNorm ON tmpNorm.GoodsId = tmpData.GoodsId
                               AND COALESCE (tmpNorm.GoodsKindId, 0) = COALESCE (tmpData.GoodsKindId, 0)
         
              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                   AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
    
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                   ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.21         *
*/

-- тест
--
/*

select * from gpReport_Supply_Olap(
     inStartDate  :='01.02.2021' ::        TDateTime , --
     inEndDate    :='03.02.2021' ::        TDateTime , --
     inUnitGroupId    := 0::     Integer,    -- группа подразделений / подразделение
     inGoodsGroupId   := 1918::     Integer,    -- группа товара
     inGoodsId        := 0::     Integer,    -- товар    2064
     inisGoodsKind    :=TRUE,
     inSession        := '5' ::     TVarChar    -- сессия пользователя
)

*/