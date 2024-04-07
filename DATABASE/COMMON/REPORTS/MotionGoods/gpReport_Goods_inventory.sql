-- Function: gpReport_Goods_inventory()

DROP FUNCTION IF EXISTS gpReport_Goods_inventory (TDateTime, TDateTime, Integer, Integer, Integer, Integer ,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_inventory (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inSession            TVarChar   -- пользователь
)
RETURNS TABLE (LocationId Integer, LocationCode Integer, LocationName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , CountStart  TFloat 
             , CountEnd    TFloat 
             , CountEnd_calc TFloat
             , Count_Inventory    TFloat
             , CountIn_Income    TFloat
             , CountIn_Loss    TFloat
             , CountIn_Send    TFloat
             , CountIn_ReturnIn    TFloat
             , CountIn_ProductionSeparate TFloat
             , CountIn_ProductionUnion    TFloat
             , CountOut_Sale    TFloat
             , CountOut_Loss    TFloat
             , CountOut_Send    TFloat
             , CountOut_ProductionSeparate    TFloat
             , CountOut_ProductionUnion    TFloat
             , CountIn_Income_un    TFloat
             , CountIn_Loss_un    TFloat
             , CountIn_Send_un    TFloat
             , CountIn_ReturnIn_un    TFloat
             , CountIn_ProductionSeparate_un    TFloat
             , CountIn_ProductionUnion_un    TFloat
             , CountOut_Sale_un    TFloat
             , CountOut_Loss_un    TFloat
             , CountOut_Send_un    TFloat
             , CountOut_ProductionSeparate_un    TFloat
             , CountOut_ProductionUnion_un    TFloat
             , OperDate TDateTime
             , OperDate_byReport TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbIsSummIn Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);
    

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- !!!определяется!!!
    vbIsSummIn:= -- Ограничение просмотра с/с
                 NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
                ;

     -- !!!может так будет быстрее!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    -- !!!меняются параметры для филиала!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
    END IF;


    RETURN QUERY
    -- группа подразделений или подразделение или место учета (МО, Авто)
     WITH _tmpLocation AS -- (LocationId, DescId, ContainerDescId)
          (SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1
           WHERE inUnitGroupId <> 0
          UNION
           SELECT Object.Id AS LocationId
                , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit() 
                  END AS DescId
                , tmpDesc.ContainerDescId
           FROM Object
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1
           WHERE Object.Id    = inLocationId
             AND inLocationId > 0
          UNION
           SELECT Object.Id AS LocationId
                , zc_ContainerLinkObject_Unit() AS DescId
                , tmpDesc.ContainerDescId
           FROM Object
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1
           WHERE Object.DescId = zc_Object_Unit()
             AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inLocationId, 0) = 0
             AND (inGoodsGroupId <> 0 OR inGoodsId <> 0)
           )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpLocation;


    -- группа товаров или товар или все товары из проводок
     , tmpObjectGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                          WHERE inGoodsGroupId > 0 AND inGoodsId = 0
                         UNION
                          SELECT inGoodsId AS GoodsId
                          WHERE inGoodsId <> 0
                         )

     , tmpGoods AS (SELECT tmpObjectGoods.GoodsId 
                         , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                    FROM tmpObjectGoods
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpObjectGoods.GoodsId
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                   )

     , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                      FROM (SELECT inAccountGroupId              AS AccountGroupId WHERE inAccountGroupId <> 0
                      UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE inAccountGroupId = 0
                      UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE inAccountGroupId = 0
                      UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE inAccountGroupId = 0
                      UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE inAccountGroupId = 0
                           ) AS tmp
                           INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                     )

    --выбираем документы инвентаризации, из них получаем остаток товара ,  дату для группы товаров от которой потом брать движение
    , tmpInventory_all AS (SELECT Movement.*
                                , MovementLinkObject_From.ObjectId AS FromId
                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                --LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                INNER JOIN _tmpLocation ON _tmpLocation.LocationId = MovementLinkObject_From.ObjectId
                           WHERE Movement.DescId = zc_Movement_Inventory()
                           AND Movement.OperDate >= inStartDate - INTERVAL '1 MONTH'
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                           )

    , tmpMI AS (SELECT Movement.Id AS MovementId
                     , Movement.OperDate
                     , Movement.InvNumber
                     , Movement.FromId
                     , tmpGoods.GoodsGroupId
                     , MovementItem.ObjectId AS GoodsId
                     , MovementItem.Id AS MI_Id
                     , MovementItem.Amount
                     , ROW_NUMBER() OVER (PARTITION BY Movement.FromId, tmpGoods.GoodsGroupId ORDER BY Movement.OperDate DESC, Movement.Id) AS ORD
                FROM tmpInventory_all AS Movement
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                )

    , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.*
                                    FROM MovementItemLinkObject
                                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MI_Id FROM tmpMI)
                                      AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                    )

    , tmpMI_all AS (SELECT tmpMI.MovementId
                         , tmpMI.OperDate
                         , tmpMI.InvNumber
                         , tmpMI.FromId
                         , tmpMI.GoodsGroupId
                         , tmpMI.GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                         , tmpMI.Amount
                         , tmpMI.ORD
                    FROM tmpMI
                         LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MI_Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    )

     -- документы инвентаризации для групп товаров по подразделениям
    , tmpInv AS (SELECT Distinct tmpMI_all.MovementId
                      , tmpMI_all.OperDate
                      , tmpMI_all.FromId
                      , tmpMI_all.GoodsGroupId
                 FROM tmpMI_all
                 WHERE tmpMI_all.Ord = 1
                 )
     --инвентаризации товаров по подразделениям
    , tmpInv_MI AS (SELECT tmpInv.MovementId
                      , tmpInv.OperDate
                      , tmpMI_all.FromId
                      , tmpMI_all.GoodsGroupId
                      , tmpMI_all.GoodsId
                      , tmpMI_all.GoodsKindId
                      , SUM (tmpMI_all.Amount) AS Amount
                    FROM tmpGoods
                        LEFT JOIN tmpInv ON tmpInv.GoodsGroupId = tmpGoods.GoodsGroupId
                        LEFT JOIN tmpMI_all ON tmpMI_all.FromId = tmpInv.FromId
                                           AND tmpMI_all.GoodsGroupId = tmpInv.GoodsGroupId
                                           AND tmpMI_all.MovementId = tmpInv.MovementId
                                           AND tmpMI_all.GoodsId = tmpGoods.GoodsId
                    GROUP BY tmpInv.MovementId
                      , tmpInv.OperDate
                      , tmpMI_all.FromId
                      , tmpMI_all.GoodsGroupId
                      , tmpMI_all.GoodsId
                      , tmpMI_all.GoodsKindId
                    --WHERE tmpMI_all.GoodsId = 2046
                    )

    -- Движение по проведенным документамвсе ContainerId
    , tmpMIContainer AS (SELECT MIContainer.*
                         FROM MovementItemContainer AS MIContainer
                              LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = MIContainer.ContainerId
                                                                          AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                         WHERE MIContainer.OperDate > (SELECT MIN (tmpInv.OperDate) AS OperDate FROM tmpInv)
                           AND MIContainer.DescId = zc_Container_Count()
                           AND MIContainer.WhereObjectId_Analyzer IN (SELECT DISTINCT _tmpLocation.LocationId FROM _tmpLocation)
                           AND MIContainer.ObjectId_Analyzer IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                           AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                            , zc_Movement_Income(), zc_Movement_ReturnOut()
                                                            , zc_Movement_Send(), zc_Movement_Loss()
                                                            , zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion()
                                                            )
                           AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                              )
                           --and MIContainer.ObjectId_Analyzer  = 7984
                         )
  
    , tmpCLO_GoodsKind AS (SELECT CLO_GoodsKind.*
                           FROM ContainerLinkObject AS CLO_GoodsKind
                           WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpMIContainer.ContainerId FROM tmpMIContainer)
                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                           )

    , tmpMIContainerAll AS (SELECT MIContainer.WhereObjectId_Analyzer AS LocationId
                                 , MIContainer.ObjectId_Analyzer AS GoodsId
                                 , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , tmpInv_MI.OperDate

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                  THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Income

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_Sale())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END ) AS CountOut_Sale

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 *COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountOut_Send
                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Send
                                        
                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountIn_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_ProductionSeparate

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_Loss

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ReturnIn())
                                             THEN 1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_ReturnIn

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_ProductionSeparate

                                 , SUM (CASE WHEN MIContainer.OperDate > tmpInv_MI.OperDate
                                              AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Loss

                           FROM tmpMIContainer AS MIContainer
                               LEFT JOIN tmpCLO_GoodsKind AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN tmpInv_MI ON tmpInv_MI.FromId = MIContainer.WhereObjectId_Analyzer
                                                   AND tmpInv_MI.GoodsId = MIContainer.ObjectId_Analyzer
                                                   AND COALESCE (tmpInv_MI.GoodsKindId, 0) = COALESCE (CLO_GoodsKind.ObjectId, 0)

                           GROUP BY MIContainer.WhereObjectId_Analyzer
                                  , MIContainer.ObjectId_Analyzer
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                                  , tmpInv_MI.OperDate
                          )
    --не проведенные документы
    , tmpMovement_UNComplete AS (SELECT Movement.*
                                      , MovementLinkObject_From.ObjectId AS FromId
                                      , MovementLinkObject_To.ObjectId   AS ToId
                                 FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 WHERE Movement.StatusId = zc_Enum_Status_UnComplete()
                                     AND Movement.OperDate > (SELECT MIN (tmpInv.OperDate) AS OperDate FROM tmpInv) 
                                     AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()
                                                           , zc_Movement_Income(), zc_Movement_ReturnOut()
                                                           , zc_Movement_Send(), zc_Movement_Loss()
                                                           , zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion()
                                                           )
                                     AND (MovementLinkObject_From.ObjectId IN (SELECT DISTINCT _tmpLocation.LocationId FROM _tmpLocation)
                                       OR MovementLinkObject_To.ObjectId IN (SELECT DISTINCT _tmpLocation.LocationId FROM _tmpLocation)
                                         )
                                 )
 
    , tmpMI_AllUnComplete AS (SELECT MovementItem.*
                              FROM MovementItem
                              WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_UNComplete.Id FROM tmpMovement_UNComplete)
                                AND MovementItem.isErased = FALSE
                              )

    , tmpMILinkObject_GoodsKind2 AS (SELECT MovementItemLinkObject.*
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_AllUnComplete.Id FROM tmpMI_AllUnComplete)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                     )

    , tmpMI_UnComplete AS (SELECT tmpMI_all.FromId AS LocationId
                                , MovementItem.ObjectId                        AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                                , tmpMI_all.OperDate
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MovementItem.Amount ELSE 0 END) AS CountIncome
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_Sale() THEN MovementItem.Amount ELSE 0 END) AS CountOut_Sale
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_ReturnIn() THEN MovementItem.Amount ELSE 0 END) AS CountIn_ReturnIn
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_Send() AND Movement.ToId = tmpMI_all.FromId THEN MovementItem.Amount ELSE 0 END) AS CountIn_Send
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_Send() AND Movement.FromId = tmpMI_all.FromId THEN MovementItem.Amount ELSE 0 END) AS CountOut_Send
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_Loss() AND Movement.ToId = tmpMI_all.FromId THEN MovementItem.Amount ELSE 0 END) AS CountIn_Loss
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_Loss() AND Movement.FromId = tmpMI_all.FromId THEN MovementItem.Amount ELSE 0 END) AS CountOut_Loss
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_ProductionSeparate() AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS CountOut_ProductionSeparate
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_ProductionSeparate() AND MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS CountIn_ProductionSeparate
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS CountIn_ProductionUnion
                                , SUM (CASE WHEN Movement.OperDate > tmpMI_all.OperDate AND Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS CountOut_ProductionUnion

                           FROM tmpMovement_UNComplete AS Movement
                                INNER JOIN tmpMI_AllUnComplete AS MovementItem
                                                               ON MovementItem.MovementId = Movement.Id
                                                            --AND MovementItem.DescId = zc_MI_Master()
                                                              AND MovementItem.isErased = FALSE
                                LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN tmpMI_all ON (tmpMI_all.FromId = Movement.FromId OR tmpMI_all.FromId = Movement.ToId)
                                                   AND tmpMI_all.GoodsId = MovementItem.ObjectId
                                                   AND COALESCE (tmpMI_all.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                           GROUP BY MovementItem.ObjectId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                                  , tmpMI_all.FromId
                                  , tmpMI_all.OperDate
                           )
 
 -- остатки из проводок
    , tmpContainer AS (SELECT _tmpLocation.LocationId
                            , Container.Id AS ContainerId
                            , Container.ObjectId AS GoodsId
                            , tmpGoods.GoodsGroupId
                            , Container.Amount
                       FROM Container
                            INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                            INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                                   AND _tmpLocation.DescId = ContainerLinkObject.DescId
                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
     
                            LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                            LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                        AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                       WHERE Container.DescId = zc_Container_Count()
                         AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                            OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000())) -- Транзит
                       )
    , tmpCLO_GoodsKind_rem AS (SELECT CLO_GoodsKind.*
                               FROM ContainerLinkObject AS CLO_GoodsKind
                               WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                              )

     , tmpRemainsEnd AS (-- Остатки конечные
                         SELECT tmpContainer.LocationId
                              , tmpContainer.GoodsId
                              , COALESCE (CLO_GoodsKind.ObjectId, 0)    AS GoodsKindId
                              , SUM (COALESCE (tmpContainer.Amount,0)) AS Amount ---RemainsEnd
                              , tmpInv.OperDate
                         FROM tmpContainer
                              LEFT JOIN tmpCLO_GoodsKind_rem AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                            AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                            
                              LEFT JOIN tmpInv ON tmpInv.FromId = tmpContainer.LocationId
                                              AND tmpInv.FromId = tmpContainer.GoodsGroupId
                         GROUP BY tmpContainer.LocationId
                          , tmpContainer.GoodsId
                          , COALESCE (CLO_GoodsKind.ObjectId, 0)
                          , tmpInv.OperDate
                         HAVING SUM (COALESCE (tmpContainer.Amount,0)) <> 0
                            )
-------------- 
    
 
 
 
 
 -- сворачиваем все в 1 таблицу
    , tmpUnion AS (--конечн. ост.
                SELECT tmp.LocationId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , 0 ::TFloat AS CountStart
                     , 0 ::TFloat AS Count_Inventory
                     , 0 ::TFloat AS CountIn_Income
                     , 0 ::TFloat AS CountIn_Loss
                     , 0 ::TFloat AS CountIn_Send
                     , 0 ::TFloat AS CountIn_ReturnIn
                     , 0 ::TFloat AS CountIn_ProductionSeparate
                     , 0 ::TFloat AS CountIn_ProductionUnion
                     , 0 ::TFloat AS CountOut_Sale
                     , 0 ::TFloat AS CountOut_Loss
                     , 0 ::TFloat AS CountOut_Send
                     , 0 ::TFloat AS CountOut_ProductionSeparate
                     , 0 ::TFloat AS CountOut_ProductionUnion
                     
                     , 0 ::TFloat AS CountIn_Income_un
                     , 0 ::TFloat AS CountIn_Loss_un
                     , 0 ::TFloat AS CountIn_Send_un
                     , 0 ::TFloat AS CountIn_ReturnIn_un
                     , 0 ::TFloat AS CountIn_ProductionSeparate_un
                     , 0 ::TFloat AS CountIn_ProductionUnion_un
                     , 0 ::TFloat AS CountOut_Sale_un
                     , 0 ::TFloat AS CountOut_Loss_un
                     , 0 ::TFloat AS CountOut_Send_un
                     , 0 ::TFloat AS CountOut_ProductionSeparate_un
                     , 0 ::TFloat AS CountOut_ProductionUnion_un
                     , tmp.Amount AS CountEnd
                     , tmp.OperDate ::TDateTime AS OperDate
                FROM tmpRemainsEnd AS tmp
                WHERE COALESCE (tmp.Amount,0) <> 0
    
               UNION ALL
                --Инвентаризация
                SELECT tmp.FromId AS LocationId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.Amount AS CountStart
                     , tmp.Amount AS Count_Inventory
                     , 0 ::TFloat AS CountIn_Income
                     , 0 ::TFloat AS CountIn_Loss
                     , 0 ::TFloat AS CountIn_Send
                     , 0 ::TFloat AS CountIn_ReturnIn
                     , 0 ::TFloat AS CountIn_ProductionSeparate
                     , 0 ::TFloat AS CountIn_ProductionUnion
                     , 0 ::TFloat AS CountOut_Sale
                     , 0 ::TFloat AS CountOut_Loss
                     , 0 ::TFloat AS CountOut_Send
                     , 0 ::TFloat AS CountOut_ProductionSeparate
                     , 0 ::TFloat AS CountOut_ProductionUnion
                     
                     , 0 ::TFloat AS CountIn_Income_un
                     , 0 ::TFloat AS CountIn_Loss_un
                     , 0 ::TFloat AS CountIn_Send_un
                     , 0 ::TFloat AS CountIn_ReturnIn_un
                     , 0 ::TFloat AS CountIn_ProductionSeparate_un
                     , 0 ::TFloat AS CountIn_ProductionUnion_un
                     , 0 ::TFloat AS CountOut_Sale_un
                     , 0 ::TFloat AS CountOut_Loss_un
                     , 0 ::TFloat AS CountOut_Send_un
                     , 0 ::TFloat AS CountOut_ProductionSeparate_un
                     , 0 ::TFloat AS CountOut_ProductionUnion_un
                     , 0 ::TFloat AS CountEnd
                     , tmp.OperDate ::TDateTime AS OperDate
                FROM tmpInv_MI AS tmp
                WHERE COALESCE (tmp.Amount,0) <> 0
              UNION ALL
                --движение
                SELECT tmp.LocationId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , 0 ::TFloat AS CountStart
                     , 0 ::TFloat AS Count_Inventory
                     
                     , tmp.CountIn_Income
                     , tmp.CountIn_Loss
                     , tmp.CountIn_Send
                     , tmp.CountIn_ReturnIn
                     , tmp.CountIn_ProductionSeparate
                     , tmp.CountIn_ProductionUnion
                     , tmp.CountOut_Sale
                     , tmp.CountOut_Loss
                     , tmp.CountOut_Send
                     , tmp.CountOut_ProductionSeparate
                     , tmp.CountOut_ProductionUnion
                     , 0 ::TFloat AS CountIn_Income_un
                     , 0 ::TFloat AS CountIn_Loss_un
                     , 0 ::TFloat AS CountIn_Send_un
                     , 0 ::TFloat AS CountIn_ReturnIn_un
                     , 0 ::TFloat AS CountIn_ProductionSeparate_un
                     , 0 ::TFloat AS CountIn_ProductionUnion_un
                     , 0 ::TFloat AS CountOut_Sale_un
                     , 0 ::TFloat AS CountOut_Loss_un
                     , 0 ::TFloat AS CountOut_Send_un
                     , 0 ::TFloat AS CountOut_ProductionSeparate_un
                     , 0 ::TFloat AS CountOut_ProductionUnion_un
                     , 0 ::TFloat AS CountEnd
                     , tmp.OperDate ::TDateTime AS OperDate
                FROM tmpMIContainerAll AS tmp
                WHERE COALESCE (tmp.CountIn_Income,0) <> 0
                   OR COALESCE (tmp.CountIn_Loss,0) <> 0
                   OR COALESCE (tmp.CountIn_Send,0) <> 0
                   OR COALESCE (tmp.CountIn_ReturnIn,0) <> 0
                   OR COALESCE (tmp.CountIn_ProductionSeparate,0) <> 0
                   OR COALESCE (tmp.CountIn_ProductionUnion,0) <> 0
                   OR COALESCE (tmp.CountOut_Sale,0) <> 0
                   OR COALESCE (tmp.CountOut_Loss,0) <> 0
                   OR COALESCE (tmp.CountOut_Send,0) <> 0
                   OR COALESCE (tmp.CountOut_ProductionSeparate,0) <> 0
                   OR COALESCE (tmp.CountOut_ProductionUnion,0) <> 0
              UNION ALL
                SELECT tmp.LocationId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , 0 ::TFloat AS CountStart
                     , 0 ::TFloat AS Count_Inventory
                     
                     , 0 ::TFloat AS CountIn_Income
                     , 0 ::TFloat AS CountIn_Loss
                     , 0 ::TFloat AS CountIn_Send
                     , 0 ::TFloat AS CountIn_ReturnIn
                     , 0 ::TFloat AS CountIn_ProductionSeparate
                     , 0 ::TFloat AS CountIn_ProductionUnion
                     , 0 ::TFloat AS CountOut_Sale
                     , 0 ::TFloat AS CountOut_Loss
                     , 0 ::TFloat AS CountOut_Send
                     , 0 ::TFloat AS CountOut_ProductionSeparate
                     , 0 ::TFloat AS CountOut_ProductionUnion
                     , tmp.CountIncome                 AS CountIn_Income_un             
                     , tmp.CountIn_Loss                AS CountIn_Loss_un               
                     , tmp.CountIn_Send                AS CountIn_Send_un               
                     , tmp.CountIn_ReturnIn            AS CountIn_ReturnIn_un           
                     , tmp.CountIn_ProductionSeparate  AS CountIn_ProductionSeparate_un 
                     , tmp.CountIn_ProductionUnion     AS CountIn_ProductionUnion_un    
                     , tmp.CountOut_Sale               AS CountOut_Sale_un              
                     , tmp.CountOut_Loss               AS CountOut_Loss_un              
                     , tmp.CountOut_Send               AS CountOut_Send_un              
                     , tmp.CountOut_ProductionSeparate AS CountOut_ProductionSeparate_un
                     , tmp.CountOut_ProductionUnion    AS CountOut_ProductionUnion_un
                     , 0 ::TFloat AS CountEnd  
                     , tmp.OperDate ::TDateTime AS OperDate
                FROM tmpMI_UnComplete AS tmp
                WHERE COALESCE (tmp.CountIncome,0) <> 0
                   OR COALESCE (tmp.CountIn_Loss,0) <> 0
                   OR COALESCE (tmp.CountIn_Send,0) <> 0
                   OR COALESCE (tmp.CountIn_ReturnIn,0) <> 0
                   OR COALESCE (tmp.CountIn_ProductionSeparate,0) <> 0
                   OR COALESCE (tmp.CountIn_ProductionUnion,0) <> 0
                   OR COALESCE (tmp.CountOut_Sale,0) <> 0
                   OR COALESCE (tmp.CountOut_Loss,0) <> 0
                   OR COALESCE (tmp.CountOut_Send,0) <> 0
                   OR COALESCE (tmp.CountOut_ProductionSeparate,0) <> 0
                   OR COALESCE (tmp.CountOut_ProductionUnion,0) <> 0
                )
 

    , tmpResult AS (SELECT tmp.LocationId
                         , tmp.GoodsId
                         , tmp.GoodsKindId
                         , MAX (tmp.OperDate) AS OperDate
                         , SUM (COALESCE (tmp.CountStart,0)) AS CountStart
                         , SUM (COALESCE (tmp.CountEnd,0))   AS CountEnd
                         , SUM (COALESCE (tmp.Count_Inventory,0)) AS Count_Inventory
                         , SUM (COALESCE (tmp.CountStart,0) 
                              + COALESCE (tmp.CountIn_Income,0)
                              + COALESCE (tmp.CountIn_Loss,0)
                              + COALESCE (tmp.CountIn_Send,0)
                              + COALESCE (tmp.CountIn_ReturnIn,0)
                              + COALESCE (tmp.CountIn_ProductionSeparate,0)
                              + COALESCE (tmp.CountIn_ProductionUnion,0)
                              - COALESCE (tmp.CountOut_Sale,0)
                              - COALESCE (tmp.CountOut_Loss,0)
                              - COALESCE (tmp.CountOut_Send,0)
                              - COALESCE (tmp.CountOut_ProductionSeparate,0)
                              - COALESCE (tmp.CountOut_ProductionUnion,0)
                              
                              + COALESCE (tmp.CountIn_Income_un,0)
                              + COALESCE (tmp.CountIn_Loss_un,0)
                              + COALESCE (tmp.CountIn_Send_un,0)
                              + COALESCE (tmp.CountIn_ReturnIn_un,0)
                              + COALESCE (tmp.CountIn_ProductionSeparate_un,0)
                              + COALESCE (tmp.CountIn_ProductionUnion_un,0)
                              - COALESCE (tmp.CountOut_Sale_un,0)
                              - COALESCE (tmp.CountOut_Loss_un,0)
                              - COALESCE (tmp.CountOut_Send_un,0)
                              - COALESCE (tmp.CountOut_ProductionSeparate_un,0)
                              - COALESCE (tmp.CountOut_ProductionUnion_un,0) ) ::TFloat AS CountEnd_calc

                         , SUM (COALESCE (tmp.CountIn_Income,0))                 AS CountIn_Income
                         , SUM (COALESCE (tmp.CountIn_Loss,0))                   AS CountIn_Loss
                         , SUM (COALESCE (tmp.CountIn_Send,0))                   AS CountIn_Send
                         , SUM (COALESCE (tmp.CountIn_ReturnIn,0))               AS CountIn_ReturnIn
                         , SUM (COALESCE (tmp.CountIn_ProductionSeparate,0))     AS CountIn_ProductionSeparate
                         , SUM (COALESCE (tmp.CountIn_ProductionUnion,0))        AS CountIn_ProductionUnion
                         , SUM (COALESCE (tmp.CountOut_Sale,0))                  AS CountOut_Sale
                         , SUM (COALESCE (tmp.CountOut_Loss,0))                  AS CountOut_Loss
                         , SUM (COALESCE (tmp.CountOut_Send,0))                  AS CountOut_Send
                         , SUM (COALESCE (tmp.CountOut_ProductionSeparate,0))    AS CountOut_ProductionSeparate
                         , SUM (COALESCE (tmp.CountOut_ProductionUnion,0))       AS CountOut_ProductionUnion
                         , SUM (COALESCE (tmp.CountIn_Income_un,0))              AS CountIn_Income_un
                         , SUM (COALESCE (tmp.CountIn_Loss_un,0))                AS CountIn_Loss_un
                         , SUM (COALESCE (tmp.CountIn_Send_un,0))                AS CountIn_Send_un
                         , SUM (COALESCE (tmp.CountIn_ReturnIn_un,0))            AS CountIn_ReturnIn_un
                         , SUM (COALESCE (tmp.CountIn_ProductionSeparate_un,0))  AS CountIn_ProductionSeparate_un
                         , SUM (COALESCE (tmp.CountIn_ProductionUnion_un,0))     AS CountIn_ProductionUnion_un
                         , SUM (COALESCE (tmp.CountOut_Sale_un,0))               AS CountOut_Sale_un
                         , SUM (COALESCE (tmp.CountOut_Loss_un,0))               AS CountOut_Loss_un
                         , SUM (COALESCE (tmp.CountOut_Send_un,0))               AS CountOut_Send_un
                         , SUM (COALESCE (tmp.CountOut_ProductionSeparate_un,0)) AS CountOut_ProductionSeparate_un
                         , SUM (COALESCE (tmp.CountOut_ProductionUnion_un,0))    AS CountOut_ProductionUnion_un
                    FROM tmpUnion AS tmp
                    GROUP BY tmp.LocationId
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           --, tmp.OperDate
                    )
  
  
     -- !!!РЕЗУЛЬТАТ!!!
     SELECT CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
           , Object_Location.ObjectCode     AS LocationCode
           , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
   
           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
   
           , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
           , Object_Goods.ObjectCode                                        AS GoodsCode
           , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
           , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
           , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
           
           , Object_Measure.ValueData       AS MeasureName
           , ObjectFloat_Weight.ValueData   AS Weight
   
           , tmpResult.CountStart                   :: TFloat 
           , tmpResult.CountEnd                     :: TFloat 
           , tmpResult.CountEnd_calc                :: TFloat 

           , tmpResult.Count_Inventory              :: TFloat
           , tmpResult.CountIn_Income               :: TFloat
           , tmpResult.CountIn_Loss                 :: TFloat
           , tmpResult.CountIn_Send                 :: TFloat
           , tmpResult.CountIn_ReturnIn             :: TFloat
           , tmpResult.CountIn_ProductionSeparate   :: TFloat
           , tmpResult.CountIn_ProductionUnion      :: TFloat
           , tmpResult.CountOut_Sale                :: TFloat
           , tmpResult.CountOut_Loss                :: TFloat
           , tmpResult.CountOut_Send                :: TFloat
           , tmpResult.CountOut_ProductionSeparate  :: TFloat
           , tmpResult.CountOut_ProductionUnion     :: TFloat
           , tmpResult.CountIn_Income_un            :: TFloat
           , tmpResult.CountIn_Loss_un              :: TFloat
           , tmpResult.CountIn_Send_un              :: TFloat
           , tmpResult.CountIn_ReturnIn_un          :: TFloat
           , tmpResult.CountIn_ProductionSeparate_un   :: TFloat
           , tmpResult.CountIn_ProductionUnion_un      :: TFloat
           , tmpResult.CountOut_Sale_un                :: TFloat
           , tmpResult.CountOut_Loss_un                :: TFloat
           , tmpResult.CountOut_Send_un                :: TFloat
           , tmpResult.CountOut_ProductionSeparate_un  :: TFloat
           , tmpResult.CountOut_ProductionUnion_un     :: TFloat
           , tmpResult.OperDate ::TDateTime
           , (COALESCE ((tmpResult.OperDate+INTERVAL '1 DAY'), inStartDate))  ::TDateTime AS OperDate_byReport

/*        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountOut ELSE 0 END :: TFloat AS CountOut_sh
        , (tmpResult.CountOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_Weight
*/
     FROM tmpResult
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpResult.LocationId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.02.22         *
*/

-- тест
-- select * from gpReport_Goods_inventory(inStartDate := ('07.03.2022')::TDateTime , inEndDate := ('14.03.2022')::TDateTime , inAccountGroupId := 9015 , inUnitGroupId := 8439 , inLocationId := 0 , inGoodsGroupId := 1945 , inGoodsId := 0 ,  inSession := '9457');


/*
SELECT MIContainer.WhereObjectId_Analyzer AS LocationId
                                 , MIContainer.ObjectId_Analyzer AS GoodsId
                               --  , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                  THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Income

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_Sale())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END ) AS CountOut_Sale

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 *COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountOut_Send
                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_Send())
                                              AND MIContainer.isActive = TRUE
                                             THEN  COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Send
                                        
                                 , SUM (CASE WHEN MIContainer.OperDate >= '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion())
                                              AND MIContainer.isActive = TRUE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountIn_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_ProductionUnion
                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_ProductionSeparate

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                                              AND MIContainer.isActive = FALSE
                                             THEN -1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END
                                       ) AS CountOut_Loss

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_ReturnIn())
                                             THEN 1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_ReturnIn

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate())
                                              AND MIContainer.isActive = TRUE
                                             THEN COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_ProductionSeparate

                                 , SUM (CASE WHEN MIContainer.OperDate > '06.03.2022'
                                              AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                                              AND MIContainer.isActive = TRUE
                                             THEN 1 * COALESCE (MIContainer.Amount, 0)
                                             ELSE 0
                                        END) AS CountIn_Loss

                           FROM MovementItemContainer AS MIContainer
                           WHERE  MIContainer.OperDate > '28.02.2022'
                           AND MIContainer.DescId = zc_Container_Count()
                           AND MIContainer.WhereObjectId_Analyzer = 8442 
                           AND  MIContainer.ObjectId_Analyzer = 4187 
and MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate())
                           GROUP BY MIContainer.WhereObjectId_Analyzer
                                  , MIContainer.ObjectId_Analyzer
                                 
with 
 tmpObjectGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1945 ) AS lfObject_Goods_byGoodsGroup
                    
                          )
    -- , tmpGoods AS 
(SELECT tmpObjectGoods.GoodsId 
                         , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                    FROM tmpObjectGoods
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpObjectGoods.GoodsId
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
where  tmpObjectGoods.GoodsId  = 4187
                   )

4187;1935  -- товар  код 4102,   участок бойни должно біть 413.8   а у меня 910,8

(SELECT Movement.*
                                , MovementLinkObject_From.ObjectId AS FromId
                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                --LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                
                           WHERE Movement.DescId = zc_Movement_Inventory()
                           AND Movement.OperDate >= '01.02.2022'
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
and MovementLinkObject_From.ObjectId =  8442
                           )

*/