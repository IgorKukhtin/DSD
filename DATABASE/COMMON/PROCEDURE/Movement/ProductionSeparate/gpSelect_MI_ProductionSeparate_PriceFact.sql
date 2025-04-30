-- Function: gpSelect_MI_ProductionSeparate_PriceFact()

--DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate_PriceFact (TDateTime, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate_PriceFact (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionSeparate_PriceFact(
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inMovementId         Integer  , -- ключ Документа
    IN inGoodsId            Integer  ,
    IN inPartionGoods       TVarChar   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , GoodsCode Integer
             , GoodsName          TVarChar
             , GoodsGroupCode     Integer
             , GoodsGroupName     TVarChar
             , GoodsGroupNameFull TVarChar
             , GroupStatId   Integer
             , GroupStatName TVarChar
             , isLoss Boolean 
             , Amount TFloat
             , PricePlan TFloat
             , PriceNorm TFloat
             , PriceFact TFloat       --расчет по файлу 
             , SummFact TFloat
             , Count_gr TFloat                 -- кол.товаров в группе
             , Str_print TFloat     --для вывода значения % выхода по группе 
             , Persent_v TFloat                --% выхода 
             , Persent_gr TFloat               --% выхода по группе 
               ) 
           
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbDescId Integer;
    DECLARE vbOperDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 

    WITH
    
       -- список товаров для отличия в Separate основного сырья от голов
       tmpGoods AS (SELECT tmp.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (2006) AS tmp) -- СО- ГОВ. И СВ. Н\К + СЫР
       -- текущий док. с партией
     , tmpMovement AS (--по партии
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
                       --по документу
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
                       --за период
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
      -- текущий док. элементы расход: количество + суммы
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
        -- текущий док., количество + суммы = в одну строку
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
       -- список
     , tmpContainer_all AS (SELECT DISTINCT
                                   CLO_PartionGoods.ObjectId AS PartionGoodsId
                            FROM tmpMIContainer
                                 INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                ON CLO_PartionGoods.ContainerId = tmpMIContainer.ContainerId
                                                               AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                                               AND CLO_PartionGoods.ObjectId <> 80132 -- vbPartionGoodsId_null
                            WHERE tmpMIContainer.DescId = zc_MIContainer_Count()
                           )
     -- список ContainerId (кол. и сумм.) для PartionGoodsId
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

        -- приход от поставщика : кол. и сумм.
     , tmpIncome AS (-- находим по партиям из проводкок
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
                      -- находим по партиям из документа (т.к. не партионный учет то проводок по партиям нет)
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


       -- список документов разделения для товара из прихода от поставщика
     , tmpSeparate AS (SELECT DISTINCT MIContainer.MovementId
                       FROM MovementItemContainer AS MIContainer
                       WHERE MIContainer.ContainerId    IN (SELECT DISTINCT tmpIncome.ContainerId FROM tmpIncome WHERE tmpIncome.DescId = zc_Container_Count())
                         AND MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                      )

       -- разделение - сумма приход (для расчета цены голов)
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

      -- разделение - кол-во приход товаров (если не головы)
     , tmpSeparateS AS (SELECT MIN (MIContainer.ObjectId_analyzer)  AS GoodsId
                             , SUM (MIContainer.Amount)    AS Amount_count
                        FROM MovementItemContainer AS MIContainer
                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                        WHERE MIContainer.DescId   = zc_MIContainer_Count()
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementId IN (SELECT DISTINCT tmpSeparate.MovementId FROM tmpSeparate)
                          AND tmpGoods.GoodsId IS NOT NULL
                       )
      --затраты из приходе поставщика
     , tmpIncomeCost AS (SELECT SUM (COALESCE (MovementFloat_AmountCost.ValueData,0)) AS AmountCost
                         FROM Movement
                              LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                      ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                     AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                         WHERE Movement.ParentId IN (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                           AND Movement.DescId   = zc_Movement_IncomeCost()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         )  
             
     , tmpCursor1 AS ( 
      -- Результат
      SELECT Object_Goods.ValueData   AS GoodsNameMaster
           , tmpMI_group.Amount_count AS CountMaster
           , tmpMI_group.HeadCount    AS HeadCountMaster
           , tmpMI_group.Amount_summ  AS SummMaster
           
           , CASE WHEN tmpMI_group.Amount_count <> 0 THEN tmpMI_group.Amount_summ / tmpMI_group.Amount_count ELSE 0 END AS PriceMaster

           , Object_Goods_income.ValueData    AS GoodsNameIncome
           , tmpIncomeAll.Amount_count        AS CountIncome
           , tmpIncomeAll.Amount_summ         AS SummIncome
           , tmpIncomeCost.AmountCost   ::TFloat AS SummCostIncome   --транспорт
           , tmpIncomeAll.HeadCount           AS HeadCountIncome
           , tmpIncomeAll.CountPacker         AS CountPackerIncome
           , tmpIncomeAll.AmountPartner       AS AmountPartnerIncome
           , tmpIncomeAll.AmountPartnerSecond AS AmountPartnerSecondIncome
           , CASE WHEN tmpIncomeAll.HeadCount <> 0 THEN tmpIncomeAll.Amount_count / tmpIncomeAll.HeadCount ELSE 0 END AS HeadCount1 -- цена головы из Income

           , tmpIncomeAll.Amount_summ / tmpIncomeAll.Amount_count                              AS PriceIncome
           , tmpIncomeAll.Amount_summ / (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker) AS PriceIncome1
           

           , (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker)      AS Count_CountPacker
           , CASE WHEN COALESCE (tmpIncomeAll.Amount_count,0) <> 0 THEN 100 * tmpSeparateS.Amount_count / tmpIncomeAll.Amount_count ELSE 0 END AS PercentCount

           , tmpSeparateS.Amount_count       AS CountSeparate
           , Object_Goods_separate.ValueData AS GoodsNameSeparate
           , tmpSeparateH.Amount_summ        AS SummHeadCount1  -- ср вес головы из Separate
      FROM tmpMI_group
           LEFT JOIN tmpSeparateH ON 1 = 1
           LEFT JOIN tmpSeparateS ON 1 = 1
           LEFT JOIN (SELECT MAX (tmpIncome.GoodsId)                                               AS GoodsId
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

           LEFT JOIN tmpIncomeCost ON 1 = 1
       )     
    
    ---чайлд
     /*   --  ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)"
      , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                          , lfSelect.GoodsKindId AS GoodsKindId
                          , lfSelect.ValuePrice
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18886 /*zc_PriceList_ProductionSeparate()*/, inOperDate:= vbOperDate) AS lfSelect
                    )
     */
        --ПРАЙС - ПЛАН обвалка (сырье)
      , tmpPricePlan AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18889, inOperDate:= inEndDate) AS lfSelect
                        )
        --ПРАЙС - НОРМА ВЫХОДОВ обвалка  - для расчета  % выхода норма 
      , tmpPriceNorm AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 12048635, inOperDate:= inEndDate) AS lfSelect
                        )                              
      , tmpMI AS (SELECT *
                  FROM MovementItem
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementItem.DescId     = zc_MI_Child()
                     AND MovementItem.Amount     <> 0
                     AND MovementItem.isErased   = FALSE
                  )

      , tmpData AS (SELECT Object_Goods.Id  			         AS GoodsId
                         , Object_Goods.ObjectCode  			 AS GoodsCode
                         , Object_Goods.ValueData   			 AS GoodsName
                         , Object_GoodsGroup.ObjectCode   		 AS GoodsGroupCode
                         , Object_GoodsGroup.ValueData   		 AS GoodsGroupName 
                         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                         , SUM (MovementItem.Amount)::TFloat		 AS Amount 
                         , SUM (SUM (COALESCE (MovementItem.Amount,0))) OVER (PARTITION BY ObjectString_Goods_GoodsGroupFull.ValueData) ::TFloat AS  TotalAmount_gr
                        
              
                         , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId IN (1966 -- СО-НЕ ВХОД. В ВЫХОД маг
                                                                                 , 1967 -- ****СО-ПОТЕРИ - _toolsView_GoodsProperty_Obvalka_isLoss_TWO
                                                                                 , 1973 -- СО-КОСТИ маг
                                                                                  )
                                     THEN TRUE
                                ELSE FALSE
                           END :: Boolean AS isLoss
              
                         --доп расчет для печати 
                           --кол.E - плановая цена - ПРАЙС - ПЛАН обвалка (сырье)
                         , COALESCE (tmpPricePlan.ValuePrice, 0) :: TFloat AS PricePlan
                         --кол F  - сумма плановая =  плановая цена * количество
                         , (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0)))::TFloat     AS SummaPlan        --kol_F 
                         , SUM (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0))) OVER () AS TotalSummaPlan   --Total_kol_F 
                         -- - НОРМА ВЫХОДОВ обвалка
                         , COALESCE (tmpPriceNorm.ValuePrice, 0)  AS PriceNorm
                    FROM tmpMI AS MovementItem
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
                         LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                               AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
             
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
                            , COALESCE (tmpPricePlan.ValuePrice, 0)
                            , ObjectLink_Goods_GoodsGroup.ChildObjectId
                            , COALESCE (tmpPriceNorm.ValuePrice, 0)
                            , Object_GoodsGroup.ObjectCode
                            , Object_GoodsGroup.ValueData
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
               
                          --доп расчет для печати 
                          , tmpData.SummaPlan 
                          , tmpData.TotalSummaPlan
                          -- кол G  итого сумма по SummaPlan дел на  SummaPlan т.е. доля
                          , CASE WHEN COALESCE (tmpData.TotalSummaPlan,0) <> 0 THEN tmpData.SummaPlan / tmpData.TotalSummaPlan ELSE 0 END :: TFloat AS Summa_dolyaPlan
                          --
                          , CASE WHEN COALESCE (tmpData.Amount,0) <> 0 
                                 THEN (tmpData.SummaPlan - 
                                      ( (tmpData.TotalSummaPlan -  (COALESCE (tmpCursor1.SummIncome,0) + COALESCE (tmpCursor1.SummCostIncome,0))  
                                         ) 
                                         * CASE WHEN COALESCE (tmpData.TotalSummaPlan,0) <> 0 THEN tmpData.SummaPlan / tmpData.TotalSummaPlan ELSE 0 END)   /* kol_H*/      
                                      )  /*kol_i */ 
                                      / COALESCE (tmpData.Amount,0) 
                                      ELSE 0 
                            END AS PriceFact
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.Amount,0)/ tmpCursor1.countmaster) ELSE 0 END         :: TFloat AS Persent_v 
                          , CASE WHEN COALESCE (tmpCursor1.countmaster,0) <> 0 THEN 100 * (COALESCE (tmpData.TotalAmount_gr,0)/ tmpCursor1.countmaster) ELSE 0 END :: TFloat AS Persent_gr

                          -- сколько строк в группе
                          , COUNT (*) OVER (PARTITION BY tmpData.GoodsGroupNameFull) AS Count_gr
                             
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
          , tmpData.isLoss
          , tmpData.Amount    ::TFloat
          , tmpData.PricePlan ::TFloat
          , tmpData.PriceNorm ::TFloat
          --
          , tmpData.PriceFact ::TFloat       --расчет по файлу 
          , (tmpData.PriceFact * COALESCE (tmpData.Amount,0)) ::TFloat AS SummFact
          , tmpData.Count_gr  ::TFloat               -- кол.товаров в группе
          , ROUND (tmpData.Count_gr / 2.0 , 0) ::TFloat AS Str_print     --для вывода значения % выхода по группе 
          , tmpData.Persent_v   ::TFloat             --% выхода 
          , tmpData.Persent_gr  ::TFloat             --% выхода по группе 
      FROM tmpDataCalc AS tmpData
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                  ON ObjectLink_Goods_GoodsGroupStat.ObjectId = tmpData.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
             LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = COALESCE (ObjectLink_Goods_GoodsGroupStat.ChildObjectId, 12045234)  --если не задано то группа "СО-не входит в выход"
      WHERE tmpData.GoodsId = inGoodsId OR COALESCE (inGoodsId,0) = 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.25         *
*/

-- тест
-- 
--SELECT * FROM gpSelect_MI_ProductionSeparate_PriceFact (inStartDate := ('24.04.2025')::TDateTime , inEndDate := ('28.04.2025')::TDateTime , inMovementId:=0, inGoodsId := 4261, inPartionGoods := '4218-242592-24.04.2025' ::TVarChar , inSession:= zfCalc_UserAdmin());  --5225 живой вес


