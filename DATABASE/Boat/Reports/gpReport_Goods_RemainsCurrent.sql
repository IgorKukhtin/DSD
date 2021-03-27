-- Function: gpReport_Supply()

DROP FUNCTION IF EXISTS gpReport_Supply (TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Supply(
    IN inStartDate1          TDateTime , --
    IN inEndDate1            TDateTime , --
    IN inStartDate2          TDateTime , --
    IN inEndDate2            TDateTime , --
    IN inStartDate3          TDateTime , --
    IN inEndDate3            TDateTime , --
    IN inUnitGroupId         Integer,    -- группа подразделений / подразделение
    IN inGoodsGroupId        Integer,    -- группа товара
    IN inGoodsId             Integer,    -- товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , GoodsKindId Integer
              , GoodsKindName TVarChar
              , LocationId Integer
              , LocationCode Integer
              , LocationName TVarChar
              , GoodsGroupId Integer
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , InfoMoneyGroupName TVarChar
              , InfoMoneyDestinationName TVarChar
              , InfoMoneyId Integer
              , InfoMoneyCode Integer
              , InfoMoneyName TVarChar
              , InfoMoneyName_all TVarChar
              , NormRem            TFloat -- Норма
              , NormOut            TFloat
              , RemainsStart1      TFloat -- Остатки на начало каждого периода
              , RemainsStart2      TFloat
              , RemainsStart3      TFloat
              , CountIncome1       TFloat -- Приходы за периоды
              , CountIncome2       TFloat
              , CountIncome3       TFloat
              , CountProductionIn1 TFloat -- Потребление за периоды
              , CountProductionIn2 TFloat
              , CountProductionIn3 TFloat
              , MoneySumm1         TFloat -- Оплата за периоды
              , MoneySumm2         TFloat
              , MoneySumm3         TFloat
              
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
                                  
                                   -- Приход
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome1
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome2
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                              AND MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome3
                                 --потребление
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1
                                              AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProductionIn1
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                              AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProductionIn2
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3
                                              AND MIContainer.isActive = TRUE
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProductionIn3
                                 ---
                                 /*, SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                              -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                              AND MIContainer.isActive = FALSE
                                                  THEN -1 * MIContainer.Amount
                                             ELSE 0
                                        END) AS CountProductionOut*/

                                
                                         -- ***REMAINS***
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate1 THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart1
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate2 THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart2
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate3 THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart3

                             FROM _tmpContainer
                                  INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                                 AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate3
                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END
                             HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                               AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                               AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                               AND MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                  --потребление
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1
                                                AND MIContainer.isActive = TRUE
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                                AND MIContainer.isActive = TRUE
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                AND MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3
                                                AND MIContainer.isActive = TRUE
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

                                    -- ***COUNT***
                                  , 0 AS CountIncome1
                                  , 0 AS CountIncome2
                                  , 0 AS CountIncome3
                                  , 0 AS CountProductionIn1
                                  , 0 AS CountProductionIn2
                                  , 0 AS CountProductionIn3

                                    -- ***REMAINS***
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart1
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart2
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart3
                             FROM _tmpContainer
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                 AND MIContainer.OperDate > inEndDate3

                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , _tmpContainer.Amount
                             HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            )
        -- оплата идет по уп статье, у приходов товара есть договор а у него zc_ObjectLink_Contract_InfoMoney  --вот самая верхняя группировка - InfoMoney
        , tmpInfoMoney AS (SELECT DISTINCT ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
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
                            --, CLO_Unit.ObjectId AS LocationId
                            , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS MoneySumm1
                            , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS MoneySumm2
                            , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS MoneySumm3
                       FROM tmpInfoMoney
                           INNER JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                          ON CLO_InfoMoney.ObjectId = tmpInfoMoney.InfoMoneyId
                                                         AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           /*INNER JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = CLO_InfoMoney.ContainerId
                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                           INNER JOIN _tmpLocation ON _tmpLocation.LocationId = CLO_Unit.ObjectId
                           */

                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = CLO_InfoMoney.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate3
                                                           AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount())
                       GROUP BY tmpInfoMoney.InfoMoneyId
                              --, CLO_Unit.ObjectId
                       HAVING SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) <> 0
                           OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) <> 0
                           OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate3 AND inEndDate3 
                                        THEN MIContainer.Amount
                                        ELSE 0
                                   END) <> 0
                       
                       )

        --объединяем таблицу товаров с оплатами
        , tmpData AS ( SELECT 0 AS InfoMoneyId
                            , tmpMIContainer.LocationId
                            , tmpMIContainer.GoodsId
                            , tmpMIContainer.GoodsKindId
                            
                            , SUM (tmpMIContainer.CountIncome1)       AS CountIncome1
                            , SUM (tmpMIContainer.CountIncome2)       AS CountIncome2
                            , SUM (tmpMIContainer.CountIncome3)       AS CountIncome3
                            , SUM (tmpMIContainer.CountProductionIn1) AS CountProductionIn1
                            , SUM (tmpMIContainer.CountProductionIn2) AS CountProductionIn2
                            , SUM (tmpMIContainer.CountProductionIn3) AS CountProductionIn3

                            , SUM (tmpMIContainer.RemainsStart1) AS RemainsStart1
                            , SUM (tmpMIContainer.RemainsStart2) AS RemainsStart2
                            , SUM (tmpMIContainer.RemainsStart3) AS RemainsStart3
                            
                            , 0 AS MoneySumm1
                            , 0 AS MoneySumm2
                            , 0 AS MoneySumm3
                       FROM tmpMIContainer
                       GROUP BY tmpMIContainer.LocationId
                            , tmpMIContainer.GoodsId
                            , tmpMIContainer.GoodsKindId
                     UNION ALL
                       SELECT tmpMoney.InfoMoneyId
                            , 0 AS LocationId
                            , 0 AS GoodsId
                            , 0 AS GoodsKindId
                            
                            , 0 AS CountIncome1
                            , 0 AS CountIncome2
                            , 0 AS CountIncome3
                            , 0 AS CountProductionIn1
                            , 0 AS CountProductionIn2
                            , 0 AS CountProductionIn3

                            , 0 AS RemainsStart1
                            , 0 AS RemainsStart2
                            , 0 AS RemainsStart3
                            
                            , tmpMoney.MoneySumm1
                            , tmpMoney.MoneySumm2
                            , tmpMoney.MoneySumm3
                       FROM tmpMoney
                      )
        
         -- Результат
         SELECT Object_Goods.Id                            AS GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData     :: TVarChar     AS GoodsName
              , Object_GoodsKind.Id        :: Integer      AS GoodsKindId
              , Object_GoodsKind.ValueData :: TVarChar     AS GoodsKindName

              , Object_Location.Id         :: Integer      AS LocationId
              , Object_Location.ObjectCode :: Integer      AS LocationCode
              , Object_Location.ValueData  :: TVarChar     AS LocationName
              , Object_GoodsGroup.Id                       AS GoodsGroupId
              , Object_GoodsGroup.ValueData                AS GoodsGroupName
              , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

              , Object_InfoMoney_View.InfoMoneyGroupName
              , Object_InfoMoney_View.InfoMoneyDestinationName
              , Object_InfoMoney_View.InfoMoneyId
              , Object_InfoMoney_View.InfoMoneyCode
              , Object_InfoMoney_View.InfoMoneyName
              , Object_InfoMoney_View.InfoMoneyName_all

              , tmpNorm.NormRem            ::TFloat
              , tmpNorm.NormOut            ::TFloat

              , tmpData.RemainsStart1      ::TFloat
              , tmpData.RemainsStart2      ::TFloat
              , tmpData.RemainsStart3      ::TFloat
              , tmpData.CountIncome1       ::TFloat
              , tmpData.CountIncome2       ::TFloat
              , tmpData.CountIncome3       ::TFloat
              , tmpData.CountProductionIn1 ::TFloat
              , tmpData.CountProductionIn2 ::TFloat
              , tmpData.CountProductionIn3 ::TFloat
              , tmpData.MoneySumm1         ::TFloat
              , tmpData.MoneySumm2         ::TFloat
              , tmpData.MoneySumm3         ::TFloat
        
         FROM tmpData
         
              LEFT JOIN View_InfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpData.InfoMoneyId

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
              LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
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
select * from gpReport_Supply(
     inStartDate1  :='01.02.2021' ::        TDateTime , --
     inEndDate1    :='02.02.2021' ::        TDateTime , --
     inStartDate2  :='01.02.2021' ::        TDateTime , --
     inEndDate2    :='02.02.2021' ::        TDateTime , --
     inStartDate3  :='01.03.2021' ::        TDateTime , --
     inEndDate3    :='02.03.2021' ::        TDateTime , --
     inUnitGroupId    := 0::     Integer,    -- группа подразделений / подразделение
     inGoodsGroupId   := 1918::     Integer,    -- группа товара
     inGoodsId        := 2064::     Integer,    -- товар
     inSession        := '5' ::     TVarChar    -- сессия пользователя
)
*/