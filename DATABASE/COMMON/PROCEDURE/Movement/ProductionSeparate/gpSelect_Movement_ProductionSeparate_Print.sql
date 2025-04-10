-- Function: gpSelect_Movement_ProductionSeparate_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbDescId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbPartionGoodsId_null Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
            INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- ��� ��� �������� ������
        RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


    -- ����� ������ ������, �.�. �� ���� ���������
    vbPartionGoodsId_null:= (SELECT Object.Id
                             FROM Object
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId = Object.Id
                                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                       ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                      AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                  LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                       ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                      AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                             WHERE Object.ValueData = ''
                               AND Object.DescId = zc_Object_PartionGoods()
                               AND ObjectLink_Unit.ObjectId IS NULL
                               AND ObjectLink_GoodsKindComplete.ObjectId IS NULL
                               AND ObjectLink_PartionCell.ObjectId       IS NULL -- �.�. ������ ��� ����� ��-��
                            ); -- 80132

 CREATE TEMP TABLE tmpCursor1 (InvNumber TVarChar
                             , OperDate TDateTime
                             , PartionGoods TVarChar
                             , OperDate_partion TDateTime
                             , GoodsNameMaster TVarChar
                             , CountMaster TFloat
                             , SummMaster TFloat
                             , HeadCountMaster TFloat
                             , PriceMaster TFloat
                             , FromName TVarChar
                             , PersonalPackerName TVarChar
                             , GoodsNameIncome TVarChar
                             , CountIncome  TFloat
                             , SummIncome  TFloat
                             , SummDop  TFloat
                             , HeadCountIncome  TFloat
                             , CountPackerIncome  TFloat
                             , HeadCount1  TFloat
                             , PriceIncome  Tfloat
                             , PriceIncome1  Tfloat
                             , PriceTransport  Tfloat
                             , Count_CountPacker   Tfloat
                             , PercentCount   Tfloat
                             , CountSeparate Tfloat
                             , GoodsNameSeparate TVarChar
                             , SummHeadCount1   Tfloat
                             , Separate_info TVarChar ) ON COMMIT DROP;
    INSERT INTO tmpCursor1 (InvNumber 
                             , OperDate 
                             , PartionGoods 
                             , OperDate_partion 
                             , GoodsNameMaster 
                             , CountMaster 
                             , SummMaster 
                             , HeadCountMaster 
                             , PriceMaster 
                             , FromName 
                             , PersonalPackerName 
                             , GoodsNameIncome 
                             , CountIncome  
                             , SummIncome  
                             , SummDop  
                             , HeadCountIncome
                             , CountPackerIncome
                             , HeadCount1
                             , PriceIncome
                             , PriceIncome1
                             , PriceTransport
                             , Count_CountPacker
                             , PercentCount
                             , CountSeparate
                             , GoodsNameSeparate
                             , SummHeadCount1
                             , Separate_info)

  WITH -- ������ ������� ��� ������� � Separate ��������� ����� �� �����
       tmpGoods AS (SELECT GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (2006)) -- ��- ���. � ��. �\� + ���
       -- ������� ���. � �������
     , tmpMovement AS (SELECT Movement.InvNumber                    AS InvNumber
                            , Movement.OperDate                     AS OperDate
                            , MovementString_PartionGoods.ValueData AS PartionGoods

                            , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                            , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion

                        FROM Movement
                             LEFT JOIN MovementString AS MovementString_PartionGoods
                                                      ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                     AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                        WHERE Movement.Id = inMovementId
                       )
      -- ������� ���. �������� ������: ���������� + �����
     , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                               , MIContainer.DescId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ContainerId       ELSE 0 END) AS ContainerId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ObjectId_analyzer ELSE 0 END) AS GoodsId
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS Amount_count
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS Amount_summ
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId = inMovementId
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
                       WHERE MovementItemFloat.DescId IN ( zc_MIFloat_AmountPacker(), zc_MIFloat_HeadCount())
                         AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpIncome_Container.MovementItemId FROM tmpIncome_Container)
                       )

        -- ������ �� ���������� : ���. � ����.
     , tmpIncome AS (-- ������� �� ������� �� ���������
                      /*SELECT tmpContainer.DescId
                           , tmpContainer.ContainerId
                           , MIContainer.MovementId
                           , MIContainer.ObjectId_analyzer AS GoodsId
                           , CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN SUM (MIContainer.Amount) ELSE 0 END AS Amount_count
                           , CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN SUM (MIContainer.Amount) ELSE 0 END AS Amount_summ
                           , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS CountPacker
                           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))    AS HeadCount

                      FROM tmpContainer
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.MovementDescId = zc_Movement_Income()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                       ON MIFloat_AmountPacker.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                      AND COALESCE (MIContainer.AnalyzerId, 0) = 0

                      GROUP BY tmpContainer.DescId, tmpContainer.ContainerId, MIContainer.MovementId, MIContainer.ObjectId_analyzer, MIContainer.DescId
                      */
                      SELECT MIContainer.DescId
                           , MIContainer.ContainerId
                           , MIContainer.MovementId
                           , MIContainer.ObjectId_analyzer AS GoodsId
                           , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN (MIContainer.Amount) ELSE 0 END) AS Amount_count
                           , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN (MIContainer.Amount) ELSE 0 END) AS Amount_summ
                           , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS CountPacker
                           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))    AS HeadCount
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
      -- ���������
      SELECT tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.PartionGoods
           , tmpMovement.OperDate_partion
           , Object_Goods.ValueData   AS GoodsNameMaster
           , tmpMI_group.Amount_count AS CountMaster
           , tmpMI_group.Amount_summ  AS SummMaster
           , tmpMI_group.HeadCount    AS HeadCountMaster
           , CASE WHEN tmpMI_group.Amount_count <> 0 THEN tmpMI_group.Amount_summ / tmpMI_group.Amount_count ELSE 0 END AS PriceMaster

           , Object_From.ValueData            AS FromName
           , Object_PersonalPacker.ValueData  AS PersonalPackerName
           , Object_Goods_income.ValueData    AS GoodsNameIncome
           , tmpIncomeAll.Amount_count        AS CountIncome
           , tmpIncomeAll.Amount_summ         AS SummIncome
           , 0 :: Tfloat                      AS SummDop

           , tmpIncomeAll.HeadCount           AS HeadCountIncome
           , tmpIncomeAll.CountPacker         AS CountPackerIncome
           , CASE WHEN tmpIncomeAll.HeadCount <> 0 THEN tmpIncomeAll.Amount_count / tmpIncomeAll.HeadCount ELSE 0 END AS HeadCount1 -- ���� ������ �� Income

           , tmpIncomeAll.Amount_summ / tmpIncomeAll.Amount_count                              AS PriceIncome
           , tmpIncomeAll.Amount_summ / (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker) AS PriceIncome1
           , 0 :: Tfloat                                                                       AS PriceTransport

           , (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker)      AS Count_CountPacker
           , 100 * tmpSeparateS.Amount_count / tmpIncomeAll.Amount_count AS PercentCount

           , tmpSeparateS.Amount_count       AS CountSeparate
           , Object_Goods_separate.ValueData AS GoodsNameSeparate
           , tmpSeparateH.Amount_summ        AS SummHeadCount1  -- �� ��� ������ �� Separate

           , CASE WHEN Object_Goods.ObjectCode = 4218 -- ����� ��� �������
                       THEN '����' -- 1
                  WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId = 2007 -- ��- �����. ����. �\\�* �� ���
                       THEN '����������' -- 3
                  ELSE '�������' -- '2-�������'
             END :: TVarChar AS Separate_info

      FROM tmpMovement
           LEFT JOIN tmpMI_group ON 1 = 1
           LEFT JOIN tmpSeparateH ON 1 = 1
           LEFT JOIN tmpSeparateS ON 1 = 1
           LEFT JOIN (SELECT MAX (tmpIncome.GoodsId)                                        AS GoodsId
                           , MAX (COALESCE (MovementLinkObject_From.ObjectId, 0))           AS FromId
                           , MAX (COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0)) AS PersonalPackerId
                           , SUM (tmpIncome.Amount_count) AS Amount_count, SUM ( tmpIncome.Amount_summ) AS Amount_summ
                           , SUM (tmpIncome.CountPacker) AS CountPacker, SUM (tmpIncome.HeadCount) AS HeadCount

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

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          ;  


    OPEN Cursor1 FOR
     -- ���������
      SELECT tmpCursor1.InvNumber
           , tmpCursor1.OperDate
           , tmpCursor1.PartionGoods
           , tmpCursor1.OperDate_partion
           , tmpCursor1.GoodsNameMaster
           , tmpCursor1.CountMaster
           , tmpCursor1.SummMaster
           , tmpCursor1.HeadCountMaster
           , tmpCursor1.PriceMaster

           , tmpCursor1.FromName
           , tmpCursor1.PersonalPackerName
           , tmpCursor1.GoodsNameIncome
           , tmpCursor1.CountIncome
           , tmpCursor1.SummIncome
           , tmpCursor1.SummDop

           , tmpCursor1.HeadCountIncome
           , tmpCursor1.CountPackerIncome
           , tmpCursor1.HeadCount1 -- ���� ������ �� Income

           , tmpCursor1.PriceIncome
           , tmpCursor1.PriceIncome1
           , tmpCursor1.PriceTransport

           , tmpCursor1.Count_CountPacker
           , tmpCursor1.PercentCount

           , tmpCursor1.CountSeparate
           , tmpCursor1.GoodsNameSeparate
           , tmpCursor1.SummHeadCount1  -- �� ��� ������ �� Separate

           , tmpCursor1.Separate_info

      FROM tmpCursor1;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH tmpMIContainer AS (SELECT MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                            FROM MovementItemContainer AS MIContainer
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND MIContainer.MovementId = inMovementId
                              AND MIContainer.isActive = TRUE
                            GROUP BY MIContainer.MovementItemId
                           )

      , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                          , lfSelect.GoodsKindId AS GoodsKindId
                          , lfSelect.ValuePrice
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18886 /*zc_PriceList_ProductionSeparate()*/, inOperDate:= vbOperDate) AS lfSelect
                    )
        --����� - ���� ������� (�����)
      , tmpPricePlan AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18889, inOperDate:= vbOperDate) AS lfSelect
                        )
 

      , tmpData AS (SELECT Object_Goods.ObjectCode  			 AS GoodsCode
                        , Object_Goods.ValueData   			 AS GoodsName
                        , Object_GoodsGroup.ValueData   		 AS GoodsGroupName
                        , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                        , Object_Measure.ValueData                    AS MeasureName
             
                        , SUM (MovementItem.Amount)::TFloat		 AS Amount 
                        , SUM (SUM (COALESCE (MovementItem.Amount,0))) OVER (PARTITION BY ObjectString_Goods_GoodsGroupFull.ValueData) ::TFloat AS  TotalAmount_gr
                        , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) :: TFloat  AS LiveWeight
                        , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) :: TFloat	 AS HeadCount
                        , CASE WHEN SUM (MovementItem.Amount) <> 0 THEN SUM (COALESCE (tmpMIContainer.Amount,0)) / SUM (MovementItem.Amount) ELSE 0 END AS SummPrice
                        , SUM (COALESCE (tmpMIContainer.Amount,0))      AS Summ
                        , COALESCE (tmpPrice.ValuePrice, 0) :: TFloat AS PricePlan
             
                        , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId IN (1966 -- ��-�� ����. � ����� ���
                                                                                , 1967 -- ****��-������ - _toolsView_GoodsProperty_Obvalka_isLoss_TWO
                                                                                , 1973 -- ��-����� ���
                                                                                 )
                                    THEN TRUE
                               ELSE FALSE
                          END :: Boolean AS isLoss
             
                        --��� ������ ��� ������ 4002
                        --���.E - �������� ���� - ����� - ���� ������� (�����)
                        --  , COALESCE (tmpPricePlan.ValuePrice, 0)  AS Price_kol_E
                        --��� F  - ����� �������� =E16*C16
                        , (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0)))::TFloat     AS kol_F 
                        , SUM (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0))) OVER () AS Total_kol_F
                    FROM MovementItem
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
                         LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                     ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                    AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                         LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                     ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                    AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
             
                         LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                               AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
             
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             
                         LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
             
                         -- ����� - ���� ����������� (�����)
                         -- �������� ��� ���� ������
                         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                                           ANd tmpPrice.GoodsKindId IS NULL

                         LEFT JOIN tmpPricePlan ON tmpPricePlan.GoodsId = MovementItem.ObjectId
                                               ANd tmpPricePlan.GoodsKindId IS NULL
             
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
             
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Child()
                       AND MovementItem.Amount     <> 0
                       AND MovementItem.isErased   = FALSE
             
                     GROUP BY Object_Goods.ObjectCode
                        , Object_Goods.ValueData
                        , Object_GoodsGroup.ValueData
                        , ObjectString_Goods_GoodsGroupFull.ValueData
                        , Object_Measure.ValueData
                        , COALESCE (tmpPrice.ValuePrice, 0)
                        , ObjectLink_Goods_GoodsGroup.ChildObjectId
           )                
   , tmpDataCalc AS (SELECT tmpData.GoodsCode
                          , tmpData.GoodsName
                          , tmpData.GoodsGroupName
                          , tmpData.GoodsGroupNameFull
                          , tmpData.MeasureName
               
                          , tmpData.Amount
                          , tmpData.LiveWeight
                          , tmpData.HeadCount
                          , tmpData.SummPrice
                          , tmpData.Summ
                          , tmpData.PricePlan
               
                          , tmpData.isLoss
               
                          --��� ������ ��� ������ 4002
                          --���.E - �������� ���� - ����� - ���� ������� (�����)
                         -- , tmpData.Price_kol_E
                          --��� F  - ����� �������� =E16*C16
                          , tmpData.kol_F 
                          , tmpData.Total_kol_F
                          -- ��� G  ����� ����� �� kol_F ��� ��  kol_F �.�. ����
                          , CASE WHEN COALESCE (tmpData.Total_kol_F,0) <> 0 THEN tmpData.kol_F / tmpData.Total_kol_F ELSE 0 END :: TFloat AS kol_G
                          --
                          , CASE WHEN COALESCE (tmpData.Amount,0) <> 0 
                                 THEN (tmpData.kol_F - 
                                      ( (tmpData.Total_kol_F - tmpCursor1.summheadcount1) * CASE WHEN COALESCE (tmpData.Total_kol_F,0) <> 0 THEN tmpData.kol_F / tmpData.Total_kol_F ELSE 0 END)/* kol_H*/      
                                      )  /*kol_i */ 
                                      / COALESCE (tmpData.Amount,0) 
                                      ELSE 0 
                            END AS PriceFact
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.Amount,0)/ tmpCursor1.countmaster) ELSE 0 END         :: TFloat AS Persent_v 
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.TotalAmount_gr,0)/ tmpCursor1.countmaster) ELSE 0 END :: TFloat AS Persent_gr

                          -- ������� ����� � ������
                          , COUNT (*) OVER (PARTITION BY tmpData.GoodsGroupNameFull) AS Count_gr
                             
                      FROM tmpData
                        LEFT JOIN tmpCursor1 ON 1 = 1 
                      )

     SELECT tmpData.GoodsCode
          , tmpData.GoodsName
          , tmpData.GoodsGroupName
          , tmpData.GoodsGroupNameFull
          , tmpData.MeasureName

          , tmpData.Amount
          , tmpData.LiveWeight
          , tmpData.HeadCount
          , tmpData.SummPrice
          , tmpData.Summ
          , tmpData.PricePlan

          , tmpData.isLoss

          --��� ������ ��� ������ 4002
          --���.E - �������� ���� - ����� - ���� ������� (�����)
          --��� F  - ����� �������� =E16*C16
          --, tmpData.kol_F 
          --, tmpData.Total_kol_F  --����� ����� ��������
          -- ��� G  ����� ����� �� kol_F ��� ��  kol_F �.�. ����
          --, tmpData.kol_G
          --
          , tmpData.PriceFact ::TFloat
          , (tmpData.PriceFact * COALESCE (tmpData.Amount,0)) ::TFloat AS SummFact
          , tmpData.Count_gr
          , ROUND (tmpData.Count_gr / 2.0 , 0) ::TFloat AS Str_print
          , tmpData.Persent_v
          , tmpData.Persent_gr   
  
      FROM tmpDataCalc AS tmpData
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_ProductionSeparate_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.19         *
 18.10.17         *
 24.03.17         *
 03.04.15         *
*/

-- ����
-- 
--SELECT * FROM gpSelect_Movement_ProductionSeparate_Print (inMovementId:= 30723210 , inSession:= zfCalc_UserAdmin());
--FETCH ALL "<unnamed portal 98>";

