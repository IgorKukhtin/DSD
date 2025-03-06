-- Function: gpReport_Goods ()

DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitGroupId  Integer   ,
    IN inLocationId   Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inGoodsId      Integer   ,
    IN inIsPartner    Boolean   ,
    IN inIsPartion    Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
              , isPeresort Boolean
              , MovementDescName TVarChar, MovementDescName_order TVarChar
              , isActive Boolean, isRemains Boolean, isRePrice Boolean, isInv Boolean
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar
              , Name_Scale TVarChar
              , GoodsKindName TVarChar, GoodsKindName_complete TVarChar
              , PartionGoods TVarChar
              , StorageId Integer, StorageName TVarChar
              , PartionModelId Integer, PartionModelName TVarChar
              , UnitId_partion Integer, UnitName_partion TVarChar, BranchName_partion TVarChar
              , PartNumber_partion  TVarChar
              , PartionCellName TVarChar, isPartionCell_Close Boolean
        
              , GoodsCode_parent Integer, GoodsName_parent TVarChar, GoodsKindName_parent TVarChar
              , Price TFloat, Price_branch TFloat, Price_end TFloat, Price_branch_end TFloat, Price_partner TFloat
              , SummPartnerIn TFloat, SummPartnerOut TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat, Amount TFloat 
              , AmountStart_weight TFloat, AmountIn_weight TFloat, AmountOut_weight TFloat, AmountEnd_weight TFloat
              , SummStart TFloat, SummStart_branch TFloat, SummIn TFloat, SummIn_branch TFloat, SummOut TFloat, SummOut_branch TFloat, SummEnd TFloat, SummEnd_branch TFloat, Summ TFloat, Summ_branch TFloat
              , Amount_Change TFloat, Summ_Change_branch TFloat, Summ_Change_zavod TFloat
              , Amount_40200 TFloat, Summ_40200_branch TFloat, Summ_40200_zavod TFloat
              , Amount_Loss TFloat, Summ_Loss_branch TFloat, Summ_Loss_zavod TFloat
              , isPage3 Boolean, isExistsPage3 Boolean
              , KVK TVarChar
              , PersonalKVKId Integer, PersonalKVKName TVarChar
              , PositionCode_KVK Integer, PositionName_KVK TVarChar
              , UnitCode_KVK Integer, UnitName_KVK TVarChar
              , PersonalGroupName TVarChar
              
              , InvNumber_Full   TVarChar
              , StartSale_promo  TDateTime
              , EndSale_promo    TDateTime
              , DayOfWeekName_doc     TVarChar   --день недели даты документа
              , DayOfWeekName_partner TVarChar   --день недели даты покупателя

              , OperDate_Protocol TDateTime
              , UserName_Protocol TVarChar
              , OperDate_Protocol_auto TDateTime
              , UserName_Protocol_auto TVarChar   
              , OperDate_Insert TDateTime
              , UserName_Insert TVarChar

              , OperDate_Protocol_mi TDateTime
              , UserName_Protocol_mi TVarChar
               )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsBranch Boolean;
 DECLARE vbIsSummIn Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!Нет прав!!! - Ограниченние - нет доступа к Отчету по остаткам
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11086934)
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав.';
    END IF;

    -- !!!определяется!!!
    vbIsBranch:= EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);

    -- !!!определяется!!!
    vbIsSummIn:= -- Ограничение просмотра с/с
                 NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
                ;

    IF inGoodsId = 0 AND inGoodsGroupId <> 0
    THEN
         RETURN QUERY
         WITH 
         
         gpReport AS (SELECT gpReport.MovementId, gpReport.InvNumber, gpReport.OperDate, gpReport.OperDatePartner
                           , gpReport.isPeresort
                           , gpReport.MovementDescName, gpReport.MovementDescName_order
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
                           
                           --
                           , '' :: TVarChar AS KVK
                           , 0              AS PersonalKVKId
                           , '' :: TVarChar AS PersonalKVKName
                           , 0              AS PositionCode_KVK
                           , '' :: TVarChar AS PositionName_KVK
                           , 0              AS UnitCode_KVK
                           , '' :: TVarChar AS UnitName_KVK
                           , '' :: TVarChar AS PersonalGroupName
             
                           , '' :: TVarChar   AS InvNumber_Full
                           , NULL ::TDateTime AS StartSale_promo
                           , NULL ::TDateTime AS EndSale_promo
                           , '' :: TVarChar   AS DayOfWeekName_doc       --день недели даты документа
                           , '' :: TVarChar   AS DayOfWeekName_partner   --день недели даты покупателя
                      FROM gpReport_GoodsGroup (inStartDate   := inStartDate
                                              , inEndDate     := inEndDate
                                              , inUnitGroupId := inUnitGroupId
                                              , inLocationId  := inLocationId
                                              , inGoodsGroupId:= inGoodsGroupId
                                              , inIsPartner   := inIsPartner
                                              , inSession     := inSession
                                               ) AS gpReport
                      )
       -- выбираем последнюю запись из протокола - дата/время + фио
     , tmpProtocol1 AS (SELECT MovementProtocol.MovementId
                             , MAX (CASE WHEN MovementProtocol.UserId NOT IN (zc_Enum_Process_Auto_PrimeCost()
                                                                            , zc_Enum_Process_Auto_ReComplete()
                                                                            , zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                                                                            , zc_Enum_Process_Auto_Defroster()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId
                             , MAX (CASE WHEN MovementProtocol.UserId     IN (zc_Enum_Process_Auto_PrimeCost()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId_Auto_Auto
                             , MAX (CASE WHEN MovementProtocol.UserId     IN (zc_Enum_Process_Auto_ReComplete()
                                                                            , zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                                                                            , zc_Enum_Process_Auto_Defroster()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId_Auto
                        FROM (SELECT DISTINCT gpReport.MovementId
                              FROM gpReport
                              WHERE gpReport.MovementId IS NOT NULL AND 1=0
                             ) AS tmp
                             INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmp.MovementId
                        GROUP BY MovementProtocol.MovementId
                       )
     , tmpProtocol AS (SELECT MovementProtocol.MovementId
                            , MovementProtocol.UserId
                            , MovementProtocol.OperDate
                            , Object_User.ValueData AS UserName

                            , MovementProtocol_auto.OperDate AS OperDate_auto
                            , Object_User_auto.ValueData     AS UserName_auto

                       FROM tmpProtocol1
                            INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmpProtocol1.MovementId
                                                       AND MovementProtocol.Id         = CASE WHEN tmpProtocol1.MaxId > 0 THEN tmpProtocol1.MaxId ELSE tmpProtocol1.MaxId_auto END
                            LEFT JOIN MovementProtocol AS MovementProtocol_auto
                                                       ON MovementProtocol_auto.MovementId = tmpProtocol1.MovementId
                                                      AND MovementProtocol_auto.Id         = tmpProtocol1.MaxId_Auto_Auto
                            LEFT JOIN Object AS Object_User      ON Object_User.Id      = MovementProtocol.UserId
                            LEFT JOIN Object AS Object_User_auto ON Object_User_auto.Id = MovementProtocol_auto.UserId
                      )  

     --
   , tmpProtocolInsert AS (SELECT tmp.MovementId
                                , tmp.OperDate
                                , tmp.UserId
                                , Object_User.ValueData AS UserName
                           FROM (SELECT *
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate ASC) AS Ord
                                 FROM MovementProtocol
                                 WHERE MovementProtocol.MovementId IN (SELECT DISTINCT gpReport.MovementId FROM gpReport)
                                 ) AS tmp
                                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId
                           WHERE tmp.Ord = 1
                          )
 
     -- РЕЗУЛЬТАТ
     SELECT -- gpReport.*  
 
          gpReport.MovementId
        , gpReport.InvNumber  ::TVarChar
        , gpReport.OperDate
        , gpReport.OperDatePartner ::TDateTime
        , gpReport.isPeresort
        , gpReport.MovementDescName ::TVarChar AS MovementDescName

        , gpReport.MovementDescName_order  ::TVarChar AS MovementDescName_order

        , gpReport.isActive
        , gpReport.isRemains
        , gpReport.isRePrice
        , gpReport.isInv

        , gpReport.LocationDescName
        , gpReport.LocationCode
        , gpReport.LocationName
        , gpReport.CarCode
        , gpReport.CarName
        , gpReport.ObjectByDescName
        , gpReport.ObjectByCode
        , gpReport.ObjectByName

        , gpReport.PaidKindName          --20

        , gpReport.GoodsCode
        , gpReport.GoodsName
        --, COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
        , '' :: TVarChar AS Name_Scale
        , gpReport.GoodsKindName
        , gpReport.GoodsKindName_complete
        , gpReport.PartionGoods ::TVarChar
        /*, gpReport.StorageId           ::Integer
        , gpReport.StorageName         ::TVarChar
        , gpReport.PartionModelId      ::Integer
        , gpReport.PartionModelName    ::TVarChar
        , gpReport.UnitId_partion      ::Integer
        , gpReport.UnitName_partion    ::TVarChar
        , gpReport.BranchName_partion ::TVarChar
        , gpReport.PartNumber_partion  ::TVarChar 
        , ''  ::TVarChar   AS PartionCellName
        , FALSE ::Boolean  AS isPartionCell_Close
       */                                       
        , 0    ::Integer AS StorageId           
        , ''  ::TVarChar AS StorageName       
        , 0   ::Integer  AS PartionModelId    
        , ''  ::TVarChar AS PartionModelName  
        , 0   ::Integer  AS UnitId_partion    
        , ''  ::TVarChar AS UnitName_partion  
        , ''  ::TVarChar AS BranchName_partion
        , ''  ::TVarChar AS PartNumber_partion
        , ''  ::TVarChar   AS PartionCellName
        , FALSE ::Boolean  AS isPartionCell_Close

        , gpReport.GoodsCode_parent
        , gpReport.GoodsName_parent
        , gpReport.GoodsKindName_parent

        , gpReport.Price            ::TFloat AS Price
        , gpReport.Price_branch     ::TFloat AS Price_branch
        , gpReport.Price_end         ::TFloat AS Price_end
        , gpReport.Price_branch_end  ::TFloat AS Price_branch_end
        , gpReport.Price_partner    ::TFloat AS Price_partner
        , gpReport.SummPartnerIn    ::TFloat  AS SummPartnerIn    
        , gpReport.SummPartnerOut   ::TFloat  AS SummPartnerOut   
        , gpReport.AmountStart      ::TFloat  AS AmountStart      
        , gpReport.AmountIn         ::TFloat  AS AmountIn         
        , gpReport.AmountOut        ::TFloat  AS AmountOut        
        , gpReport.AmountEnd        ::TFloat  AS AmountEnd        
        , gpReport.Amount           ::TFloat  AS Amount   
        --в этом  отчете все в весе
        , 0      ::TFloat  AS AmountStart_weight      
        , 0      ::TFloat  AS AmountIn_weight         
        , 0      ::TFloat  AS AmountOut_weight        
        , 0      ::TFloat  AS AmountEnd_weight

        , gpReport.SummStart        ::TFloat  AS SummStart        
        , gpReport.SummStart_branch ::TFloat  AS SummStart_branch 
        , gpReport.SummIn           ::TFloat  AS SummIn           
        , gpReport.SummIn_branch    ::TFloat  AS SummIn_branch    
        , gpReport.SummOut          ::TFloat  AS SummOut          
        , gpReport.SummOut_branch   ::TFloat  AS SummOut_branch   
        , gpReport.SummEnd          ::TFloat  AS SummEnd          
        , gpReport.SummEnd_branch   ::TFloat  AS SummEnd_branch   
        , gpReport.Summ             ::TFloat  AS Summ             
        , gpReport.Summ_branch      ::TFloat  AS Summ_branch      

        , gpReport.Amount_Change :: TFloat AS Amount_Change, gpReport.Summ_Change_branch :: TFloat AS Summ_Change_branch, gpReport.Summ_Change_zavod :: TFloat AS Summ_Change_zavod
        , gpReport.Amount_40200 :: TFloat AS Amount_40200,  gpReport.Summ_40200_branch  :: TFloat AS Summ_40200_branch,  gpReport.Summ_40200_zavod  :: TFloat AS Summ_40200_zavod
        , gpReport.Amount_Loss  :: TFloat AS Amount_Loss,   gpReport.Summ_Loss_branch   :: TFloat AS Summ_Loss_branch,   gpReport.Summ_Loss_zavod   :: TFloat AS Summ_Loss_zavod 

        , gpReport.isPage3
        , gpReport.isExistsPage3

        , gpReport.KVK
        , gpReport.PersonalKVKId
        , gpReport.PersonalKVKName
        , gpReport.PositionCode_KVK
        , gpReport.PositionName_KVK
        , gpReport.UnitCode_KVK
        , gpReport.UnitName_KVK
        , gpReport.PersonalGroupName

        --Акция
        , gpReport.InvNumber_Full  ::TVarChar
        , gpReport.StartSale_promo ::TDateTime
        , gpReport.EndSale_promo   ::TDateTime
        --
        , gpReport.DayOfWeekName_doc ::TVarChar 
        , gpReport.DayOfWeekName_partner  ::TVarChar
     
          , tmpProtocol.OperDate      ::TDateTime AS OperDate_Protocol
          , tmpProtocol.UserName      ::TVarChar  AS UserName_Protocol
          , tmpProtocol.OperDate_auto ::TDateTime AS OperDate_Protocol_auto
          , tmpProtocol.UserName_auto ::TVarChar  AS UserName_Protocol_auto
          
          , tmpProtocolInsert.OperDate ::TDateTime AS OperDate_Insert
          , tmpProtocolInsert.UserName ::TVarChar  AS UserName_Insert

          , NULL ::TDateTime AS OperDate_Protocol_mi
          , NULL ::TVarChar  AS UserName_Protocol_mi

     FROM gpReport
          LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = gpReport.MovementId 
          
          LEFT JOIN tmpProtocolInsert ON tmpProtocolInsert.MovementId = gpReport.MovementId

          ;
 
 
   ELSE

   -- РЕЗУЛЬТАТ
   RETURN QUERY
    WITH tmpWhere AS (SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId, inGoodsId AS GoodsId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect WHERE inLocationId = 0
                     UNION
                      SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId, inGoodsId AS GoodsId FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect WHERE inLocationId <> 0
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId, inGoodsId AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Car() AND (Object.Id = inLocationId OR (COALESCE(inLocationId, 0) = 0 AND COALESCE(inUnitGroupId, 0) = 0))
                     UNION
                      SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId, inGoodsId AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Member() AND (Object.Id = inLocationId OR (COALESCE(inLocationId, 0) = 0 AND COALESCE(inUnitGroupId, 0) = 0))
                     UNION
                      SELECT Object_Unit.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId, inGoodsId AS GoodsId FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit() AND COALESCE (inLocationId, 0) = 0 AND COALESCE (inUnitGroupId, 0) = 0
                    )
       , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                     , CLO_Location.ObjectId AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , CASE WHEN inIsPartion = TRUE THEN COALESCE (CLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
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
                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               )
                , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.GoodsKindId
                                       , MIContainer.ObjectIntId_Analyzer AS GoodsKindId_mic
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
                                         , MIContainer.ObjectIntId_Analyzer
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
                                      , MIContainer.ObjectIntId_Analyzer AS GoodsKindId_mic
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
                                        , MIContainer.ObjectIntId_Analyzer
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

         , tmpMI_Summ_group AS (SELECT DISTINCT tmpMI_Summ.MovementId, tmpMI_Summ.MovementItemId, tmpMI_Summ.ContainerId_Analyzer, tmpMI_Summ.isActive
                                FROM tmpMI_Summ
                                WHERE tmpMI_Summ.MovementItemId > 0
                                -- and  1=0
                                )
         -- , tmpMI_SummBranch_group AS (SELECT DISTINCT tmpMI_Summ.MovementId FROM tmpMI_Summ WHERE tmpMI_Summ.MovementId > 0 AND tmpMI_Summ.MovementDescId = zc_Movement_SendOnPrice())
         , tmpMI_SummBranch_group AS (SELECT DISTINCT tmpMI_Summ.MovementItemId FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0 AND tmpMI_Summ.MovementDescId = zc_Movement_SendOnPrice())
         , tmpMI_SummPartner AS (SELECT tmpMI_Summ_group.MovementItemId
                                      , SUM (CASE WHEN MIContainer.AccountId IN (zc_Enum_AnalyzerId_SummIn_110101(), zc_Enum_AnalyzerId_SummOut_110101()) THEN 0 ELSE MIContainer.Amount END * CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ReturnOut(), zc_Movement_Sale()) THEN 1 ELSE -1 END) AS Amount
                                 FROM tmpMI_Summ_group
                                      INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId     = tmpMI_Summ_group.MovementId
                                                                                     AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                                     AND MIContainer.MovementItemId = tmpMI_Summ_group.MovementItemId
                                                                                     AND MIContainer.ContainerId    = tmpMI_Summ_group.ContainerId_Analyzer
                                                                                     AND MIContainer.isActive      <> tmpMI_Summ_group.isActive
                                 GROUP BY tmpMI_Summ_group.MovementItemId
                                UNION ALL
                                 SELECT tmpMI_SummBranch_group.MovementItemId
                                 -- SELECT MovementItem.Id          AS MovementItemId
                                      , (MIF_SummFrom.ValueData) AS Amount
                                 FROM tmpMI_SummBranch_group
                                      INNER JOIN MovementItemFloat AS MIF_SummFrom
                                                                   ON MIF_SummFrom.MovementItemId = tmpMI_SummBranch_group.MovementItemId
                                                                  AND MIF_SummFrom.DescId         = zc_MIFloat_SummFrom()
                                      /*INNER JOIN MovementItem ON MovementItem.MovementId = tmpMI_SummBranch_group.MovementId
                                                             AND MovementItem.isErased   = FALSE
                                      INNER JOIN MovementItemFloat AS MIF_SummFrom
                                                                   ON MIF_SummFrom.MovementItemId = MovementItem.Id
                                                                  AND MIF_SummFrom.DescId         = zc_MIFloat_SummFrom()*/
                                )
               , tmpMI_Id AS (SELECT DISTINCT tmpMI_Count.MovementItemId FROM tmpMI_Count WHERE tmpMI_Count.MovementItemId > 0
                             UNION
                              SELECT DISTINCT tmpMI_Summ.MovementItemId FROM tmpMI_Summ WHERE tmpMI_Summ.MovementItemId > 0
                             )

               , tmpMI_find AS (SELECT MovementItem.* FROM MovementItem WHERE MovementItem.Id IN (SELECT DISTINCT tmpMI_Id.MovementItemId FROM tmpMI_Id))
      , tmpMID_PartionGoods AS (SELECT MID.* FROM MovementItemDate AS MID WHERE MID.MovementItemId IN (SELECT DISTINCT tmpMI_Id.MovementItemId FROM tmpMI_Id) AND MID.DescId = zc_MIDate_PartionGoods() AND MID.ValueData > zc_DateStart() LIMIT (SELECT COUNT(*) FROM tmpMI_Id))
--    , tmpMID_PartionGoods AS (SELECT MID.* FROM tmpMI_Id JOIN MovementItemDate AS MID ON MID.MovementItemId = tmpMI_Id.MovementItemId AND MID.DescId = zc_MIDate_PartionGoods())
      , tmpMIS_PartionGoods AS (SELECT MIS.* FROM MovementItemString AS MIS WHERE MIS.MovementItemId IN (SELECT DISTINCT tmpMI_Id.MovementItemId FROM tmpMI_Id) AND MIS.DescId = zc_MIString_PartionGoods())

      , tmpMIContainer_all AS (-- 1.1. Остатки кол-во
                               SELECT -1 AS MovementId
                                    , 0 AS MovementItemId
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
                               -- 1.2. Движение кол-во
                               SELECT tmpMI_Count.MovementId
                                    , tmpMI_Count.MovementItemId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , CASE WHEN tmpMI_Count.GoodsKindId > 0 THEN tmpMI_Count.GoodsKindId ELSE tmpMI_Count.GoodsKindId_mic END AS GoodsKindId
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

                                    LEFT JOIN tmpMI_find AS MovementItem ON MovementItem.Id = tmpMI_Count.MovementItemId
                                    LEFT JOIN tmpMID_PartionGoods AS MIDate_PartionGoods ON MIDate_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId
                                                                                        AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                    LEFT JOIN tmpMIS_PartionGoods AS MIString_PartionGoods ON MIString_PartionGoods.MovementItemId = tmpMI_Count.MovementItemId

                                    LEFT JOIN MovementString AS MovementString_PartionGoods
                                                             ON MovementString_PartionGoods.MovementId = tmpMI_Count.MovementId
                                                            AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                            AND tmpMI_Count.MovementDescId = zc_Movement_ProductionSeparate()
                                    /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Count.MovementItemId
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                               WHERE tmpMI_Count.Amount_Period <> 0
                              UNION ALL
                               -- 2.1. Остатки суммы
                               SELECT -1 AS MovementId
                                    , 0 AS MovementItemId
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
                               -- 2.2. Движение суммы
                               SELECT tmpMI_Summ.MovementId
                                    , tmpMI_Summ.MovementItemId
                                    , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                    , tmpMI_Summ.ContainerId
                                    , tmpMI_Summ.LocationId
                                    , tmpMI_Summ.GoodsId
                                    , CASE WHEN tmpMI_Summ.GoodsKindId > 0 THEN tmpMI_Summ.GoodsKindId ELSE tmpMI_Summ.GoodsKindId_mic END AS GoodsKindId
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
                                    LEFT JOIN tmpMI_find AS MovementItem ON MovementItem.Id = tmpMI_Summ.MovementItemId
                                    LEFT JOIN tmpMID_PartionGoods AS MIDate_PartionGoods ON MIDate_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                                                                        AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                    LEFT JOIN tmpMIS_PartionGoods AS MIString_PartionGoods ON MIString_PartionGoods.MovementItemId = tmpMI_Summ.MovementItemId
                                    LEFT JOIN MovementString AS MovementString_PartionGoods
                                                             ON MovementString_PartionGoods.MovementId = tmpMI_Summ.MovementId
                                                            AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                            AND tmpMI_Summ.MovementDescId = zc_Movement_ProductionSeparate()
                                    /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Summ.MovementItemId
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                               WHERE tmpMI_Summ.Amount_Period <> 0
                              )

      , tmpMIString_KVK AS (SELECT *
                            FROM MovementItemString
                            WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMIContainer_all.MovementItemId FROM tmpMIContainer_all)
                              AND MovementItemString.DescId = zc_MIString_KVK()
                           )
   
      , tmpMILO_PersonalKVK AS (SELECT *
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIContainer_all.MovementItemId FROM tmpMIContainer_all)
                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_PersonalKVK()
                               )

      , tmpMIFloat_Price AS (SELECT *
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIContainer_all.MovementItemId FROM tmpMIContainer_all)
                               AND MovementItemFloat.DescId = zc_MIFloat_Price()
                            )

      , tmpMIContainer_group AS (SELECT tmpMIContainer_all.MovementId
                                      -- , 0 AS MovementItemId
                                      , tmpMIContainer_all.MovementItemId
                                      , tmpMIContainer_all.ParentId
                                      , tmpMIContainer_all.LocationId
                                      , MIString_KVK.ValueData            AS KVK
                                      , MILinkObject_PersonalKVK.ObjectId AS PersonalId_KVK
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
                                      
                                      , COALESCE (MIF_Price.ValueData, 0) AS Price_real
                                FROM tmpMIContainer_all
                                     LEFT JOIN tmpMIFloat_Price AS MIF_Price
                                                                ON MIF_Price.MovementItemId = tmpMIContainer_all.MovementItemId
                                                               AND MIF_Price.DescId         = zc_MIFloat_Price()

                                       LEFT JOIN tmpMILO_PersonalKVK AS MILinkObject_PersonalKVK
                                                                     ON MILinkObject_PersonalKVK.MovementItemId = tmpMIContainer_all.MovementItemId
   
                                       LEFT JOIN tmpMIString_KVK AS MIString_KVK
                                                                 ON MIString_KVK.MovementItemId = tmpMIContainer_all.MovementItemId
                                 GROUP BY tmpMIContainer_all.MovementId
                                        , tmpMIContainer_all.MovementItemId
                                        , tmpMIContainer_all.ParentId
                                        , tmpMIContainer_all.LocationId
                                        , tmpMIContainer_all.GoodsId
                                        , tmpMIContainer_all.GoodsKindId
                                        , tmpMIContainer_all.PartionGoodsId
                                        , tmpMIContainer_all.ContainerId_Analyzer
                                        , tmpMIContainer_all.isActive
                                        , tmpMIContainer_all.isReprice
                                        , tmpMIContainer_all.PartionGoods_item
                                        , COALESCE (MIF_Price.ValueData, 0)
                                        , MIString_KVK.ValueData
                                        , MILinkObject_PersonalKVK.ObjectId
                                )

  ----
  
  , tmpMLO_By AS (SELECT MovementLinkObject_By.*
                  FROM MovementLinkObject AS MovementLinkObject_By
                   WHERE MovementLinkObject_By.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group) 
                     AND MovementLinkObject_By.DescId IN ( zc_MovementLinkObject_From()
                                                         , zc_MovementLinkObject_To()
                                                         , zc_MovementLinkObject_ArticleLoss()
                                                         , zc_MovementLinkObject_PaidKind()
                                                         , zc_MovementLinkObject_PersonalGroup()
                                                         )
                 )

  , tmpMovementDate AS (SELECT MovementDate_OperDatePartner.*
                        FROM MovementDate AS MovementDate_OperDatePartner
                        WHERE MovementDate_OperDatePartner.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group) 
                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        )

  , tmpMILO_GoodsKind_parent AS (SELECT MILinkObject_GoodsKind_parent.*
                                 FROM MovementItemLinkObject AS MILinkObject_GoodsKind_parent
                                 WHERE MILinkObject_GoodsKind_parent.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.ParentId FROM tmpMIContainer_group)  
                                   AND MILinkObject_GoodsKind_parent.DescId = zc_MILinkObject_GoodsKind()
                                )
  , tmpMILO_GoodsKind AS (SELECT MILinkObject_GoodsKind.*
                          FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                          WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.MovementItemId FROM tmpMIContainer_group)  
                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         )

  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                           FROM MovementBoolean
                           WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group) 
                             AND MovementBoolean.DescId = zc_MovementBoolean_Peresort()
                           )
   -- данные по акциям
  , tmpMIFloat_promo AS (SELECT MIFloat_PromoMovement.MovementItemId
                              , MIFloat_PromoMovement.ValueData ::Integer AS MovementId_promo
                         FROM MovementItemFloat AS MIFloat_PromoMovement
                         WHERE MIFloat_PromoMovement.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.MovementItemId FROM tmpMIContainer_group)  
                           AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                        )
  , tmpPromo AS (SELECT tmp.MovementId
                      , ('№ '||Movement.InvNumber||' от '|| Movement.OperDate ::Date ::TVarChar) :: TVarChar AS InvNumber_Full
                      , MovementDate_StartSale.ValueData AS StartSale
                      , MovementDate_EndSale.ValueData   AS EndSale
                 FROM (SELECT DISTINCT tmpMIFloat_promo.MovementId_promo AS MovementId FROM tmpMIFloat_promo) AS tmp
                     LEFT JOIN Movement ON Movement.Id = tmp.MovementId
                     LEFT JOIN MovementDate AS MovementDate_StartSale
                                            ON MovementDate_StartSale.MovementId = tmp.MovementId
                                           AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                     LEFT JOIN MovementDate AS MovementDate_EndSale
                                            ON MovementDate_EndSale.MovementId = Movement.Id
                                           AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                 )

       -- выбираем последнюю запись из протокола - дата/время + фио
     , tmpProtocol1 AS (SELECT MovementProtocol.MovementId
                             , MAX (CASE WHEN MovementProtocol.UserId NOT IN (zc_Enum_Process_Auto_PrimeCost()
                                                                            , zc_Enum_Process_Auto_ReComplete()
                                                                            , zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                                                                            , zc_Enum_Process_Auto_Defroster()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId
                             , MAX (CASE WHEN MovementProtocol.UserId     IN (zc_Enum_Process_Auto_PrimeCost()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId_Auto_Auto
                             , MAX (CASE WHEN MovementProtocol.UserId     IN (zc_Enum_Process_Auto_ReComplete()
                                                                            , zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                                                                            , zc_Enum_Process_Auto_Defroster()
                                                                             )
                                              THEN MovementProtocol.Id
                                         ELSE 0
                                    END) AS MaxId_Auto
                        FROM (SELECT DISTINCT tmpMIContainer_group.MovementId 
                              FROM tmpMIContainer_group
                              WHERE tmpMIContainer_group.MovementId IS NOT NULL-- AND 1=0
                              ) AS tmp
                              INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmp.MovementId
                        GROUP BY MovementProtocol.MovementId
                       )
, tmpMIProtocol_find AS (SELECT MovementItemProtocol.MovementItemId
                              , MAX (MovementItemProtocol.Id) AS MaxId
                         FROM (SELECT DISTINCT tmpMI_Id.MovementItemId 
                               FROM tmpMI_Id
                               WHERE tmpMI_Id.MovementItemId > 0
                               ) AS tmp
                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmp.MovementItemId
                                                            --AND MovementItemProtocol.UserId NOT IN (zc_Enum_Process_Auto_PrimeCost())
                                                            --AND MovementItemProtocol.OperDate BETWEEN '28.02.2025' AND '01.03.2025'
                         GROUP BY MovementItemProtocol.MovementItemId
                        )
     , tmpProtocol AS (SELECT MovementProtocol.MovementId
                            , MovementProtocol.UserId
                            , MovementProtocol.OperDate
                            , Object_User.ValueData AS UserName

                            , MovementProtocol_auto.OperDate AS OperDate_auto
                            , Object_User_auto.ValueData     AS UserName_auto

                       FROM tmpProtocol1
                            INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmpProtocol1.MovementId
                                                       AND MovementProtocol.Id         = CASE WHEN tmpProtocol1.MaxId > 0 THEN tmpProtocol1.MaxId ELSE tmpProtocol1.MaxId_auto END
                            LEFT JOIN MovementProtocol AS MovementProtocol_auto
                                                       ON MovementProtocol_auto.MovementId = tmpProtocol1.MovementId
                                                      AND MovementProtocol_auto.Id         = tmpProtocol1.MaxId_Auto_Auto
                            LEFT JOIN Object AS Object_User      ON Object_User.Id      = MovementProtocol.UserId
                            LEFT JOIN Object AS Object_User_auto ON Object_User_auto.Id = MovementProtocol_auto.UserId
                      )
   , tmpMIProtocol AS (SELECT MovementItemProtocol.MovementItemId
                            , MovementItemProtocol.UserId
                            , MovementItemProtocol.OperDate
                            , Object_User.ValueData AS UserName
                       FROM tmpMIProtocol_find
                            INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMIProtocol_find.MovementItemId
                                                           AND MovementItemProtocol.Id             = tmpMIProtocol_find.MaxId
                            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
                      )


    , tmpProtocolInsert AS (SELECT tmp.MovementId
                                , tmp.OperDate
                                , tmp.UserId
                                , Object_User.ValueData AS UserName
                           FROM (SELECT *
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate ASC) AS Ord
                                 FROM MovementProtocol
                                 WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMIContainer_group.MovementId FROM tmpMIContainer_group)
                                 ) AS tmp
                                 LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId
                           WHERE tmp.Ord = 1
                          )

   -- ячейки
   , tmpPartionCell AS (WITH
                        tmpMILO AS (SELECT MovementItemLinkObject.*
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.MovementItemId FROM tmpMIContainer_group)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionCell_1()
                                                                              , zc_MILinkObject_PartionCell_2()
                                                                              , zc_MILinkObject_PartionCell_3()
                                                                              , zc_MILinkObject_PartionCell_4()
                                                                              , zc_MILinkObject_PartionCell_5() 
                                                                               )
                                          AND 1=0
                                       )

                      , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                                          FROM MovementItemBoolean
                                          WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.MovementItemId FROM tmpMIContainer_group)
                                            AND MovementItemBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                                             , zc_MIBoolean_PartionCell_Close_2()
                                                                             , zc_MIBoolean_PartionCell_Close_3()
                                                                             , zc_MIBoolean_PartionCell_Close_4()
                                                                             , zc_MIBoolean_PartionCell_Close_5() 
                                                                              )
                                            AND 1=0
                                         )
                        
                        SELECT tmp.MovementItemId
                             , STRING_AGG (DISTINCT Object_PartionCell.ValueData, ';') AS PartionCellName
                             , SUM (CASE WHEN Object_PartionCell.Id <> 0 AND COALESCE (MIBoolean_PartionCell_Close.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END ) AS PartionCell_Close
                        FROM (SELECT DISTINCT tmpMIContainer_group.MovementItemId FROM tmpMIContainer_group) AS tmp
                          LEFT JOIN tmpMILO AS MILinkObject_PartionCell
                                            ON MILinkObject_PartionCell.MovementItemId = tmp.MovementItemId
                          LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILinkObject_PartionCell.ObjectId 
                          
                          LEFT JOIN tmpMI_Boolean AS MIBoolean_PartionCell_Close
                                                  ON MIBoolean_PartionCell_Close.MovementItemId = tmp.MovementItemId 
                        GROUP BY tmp.MovementItemId
                        )

    -- РЕЗУЛЬТАТ
  , tmpDataAll AS (SELECT Movement.Id AS MovementId
                        , Movement.InvNumber
                        , Movement.OperDate
                        , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                        , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) :: Boolean AS isPeresort
                
                        , CASE WHEN MovementDesc.Id = zc_Movement_Inventory() AND tmpMIContainer_group.isReprice = TRUE
                                    THEN MovementDesc.ItemName || ' переоценка'
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE
                                    THEN MovementDesc.ItemName || ' ПРИХОД'
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(),zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE
                                    THEN MovementDesc.ItemName || ' РАСХОД'
                               ELSE MovementDesc.ItemName
                          END :: TVarChar AS MovementDescName
                
                        , CASE WHEN Movement.DescId = zc_Movement_Income()
                                    THEN '01 ' || MovementDesc.ItemName
                               WHEN Movement.DescId = zc_Movement_ReturnOut()
                                    THEN '02 ' || MovementDesc.ItemName
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpMIContainer_group.isActive = TRUE
                                    THEN '03 ' || MovementDesc.ItemName
                               WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpMIContainer_group.isActive = FALSE
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
                
                        , Object_Goods.Id         AS GoodsId
                        , Object_Goods.ObjectCode AS GoodsCode
                        , Object_Goods.ValueData  AS GoodsName
                        , Object_GoodsKind.ValueData AS GoodsKindName
                        , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete
                        , COALESCE (CASE WHEN Object_PartionGoods.ValueData <> '' THEN Object_PartionGoods.ValueData ELSE NULL END
                                  , CASE WHEN tmpMIContainer_group.PartionGoods_item <> '' AND vbUserId = 5 THEN '*док-' ELSE '' END || tmpMIContainer_group.PartionGoods_item
                                   ) :: TVarChar AS PartionGoods
                        , Object_Goods_parent.Id         AS GoodsId_parent
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
                
                        , CAST (CASE WHEN tmpMIContainer_group.Price_real > 0 
                                          THEN tmpMIContainer_group.Price_real
                                          
                                     WHEN tmpMIContainer_group.AmountIn <> 0
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
                              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
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
                              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                                AS TFloat) AS Summ
                        , CAST ((tmpMIContainer_group.SummIn_branch - tmpMIContainer_group.SummOut_branch)
                              * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
                              * CASE WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN -1 ELSE 1 END
                                AS TFloat) AS Summ_branch
                
                        , 0 :: TFloat AS Amount_Change, 0 :: TFloat AS Summ_Change_branch, 0 :: TFloat AS Summ_Change_zavod
                        , 0 :: TFloat AS Amount_40200,  0 :: TFloat AS Summ_40200_branch,  0 :: TFloat AS Summ_40200_zavod
                        , 0 :: TFloat AS Amount_Loss,   0 :: TFloat AS Summ_Loss_branch,   0 :: TFloat AS Summ_Loss_zavod
                
                        , FALSE AS isPage3
                        , FALSE AS isExistsPage3
                        
                        , tmpMIContainer_group.KVK
                        , Object_PersonalKVK.Id          AS PersonalKVKId
                        , Object_PersonalKVK.ValueData   AS PersonalKVKName
                        , Object_PositionKVK.ObjectCode  AS PositionCode_KVK
                        , Object_PositionKVK.ValueData   AS PositionName_KVK
                        , Object_UnitKVK.ObjectCode      AS UnitCode_KVK
                        , Object_UnitKVK.ValueData       AS UnitName_KVK
                        , Object_PersonalGroup.ValueData AS PersonalGroupName

                        --Акция
                        , tmpPromo.InvNumber_Full  ::TVarChar
                        , tmpPromo.StartSale       ::TDateTime AS StartSale_promo
                        , tmpPromo.EndSale         ::TDateTime AS EndSale_promo
                        --
                        , tmpWeekDay_doc.DayOfWeekName     ::TVarChar AS DayOfWeekName_doc      --день недели даты документа
                        , tmpWeekDay_partner.DayOfWeekName ::TVarChar AS DayOfWeekName_partner  --день недели даты покупателя
                        
                        , tmpProtocol.OperDate      ::TDateTime AS OperDate_Protocol
                        , tmpProtocol.UserName      ::TVarChar  AS UserName_Protocol
                        , tmpProtocol.OperDate_auto ::TDateTime AS OperDate_Protocol_auto
                        , tmpProtocol.UserName_auto ::TVarChar  AS UserName_Protocol_auto

                        , tmpProtocolInsert.OperDate ::TDateTime AS OperDate_Insert
                        , tmpProtocolInsert.UserName ::TVarChar  AS UserName_Insert

                        , tmpMIProtocol.OperDate     ::TDateTime AS OperDate_Protocol_mi
                        , tmpMIProtocol.UserName     ::TVarChar  AS UserName_Protocol_mi
                        
                         --
                        , Object_Storage.Id                 AS StorageId
                        , Object_Storage.ValueData          AS StorageName
                        , Object_PartionModel.Id            AS PartionModelId
                        , Object_PartionModel.ValueData     AS PartionModelName
                        , Object_Unit.Id                    AS UnitId_partion
                        , Object_Unit.ValueData             AS UnitName_partion
                        , Object_Branch.ValueData           AS BranchName_partion
                        , ObjectString_PartNumber.ValueData AS PartNumber_partion
                        
                        , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
                        
                      --, tmpPartionCell.PartionCellName
                      --, CASE WHEN tmpPartionCell.PartionCell_Close <> 0 THEN FALSE ELSE TRUE END ::Boolean AS isPartionCell_Close
                        , Object_PartionCell.ValueData AS PartionCellName
                        , FALSE  ::Boolean AS isPartionCell_Close
                   FROM tmpMIContainer_group
                        LEFT JOIN Movement ON Movement.Id = tmpMIContainer_group.MovementId
                        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                
                        LEFT JOIN ContainerLinkObject AS CLO_Object_By
                                                      ON CLO_Object_By.ContainerId = tmpMIContainer_group.ContainerId_Analyzer
                                                     AND CLO_Object_By.DescId IN (zc_ContainerLinkObject_Partner(), zc_ContainerLinkObject_Member())
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_By
                                            ON MovementLinkObject_By.MovementId = tmpMIContainer_group.MovementId
                                           AND MovementLinkObject_By.DescId = CASE WHEN Movement.DescId = zc_Movement_Income() THEN zc_MovementLinkObject_From()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnOut() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                                   WHEN Movement.DescId = zc_Movement_Loss() THEN zc_MovementLinkObject_ArticleLoss()
                                                                                   WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = TRUE THEN zc_MovementLinkObject_From()
                                                                                   WHEN Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpMIContainer_group.isActive = FALSE THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = TRUE THEN zc_MovementLinkObject_From()
                                                                                   WHEN Movement.DescId = zc_Movement_Inventory() AND tmpMIContainer_group.isActive = FALSE THEN zc_MovementLinkObject_To()
                                                                              END
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_By_to
                                            ON MovementLinkObject_By_to.MovementId = tmpMIContainer_group.MovementId
                                           AND MovementLinkObject_By_to.DescId     = zc_MovementLinkObject_To()
                                           AND Movement.DescId = zc_Movement_Loss()
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = tmpMIContainer_group.MovementId
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                
                        LEFT JOIN tmpMLO_By AS MovementLinkObject_PersonalGroup
                                            ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                           AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

                        LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = tmpMIContainer_group.MovementId
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                
                        LEFT JOIN tmpMovementBoolean AS MovementBoolean_Peresort
                                                     ON MovementBoolean_Peresort.MovementId = tmpMIContainer_group.MovementId
                                                    --AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                
                        LEFT JOIN MovementItem AS MovementItem_parent ON MovementItem_parent.Id = tmpMIContainer_group.ParentId
                        LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MovementItem_parent.ObjectId
                        LEFT JOIN tmpMILO_GoodsKind_parent AS MILinkObject_GoodsKind_parent
                                                           ON MILinkObject_GoodsKind_parent.MovementItemId = tmpMIContainer_group.ParentId
                                                          --AND MILinkObject_GoodsKind_parent.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN Object AS Object_GoodsKind_parent ON Object_GoodsKind_parent.Id = MILinkObject_GoodsKind_parent.ObjectId
                
                        LEFT JOIN tmpMILO_GoodsKind AS tmpMILO_GoodsKind
                                                           ON tmpMILO_GoodsKind.MovementItemId = tmpMIContainer_group.MovementItemId
                                                          --AND MILinkObject_GoodsKind_parent.DescId = zc_MILinkObject_GoodsKind()

                        LEFT JOIN tmpMIFloat_promo AS MIFloat_PromoMovement
                                                   ON MIFloat_PromoMovement.MovementItemId = tmpMIContainer_group.MovementItemId
                                                  --AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                        LEFT JOIN tmpPromo ON tmpPromo.MovementId = MIFloat_PromoMovement.MovementId_promo 

                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (tmpMIContainer_group.GoodsKindId, tmpMILO_GoodsKind.ObjectId)
 
                        LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                               ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                              AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()
               
                        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
                        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
                        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.LocationId
                                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END
                        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.LocationId END
                        LEFT JOIN Object AS Object_By ON Object_By.Id = CASE WHEN CLO_Object_By.ObjectId > 0 THEN CLO_Object_By.ObjectId ELSE COALESCE (MovementLinkObject_By.ObjectId, MovementLinkObject_By_to.ObjectId) END
                        LEFT JOIN ObjectDesc AS ObjectDesc_By ON ObjectDesc_By.Id = Object_By.DescId
                        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                             ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_group.PartionGoodsId
                                            AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                             ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_group.PartionGoodsId
                                            AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()
                        LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = ObjectLink_PartionCell.ChildObjectId                                    
                        --
                        LEFT JOIN ObjectLink AS ObjectLink_Storage
                                             ON ObjectLink_Storage.ObjectId = tmpMIContainer_group.PartionGoodsId
                                            AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                            AND inIsPartion = TRUE
                        LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId                                    

                        LEFT JOIN ObjectLink AS ObjectLink_Unit
                                             ON ObjectLink_Unit.ObjectId = tmpMIContainer_group.PartionGoodsId
                                            AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                            AND inIsPartion = TRUE
                        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                        LEFT JOIN ObjectString AS ObjectString_PartNumber
                                               ON ObjectString_PartNumber.ObjectId = tmpMIContainer_group.PartionGoodsId                   -- Сер.номер
                                              AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()
                                              AND inIsPartion = TRUE

                        LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                             ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_group.PartionGoodsId	               -- модель
                                            AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                            AND inIsPartion = TRUE
                        LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId

                        LEFT JOIN Object AS Object_PersonalKVK ON Object_PersonalKVK.Id = tmpMIContainer_group.PersonalId_KVK
               
                        LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionKVK
                                             ON ObjectLink_Personal_PositionKVK.ObjectId = Object_PersonalKVK.Id
                                            AND ObjectLink_Personal_PositionKVK.DescId = zc_ObjectLink_Personal_Position()
                        LEFT JOIN Object AS Object_PositionKVK ON Object_PositionKVK.Id = ObjectLink_Personal_PositionKVK.ChildObjectId
               
                        LEFT JOIN ObjectLink AS ObjectLink_Personal_UnitKVK
                                             ON ObjectLink_Personal_UnitKVK.ObjectId = Object_PersonalKVK.Id
                                            AND ObjectLink_Personal_UnitKVK.DescId = zc_ObjectLink_Personal_Unit()
                        LEFT JOIN Object AS Object_UnitKVK ON Object_UnitKVK.Id = ObjectLink_Personal_UnitKVK.ChildObjectId

                        LEFT JOIN zfCalc_DayOfWeekName (Movement.OperDate) AS tmpWeekDay_doc ON 1=1
                        LEFT JOIN zfCalc_DayOfWeekName (MovementDate_OperDatePartner.ValueData) AS tmpWeekDay_partner ON 1=1

                        LEFT JOIN tmpProtocol ON tmpProtocol.MovementId =  tmpMIContainer_group.MovementId
                        LEFT JOIN tmpProtocolInsert ON tmpProtocolInsert.MovementId =  tmpMIContainer_group.MovementId
                        LEFT JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId =  tmpMIContainer_group.MovementItemId
                        
                        -- LEFT JOIN tmpPartionCell ON tmpPartionCell.MovementItemId = tmpMIContainer_group.MovementItemId
                   )

   -- РЕЗУЛЬТАТ
   SELECT tmpDataAll.MovementId AS MovementId
        , tmpDataAll.InvNumber  ::TVarChar AS InvNumber
        , tmpDataAll.OperDate
        , tmpDataAll.OperDatePartner ::TDateTime AS OperDatePartner
        , tmpDataAll.isPeresort

        , tmpDataAll.MovementDescName ::TVarChar AS MovementDescName

        , tmpDataAll.MovementDescName_order  ::TVarChar AS MovementDescName_order

        , tmpDataAll.isActive
        , tmpDataAll.isRemains
        , tmpDataAll.isRePrice
        , tmpDataAll.isInv

        , tmpDataAll.LocationDescName
        , tmpDataAll.LocationCode
        , tmpDataAll.LocationName
        , tmpDataAll.CarCode
        , tmpDataAll.CarName
        , tmpDataAll.ObjectByDescName
        , tmpDataAll.ObjectByCode
        , tmpDataAll.ObjectByName

        , tmpDataAll.PaidKindName          --20

        , tmpDataAll.GoodsCode
        , tmpDataAll.GoodsName
        , tmpDataAll.Name_Scale          ::TVarChar
        , tmpDataAll.GoodsKindName
        , tmpDataAll.GoodsKindName_complete
        , CASE WHEN inIsPartion = TRUE THEN tmpDataAll.PartionGoods ELSE NULL END ::TVarChar AS PartionGoods
        , tmpDataAll.StorageId           ::Integer
        , tmpDataAll.StorageName         ::TVarChar
        , tmpDataAll.PartionModelId      ::Integer
        , tmpDataAll.PartionModelName    ::TVarChar
        , tmpDataAll.UnitId_partion      ::Integer
        , tmpDataAll.UnitName_partion    ::TVarChar
        , tmpDataAll.BranchName_partion  ::TVarChar
        , tmpDataAll.PartNumber_partion  ::TVarChar
        , tmpDataAll.PartionCellName     ::TVarChar
        , tmpDataAll.isPartionCell_Close ::Boolean

        , tmpDataAll.GoodsCode_parent
        , tmpDataAll.GoodsName_parent
        , tmpDataAll.GoodsKindName_parent

        , CASE WHEN vbIsSummIn = TRUE THEN AVG (tmpDataAll.Price)            ELSE 0 END ::TFloat AS Price
        , CASE WHEN vbIsSummIn = TRUE THEN AVG (tmpDataAll.Price_branch)     ELSE 0 END ::TFloat AS Price_branch

        , CASE WHEN vbIsSummIn = TRUE THEN AVG (tmpDataAll.Price_end)        ELSE 0 END ::TFloat AS Price_end
        , CASE WHEN vbIsSummIn = TRUE THEN AVG (tmpDataAll.Price_branch_end) ELSE 0 END ::TFloat AS Price_branch_end

        , CASE WHEN vbIsSummIn = TRUE THEN AVG (tmpDataAll.Price_partner)    ELSE 0 END ::TFloat AS Price_partner

        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummPartnerIn)    ELSE 0 END ::TFloat  AS SummPartnerIn    
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummPartnerOut)   ELSE 0 END ::TFloat  AS SummPartnerOut   
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountStart)      ELSE 0 END ::TFloat  AS AmountStart      
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountIn)         ELSE 0 END ::TFloat  AS AmountIn         
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountOut)        ELSE 0 END ::TFloat  AS AmountOut        
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountEnd)        ELSE 0 END ::TFloat  AS AmountEnd        
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.Amount)           ELSE 0 END ::TFloat  AS Amount    
        --вес
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountStart * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ELSE 0 END  ::TFloat  AS AmountStart_weight      
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountIn    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ELSE 0 END  ::TFloat  AS AmountIn_weight         
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountOut   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ELSE 0 END  ::TFloat  AS AmountOut_weight        
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.AmountEnd   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ELSE 0 END  ::TFloat  AS AmountEnd_weight        
        
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummStart)        ELSE 0 END ::TFloat  AS SummStart        
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummStart_branch) ELSE 0 END ::TFloat  AS SummStart_branch 
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummIn)           ELSE 0 END ::TFloat  AS SummIn           
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummIn_branch)    ELSE 0 END ::TFloat  AS SummIn_branch    
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummOut)          ELSE 0 END ::TFloat  AS SummOut          
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummOut_branch)   ELSE 0 END ::TFloat  AS SummOut_branch   
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummEnd)          ELSE 0 END ::TFloat  AS SummEnd          
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.SummEnd_branch)   ELSE 0 END ::TFloat  AS SummEnd_branch   
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.Summ)             ELSE 0 END ::TFloat  AS Summ             
        , CASE WHEN vbIsSummIn = TRUE THEN SUM (tmpDataAll.Summ_branch)      ELSE 0 END ::TFloat  AS Summ_branch      

        , 0 :: TFloat AS Amount_Change, 0 :: TFloat AS Summ_Change_branch, 0 :: TFloat AS Summ_Change_zavod
        , 0 :: TFloat AS Amount_40200,  0 :: TFloat AS Summ_40200_branch,  0 :: TFloat AS Summ_40200_zavod
        , 0 :: TFloat AS Amount_Loss,   0 :: TFloat AS Summ_Loss_branch,   0 :: TFloat AS Summ_Loss_zavod 

        , tmpDataAll.isPage3
        , tmpDataAll.isExistsPage3

        , tmpDataAll.KVK
        , tmpDataAll.PersonalKVKId
        , tmpDataAll.PersonalKVKName
        , tmpDataAll.PositionCode_KVK
        , tmpDataAll.PositionName_KVK
        , tmpDataAll.UnitCode_KVK
        , tmpDataAll.UnitName_KVK
        , tmpDataAll.PersonalGroupName

        --Акция
        , tmpDataAll.InvNumber_Full  ::TVarChar
        , tmpDataAll.StartSale_promo ::TDateTime
        , tmpDataAll.EndSale_promo   ::TDateTime
        --
        , CASE WHEN tmpDataAll.OperDate IS NULL THEN '' ELSE tmpDataAll.DayOfWeekName_doc END  ::TVarChar AS DayOfWeekName_doc --день недели даты документа
        , CASE WHEN tmpDataAll.OperDatePartner IS NULL THEN '' ELSE tmpDataAll.DayOfWeekName_partner END ::TVarChar AS DayOfWeekName_partner --день недели даты покупателя

        , tmpDataAll.OperDate_Protocol      ::TDateTime AS OperDate_Protocol
        , tmpDataAll.UserName_Protocol      ::TVarChar  AS UserName_Protocol
        , tmpDataAll.OperDate_Protocol_auto ::TDateTime AS OperDate_Protocol_auto
        , tmpDataAll.UserName_Protocol_auto ::TVarChar  AS UserName_Protocol_auto

        , tmpDataAll.OperDate_Insert ::TDateTime AS OperDate_Insert
        , tmpDataAll.UserName_Insert ::TVarChar  AS UserName_Insert

        , tmpDataAll.OperDate_Protocol_mi
        , tmpDataAll.UserName_Protocol_mi

   FROM tmpDataAll
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = tmpDataAll.GoodsId
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight() 
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpDataAll.GoodsId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
   GROUP BY tmpDataAll.MovementId
        , tmpDataAll.InvNumber
        , tmpDataAll.OperDate
        , tmpDataAll.OperDatePartner
        , tmpDataAll.isPeresort
        , tmpDataAll.MovementDescName
        , tmpDataAll.MovementDescName_order
        , tmpDataAll.isActive
        , tmpDataAll.isRemains
        , tmpDataAll.isRePrice
        , tmpDataAll.isInv
        , tmpDataAll.LocationDescName
        , tmpDataAll.LocationCode
        , tmpDataAll.LocationName
        , tmpDataAll.CarCode
        , tmpDataAll.CarName
        , tmpDataAll.ObjectByDescName
        , tmpDataAll.ObjectByCode
        , tmpDataAll.ObjectByName
        , tmpDataAll.PaidKindName
        , tmpDataAll.GoodsCode
        , tmpDataAll.GoodsName
        , tmpDataAll.Name_Scale
        , tmpDataAll.GoodsKindName
        , tmpDataAll.GoodsKindName_complete
        , CASE WHEN inIsPartion = TRUE THEN tmpDataAll.PartionGoods ELSE NULL END
        , tmpDataAll.GoodsCode_parent
        , tmpDataAll.GoodsName_parent
        , tmpDataAll.GoodsKindName_parent
        , tmpDataAll.isPage3
        , tmpDataAll.isExistsPage3

        , tmpDataAll.KVK
        , tmpDataAll.PersonalKVKId
        , tmpDataAll.PersonalKVKName
        , tmpDataAll.PositionCode_KVK
        , tmpDataAll.PositionName_KVK
        , tmpDataAll.UnitCode_KVK
        , tmpDataAll.UnitName_KVK
        , tmpDataAll.PersonalGroupName

        , tmpDataAll.InvNumber_Full
        , tmpDataAll.StartSale_promo
        , tmpDataAll.EndSale_promo
        , CASE WHEN tmpDataAll.OperDate IS NULL THEN '' ELSE tmpDataAll.DayOfWeekName_doc END
        , CASE WHEN tmpDataAll.OperDatePartner IS NULL THEN '' ELSE tmpDataAll.DayOfWeekName_partner END
        , tmpDataAll.OperDate_Protocol
        , tmpDataAll.UserName_Protocol
        , tmpDataAll.OperDate_Protocol_auto
        , tmpDataAll.UserName_Protocol_auto
        , tmpDataAll.OperDate_Insert
        , tmpDataAll.UserName_Insert
        , tmpDataAll.StorageId          
        , tmpDataAll.StorageName        
        , tmpDataAll.PartionModelId     
        , tmpDataAll.PartionModelName   
        , tmpDataAll.UnitId_partion     
        , tmpDataAll.UnitName_partion 
        , tmpDataAll.BranchName_partion
        , tmpDataAll.PartNumber_partion
        , tmpDataAll.PartionCellName
        , tmpDataAll.isPartionCell_Close 
        , tmpDataAll.OperDate_Protocol_mi
        , tmpDataAll.UserName_Protocol_mi
   ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.24         * 
 30.01.24         *
 22.01.24         *
 03.12.21         *
 29.03.20         * add zc_Movement_SendAsset()
 02.03.20         *
 11.08.15                                        * add inUnitGroupId AND inGoodsGroupId
 30.05.14                                        * ALL
 10.04.14                                        * ALL
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *
*/

-- тест
-- SELECT * FROM gpReport_Goods (inStartDate:= '01.01.2022', inEndDate:= '01.01.2022', inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 1826, inIsPartner:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * from gpReport_Goods(inStartDate := ('02.03.2025')::TDateTime , inEndDate := ('03.03.2025')::TDateTime , inUnitGroupId := 0 , inLocationId := 8451 , inGoodsGroupId := 1858 , inGoodsId := 341913 , inIsPartner := 'False' , inIsPartion := 'False', inSession := '5');
