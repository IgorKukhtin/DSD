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
              , MoneySumm                TFloat -- Оплата за периоды
              
              )
AS
$BODY$
BEGIN

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
    CREATE TEMP TABLE _tmpContainer (ContainerId Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpContainer (ContainerId, LocationId, GoodsId, GoodsKindId, Amount)
           SELECT CLO_Unit.ContainerId
                , _tmpLocation.LocationId
                , tmpGoods.GoodsId
                , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                , COALESCE (Container.Amount,0)        AS Amount
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject AS CLO_Unit
                                               ON CLO_Unit.ObjectId = _tmpLocation.LocationId
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                   AND Container.DescId = zc_Container_Count()

                INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                
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
        , tmpMIContainer AS (SELECT _tmpContainer.ContainerId
                                  , _tmpContainer.LocationId
                                  , _tmpContainer.GoodsId
                                  , _tmpContainer.GoodsKindId
                                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END AS MovementId_income
                                  
                                  , DATE_TRUNC ('Month', MIContainer.OperDate)  AS MonthDate
                                  
                                   -- Приход
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome
                                 --потребление
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                              --AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProduction
                                
                                         -- ***REMAINS***
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart

                             FROM _tmpContainer
                                  INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                                 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END
                                    , DATE_TRUNC ('Month', MIContainer.OperDate)

                             HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                  --потребление
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                --AND MIContainer.isActive = TRUE
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0                                       
                                    -- ***REMAINS***
                                 OR SUM (MIContainer.Amount) <> 0

                            UNION ALL
                             --для расчета остатков
                             SELECT _tmpContainer.ContainerId
                                  , _tmpContainer.LocationId
                                  , _tmpContainer.GoodsId
                                  , _tmpContainer.GoodsKindId
                                  , 0 AS MovementId_income
                                  , DATE_TRUNC ('Month', inStartDate)  AS MonthDate

                                    -- ***COUNT***
                                  , 0 AS CountIncome
                                  , 0 AS CountProduction

                                    -- ***REMAINS***
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart

                             FROM _tmpContainer
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                 AND MIContainer.OperDate > inEndDate

                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , _tmpContainer.Amount
                                    , DATE_TRUNC ('Month', inStartDate)
                             HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            )

        -- оплата идет по уп статье, у приходов товара есть договор а у него zc_ObjectLink_Contract_InfoMoney  --вот самая верхняя группировка - InfoMoney
        , tmpInfoMoney AS (SELECT DISTINCT ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                         , tmp.MovementId_income
                           FROM (SELECT DISTINCT tmpMIContainer.MovementId_income FROM tmpMIContainer) AS tmp
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = tmp.MovementId_income
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                      ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                     AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
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
                            , tmpInfoMoney.InfoMoneyId
                            , tmpMIContainer.LocationId
                            , tmpMIContainer.GoodsId
                            , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END AS GoodsKindId
                            --, STRING_AGG (DISTINCT Object_GoodsKind.ValueData, ',') ::TVarChar AS GoodsKindName
                            , CASE WHEN inisGoodsKind = TRUE THEN Object_GoodsKind.ValueData ELSE '' END AS GoodsKindName
                            
                            , SUM (tmpMIContainer.CountIncome)     AS CountIncome
                            , SUM (tmpMIContainer.CountProduction) AS CountProduction
                            , SUM (tmpMIContainer.RemainsStart)    AS RemainsStart
                            , 0 AS MoneySumm
                       FROM tmpMIContainer
                            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer.GoodsKindId
                            LEFT JOIN tmpInfoMoney ON tmpInfoMoney.MovementId_income = tmpMIContainer.MovementId_income
                       GROUP BY tmpMIContainer.LocationId
                              , tmpMIContainer.GoodsId
                              , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END
                              , CASE WHEN inisGoodsKind = TRUE THEN Object_GoodsKind.ValueData ELSE '' END
                              , tmpInfoMoney.InfoMoneyId
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
                            , 0 AS RemainsStart
                            , tmpMoney.MoneySumm
                       FROM tmpMoney
                      )
        
         -- Результат
         SELECT tmpData.MonthDate  :: TDateTime
              , Object_Goods.Id                            AS GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData     :: TVarChar     AS GoodsName
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

              , tmpData.MoneySumm         ::TFloat
        
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