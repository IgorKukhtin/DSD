-- Function: gpReport_Supply_Remains()

DROP FUNCTION IF EXISTS gpReport_Supply_Remains (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Supply_Remains(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inUnitGroupId         Integer,    -- группа подразделений / подразделение
    IN inGoodsGroupId        Integer,    -- группа товара
    IN inGoodsId             Integer,    -- товар
    IN inisGoodsKind         Boolean,    -- по видам товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , GoodsKindName TVarChar
              , GoodsGroupId Integer
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar, Weight TFloat
              , RemainsStart             TFloat -- Остатки на начало
              , RemainsStart_Weight      TFloat -- Остатки на начало
              , RemainsEnd               TFloat -- Остатки на конец
              , RemainsEnd_Weight        TFloat -- Остатки на конец
              , CountIncome              TFloat -- Приходы
              , CountIncome_Weight       TFloat -- Приходы
              , CountProduction          TFloat -- Потребление
              , CountProduction_Weight   TFloat -- Потребление
              , CountOther               TFloat
              , CountOther_Weight        TFloat
              
              , CountProduction1          TFloat -- Потребление -ЦЕХ деликатесов
              , CountProduction1_Weight   TFloat -- Потребление -
              , CountProduction2          TFloat -- Потребление -ЦЕХ колбасный
              , CountProduction2_Weight   TFloat -- Потребление - 
              , CountProduction3          TFloat -- Потребление -ЦЕХ копчения
              , CountProduction3_Weight   TFloat -- Потребление -
              , CountProduction4          TFloat -- Потребление -ЦЕХ с/к
              , CountProduction4_Weight   TFloat -- Потребление -
              , CountProduction5          TFloat -- Потребление -ЦЕХ упаковки
              , CountProduction5_Weight   TFloat -- Потребление -
              , CountProduction6          TFloat -- Потребление -ЦЕХ упаковки МЯСО
              , CountProduction6_Weight   TFloat -- Потребление -
              , CountProduction7          TFloat -- Потребление -Склад Реализация + Склад База
              , CountProduction7_Weight   TFloat -- Потребление -
              , CountProduction8          TFloat -- Потребление -другие склады
              , CountProduction8_Weight   TFloat -- Потребление -
              
              , CountProduction_avg        TFloat -- среднесуточный расход
              , CountProduction_Weight_avg TFloat -- среднесуточный расход
              , CountDays             TFloat -- Запас дней
 
              )
AS
$BODY$
  DECLARE vbCountDays Integer;
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

    -- колво дней в выбранном периоде 
    vbCountDays := (SELECT DATE_PART('Day', inEndDate - inStartDate) + 1);
    -- с  каждой недели снимим 1 выходной
    vbCountDays := vbCountDays - ROUND (vbCountDays/7);

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
          tmpMIContainer AS (SELECT _tmpContainer.ContainerId
                                  , _tmpContainer.LocationId
                                  , _tmpContainer.GoodsId
                                  , _tmpContainer.GoodsKindId
                          
                                   -- Приход
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                             THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountIncome
                                 --потребление
                                 , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) < 0 --MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                  THEN MIContainer.Amount --* (-1)
                                                  
                                             ELSE 0
                                        END) AS CountProduction
                                 -- прочее
                                 , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) > 0 AND MIContainer.MovementDescId NOT IN (zc_Movement_Income()) 
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS CountOther

                                         -- ***REMAINS***
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart
                                 , -1 * SUM (CASE WHEN MIContainer.OperDate > inEndDate    THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsEnd

                             FROM _tmpContainer
                                  INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                                 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.MovementId ELSE 0 END
                             HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                  --потребление
                                 OR SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(),zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   THEN MIContainer.Amount
                                              ELSE 0
                                         END) <> 0
                                 OR SUM (CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
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

                                    -- ***COUNT***
                                  , 0 AS CountIncome
                                  , 0 AS CountProduction
                                  , 0 AS CountOther
                                    -- ***REMAINS***
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                 , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd

                             FROM _tmpContainer
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = _tmpContainer.ContainerId
                                                                 AND MIContainer.OperDate > inEndDate

                             GROUP BY _tmpContainer.ContainerId
                                    , _tmpContainer.LocationId
                                    , _tmpContainer.GoodsId
                                    , _tmpContainer.GoodsKindId
                                    , _tmpContainer.Amount
                             HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            )
         -- Группируем
        , tmpData AS (SELECT tmpMIContainer.GoodsId
                           , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END AS GoodsKindId
                           , STRING_AGG (Object_GoodsKind.ValueData, ',') ::TVarChar AS GoodsKindName

                           , SUM (tmpMIContainer.CountIncome)      AS CountIncome
                           , SUM (tmpMIContainer.CountProduction)  AS CountProduction
                           , SUM (tmpMIContainer.CountOther)       AS CountOther
                           
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 8448   THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction1 --8448   ЦЕХ деликатесов
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 8447   THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction2 --8447   ЦЕХ колбасный
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 8450   THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction3 --8450   ЦЕХ копчения
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 8449   THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction4 --8449   ЦЕХ с/к
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 8451   THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction5 --8451   ЦЕХ упаковки
                           , SUM (CASE WHEN tmpMIContainer.LocationId = 951601 THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction6 --951601 ЦЕХ упаковки МЯСО
                           , SUM (CASE WHEN tmpMIContainer.LocationId IN (8457, 1078643,8458,8459) THEN tmpMIContainer.CountProduction ELSE 0 END) AS CountProduction7 --8457   Склад Реализация + Склад База  -- 1078643
                           , SUM (CASE WHEN tmpMIContainer.LocationId NOT IN (8448, 8447, 8450, 8449, 8451, 8457, 951601, 1078643,8458,8459)
                                       THEN tmpMIContainer.CountProduction
                                       ELSE 0
                                  END)                                                                                         AS CountProduction8 --       другие

                           , SUM (tmpMIContainer.RemainsStart) AS RemainsStart
                           , SUM (tmpMIContainer.RemainsEnd)   AS RemainsEnd
                           
                      FROM tmpMIContainer
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer.GoodsKindId
                      GROUP BY tmpMIContainer.GoodsId
                             , CASE WHEN inisGoodsKind = TRUE THEN tmpMIContainer.GoodsKindId ELSE 0 END
                      HAVING  SUM (tmpMIContainer.CountIncome) <> 0
                           OR SUM (tmpMIContainer.CountProduction) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8448   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8447   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8450   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8449   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8451   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 951601 THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId = 8457   THEN tmpMIContainer.CountProduction ELSE 0 END) <> 0
                           OR SUM (CASE WHEN tmpMIContainer.LocationId NOT IN (8448, 8447, 8450, 8449, 8451, 8457, 951601)
                                       THEN tmpMIContainer.CountProduction
                                       ELSE 0
                                  END) <> 0
                           OR SUM (tmpMIContainer.RemainsStart) <> 0
                           OR SUM (tmpMIContainer.RemainsEnd) <> 0
                      )

        , tmpRez AS (SELECT tmpData.GoodsId
                          , tmpData.GoodsKindName

                          , Object_Measure.ValueData       :: TVarChar AS MeasureName
                          , ObjectFloat_Weight.ValueData   :: TFloat   AS Weight

                          , tmpData.RemainsStart      ::TFloat
                          , (tmpData.RemainsStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS RemainsStart_Weight
                          , tmpData.RemainsEnd        ::TFloat
                          , (tmpData.RemainsEnd   * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS RemainsEnd_Weight

                          , tmpData.CountIncome       ::TFloat
                          , (tmpData.CountIncome * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountIncome1_Weight

                          , tmpData.CountProduction   ::TFloat
                          , (tmpData.CountProduction * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction_Weight

                          , tmpData.CountOther   ::TFloat
                          , (tmpData.CountOther * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountOther_Weight

                          , tmpData.CountProduction1   ::TFloat
                          , (tmpData.CountProduction1 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction1_Weight
                          , tmpData.CountProduction2   ::TFloat
                          , (tmpData.CountProduction2 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction2_Weight
                          , tmpData.CountProduction3   ::TFloat
                          , (tmpData.CountProduction3 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction3_Weight
                          , tmpData.CountProduction4   ::TFloat
                          , (tmpData.CountProduction4 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction4_Weight
                          , tmpData.CountProduction5   ::TFloat
                          , (tmpData.CountProduction5 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction5_Weight
                          , tmpData.CountProduction6   ::TFloat
                          , (tmpData.CountProduction6 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction6_Weight
                          , tmpData.CountProduction7   ::TFloat
                          , (tmpData.CountProduction7 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction7_Weight
                          , tmpData.CountProduction8   ::TFloat
                          , (tmpData.CountProduction8 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS CountProduction8_Weight
                     FROM tmpData
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                ON ObjectFloat_Weight.ObjectId = tmpData.GoodsId
                                               AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                               ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                     )


         -- Результат
         SELECT Object_Goods.Id                            AS GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData     :: TVarChar     AS GoodsName
              , tmpData.GoodsKindName      ::TVarChar      AS GoodsKindName

              , Object_GoodsGroup.Id                       AS GoodsGroupId
              , Object_GoodsGroup.ValueData                AS GoodsGroupName
              , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

              , tmpData.MeasureName  :: TVarChar
              , tmpData.Weight       :: TFloat  

              , tmpData.RemainsStart        ::TFloat
              , tmpData.RemainsStart_Weight ::TFloat
              , tmpData.RemainsEnd          ::TFloat
              , tmpData.RemainsEnd_Weight   ::TFloat

              , tmpData.CountIncome            ::TFloat
              , tmpData.CountIncome1_Weight    ::TFloat
              , tmpData.CountProduction        ::TFloat
              , tmpData.CountProduction_Weight ::TFloat
              , tmpData.CountOther             ::TFloat
              , tmpData.CountOther_Weight      ::TFloat

              , tmpData.CountProduction1        ::TFloat
              , tmpData.CountProduction1_Weight ::TFloat
              , tmpData.CountProduction2        ::TFloat
              , tmpData.CountProduction2_Weight ::TFloat
              , tmpData.CountProduction3        ::TFloat
              , tmpData.CountProduction3_Weight ::TFloat
              , tmpData.CountProduction4        ::TFloat
              , tmpData.CountProduction4_Weight ::TFloat
              , tmpData.CountProduction5        ::TFloat
              , tmpData.CountProduction5_Weight ::TFloat
              , tmpData.CountProduction6        ::TFloat
              , tmpData.CountProduction6_Weight ::TFloat
              , tmpData.CountProduction7        ::TFloat
              , tmpData.CountProduction7_Weight ::TFloat
              , tmpData.CountProduction8        ::TFloat
              , tmpData.CountProduction8_Weight ::TFloat

              , CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction/ vbCountDays        ELSE 0 END ::TFloat  AS CountProduction_avg -- среднесуточный расход
              , CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction_Weight/ vbCountDays ELSE 0 END ::TFloat  AS CountProduction_Weight_avg -- среднесуточный расход
              
              , (CASE WHEN (CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction_Weight/ vbCountDays ELSE 0 END) < 0
                      THEN tmpData.RemainsEnd_Weight / CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction_Weight/ vbCountDays ELSE 0 END
                      WHEN (CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction/ vbCountDays ELSE 0 END) < 0
                      THEN tmpData.RemainsEnd / CASE WHEN COALESCE (vbCountDays,0) <> 0 THEN tmpData.CountProduction/ vbCountDays ELSE 0 END
                      ELSE 0
                 END * (-1))                            :: TFloat AS CountDays-- Запас дней

         FROM tmpRez AS tmpData
         
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

              LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                     ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.21         *
*/

-- тест
--
/*
select * from gpReport_Supply_Remains(
     inStartDate  :='01.02.2021' ::        TDateTime , --
     inEndDate    :='03.02.2021' ::        TDateTime , --
     inUnitGroupId    := 0::     Integer,    -- группа подразделений / подразделение
     inGoodsGroupId   := 1918::     Integer,    -- группа товара
     inGoodsId        := 0::     Integer,    -- товар    2064
     inisGoodsKind    :=TRUE,
     inSession        := '5' ::     TVarChar    -- сессия пользователя
)
*/