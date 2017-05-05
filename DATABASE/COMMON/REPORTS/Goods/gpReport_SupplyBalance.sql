-- Function: gpReport_SupplyBalance()

DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SupplyBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inJuridicalId        Integer,    -- поставщик
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , MeasureName          TVarChar
             , GoodsGroupNameFull   TVarChar
             , GoodsGroupName       TVarChar
             , PartnerName          TVarChar
             , CountDays            Integer
             , RemainsStart         TFloat
             , RemainsEnd           TFloat
             , RemainsStart_Oth     TFloat
             , RemainsEnd_Oth       TFloat
             , CountIncome          TFloat
             , CountProductionOut   TFloat
             , CountIn_oth          TFloat
             , CountOut_oth         TFloat
             , CountOnDay           TFloat
             , RemainsDays          TFloat
             , ReserveDays          TFloat
             , PlanOrder            TFloat
             , CountOrder           TFloat
             , RemainsDaysWithOrder TFloat
             , Color_RemainsDays    Integer
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
           SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
    ELSE
        -- ох и долго будет открываться в этом случае
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    vbCountDays := (SELECT DATE_PART('day', (inEndDate - inStartDate )) + 1);

     RETURN QUERY
     WITH -- подразделения для "остатки впроизводстве"
          tmpUnit AS (SELECT 8448 AS UnitId       --цех деликатесов+   
                     UNION
                      SELECT 8447 AS UnitId       -- колбасный+           
                     UNION
                      SELECT 8451 AS UnitId       -- упаковка+            
                     UNION
                      SELECT 951601 AS UnitId     -- упаковка мясо+       
                     UNION
                      SELECT 981821 AS UnitId     -- шприцевание          
                     )
    -- заявки по Юр Лицам - !!!только если под них еще нет прихода!!!
  , tmpOrderIncome AS (SELECT MILinkObject_Goods.ObjectId AS GoodsId
                            , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфі не окажется
                            , SUM (MovementItem.Amount) AS Amount
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                          ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                         AND MovementLinkObject_Juridical.DescId     = zc_MovementLinkObject_Juridical()
                                                         -- !!!ограничили!!!
                                                         AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                            LEFT JOIN Object ON Object.Id = MovementLinkObject_Juridical.ObjectId

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId > 0 -- !!!значит это заявка "снабжения"!!!
                            LEFT JOIN MovementItem ON MovementItem.MovementId  = Movement.Id
                                                  AND MovementItem.isErased    = False
                                                  AND MovementItem.DescId      = zc_MI_Master()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MILinkObject_Goods.ObjectId

                            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                                           ON MovementLinkMovement_Income.MovementChildId = Movement.Id
                                                          AND MovementLinkMovement_Income.DescId = zc_MovementLinkMovement_Order()
                            LEFT JOIN Movement AS Movement_Income
                                               ON Movement_Income.Id       = MovementLinkMovement_Income.MovementId
                                              AND Movement_Income.StatusId = zc_Enum_Status_Complete()

                       WHERE Movement.DescId     = zc_Movement_OrderIncome()
                         AND Movement.StatusId   = zc_Enum_Status_Complete()
                         AND Movement_Income.Id IS NULL -- т.е. у заявки еще нет ПРОВЕДЕННОГО прихода
                       GROUP BY MILinkObject_Goods.ObjectId
                       )
    -- список товаров по поставщикам из прихода (кол-во прихода возьмем из проводок - потом)
  , tmpContainerIncome AS (SELECT DISTINCT
                                  MIContainer.ObjectId_Analyzer    AS GoodsId
                                , MIContainer.ObjectExtId_Analyzer AS PartnerId
                           FROM MovementItemContainer AS MIContainer
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = MIContainer.ObjectExtId_Analyzer
                                                     AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                                     -- !!!ограничили!!!
                                                     AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                           WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             AND MIContainer.WhereObjectId_Analyzer = inUnitId
                             AND MIContainer.MovementDescId         = zc_Movement_Income()
                             AND MIContainer.DescId                 = zc_MIContainer_Count()
                          )
  -- список товаров по поставщикам из !!!последней!!! "привязки"
, tmpGoodsListIncome AS (SELECT DISTINCT
                                tmpGoods.GoodsId
                              , ObjectLink_GoodsListIncome_Partner.ChildObjectId AS PartnerId
                         FROM _tmpGoods AS tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                                    ON ObjectLink_GoodsListIncome_Goods.ChildObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_GoodsListIncome_Goods.DescId        = zc_ObjectLink_GoodsListIncome_Goods()
                              INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                                       ON ObjectBoolean_GoodsListIncome_Last.ObjectId  = ObjectLink_GoodsListIncome_Goods.ObjectId
                                                      AND ObjectBoolean_GoodsListIncome_Last.DescId    = zc_ObjectBoolean_GoodsListIncome_Last()
                                                      AND ObjectBoolean_GoodsListIncome_Last.ValueData = TRUE -- из последней
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                                   ON ObjectLink_GoodsListIncome_Partner.ObjectId = ObjectLink_GoodsListIncome_Goods.ObjectId
                                                  AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                              INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_GoodsListIncome_Partner.ChildObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                   -- !!!ограничили!!!
                                                   AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                        )
      -- !!!финальный!!! список товаров + он ПО поставщикам - и GoodsId в нем надеюсь уникальный
    , tmpGoodsList AS (SELECT tmp.GoodsId
                            , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфі не окажется
                       FROM (-- приоритет № 1
                             SELECT tmpContainerIncome.GoodsId
                                  , tmpContainerIncome.PartnerId
                             FROM tmpContainerIncome
                            UNION
                             -- еще добавим из списка - если нет в приходе
                             SELECT tmpGoodsListIncome.GoodsId
                                  , tmpGoodsListIncome.PartnerId
                             FROM tmpGoodsListIncome
                                  LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = tmpGoodsListIncome.GoodsId
                             WHERE tmpContainerIncome.GoodsId IS NULL
                            ) AS tmp
                            LEFT JOIN Object ON Object.Id = tmp.PartnerId
                       GROUP BY tmp.GoodsId
                      UNION
                       -- приоритет № 2 - еще добавим из заявок - если нет в предыдущем
                       SELECT tmpOrderIncome.GoodsId, tmpOrderIncome.PartnerName
                       FROM tmpOrderIncome
                            LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = tmpOrderIncome.GoodsId
                            LEFT JOIN tmpGoodsListIncome ON tmpGoodsListIncome.GoodsId = tmpOrderIncome.GoodsId
                       WHERE tmpContainerIncome.GoodsId IS NULL
                         AND tmpGoodsListIncome.GoodsId IS NULL
                      UNION
                       -- приоритет № 3 - еще остальные - НО если НЕТ inJuridicalId
                       SELECT _tmpGoods.GoodsId, '' AS PartnerName
                       FROM _tmpGoods
                            LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = _tmpGoods.GoodsId
                            LEFT JOIN tmpGoodsListIncome ON tmpGoodsListIncome.GoodsId = _tmpGoods.GoodsId
                            LEFT JOIN tmpOrderIncome     ON tmpOrderIncome.GoodsId     = _tmpGoods.GoodsId
                       WHERE inJuridicalId = 0
                         AND tmpContainerIncome.GoodsId IS NULL
                         AND tmpGoodsListIncome.GoodsId IS NULL
                         AND tmpOrderIncome.GoodsId     IS NULL
                      )

   -- контейнеры для движения - по !!!финальному!!! списку
 , tmpContainerAll AS (SELECT Container.Id         AS ContainerId
                            , CLO_Unit.ObjectId    AS UnitId
                            , Container.ObjectId   AS GoodsId
                            , Container.Amount
                       FROM ContainerLinkObject AS CLO_Unit
                            -- INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId
                            INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count()
                            INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = Container.ObjectId
                       WHERE CLO_Unit.ObjectId = inUnitId
                         AND CLO_Unit.DescId   = zc_ContainerLinkObject_Unit()
                      )
    -- движение + остатки
  , tmpContainer AS (SELECT tmp.GoodsId 
                          , SUM (tmp.StartAmount)        AS RemainsStart
                          , SUM (tmp.EndAmount)          AS RemainsEnd
                          , SUM (CASE -- если надо по всем поставщикам - тогда весь приход
                                      WHEN inJuridicalId = 0
                                           THEN tmp.CountIncome
                                      -- если надо только по одному поставщику
                                      WHEN ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId AND inJuridicalId > 0
                                           THEN tmp.CountIncome
                                      -- иначе это "другой" приход/расход
                                      ELSE 0
                                END) AS CountIncome
                          , SUM (tmp.CountSendOut)       AS CountProductionOut
                          , SUM (tmp.CountIn_oth
                               + CASE -- иначе это "другой" приход
                                      WHEN ObjectLink_Partner_Juridical.ChildObjectId <> inJuridicalId AND inJuridicalId > 0
                                           AND tmp.CountIncome > 0
                                           THEN tmp.CountIncome
                                      ELSE 0
                                END) AS CountIn_oth
                          , SUM (tmp.CountOut_oth
                               + CASE -- иначе это "другой" расход
                                      WHEN ObjectLink_Partner_Juridical.ChildObjectId <> inJuridicalId AND inJuridicalId > 0
                                           AND tmp.CountIncome < 0
                                           THEN -1 * tmp.CountIncome
                                      ELSE 0
                                END) AS CountOut_oth

                     FROM (SELECT CASE WHEN MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END AS ObjectExtId_Analyzer
                                , tmpContainerAll.GoodsId
                                , tmpContainerAll.Amount
                                , tmpContainerAll.Amount - SUM (COALESCE (MIContainer.Amount, 0))  AS StartAmount
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
                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale())
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
                                             AND MIContainer.MovementDescId IN (zc_Movement_ReturnIn())
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
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
                           WHERE tmpContainerAll.UnitId = inUnitId
                           GROUP BY CASE WHEN MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END
                                  , tmpContainerAll.ContainerId, tmpContainerAll.GoodsId, tmpContainerAll.Amount
                          ) AS tmp
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = tmp.ObjectExtId_Analyzer
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                     GROUP BY tmp.GoodsId
                     )
   -- контейнеры - для "остатки в производстве"
 , tmpContainer_Oth AS (SELECT Container.Id       AS ContainerId
                             , Container.ObjectId AS GoodsId
                             , Container.Amount
                        FROM tmpUnit
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                            ON CLO_Unit.ObjectId = tmpUnit.UnitId
                                                           AND CLO_Unit.DescId   = zc_ContainerLinkObject_Unit()
                             INNER JOIN Container ON Container.Id     = CLO_Unit.ContainerId
                                                 AND Container.DescId = zc_Container_Count()
                             INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = Container.ObjectId
                       )
    --"остатки в производстве"
  , tmpRemains_Oth AS (SELECT tmp.GoodsId
                            , SUM (tmp.StartAmount) AS RemainsStart
                            , SUM (tmp.EndAmount)   AS RemainsEnd

                       FROM (SELECT tmpContainer_Oth.ContainerId
                                  , tmpContainer_Oth.GoodsId
                                  , tmpContainer_Oth.Amount - SUM (COALESCE (MIContainer.Amount, 0))  AS StartAmount
                                  , tmpContainer_Oth.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                             FROM tmpContainer_Oth
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.Containerid = tmpContainer_Oth.ContainerId
                                                                 AND MIContainer.OperDate    >= inStartDate
                             GROUP BY tmpContainer_Oth.ContainerId, tmpContainer_Oth.GoodsId, tmpContainer_Oth.Amount
                             HAVING tmpContainer_Oth.Amount - SUM (COALESCE (MIContainer.Amount, 0))  <> 0
                                 OR tmpContainer_Oth.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                            ) AS tmp
                       GROUP BY tmp.GoodsId, tmp.ContainerId
                      )
       -- Результат
       SELECT
             Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName

           , tmpGoodsList.PartnerName :: TVarChar AS PartnerName

           , vbCountDays                 AS CountDays

           , tmpContainer.RemainsStart        :: TFloat AS RemainsStart
           , tmpContainer.RemainsEnd          :: TFloat AS RemainsEnd
           , tmpRemains_Oth.RemainsStart      :: TFloat AS RemainsStart_Oth
           , tmpRemains_Oth.RemainsEnd        :: TFloat AS RemainsEnd_Oth
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
                  WHEN (tmpContainer.CountProductionOut / vbCountDays) <> 0
                  THEN (COALESCE (tmpContainer.RemainsEnd, 0) + COALESCE (tmpOrderIncome.Amount, 0)) / (tmpContainer.CountProductionOut / vbCountDays)
                  ELSE 0
             END  :: TFloat AS RemainsDaysWithOrder

           , CASE WHEN COALESCE (tmpOrderIncome.Amount, 0) > 0 THEN 25088  -- зеленый
                  ELSE
                    CASE WHEN tmpContainer.CountProductionOut <= 0 AND tmpContainer.RemainsEnd <> 0
                              THEN zc_Color_Black()

                         WHEN COALESCE (tmpContainer.CountProductionOut, 0) <= 0 AND COALESCE (tmpContainer.RemainsEnd, 0) = 0
                              THEN zc_Color_Black()

                         WHEN 29.9 < CASE WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut / vbCountDays) <> 0
                                               THEN COALESCE (tmpContainer.RemainsEnd, 0) / (tmpContainer.CountProductionOut / vbCountDays)
                                           ELSE 0
                                     END
                              THEN zc_Color_Black()

                         ELSE zc_Color_Red()
                    END 
              END :: Integer AS Color_RemainsDays

       FROM tmpGoodsList
          LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN tmpOrderIncome ON tmpOrderIncome.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN tmpRemains_Oth ON tmpRemains_Oth.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsList.GoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
          
       WHERE tmpContainer.RemainsStart   <> 0 OR tmpContainer.RemainsEnd         <> 0 OR tmpOrderIncome.Amount  <> 0
          OR tmpContainer.CountIncome    <> 0 OR tmpContainer.CountProductionOut <> 0
          OR tmpContainer.CountIn_oth    <> 0 OR tmpContainer.CountOut_oth       <> 0
          OR tmpRemains_Oth.RemainsStart <> 0
          OR tmpRemains_Oth.RemainsEnd   <> 0
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
-- SELECT * FROM gpReport_SupplyBalance (inStartDate:= '01.04.2017', inEndDate:= '30.04.2017', inUnitId:= 8455, inGoodsGroupId:= 1941, inJuridicalId:= 0, inSession := '5'); -- Склад специй
