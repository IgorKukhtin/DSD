-- Function: gpSelect_MI_ProductionSeparate_PriceFact()

--DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate_PriceFact (TDateTime, TDateTime, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate_PriceFact (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate_PriceFact (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionSeparate_PriceFact(
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inMovementId         Integer  , -- ���� ��������� 
    IN inPriceListId_norm   Integer   ,--
    IN inGoodsId            Integer  ,
    IN inPartionGoods       TVarChar   ,
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsId Integer
             , GoodsCode Integer
             , GoodsName          TVarChar
             , GoodsGroupCode     Integer
             , GoodsGroupName     TVarChar
             , GoodsGroupNameFull TVarChar
             , GroupStatId   Integer
             , GroupStatName TVarChar 
             , Separate_info TVarChar
             , isLoss Boolean 
             , Amount TFloat
             , PricePlan TFloat
             , PriceNorm TFloat
             , PriceFact TFloat                --������ �� ����� 
             , SummFact TFloat
             , Count_gr TFloat                 -- ���.������� � ������
             , Str_print TFloat                --��� ������ �������� % ������ �� ������ 
             , Persent_v TFloat                --% ������ 
             , Persent_gr TFloat               --% ������ �� ������ 
 
             , TotalSummaPlan_calc TFloat       -- ����� ����� �� ���� ����* ��� ������� ����� 
             , SummaPlan_calc   TFloat          -- ����� �� ���� ����* ��� ������� �����
             , PricePlan_calc   TFloat          -- ���� ����* ��� ������� �����

             , FromName            TVarChar
             , PersonalPackerName  TVarChar
             , GoodsNameMaster  TVarChar
             , CountMaster      TFloat
             , HeadCountMaster  TFloat
             , SummMaster       TFloat
             , PriceMaster      TFloat
             , GoodsNameIncome  TVarChar
             , CountIncome      TFloat
             , SummIncome       TFloat
             , SummCostIncome   TFloat--��������� 
             , CountDocIncome   TFloat
             , HeadCountIncome   TFloat
             , CountPackerIncome TFloat
             , AmountPartnerIncome TFloat
             , AmountPartnerSecondIncome TFloat
             , HeadCount1       TFloat-- ���� ������ �� Income
             , PriceIncome      TFloat
             , PriceIncome1     TFloat
             , PriceIncome2     TFloat -- �� ���. ����������
             , Count_CountPacker TFloat
             , PercentCount     TFloat
             , CountSeparate    TFloat
             , GoodsNameSeparate  TVarChar
             , SummHeadCount1   TFloat-- �� ��� ������ �� Separate
               ) 
           
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbDescId Integer;
    DECLARE vbOperDate TDateTime;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
     
     --���� �� ������ ����� ����� 
     inPriceListId_norm := CASE WHEN COALESCE (inPriceListId_norm,0) = 0 THEN 12048635 ELSE inPriceListId_norm END;
    
   RETURN QUERY 

    WITH
    
       -- ������ ������� ��� ������� � Separate ��������� ����� �� �����
       tmpGoods AS (SELECT tmp.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (2006) AS tmp) -- ��- ���. � ��. �\� + ���
       -- ������� ���. � �������
     , tmpMovement AS (--�� ������
                       SELECT Movement.Id
                            , Movement.InvNumber                    AS InvNumber
                            , Movement.OperDate                     AS OperDate
                            , MovementString_PartionGoods.ValueData AS PartionGoods

                            , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                            , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion
                       FROM MovementString AS MovementString_PartionGoods
                            INNER JOIN Movement ON Movement.Id = MovementString_PartionGoods.MovementId
                                               AND Movement.DescId = zc_Movement_ProductionSeparate()              
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                       WHERE MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                         AND MovementString_PartionGoods.ValueData ILIKE inPartionGoods
                         AND COALESCE (inPartionGoods,'') <> ''
                         AND COALESCE (inMovementId,0) = 0
                      UNION
                       --�� ���������
                       SELECT Movement.Id
                           , Movement.InvNumber                    AS InvNumber
                           , Movement.OperDate                     AS OperDate
                           , MovementString_PartionGoods.ValueData AS PartionGoods

                           , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                           , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion
                       FROM Movement
                           LEFT JOIN MovementString AS MovementString_PartionGoods
                                                     ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                       WHERE Movement.DescId = zc_Movement_ProductionSeparate()              
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.Id = inMovementId
                         AND COALESCE (inMovementId,0) <> 0
                      UNION
                       --�� ������
                       SELECT Movement.Id
                            , Movement.InvNumber                    AS InvNumber
                            , Movement.OperDate                     AS OperDate
                            , MovementString_PartionGoods.ValueData AS PartionGoods

                            , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                            , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion
                       FROM Movement
                            LEFT JOIN MovementString AS MovementString_PartionGoods
                                                      ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                     AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                       WHERE Movement.DescId = zc_Movement_ProductionSeparate()              
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND COALESCE (inMovementId,0) = 0
                         AND COALESCE (inPartionGoods,'') = ''   
                       )
      -- ������� ���. �������� ������: ���������� + �����
     , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                               , MIContainer.DescId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ContainerId       ELSE 0 END) AS ContainerId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ObjectId_analyzer ELSE 0 END) AS GoodsId
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS Amount_count
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS Amount_summ
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MIContainer.isActive = FALSE
                          GROUP BY MIContainer.MovementItemId
                                 , MIContainer.DescId
                         )
        -- ������� ���., ���������� + ����� = � ���� ������
     , tmpMI_group AS (SELECT MAX (tmpMIContainer.GoodsId)                        AS GoodsId
                            , SUM (tmpMIContainer.Amount_count)                   AS Amount_count
                            , SUM (COALESCE (tmpMIContainer_Summ.Amount_summ, 0)) AS Amount_summ
                            , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))     AS HeadCount
                       FROM tmpMIContainer
                            LEFT JOIN tmpMIContainer AS tmpMIContainer_Summ ON tmpMIContainer_Summ.MovementItemId = tmpMIContainer.MovementItemId
                                                                           AND tmpMIContainer_Summ.DescId = zc_MIContainer_Summ()
                            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                        ON MIFloat_HeadCount.MovementItemId = tmpMIContainer.MovementItemId
                                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                       WHERE tmpMIContainer.DescId = zc_MIContainer_Count()
                      )
       -- ������
     , tmpContainer_all AS (SELECT DISTINCT
                                   CLO_PartionGoods.ObjectId AS PartionGoodsId
                            FROM tmpMIContainer
                                 INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                ON CLO_PartionGoods.ContainerId = tmpMIContainer.ContainerId
                                                               AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                               AND CLO_PartionGoods.ObjectId <> 80132 -- vbPartionGoodsId_null
                            WHERE tmpMIContainer.DescId = zc_MIContainer_Count()
                           )
     -- ������ ContainerId (���. � ����.) ��� PartionGoodsId
     , tmpContainer AS (SELECT DISTINCT
                               CLO_PartionGoods.ContainerId
                             , CLO_PartionGoods.ObjectId AS PartionGoodsId
                             , Container.DescId
                        FROM tmpContainer_all AS tmp
                             INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ObjectId = tmp.PartionGoodsId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                             LEFT JOIN Container ON Container.Id =  CLO_PartionGoods.ContainerId
                       )

     , tmpIncome_Container AS (SELECT MIContainer.*
                               FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.ContainerId IN (SELECT tmpContainer.ContainerId FROM tmpContainer)
                                 AND MIContainer.MovementDescId = zc_Movement_Income()
                               )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpIncome_Container.MovementItemId FROM tmpIncome_Container)
                         AND MovementItemFloat.DescId IN ( zc_MIFloat_AmountPacker()
                                                         , zc_MIFloat_HeadCount()
                                                         , zc_MIFloat_AmountPartner()
                                                         , zc_MIFloat_AmountPartnerSecond()
                                                         )
                       )

        -- ������ �� ���������� : ���. � ����.
     , tmpIncome AS (-- ������� �� ������� �� ���������
                      SELECT MIContainer.DescId
                           , MIContainer.ContainerId
                           , MIContainer.MovementId
                           , MIContainer.ObjectId_analyzer AS GoodsId
                           , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN (MIContainer.Amount) ELSE 0 END) AS Amount_count
                           , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN (MIContainer.Amount) ELSE 0 END) AS Amount_summ
                           , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS CountPacker
                           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))    AS HeadCount
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0))       AS AmountPartner
                           , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData,0)) AS AmountPartnerSecond
                      FROM tmpIncome_Container AS MIContainer
                           LEFT JOIN tmpMI_Float AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0
                           LEFT JOIN tmpMI_Float AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0

                           LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0
                           LEFT JOIN tmpMI_Float AS MIFloat_AmountPartnerSecond
                                                 ON MIFloat_AmountPartnerSecond.MovementItemId = MIContainer.MovementItemId
                                                AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0
                      GROUP BY MIContainer.DescId
                             , MIContainer.ContainerId
                             , MIContainer.MovementId
                             , MIContainer.ObjectId_analyzer 
                     UNION ALL
                      -- ������� �� ������� �� ��������� (�.�. �� ���������� ���� �� �������� �� ������� ���)
                      SELECT 0 AS DescId
                           , 0 AS ContainerId
                           , MIContainer.MovementId
                           , MIContainer.ObjectId_analyzer AS GoodsId
                           , CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN SUM (MIContainer.Amount) ELSE 0 END AS Amount_count
                           , CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN SUM (MIContainer.Amount) ELSE 0 END AS Amount_summ
                           , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS CountPacker
                           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))    AS HeadCount
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0))       AS AmountPartner
                           , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData,0)) AS AmountPartnerSecond
                      FROM tmpMovement
                           LEFT JOIN tmpContainer ON 1 = 1
                           INNER JOIN Movement ON Movement.OperDate = tmpMovement.OperDate_partion
                                              AND Movement.DescId = zc_Movement_Income()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN Object AS Object_Partner ON Object_Partner.ObjectCode = tmpMovement.PartnerCode_partion AND Object_Partner.DescId = zc_Object_Partner()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = Object_Partner.Id
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementId = Movement.Id
                                                           AND MIContainer.ObjectId_analyzer IN (SELECT tmpMI_group.GoodsId FROM tmpMI_group)
                                                           AND MIContainer.isActive = TRUE
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                                       ON MIFloat_AmountPartnerSecond.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                      WHERE tmpContainer.ContainerId IS NULL
                        AND tmpMovement.PartnerCode_partion > 0
                      GROUP BY MIContainer.MovementId, MIContainer.ObjectId_analyzer, MIContainer.DescId
                     )


       -- ������ ���������� ���������� ��� ������ �� ������� �� ����������
     , tmpSeparate AS (SELECT DISTINCT MIContainer.MovementId
                       FROM MovementItemContainer AS MIContainer
                       WHERE MIContainer.ContainerId    IN (SELECT DISTINCT tmpIncome.ContainerId FROM tmpIncome WHERE tmpIncome.DescId = zc_Container_Count())
                         AND MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                      )

       -- ���������� - ����� ������ (��� ������� ���� �����)
     , tmpSeparateH_All AS (SELECT  MIContainer.*
                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND MIContainer.isActive = TRUE
                              AND MIContainer.MovementId IN (SELECT DISTINCT tmpSeparate.MovementId FROM tmpSeparate)
                              AND tmpGoods.GoodsId IS NULL
                            )

     , tmpSeparateH AS (SELECT SUM (tmpSeparateH_All.Amount) AS Amount_summ
                        FROM tmpSeparateH_All
                        )

      -- ���������� - ���-�� ������ ������� (���� �� ������)
     , tmpSeparateS AS (SELECT MIN (MIContainer.ObjectId_analyzer)  AS GoodsId
                             , SUM (MIContainer.Amount)    AS Amount_count
                        FROM MovementItemContainer AS MIContainer
                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                        WHERE MIContainer.DescId   = zc_MIContainer_Count()
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementId IN (SELECT DISTINCT tmpSeparate.MovementId FROM tmpSeparate)
                          AND tmpGoods.GoodsId IS NOT NULL
                       )
      --������� �� ������� ����������
     , tmpIncomeCost AS (SELECT SUM (COALESCE (MovementFloat_AmountCost.ValueData,0)) AS AmountCost
                              , COUNT (DISTINCT Movement.ParentId)                    AS CountDoc --���������� ���������� ������� = ���-�� ����������
                         FROM Movement
                              LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                      ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                     AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                         WHERE Movement.ParentId IN (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                           AND Movement.DescId   = zc_Movement_IncomeCost()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         )  
             
     , tmpCursor1 AS ( 
      -- ���������
      SELECT Object_Goods.ValueData   AS GoodsNameMaster
           , tmpMI_group.Amount_count AS CountMaster
           , tmpMI_group.HeadCount    AS HeadCountMaster
           , tmpMI_group.Amount_summ  AS SummMaster
           
           --, CASE WHEN tmpMI_group.Amount_count <> 0 THEN tmpMI_group.Amount_summ / tmpMI_group.Amount_count ELSE 0 END AS PriceMaster  /**/
           , CASE WHEN COALESCE (tmpIncomeAll.Amount_count,0) <> 0 THEN tmpIncomeAll.Amount_summ / tmpIncomeAll.Amount_count ELSE 0 END AS PriceMaster 

           , Object_From.ValueData            AS FromName
           , Object_PersonalPacker.ValueData  AS PersonalPackerName
           , Object_Goods_income.ValueData    AS GoodsNameIncome
           , tmpIncomeAll.Amount_count        AS CountIncome
           , tmpIncomeAll.Amount_summ         AS SummIncome
           , tmpIncomeCost.AmountCost   ::TFloat  AS SummCostIncome   --��������� 
           , tmpIncomeCost.CountDoc     ::Integer AS CountDocIncome
           , tmpIncomeAll.HeadCount           AS HeadCountIncome
           , tmpIncomeAll.CountPacker         AS CountPackerIncome
           , tmpIncomeAll.AmountPartner       AS AmountPartnerIncome
           , tmpIncomeAll.AmountPartnerSecond AS AmountPartnerSecondIncome
           , CASE WHEN tmpIncomeAll.HeadCount <> 0 THEN tmpIncomeAll.Amount_count / tmpIncomeAll.HeadCount ELSE 0 END AS HeadCount1 -- ���� ������ �� Income

           , tmpIncomeAll.Amount_summ / tmpIncomeAll.Amount_count                              AS PriceIncome
           , tmpIncomeAll.Amount_summ / (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker) AS PriceIncome1
           , CASE WHEN COALESCE (tmpIncomeAll.AmountPartner,0) <> 0 THEN tmpIncomeAll.Amount_summ / (tmpIncomeAll.AmountPartner) ELSE 0 END AS PriceIncome2  -- �� ���. ����������
           

           , (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker)      AS Count_CountPacker
           , CASE WHEN COALESCE (tmpIncomeAll.Amount_count,0) <> 0 THEN 100 * tmpSeparateS.Amount_count / tmpIncomeAll.Amount_count ELSE 0 END AS PercentCount

           , tmpSeparateS.Amount_count       AS CountSeparate
           , Object_Goods_separate.ValueData AS GoodsNameSeparate
           , tmpSeparateH.Amount_summ        AS SummHeadCount1  -- �� ��� ������ �� Separate
      FROM tmpMI_group
           LEFT JOIN tmpSeparateH ON 1 = 1
           LEFT JOIN tmpSeparateS ON 1 = 1
           LEFT JOIN (SELECT MAX (tmpIncome.GoodsId)                                               AS GoodsId
                           , MAX (COALESCE (MovementLinkObject_From.ObjectId, 0))                  AS FromId
                           , MAX (COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0))        AS PersonalPackerId
                           , SUM (tmpIncome.Amount_count) AS Amount_count, SUM ( tmpIncome.Amount_summ) AS Amount_summ
                           , SUM (tmpIncome.CountPacker) AS CountPacker, SUM (tmpIncome.HeadCount) AS HeadCount
                           , SUM (tmpIncome.AmountPartner)       AS AmountPartner
                           , SUM (tmpIncome.AmountPartnerSecond) AS AmountPartnerSecond
                      FROM tmpIncome
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = tmpIncome.MovementId
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                                        ON MovementLinkObject_PersonalPacker.MovementId = tmpIncome.MovementId
                                                       AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
                     ) AS tmpIncomeAll ON 1 = 1
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  tmpMI_group.GoodsId
           LEFT JOIN Object AS Object_Goods_separate ON Object_Goods_separate.Id =  tmpSeparateS.GoodsId
           LEFT JOIN Object AS Object_Goods_income ON Object_Goods_income.Id = tmpIncomeAll.GoodsId
           LEFT JOIN Object AS Object_From ON Object_From.Id = tmpIncomeAll.FromId
           LEFT JOIN Object AS Object_PersonalPacker ON Object_PersonalPacker.Id = tmpIncomeAll.PersonalPackerId
           
           LEFT JOIN tmpIncomeCost ON 1 = 1
       )     
    
    ---�����
        --  ����� - ���� ����������� (�����)"   - Id = 18886
      , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                          , lfSelect.GoodsKindId AS GoodsKindId
                          , lfSelect.ValuePrice
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18886 /*zc_PriceList_ProductionSeparate()*/, inOperDate:= inEndDate) AS lfSelect
                    )
     
        --����� - ���� ������� (�����)  Id = 18889
      , tmpPricePlan AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18889, inOperDate:= inEndDate) AS lfSelect
                        )
        --����� - ����� ������� �������  - ��� �������  % ������ ����� 
      , tmpPriceNorm AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId_norm, inOperDate:= inEndDate) AS lfSelect
                        )                              
      , tmpMI AS (SELECT *
                  FROM MovementItem
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementItem.DescId     = zc_MI_Child()
                     AND MovementItem.Amount     <> 0
                     AND MovementItem.isErased   = FALSE
                  )

      , tmpData AS (SELECT Object_Goods.Id                       AS GoodsId
                         , Object_Goods.ObjectCode               AS GoodsCode
                         , Object_Goods.ValueData                AS GoodsName
                         , Object_GoodsGroup.ObjectCode          AS GoodsGroupCode
                         , Object_GoodsGroup.ValueData   		 AS GoodsGroupName 
                         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                         , SUM (MovementItem.Amount)::TFloat		 AS Amount 
                         , SUM (SUM (COALESCE (MovementItem.Amount,0))) OVER (PARTITION BY ObjectString_Goods_GoodsGroupFull.ValueData) ::TFloat AS  TotalAmount_gr
                        
              
                         , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId IN (1966 -- ��-�� ����. � ����� ���
                                                                                 , 1967 -- ****��-������ - _toolsView_GoodsProperty_Obvalka_isLoss_TWO
                                                                                 , 1973 -- ��-����� ���
                                                                                  )
                                     THEN TRUE
                                ELSE FALSE
                           END :: Boolean AS isLoss
                         
                         , COALESCE (tmpPrice.ValuePrice, 0) :: TFloat AS PricePlan
                         --��� ������ ��� ������ 
                           --���.E - �������� ���� - ����� - ���� ������� (�����)
                         --, COALESCE (tmpPricePlan.ValuePrice, 0) :: TFloat AS PricePlan
                         --��� F  - ����� �������� =  �������� ���� * ����������
                         , (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0)))::TFloat     AS SummaPlan        --kol_F 
                         , SUM (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0))) OVER () AS TotalSummaPlan   --Total_kol_F 
                         -- - ����� ������� �������
                         , COALESCE (tmpPriceNorm.ValuePrice, 0)  AS PriceNorm 
                         
                         , CASE WHEN Object_Goods.ObjectCode = 4218 -- ����� ��� �������
                                     THEN '����' -- 1
                                WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId = 2007 -- ��- �����. ����. �\\�* �� ���
                                     THEN '����������' -- 3
                                ELSE '�������' -- '2-�������'
                           END :: TVarChar AS Separate_info
             
                    FROM tmpMI AS MovementItem
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
                         LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                               AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                                           ANd tmpPrice.GoodsKindId IS NULL

                         LEFT JOIN tmpPricePlan ON tmpPricePlan.GoodsId = MovementItem.ObjectId
                                               ANd tmpPricePlan.GoodsKindId IS NULL

                         LEFT JOIN tmpPriceNorm ON tmpPriceNorm.GoodsId = MovementItem.ObjectId
                                               ANd tmpPriceNorm.GoodsKindId IS NULL                                                    

                         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                     GROUP BY Object_Goods.ObjectCode
                            , Object_Goods.Id
                            , Object_Goods.ValueData
                            , ObjectString_Goods_GoodsGroupFull.ValueData
                            , COALESCE (tmpPrice.ValuePrice, 0)
                            , ObjectLink_Goods_GoodsGroup.ChildObjectId
                            , COALESCE (tmpPriceNorm.ValuePrice, 0)
                            , Object_GoodsGroup.ObjectCode
                            , Object_GoodsGroup.ValueData
                            , CASE WHEN Object_Goods.ObjectCode = 4218 -- ����� ��� �������
                                        THEN '����' -- 1
                                   WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId = 2007 -- ��- �����. ����. �\\�* �� ���
                                        THEN '����������' -- 3
                                   ELSE '�������' -- '2-�������'
                              END
                     )                

   , tmpDataCalc AS (SELECT tmpData.GoodsId
                          , tmpData.GoodsCode
                          , tmpData.GoodsName
                          , tmpData.GoodsGroupCode
                          , tmpData.GoodsGroupName 
                          , tmpData.GoodsGroupNameFull
                          , tmpData.isLoss
                          , tmpData.Amount
                          , tmpData.PricePlan
                          , tmpData.PriceNorm
                          , tmpData.Separate_info
                          --��� ������ ��� ������ 
                          , tmpData.SummaPlan 
                          , tmpData.TotalSummaPlan
                          -- ��� G  ����� ����� �� SummaPlan ��� ��  SummaPlan �.�. ����
                          , CASE WHEN COALESCE (tmpData.TotalSummaPlan,0) <> 0 THEN tmpData.SummaPlan / tmpData.TotalSummaPlan ELSE 0 END :: TFloat AS Summa_dolyaPlan
                          --
                          , CAST (CASE WHEN COALESCE (tmpData.Amount,0) <> 0 
                                 THEN (tmpData.SummaPlan - 
                                      ( (tmpData.TotalSummaPlan 
                                        -- ���� ����� ���, � ����. ����� ���� ������  - (COALESCE (tmpCursor1.SummIncome,0) + COALESCE (tmpCursor1.SummCostIncome,0))   
                                        - ( CASE WHEN COALESCE (tmpCursor1.CountIncome,0) <>0 THEN ((tmpCursor1.PriceIncome2 * tmpCursor1.amountpartnerincome + COALESCE (tmpCursor1.SummCostIncome,0)) / tmpCursor1.CountIncome) ELSE 0 END * tmpCursor1.countmaster)
                                         ) 
                                         * CASE WHEN COALESCE (tmpData.TotalSummaPlan,0) <> 0 THEN tmpData.SummaPlan / tmpData.TotalSummaPlan ELSE 0 END)   /* kol_H*/      
                                      )  /*kol_i */ 
                                      / COALESCE (tmpData.Amount,0) 
                                      ELSE 0 
                            END AS  NUMERIC(16,8)) AS PriceFact
                            
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.Amount,0)/ tmpCursor1.countmaster) ELSE 0 END         :: TFloat AS Persent_v 
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.TotalAmount_gr,0)/ tmpCursor1.countmaster) ELSE 0 END :: TFloat AS Persent_gr

                          -- ������� ����� � ������
                          , COUNT (*) OVER (PARTITION BY tmpData.GoodsGroupNameFull) AS Count_gr
                          

                          --
                          , tmpCursor1.GoodsNameMaster
                          , tmpCursor1.CountMaster
                          , tmpCursor1.HeadCountMaster
                          , tmpCursor1.SummMaster
                          
                          , tmpCursor1.PriceMaster
                          , tmpCursor1.FromName
                          , tmpCursor1.PersonalPackerName
                          , tmpCursor1.GoodsNameIncome
                          , tmpCursor1.CountIncome
                          , tmpCursor1.SummIncome
                          , tmpCursor1.SummCostIncome   --���������
                          , tmpCursor1.CountDocIncome
                          , tmpCursor1.HeadCountIncome
                          , tmpCursor1.CountPackerIncome
                          , tmpCursor1.AmountPartnerIncome
                          , tmpCursor1.AmountPartnerSecondIncome
                          , tmpCursor1.HeadCount1 -- ���� ������ �� Income
               
                          , tmpCursor1.PriceIncome
                          , tmpCursor1.PriceIncome1
                          , tmpCursor1.PriceIncome2  -- �� ���. ����������
                          
               
                          , tmpCursor1.Count_CountPacker
                          , tmpCursor1.PercentCount
               
                          , tmpCursor1.CountSeparate
                          , tmpCursor1.GoodsNameSeparate
                          , tmpCursor1.SummHeadCount1  -- �� ��� ������ �� Separate
                      FROM tmpData
                           LEFT JOIN tmpCursor1 ON 1 = 1 
                      )


     SELECT tmpData.GoodsId
          , tmpData.GoodsCode
          , tmpData.GoodsName
          , tmpData.GoodsGroupCode
          , tmpData.GoodsGroupName
          , tmpData.GoodsGroupNameFull 
          , Object_GoodsGroupStat.Id        AS GroupStatId
          , Object_GoodsGroupStat.ValueData AS GroupStatName
          , tmpData.Separate_info ::TVarChar
          , tmpData.isLoss
          
          , tmpData.Amount    ::TFloat
          , tmpData.PricePlan ::TFloat
          , tmpData.PriceNorm ::TFloat
          --
          , tmpData.PriceFact ::TFloat       --������ �� ����� 
          , (tmpData.PriceFact * COALESCE (tmpData.Amount,0)) ::TFloat AS SummFact
          , tmpData.Count_gr  ::TFloat               -- ���.������� � ������
          , ROUND (tmpData.Count_gr / 2.0 , 0) ::TFloat AS Str_print     --��� ������ �������� % ������ �� ������ 
          , tmpData.Persent_v   ::TFloat             --% ������ 
          , tmpData.Persent_gr  ::TFloat             --% ������ �� ������ 
          --��� ��������
          , tmpData.TotalSummaPlan ::TFloat  AS TotalSummaPlan_calc        -- ����� ����� �� ���� ����* ��� ������� ����� 
          , tmpData.SummaPlan      ::TFloat  AS SummaPlan_calc             -- ����� �� ���� ����* ��� ������� �����
          , CASE WHEN COALESCE (tmpData.Amount,0) <>0 THEN tmpData.SummaPlan / tmpData.Amount ELSE 0 END ::TFloat AS PricePlan_calc     -- ���� ����* ��� ������� �����  
          
          --����� 
          , tmpData.FromName
          , tmpData.PersonalPackerName
          , tmpData.GoodsNameMaster
          , tmpData.CountMaster      ::TFloat
          , tmpData.HeadCountMaster  ::TFloat
          , tmpData.SummMaster       ::TFloat
          
          , tmpData.PriceMaster      ::TFloat
                                     
          , tmpData.GoodsNameIncome  
          , tmpData.CountIncome      ::TFloat
          , tmpData.SummIncome       ::TFloat
          , tmpData.SummCostIncome   ::TFloat--���������
          , tmpData.CountDocIncome   ::TFloat
          , tmpData.HeadCountIncome   ::TFloat
          , tmpData.CountPackerIncome ::TFloat
          , tmpData.AmountPartnerIncome ::TFloat
          , tmpData.AmountPartnerSecondIncome  ::TFloat
          , tmpData.HeadCount1 ::TFloat-- ���� ������ �� Income

          , tmpData.PriceIncome        ::TFloat
          , tmpData.PriceIncome1       ::TFloat
          , tmpData.PriceIncome2       ::TFloat-- �� ���. ����������
          

          , tmpData.Count_CountPacker  ::TFloat
          , tmpData.PercentCount       ::TFloat

          , tmpData.CountSeparate      ::TFloat
          , tmpData.GoodsNameSeparate  ::TVarChar
          , tmpData.SummHeadCount1     ::TFloat-- �� ��� ������ �� Separate
      FROM tmpDataCalc AS tmpData
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                  ON ObjectLink_Goods_GoodsGroupStat.ObjectId = tmpData.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
             LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = COALESCE (ObjectLink_Goods_GoodsGroupStat.ChildObjectId, 12045234)  --���� �� ������ �� ������ "��-�� ������ � �����"
      WHERE tmpData.GoodsId = inGoodsId OR COALESCE (inGoodsId,0) = 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.25         *
*/

-- ����
-- 
--SELECT * FROM gpSelect_MI_ProductionSeparate_PriceFact (inStartDate := ('24.04.2025')::TDateTime , inEndDate := ('28.04.2025')::TDateTime , inMovementId:=31194601 , inGoodsId := 4261, inPartionGoods := '4218-242592-24.04.2025' ::TVarChar , inSession:= zfCalc_UserAdmin());  --5225 ����� ���
 --SELECT * FROM gpSelect_MI_ProductionSeparate_PriceFact (inStartDate := ('05.05.2025')::TDateTime , inEndDate := ('05.05.2025')::TDateTime , inMovementId:=31194601, inPriceListId_norm:= 0, inGoodsId := 0, inPartionGoods := '4218-11956-05.05.2025' ::TVarChar , inSession:= zfCalc_UserAdmin());  --5225 ����� ���


