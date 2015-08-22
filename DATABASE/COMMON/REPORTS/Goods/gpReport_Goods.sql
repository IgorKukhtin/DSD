-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitGroupId  Integer   ,
    IN inLocationId   Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inGoodsId      Integer   ,
    IN inIsPartner    Boolean   ,
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar, MovementDescName_order TVarChar
              , isActive Boolean, isRemains Boolean, isRePrice Boolean, isInv Boolean
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, PartionGoods TVarChar
              , GoodsCode_parent Integer, GoodsName_parent TVarChar, GoodsKindName_parent TVarChar
              , Price TFloat, Price_branch TFloat, Price_end TFloat, Price_branch_end TFloat, Price_partner TFloat
              , SummPartnerIn TFloat, SummPartnerOut TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat, Amount TFloat
              , SummStart TFloat, SummStart_branch TFloat, SummIn TFloat, SummIn_branch TFloat, SummOut TFloat, SummOut_branch TFloat, SummEnd TFloat, SummEnd_branch TFloat, Summ TFloat, Summ_branch TFloat
              , Amount_Change TFloat, Summ_Change_branch TFloat, Summ_Change_zavod TFloat
              , Amount_40200 TFloat, Summ_40200_branch TFloat, Summ_40200_zavod TFloat
              , Amount_Loss TFloat, Summ_Loss_branch TFloat, Summ_Loss_zavod TFloat
              , isPage3 Boolean, isExistsPage3 Boolean
               )  
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsBranch Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������������!!!
     vbIsBranch:= EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);


    IF inGoodsId = 0 AND inGoodsGroupId <> 0
    THEN
         RETURN QUERY
         SELECT gpReport.MovementId, gpReport.InvNumber, gpReport.OperDate, gpReport.OperDatePartner, gpReport.MovementDescName, gpReport.MovementDescName_order
              , gpReport.isActive, gpReport.isRemains, gpReport.isRePrice, gpReport.isInv
              , gpReport.LocationDescName, gpReport.LocationCode, gpReport.LocationName
              , gpReport.CarCode, gpReport.CarName
              , gpReport.ObjectByDescName, gpReport.ObjectByCode, gpReport.ObjectByName
              , gpReport.PaidKindName
              , gpReport.GoodsCode, gpReport.GoodsName, gpReport.GoodsKindName, gpReport.GoodsKindName_complete, gpReport.PartionGoods
              , gpReport.GoodsCode_parent, gpReport.GoodsName_parent, gpReport.GoodsKindName_parent
              , gpReport.Price, gpReport.Price_branch, gpReport.Price_end, gpReport.Price_branch_end, gpReport.Price_partner
              , gpReport.SummPartnerIn, gpReport.SummPartnerOut
              , gpReport.AmountStart, gpReport.AmountIn, gpReport.AmountOut, gpReport.AmountEnd, gpReport.Amount
              , gpReport.SummStart, gpReport.SummStart_branch, gpReport.SummIn, gpReport.SummIn_branch, gpReport.SummOut, gpReport.SummOut_branch, gpReport.SummEnd, gpReport.SummEnd_branch, gpReport.Summ, gpReport.Summ_branch
              , gpReport.Amount_Change, gpReport.Summ_Change_branch, gpReport.Summ_Change_zavod
              , gpReport.Amount_40200, gpReport.Summ_40200_branch, gpReport.Summ_40200_zavod
              , gpReport.Amount_Loss, gpReport.Summ_Loss_branch, gpReport.Summ_Loss_zavod
              , gpReport.isPage3, gpReport.isExistsPage3
         FROM gpReport_GoodsGroup (inStartDate   := inStartDate
                                 , inEndDate     := inEndDate
                                 , inUnitGroupId := inUnitGroupId
                                 , inLocationId  := inLocationId
                                 , inGoodsGroupId:= inGoodsGroupId
                                 , inIsPartner   := inIsPartner
                                 , inSession     := inSession
                                  ) AS gpReport;
    ELSE

    RETURN QUERY
    WITH tmpWhere AS (SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId, inGoodsId AS GoodsId FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId, inGoodsId AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Car() AND (Object.Id = inLocationId OR COALESCE(inLocationId, 0) = 0)
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId, inGoodsId AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Member() AND (Object.Id = inLocationId OR COALESCE(inLocationId, 0) = 0)
                    )
       , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , Container.Amount
                                FROM tmpWhere
                                     INNER JOIN Container ON Container.ObjectId = tmpWhere.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN ContainerLinkObject AS CLO_Location ON CLO_Location.ContainerId = Container.Id
                                                                                   AND CLO_Location.DescId = tmpWhere.DescId
                                                                                   AND CLO_Location.ObjectId = tmpWhere.LocationId
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
                               )
                , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
                                       , tmpContainer_Count.PartionGoodsId
                                       , tmpContainer_Count.Amount
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                   THEN MIContainer.ContainerId_Analyzer
                                              ELSE 0
                                         END AS ContainerId_Analyzer
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   THEN MIContainer.MovementId
                                              ELSE 0
                                         END AS MovementId
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   THEN MIContainer.MovementItemId
                                              ELSE 0
                                         END AS MovementItemId
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS Amount_Period
                                       , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                                       , MIContainer.MovementDescId
                                       , MIContainer.isActive
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.PartionGoodsId
                                         , tmpContainer_Count.Amount
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                     THEN MIContainer.ContainerId_Analyzer
                                                ELSE 0
                                           END
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementId
                                                ELSE 0
                                           END
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                     THEN MIContainer.MovementItemId
                                                ELSE 0
                                           END
                                         , MIContainer.MovementDescId
                                         , MIContainer.isActive
                                 )
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , tmpContainer_Count.LocationId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.GoodsKindId
                                    , tmpContainer_Count.PartionGoodsId
                                    , Object_Account_View.AccountDirectionId
                                    , Container.Id AS ContainerId_Summ
                                    , Container.Amount
                               FROM tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                        AND Container.DescId = zc_Container_Summ()
                                    LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Container.ObjectId
                               WHERE Object_Account_View.AccountDirectionId <> zc_Enum_AccountDirection_60200() OR vbIsBranch = FALSE
                              )
                , tmpMI_Summ AS (SELECT tmpContainer_Summ.AccountDirectionId
                                      , tmpContainer_Summ.ContainerId_Count AS ContainerId
                                      , tmpContainer_Summ.LocationId
                                      , tmpContainer_Summ.GoodsId
                                      , tmpContainer_Summ.GoodsKindId
                                      , tmpContainer_Summ.PartionGoodsId
                                      , tmpContainer_Summ.Amount
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  THEN MIContainer.AnalyzerId
                                             ELSE 0
                                        END AS AnalyzerId
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                  THEN MIContainer.ContainerId_Analyzer
                                             ELSE 0
                                        END AS ContainerId_Analyzer
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  THEN MIContainer.MovementId
                                             ELSE 0
                                        END AS MovementId
                                      , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  THEN MIContainer.MovementItemId
                                             ELSE 0
                                        END AS MovementItemId
                                      , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_Period
                                      , SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_Total
                                      , MIContainer.MovementDescId
                                      , MIContainer.isActive
                                 FROM tmpContainer_Summ
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId_Summ
                                                                                    AND MIContainer.OperDate >= inStartDate
                                 GROUP BY tmpContainer_Summ.AccountDirectionId
                                        , tmpContainer_Summ.ContainerId_Count
                                        , tmpContainer_Summ.ContainerId_Summ
                                        , tmpContainer_Summ.LocationId
                                        , tmpContainer_Summ.GoodsId
                                        , tmpContainer_Summ.GoodsKindId
                                        , tmpContainer_Summ.PartionGoodsId
                                        , tmpContainer_Summ.Amount
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.AnalyzerId
                                               ELSE 0
                                          END
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                    THEN MIContainer.ContainerId_Analyzer
                                               ELSE 0
                                          END
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementId
                                               ELSE 0
                                          END
                                        , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    THEN MIContainer.MovementItemId
                                               ELSE 0
                                          END
                                        , MIContainer.MovementDescId
                                        , MIContainer.isActive
                                )

         , tmpMI_Summ_group AS (SELECT tmpMI_Summ.MovementId, tmpMI_Summ.MovementItemId, tmpMI_Summ.ContainerId_Analyzer, tmpMI_Summ.isActive FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0 GROUP BY tmpMI_Summ.MovementId, tmpMI_Summ.MovementItemId, tmpMI_Summ.ContainerId_Analyzer, tmpMI_Summ.isActive)
         , tmpMI_SummPartner AS (SELECT tmpMI_Summ_group.MovementItemId
                                      , SUM (MIContainer.Amount * CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnOut(), zc_Movement_Sale()) THEN 1 ELSE -1 END) AS Amount
                                 FROM tmpMI_Summ_group
                                      INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId     = tmpMI_Summ_group.MovementId
                                                                                     AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                                     AND MIContainer.MovementItemId = tmpMI_Summ_group.MovementItemId
                                                                                     AND MIContainer.ContainerId    = tmpMI_Summ_group.ContainerId_Analyzer
                                                                                     AND MIContainer.isActive      <> tmpMI_Summ_group.isActive
                                 GROUP BY tmpMI_Summ_group.MovementItemId
                                )
   SELECT Movement.Id AS MovementId
        , Movement.InvNumber
        , Movement.OperDate
        , MovementDate_OperDatePartner.ValueData AS OperDatePartner

        , CASE WHEN MovementDesc.Id = zc_Movement_Inventory() AND tmpMIContainer_group.isReprice = TRUE
                    THEN MovementDesc.ItemName || ' ����������'
               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE
                    THEN MovementDesc.ItemName || ' ������'
               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE
                    THEN MovementDesc.ItemName || ' ������'
               ELSE MovementDesc.ItemName
          END :: TVarChar AS MovementDescName

        , CASE WHEN Movement.DescId = zc_Movement_Income()
                    THEN '01 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ReturnOut()
                    THEN '02 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Send() AND tmpMIContainer_group.isActive = TRUE
                    THEN '03 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Send() AND tmpMIContainer_group.isActive = FALSE
                    THEN '04 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ProductionUnion() AND tmpMIContainer_group.isActive = TRUE
                    THEN '05 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ProductionUnion() AND tmpMIContainer_group.isActive = FALSE
                    THEN '06 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ProductionSeparate() AND tmpMIContainer_group.isActive = TRUE
                    THEN '07 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ProductionSeparate() AND tmpMIContainer_group.isActive = FALSE
                    THEN '08 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_SendOnPrice() AND tmpMIContainer_group.isActive = TRUE
                    THEN '109 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_SendOnPrice() AND tmpMIContainer_group.isActive = FALSE
                    THEN '110 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Sale()
                    THEN '111 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_ReturnIn()
                    THEN '112 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Loss()
                    THEN '13 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = TRUE  AND tmpMIContainer_group.isRePrice = FALSE
                    THEN '14 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = FALSE AND tmpMIContainer_group.isRePrice = FALSE
                    THEN '15 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = TRUE  AND tmpMIContainer_group.isRePrice = TRUE
                    THEN '16 ' || MovementDesc.ItemName
               WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = FALSE AND tmpMIContainer_group.isRePrice = TRUE
                    THEN '17 ' || MovementDesc.ItemName
               ELSE '201 ' || MovementDesc.ItemName
          END :: TVarChar AS MovementDescName_order

        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN NULL ELSE tmpMIContainer_group.isActive END :: Boolean AS isActive
        , CASE WHEN tmpMIContainer_group.MovementId <= 0 THEN TRUE ELSE FALSE END :: Boolean AS isRemains
        , tmpMIContainer_group.isRePrice
        , CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN TRUE ELSE FALSE END :: Boolean AS isInv

        , ObjectDesc.ItemName            AS LocationDescName
        , Object_Location.ObjectCode     AS LocationCode
        , Object_Location.ValueData      AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , ObjectDesc_By.ItemName         AS ObjectByDescName
        , Object_By.ObjectCode           AS ObjectByCode
        , Object_By.ValueData            AS ObjectByName

        , Object_PaidKind.ValueData AS PaidKindName

        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        , Object_GoodsKind.ValueData AS GoodsKindName
        , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete
        , COALESCE (CASE WHEN Object_PartionGoods.ValueData <> '' THEN Object_PartionGoods.ValueData ELSE NULL END, CASE WHEN tmpMIContainer_group.PartionGoods_item <> '' THEN '*' || tmpMIContainer_group.PartionGoods_item ELSE '' END) :: TVarChar AS PartionGoods
        , Object_Goods_parent.ObjectCode AS GoodsCode_parent
        , Object_Goods_parent.ValueData  AS GoodsName_parent
        , Object_GoodsKind_parent.ValueData AS GoodsKindName_parent

        , CAST (CASE WHEN Movement.DescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpMIContainer_group.MovementId = -1 AND */tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.AmountStart
                     /*WHEN tmpMIContainer_group.MovementId = -2 AND tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd*/
                     WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummIn / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummOut / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS Price
        , CAST (CASE WHEN Movement.DescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpMIContainer_group.MovementId = -1 AND */tmpMIContainer_group.AmountStart <> 0
                          THEN tmpMIContainer_group.SummStart_branch / tmpMIContainer_group.AmountStart
                     /*WHEN tmpMIContainer_group.MovementId = -2 AND tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd*/
                     WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummIn_branch / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummOut_branch / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS Price_branch

        , CAST (CASE WHEN tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.AmountEnd
                     ELSE 0
                END AS TFloat) AS Price_end
        , CAST (CASE WHEN tmpMIContainer_group.AmountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd_branch / tmpMIContainer_group.AmountEnd
                     ELSE 0
                END AS TFloat) AS Price_branch_end

        , CAST (CASE WHEN tmpMIContainer_group.AmountIn <> 0
                          THEN tmpMIContainer_group.SummPartnerIn / tmpMIContainer_group.AmountIn
                     WHEN tmpMIContainer_group.AmountOut <> 0
                          THEN tmpMIContainer_group.SummPartnerOut / tmpMIContainer_group.AmountOut
                     ELSE 0
                END AS TFloat) AS Price_partner

        , CAST (tmpMIContainer_group.SummPartnerIn AS TFloat)      AS SummPartnerIn
        , CAST (tmpMIContainer_group.SummPartnerOut AS TFloat)     AS SummPartnerOut

        , CAST (tmpMIContainer_group.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpMIContainer_group.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpMIContainer_group.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpMIContainer_group.AmountEnd AS TFloat)   AS AmountEnd 
        , CAST ((tmpMIContainer_group.AmountIn - tmpMIContainer_group.AmountOut)
              * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Amount

        , CAST (tmpMIContainer_group.SummStart AS TFloat)   AS SummStart
        , tmpMIContainer_group.SummStart_branch :: TFloat   AS SummStart_branch
        , CAST (tmpMIContainer_group.SummIn AS TFloat)      AS SummIn
        , tmpMIContainer_group.SummIn_branch :: TFloat      AS SummIn_branch
        , CAST (tmpMIContainer_group.SummOut AS TFloat)     AS SummOut
        , tmpMIContainer_group.SummOut_branch :: TFloat     AS SummOut_branch
        , CAST (tmpMIContainer_group.SummEnd AS TFloat)     AS SummEnd
        , tmpMIContainer_group.SummEnd_branch :: TFloat     AS SummEnd_branch
        , CAST ((tmpMIContainer_group.SummIn - tmpMIContainer_group.SummOut)
              * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Summ
        , CAST ((tmpMIContainer_group.SummIn_branch - tmpMIContainer_group.SummOut_branch)
              * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Summ_branch

        , 0 :: TFloat AS Amount_Change, 0 :: TFloat AS Summ_Change_branch, 0 :: TFloat AS Summ_Change_zavod
        , 0 :: TFloat AS Amount_40200,  0 :: TFloat AS Summ_40200_branch,  0 :: TFloat AS Summ_40200_zavod
        , 0 :: TFloat AS Amount_Loss,   0 :: TFloat AS Summ_Loss_branch,   0 :: TFloat AS Summ_Loss_zavod

        , FALSE AS isPage3
        , FALSE AS isExistsPage3

   FROM (SELECT tmpMIContainer_all.MovementId
              -- , 0 AS MovementItemId
              , tmpMIContainer_all.ParentId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.ContainerId_Analyzer
              , tmpMIContainer_all.isActive
              , tmpMIContainer_all.isReprice
              , tmpMIContainer_all.PartionGoods_item
              , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
              , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
              , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
              , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut
              , SUM (tmpMIContainer_all.SummStart)        AS SummStart
              , SUM (tmpMIContainer_all.SummStart_branch) AS SummStart_branch
              , SUM (tmpMIContainer_all.SummEnd)          AS SummEnd
              , SUM (tmpMIContainer_all.SummEnd_branch)   AS SummEnd_branch
              , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                          THEN SUM (tmpMIContainer_all.SummIn)
                     WHEN SUM (tmpMIContainer_all.AmountIn) > 0 AND SUM (tmpMIContainer_all.AmountOut) = 0
                          THEN SUM (tmpMIContainer_all.SummIn - tmpMIContainer_all.SummOut)
                     ELSE 0
                END AS SummIn
              , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                          THEN SUM (tmpMIContainer_all.SummIn_branch)
                     WHEN SUM (tmpMIContainer_all.AmountIn) > 0 AND SUM (tmpMIContainer_all.AmountOut) = 0
                          THEN SUM (tmpMIContainer_all.SummIn_branch - tmpMIContainer_all.SummOut_branch)
                     ELSE 0
                END AS SummIn_branch
              , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                          THEN SUM (tmpMIContainer_all.SummOut)
                     WHEN SUM (tmpMIContainer_all.AmountOut) > 0 AND SUM (tmpMIContainer_all.AmountIn) = 0
                          THEN SUM (tmpMIContainer_all.SummOut - tmpMIContainer_all.SummIn)
                     ELSE 0
                END AS SummOut
              , CASE WHEN SUM (tmpMIContainer_all.AmountIn) <> 0 AND SUM (tmpMIContainer_all.AmountOut) <> 0
                          THEN SUM (tmpMIContainer_all.SummOut_branch)
                     WHEN SUM (tmpMIContainer_all.AmountOut) > 0 AND SUM (tmpMIContainer_all.AmountIn) = 0
                          THEN SUM (tmpMIContainer_all.SummOut_branch - tmpMIContainer_all.SummIn_branch)
                     ELSE 0
                END AS SummOut_branch
              , SUM (tmpMIContainer_all.SummPartnerIn)  AS SummPartnerIn
              , SUM (tmpMIContainer_all.SummPartnerOut) AS SummPartnerOut
        FROM (-- 1.1. ������� ���-��
              SELECT -1 AS MovementId
                   -- , 0 AS MovementItemId
                   , 0 AS ParentId
                   , tmpMI_Count.ContainerId
                   , tmpMI_Count.LocationId
                   , tmpMI_Count.GoodsId
                   , tmpMI_Count.GoodsKindId
                   , tmpMI_Count.PartionGoodsId
                   , 0    AS ContainerId_Analyzer
                   , TRUE  AS isActive
                   , FALSE AS isReprice
                   , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total)                                   AS AmountStart
                   , tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) + SUM (tmpMI_Count.Amount_Period) AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummPartnerIn
                   , 0 AS SummPartnerOut
                   , 0 AS SummStart
                   , 0 AS SummStart_branch
                   , 0 AS SummEnd
                   , 0 AS SummEnd_branch
                   , 0 AS SummIn
                   , 0 AS SummIn_branch
                   , 0 AS SummOut
                   , 0 AS SummOut_branch
                   , ''  AS PartionGoods_item
              FROM tmpMI_Count
              GROUP BY tmpMI_Count.ContainerId
                     , tmpMI_Count.LocationId
                     , tmpMI_Count.GoodsId
                     , tmpMI_Count.GoodsKindId
                     , tmpMI_Count.PartionGoodsId
                     , tmpMI_Count.Amount
              HAVING tmpMI_Count.Amount - SUM (tmpMI_Count.Amount_Total) <> 0
                  OR SUM (tmpMI_Count.Amount_Period) <> 0
             UNION ALL
              -- 1.2. �������� ���-��
              SELECT tmpMI_Count.MovementId
                   -- , tmpMI_Count.MovementItemId
                   , COALESCE (MovementItem.ParentId, 0) AS ParentId
                   , tmpMI_Count.ContainerId
                   , tmpMI_Count.LocationId
                   , tmpMI_Count.GoodsId
                   , tmpMI_Count.GoodsKindId
                   , tmpMI_Count.PartionGoodsId
                   , tmpMI_Count.ContainerId_Analyzer
                   , tmpMI_Count.isActive
                   , FALSE AS isReprice
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN      tmpMI_Count.Amount_Period ELSE 0 END AS AmountIn
                   , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN -1 * tmpMI_Count.Amount_Period ELSE 0 END AS AmountOut
                   , CASE WHEN tmpMI_Count.Amount_Period > 0 THEN tmpMI_SummPartner.Amount ELSE 0 END AS SummPartnerIn
                   , CASE WHEN tmpMI_Count.Amount_Period < 0 THEN tmpMI_SummPartner.Amount ELSE 0 END AS SummPartnerOut
                   , 0 AS SummStart
                   , 0 AS SummStart_branch
                   , 0 AS SummEnd
                   , 0 AS SummEnd_branch
                   , 0 AS SummIn
                   , 0 AS SummIn_branch
                   , 0 AS SummOut
                   , 0 AS SummOut_branch
                   , CASE WHEN tmpMI_Count.MovementDescId = zc_Movement_ProductionSeparate()
                               THEN MovementString_PartionGoods.ValueData
                          WHEN MIString_PartionGoods.ValueData <> ''
                               THEN MIString_PartionGoods.ValueData
                          ELSE TO_CHAR (MIDate_PartionGoods.ValueData, 'DD.MM.YYYY')
                     END AS PartionGoods_item
              FROM tmpMI_Count
                   LEFT JOIN tmpMI_SummPartner ON tmpMI_SummPartner.MovementItemId = tmpMI_Count.MovementItemId

                   LEFT JOIN MovementItem ON MovementItem.Id = tmpMI_Count.MovementItemId
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementString AS MovementString_PartionGoods
                                            ON MovementString_PartionGoods.MovementId = tmpMI_Count.MovementId
                                           AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                           AND tmpMI_Count.MovementDescId = zc_Movement_ProductionSeparate()
              WHERE tmpMI_Count.Amount_Period <> 0
             UNION ALL
              -- 2.1. ������� �����
              SELECT -1 AS MovementId
                   -- , 0 AS MovementItemId
                   , 0 ParentId
                   , tmpMI_Summ.ContainerId
                   , tmpMI_Summ.LocationId
                   , tmpMI_Summ.GoodsId
                   , tmpMI_Summ.GoodsKindId
                   , tmpMI_Summ.PartionGoodsId
                   , 0 AS ContainerId_Analyzer
                   , TRUE AS isActive
                   , FALSE AS isReprice
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummPartnerIn
                   , 0 AS SummPartnerOut
                   , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) AS SummStart
                   , CASE WHEN tmpMI_Summ.AccountDirectionId <> zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) ELSE 0 END AS SummStart_branch
                   , tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) + SUM (tmpMI_Summ.Amount_Period) AS SummEnd
                   , CASE WHEN tmpMI_Summ.AccountDirectionId <> zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) + SUM (tmpMI_Summ.Amount_Period) ELSE 0 END AS SummEnd_branch
                   , 0 AS SummIn
                   , 0 AS SummIn_branch
                   , 0 AS SummOut
                   , 0 AS SummOut_branch
                   , '' AS PartionGoods_item
              FROM tmpMI_Summ
              GROUP BY tmpMI_Summ.AccountDirectionId
                     , tmpMI_Summ.ContainerId
                     , tmpMI_Summ.LocationId
                     , tmpMI_Summ.GoodsId
                     , tmpMI_Summ.GoodsKindId
                     , tmpMI_Summ.PartionGoodsId
                     , tmpMI_Summ.Amount
              HAVING tmpMI_Summ.Amount - SUM (tmpMI_Summ.Amount_Total) <> 0
                  OR SUM (tmpMI_Summ.Amount_Period) <> 0
             UNION ALL
              -- 2.2. �������� �����
              SELECT tmpMI_Summ.MovementId
                   -- , tmpMI_Summ.MovementItemId
                   , COALESCE (MovementItem.ParentId, 0) AS ParentId
                   , tmpMI_Summ.ContainerId
                   , tmpMI_Summ.LocationId
                   , tmpMI_Summ.GoodsId
                   , tmpMI_Summ.GoodsKindId
                   , tmpMI_Summ.PartionGoodsId
                   , tmpMI_Summ.ContainerId_Analyzer
                   , tmpMI_Summ.isActive
                   , CASE WHEN tmpMI_Summ.AnalyzerId = zc_Enum_AccountGroup_60000() THEN TRUE ELSE FALSE END AS isReprice
                   , 0 AS AmountStart
                   , 0 AS AmountEnd
                   , 0 AS AmountIn
                   , 0 AS AmountOut
                   , 0 AS SummPartnerIn
                   , 0 AS SummPartnerOut
                   , 0 AS SummStart
                   , 0 AS SummStart_branch
                   , 0 AS SummEnd
                   , 0 AS SummEnd_branch
                   , CASE WHEN tmpMI_Summ.Amount_Period > 0 THEN tmpMI_Summ.Amount_Period ELSE 0 END AS SummIn
                   , CASE WHEN tmpMI_Summ.Amount_Period > 0 AND tmpMI_Summ.AccountDirectionId <> zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.Amount_Period ELSE 0 END AS SummIn_branch
                   , CASE WHEN tmpMI_Summ.Amount_Period < 0 THEN -1 * tmpMI_Summ.Amount_Period ELSE 0 END AS SummOut
                   , CASE WHEN tmpMI_Summ.Amount_Period < 0 AND tmpMI_Summ.AccountDirectionId <> zc_Enum_AccountDirection_60200() THEN -1 * tmpMI_Summ.Amount_Period ELSE 0 END AS SummOut_branch
                   , CASE WHEN tmpMI_Summ.MovementDescId = zc_Movement_ProductionSeparate()
                               THEN MovementString_PartionGoods.ValueData
                          WHEN MIString_PartionGoods.ValueData <> ''
                               THEN MIString_PartionGoods.ValueData
                          ELSE TO_CHAR (MIDate_PartionGoods.ValueData, 'DD.MM.YYYY')
                     END AS PartionGoods_item
              FROM tmpMI_Summ
                   LEFT JOIN MovementItem ON MovementItem.Id = tmpMI_Summ.MovementItemId
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementString AS MovementString_PartionGoods
                                            ON MovementString_PartionGoods.MovementId = tmpMI_Summ.MovementId
                                           AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                           AND tmpMI_Summ.MovementDescId = zc_Movement_ProductionSeparate()
              WHERE tmpMI_Summ.Amount_Period <> 0
             ) AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.MovementId
                -- , tmpMIContainer_all.MovementItemId
                , tmpMIContainer_all.ParentId
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.ContainerId_Analyzer
                , tmpMIContainer_all.isActive
                , tmpMIContainer_all.isReprice
                , tmpMIContainer_all.PartionGoods_item
        ) AS tmpMIContainer_group
        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN ContainerLinkObject AS CLO_Object_By ON CLO_Object_By.ContainerId = tmpMIContainer_group.ContainerId_Analyzer
                                                      AND CLO_Object_By.DescId IN (zc_ContainerLinkObject_Partner(), zc_ContainerLinkObject_Member())
        LEFT JOIN MovementLinkObject AS MovementLinkObject_By
                                     ON MovementLinkObject_By.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_By.DescId = CASE WHEN Movement.DescId = zc_Movement_Income() THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                            WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId = zc_Movement_Loss() THEN zc_MovementLinkObject_ArticleLoss()
                                                                            WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN zc_MovementLinkObject_To()
                                                                       END
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = tmpMIContainer_group.MovementId
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                               ON MovementDate_OperDatePartner.MovementId = tmpMIContainer_group.MovementId
                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

        LEFT JOIN MovementItem AS MovementItem_parent ON MovementItem_parent.Id = tmpMIContainer_group.ParentId
        LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MovementItem_parent.ObjectId
        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_parent
                                         ON MILinkObject_GoodsKind_parent.MovementItemId = tmpMIContainer_group.ParentId
                                        AND MILinkObject_GoodsKind_parent.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind_parent ON Object_GoodsKind_parent.Id = MILinkObject_GoodsKind_parent.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_By ON Object_By.Id = CASE WHEN CLO_Object_By.ObjectId > 0 THEN CLO_Object_By.ObjectId ELSE MovementLinkObject_By.ObjectId END
        LEFT JOIN ObjectDesc AS ObjectDesc_By ON ObjectDesc_By.Id = Object_By.DescId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                             ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId
   ;

   END IF;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.08.15                                        * add inUnitGroupId AND inGoodsGroupId
 30.05.14                                        * ALL
 10.04.14                                        * ALL
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *  
*/

-- ����
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 1826, inIsPartner:= FALSE, inSession:= zfCalc_UserAdmin());
