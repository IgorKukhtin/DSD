-- Function: gpReport_SupplyBalance()

DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SupplyBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar
            -- , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , PartnerName TVarChar
             , CountDays Integer
             , RemainsStart TFloat
             , RemainsEnd TFloat
             , CountIncome TFloat
             , CountProductionOut TFloat
             , CountIn_oth  TFloat
             , CountOut_oth TFloat
             , CountOnDay TFloat
             , RemainsDays TFloat
             , ReserveDays TFloat
             , PlanOrder TFloat
             , CountOrder TFloat
             , RemainsDaysWithOrder TFloat
             , Color_RemainsDays Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountDays Integer;
BEGIN

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    vbCountDays := (SELECT DATE_PART('day', (inEndDate - inStartDate )) + 1);

     RETURN QUERY
     WITH
   tmpContainerAll AS (SELECT Container.Id                           AS ContainerId
                            , Container.ObjectId                     AS GoodsId
                            , Container.Amount
                       FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count()
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                       WHERE CLO_Unit.ObjectId = inUnitId
                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                       GROUP BY Container.Id, Container.ObjectId, Container.Amount
                      )
  -- выбираем поставщиков
  , tmpContainerIncome AS (SELECT DISTINCT tmpContainerAll.GoodsId, MIContainer.ObjectExtId_Analyzer AS PartnerId
                           FROM tmpContainerAll
                                INNER JOIN MovementItemContainer AS MIContainer
                                        ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.MovementDescId = zc_Movement_Income()
                                       AND COALESCE (MIContainer.ObjectExtId_Analyzer,0) <> 0
                          )
  , tmpPartnerList AS (SELECT goodsid, STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                       FROM tmpContainerIncome
                            LEFT JOIN Object ON Object.Id = tmpContainerIncome.PartnerId
                       GROUP BY tmpContainerIncome.GoodsId
                       )
  --
  , tmpContainer AS (SELECT tmp.GoodsId                          --, tmp.goodskindid
                          , SUM (tmp.StartAmount)        AS RemainsStart
                          , SUM (tmp.EndAmount)          AS RemainsEnd
                          , SUM (tmp.CountIncome)        AS CountIncome
                          , SUM (tmp.CountSendOut)       AS CountProductionOut
                          , SUM (tmp.CountIn_oth)        AS CountIn_oth
                          , SUM (tmp.CountOut_oth)       AS CountOut_oth
                     FROM (SELECT tmpContainerAll.GoodsId
                                --, COALESCE (CLO_GoodsKind.ObjectId, 0)   AS GoodsKindId
                                , tmpContainerAll.Amount
                                , tmpContainerAll.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS StartAmount
                                , tmpContainerAll.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                            THEN COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIncome
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Send()
                                             -- AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountSendOut

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Inventory())
                                             AND MIContainer.Amount < 0
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountOut_oth

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = TRUE
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                             AND MIContainer.Amount > 0
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIn_oth

                           FROM tmpContainerAll
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                                               AND MIContainer.OperDate >= inStartDate
                           GROUP BY tmpContainerAll.GoodsId, tmpContainerAll.Amount
                           ) AS tmp
                     GROUP BY tmp.GoodsId
                     )

, tmpGoodsListIncome AS (SELECT tmpGoods.GoodsId
                              , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                         FROM _tmpGoods AS tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                      ON ObjectLink_GoodsListIncome_Goods.ChildObjectId = tmpGoods.GoodsId
                                     AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                              LEFT JOIN Object AS Object_GoodsListIncome
                                     ON Object_GoodsListIncome.Id = ObjectLink_GoodsListIncome_Goods.ObjectId
                                    AND Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                              INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                      ON ObjectBoolean_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                                     AND ObjectBoolean_GoodsListIncome_Last.DescId = zc_ObjectBoolean_GoodsListIncome_Last()
                                     AND ObjectBoolean_GoodsListIncome_Last.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                     ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                                    AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                              LEFT JOIN Object ON Object.Id = ObjectLink_GoodsListIncome_Partner.ChildObjectId
                          GROUP BY tmpGoods.GoodsId
                         )

  , tmpOrderIncome AS (SELECT MILinkObject_Goods.ObjectId AS GoodsId
                            , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                            , SUM (MovementItem.Amount) AS Amount
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                            LEFT JOIN MovementItem ON MovementItem.MovementId  = Movement.Id
                                                  AND MovementItem.isErased = False
                                                  AND MovementItem.DescId = zc_MI_Master()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MILinkObject_Goods.ObjectId

                            LEFT JOIN Object ON Object.Id = MovementLinkObject_Juridical.ObjectId

                       WHERE Movement.DescId = zc_Movement_OrderIncome()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY MILinkObject_Goods.ObjectId
                       )
 , tmpGoodsByReport AS (SELECT tmpGoods.GoodsId
                             , COALESCE (tmpPartnerList.PartnerName, tmpGoodsListIncome.PartnerName) AS PartnerName
                        FROM (SELECT DISTINCT tmpContainer.GoodsId
                              FROM tmpContainer
                             UNION
                              SELECT DISTINCT tmpOrderIncome.GoodsId
                              FROM tmpOrderIncome
                              ) AS tmpGoods
                              LEFT JOIN tmpPartnerList ON tmpPartnerList.GoodsId = tmpGoods.GoodsId
                              LEFT JOIN tmpGoodsListIncome ON tmpGoodsListIncome.GoodsId = tmpGoods.GoodsId
                                                          AND COALESCE (tmpPartnerList.PartnerName, '') = ''
                       )

       -- Результат
       SELECT
             Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           --, Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName

           , COALESCE (tmpGoodsByReport.PartnerName, tmpOrderIncome.PartnerName) ::TVarChar AS PartnerName

           , vbCountDays                 AS CountDays

           , tmpContainer.RemainsStart   :: TFloat
           , tmpContainer.RemainsEnd     :: TFloat
           , tmpContainer.CountIncome         :: TFloat AS CountIncome
           , tmpContainer.CountProductionOut  :: TFloat AS CountProductionOut
           , tmpContainer.CountIn_oth         :: TFloat AS CountIn_oth
           , tmpContainer.CountOut_oth        :: TFloat AS CountOut_oth

           , (CASE WHEN vbCountDays <> 0 THEN tmpContainer.CountProductionOut/vbCountDays ELSE 0 END)  :: TFloat AS CountOnDay
           , CASE WHEN tmpContainer.CountProductionOut <=0 AND  tmpContainer.RemainsEnd <> 0 THEN 365
                  WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut/vbCountDays) <> 0
                  THEN tmpContainer.RemainsEnd / (tmpContainer.CountProductionOut/vbCountDays)
                  ELSE 0
             END :: TFloat AS RemainsDays

           , 30 :: TFloat AS ReserveDays
           , CASE WHEN tmpContainer.CountProductionOut > 0 AND tmpContainer.RemainsEnd <> 0 AND tmpContainer.RemainsEnd <> 0  AND tmpContainer.RemainsEnd < (tmpContainer.CountProductionOut/vbCountDays) * 30 THEN (tmpContainer.CountProductionOut/vbCountDays) * 30 - tmpContainer.RemainsEnd ELSE 0 END :: TFloat AS PlanOrder
           , tmpOrderIncome.Amount  :: TFloat AS CountOrder

           , CASE WHEN tmpContainer.CountProductionOut <= 0 AND tmpContainer.RemainsEnd <> 0
                  THEN 365
                  WHEN (tmpContainer.CountProductionOut/vbCountDays) <> 0
                  THEN (COALESCE(tmpContainer.RemainsEnd,0) + COALESCE(tmpOrderIncome.Amount,0))/ (tmpContainer.CountProductionOut/vbCountDays)
                  ELSE 0
             END  :: TFloat AS RemainsDaysWithOrder

           , CASE WHEN tmpContainer.CountProductionOut <= 0 AND tmpContainer.RemainsEnd <> 0
                  THEN zc_Color_Black()
                  WHEN COALESCE (tmpContainer.CountProductionOut, 0) <= 0 AND COALESCE (tmpContainer.RemainsEnd, 0) = 0
                  THEN zc_Color_Black()
                  WHEN (CASE WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut/vbCountDays) <> 0
                        THEN COALESCE(tmpContainer.RemainsEnd,0) / (tmpContainer.CountProductionOut/vbCountDays)
                        ELSE 0 END) > 29.9
                  THEN zc_Color_Black()
                  ELSE zc_Color_Red()
             END  :: integer AS Color_RemainsDays

       FROM tmpGoodsByReport
          LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpGoodsByReport.GoodsId
          LEFT JOIN tmpOrderIncome ON tmpOrderIncome.GoodsId = tmpGoodsByReport.GoodsId

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsByReport.GoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
       WHERE tmpContainer.RemainsStart <> 0 OR tmpContainer.RemainsEnd <> 0 OR tmpOrderIncome.Amount  <> 0
          OR tmpContainer.CountIncome <> 0 OR tmpContainer.CountProductionOut <> 0
          OR tmpContainer.CountIn_oth <> 0 OR tmpContainer.CountOut_oth <> 0
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.03.17         *
*/

-- тест
-- SELECT * FROM gpReport_SupplyBalance(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('21.12.2016')::TDateTime , inUnitId := 8455 , inGoodsGroupId := 1917 ,  inSession := '5');
