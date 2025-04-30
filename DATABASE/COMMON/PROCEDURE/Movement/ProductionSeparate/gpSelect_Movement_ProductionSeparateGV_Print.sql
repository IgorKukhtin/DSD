-- Function: gpSelect_Movement_ProductionSeparateGV_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparateGV_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparateGV_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbDescId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbPartionGoodsId_null Integer;
    DECLARE vbPartionGoods TVarChar;
            vbvbPartionGoods_GV TVarChar;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementString_PartionGoods.ValueData
            INTO vbDescId, vbStatusId, vbOperDate, vbPartionGoods
     FROM Movement
          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
     WHERE Movement.Id = inMovementId;

     --партия для ЖВ
     vbvbPartionGoods_GV := CASE WHEN vbPartionGoods ::TVarChar LIKE 'пр-%' THEN SUBSTRING (vbPartionGoods::TVarChar FROM 4)
                                 ELSE vbPartionGoods ::TVarChar
                            END;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


    -- поиск пустой партии, т.к. ее надо отбросить
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
                               AND ObjectLink_PartionCell.ObjectId       IS NULL -- т.е. вообще нет этого св-ва
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
                             , AmountPartnerIncome TFloat, AmountPartnerSecondIncome TFloat
                             , HeadCount1  TFloat
                             , PriceIncome  Tfloat
                             , PriceIncome1  Tfloat
                             , PriceTransport  Tfloat 
                             , SummCostIncome TFloat
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
                             , AmountPartnerIncome, AmountPartnerSecondIncome
                             , HeadCount1
                             , PriceIncome
                             , PriceIncome1
                             , PriceTransport
                             , SummCostIncome
                             , Count_CountPacker
                             , PercentCount
                             , CountSeparate
                             , GoodsNameSeparate
                             , SummHeadCount1
                             , Separate_info)

  WITH -- список товаров для отличия в Separate основного сырья от голов
       tmpGoods AS (SELECT GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (2006)) -- СО- ГОВ. И СВ. Н\К + СЫР
       -- текущий док. с партией
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
      -- текущий док. элементы расход: количество + суммы
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
      
      -- Результат
      SELECT tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.PartionGoods
           , tmpMovement.OperDate_partion
           , Object_Goods.ValueData   AS GoodsNameMaster
           , tmpMI_group.Amount_count AS CountMaster
           , tmpMI_group.Amount_summ  AS SummMaster
           , tmpMI_group.HeadCount    AS HeadCountMaster
           , CASE WHEN tmpMI_group.Amount_count <> 0 THEN (tmpMI_group.Amount_summ-tmpIncomeCost.AmountCost) / tmpMI_group.Amount_count ELSE 0 END AS PriceMaster

           , Object_From.ValueData            AS FromName
           , Object_PersonalPacker.ValueData  AS PersonalPackerName
           , Object_Goods_income.ValueData    AS GoodsNameIncome
           , tmpIncomeAll.Amount_count        AS CountIncome
           , tmpIncomeAll.Amount_summ         AS SummIncome
           , 0 :: Tfloat                      AS SummDop

           , tmpIncomeAll.HeadCount           AS HeadCountIncome
           , tmpIncomeAll.CountPacker         AS CountPackerIncome
           , tmpIncomeAll.AmountPartner       AS AmountPartnerIncome
           , tmpIncomeAll.AmountPartnerSecond AS AmountPartnerSecondIncome
           , CASE WHEN tmpIncomeAll.HeadCount <> 0 THEN tmpIncomeAll.Amount_count / tmpIncomeAll.HeadCount ELSE 0 END AS HeadCount1 -- цена головы из Income

           , tmpIncomeAll.Amount_summ / tmpIncomeAll.Amount_count                              AS PriceIncome
           , tmpIncomeAll.Amount_summ / (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker) AS PriceIncome1
           , 0 :: Tfloat                                                                       AS PriceTransport
           , tmpIncomeCost.AmountCost   ::TFloat                                               AS SummCostIncome

           , (tmpIncomeAll.Amount_count - tmpIncomeAll.CountPacker)      AS Count_CountPacker
           , 100 * tmpSeparateS.Amount_count / tmpIncomeAll.Amount_count AS PercentCount

           , tmpSeparateS.Amount_count       AS CountSeparate
           , Object_Goods_separate.ValueData AS GoodsNameSeparate
           , tmpSeparateH.Amount_summ        AS SummHeadCount1  -- ср вес головы из Separate

           , CASE WHEN Object_Goods.ObjectCode = 4218 -- ЖИВОЙ ВЕС СВИНИНА
                       THEN 'Убой' -- 1
                  WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId = 2007 -- СО- ЗАКУП. СВИН. Н\\Ж* зп жил
                       THEN 'Разжиловка' -- 3
                  ELSE 'Обвалка' -- '2-Обвалка'
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

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

           LEFT JOIN tmpIncomeCost ON 1 = 1
          ;  


   ---даннык строк для курсора2 
    CREATE TEMP TABLE tmpCursor2 (GoodsCode Integer
                                , GoodsName TVarChar
                                , GoodsGroupCode Integer, GoodsGroupName TVarChar
                                , GoodsGroupNameFull TVarChar
                                , GroupStatId Integer
                                , GroupStatName TVarChar
                                , isLoss  Boolean
                                , Amount  TFloat
                                , LiveWeight  TFloat
                                , HeadCount  TFloat
                                , SummPrice  TFloat
                                , Summ  TFloat
                                , PricePlan TFloat
                                , PriceNorm TFloat
                                , PriceFact  Tfloat
                                , SummFact  Tfloat
                                , Count_gr  Tfloat 
                                , Str_print TFloat
                                , Persent_v   Tfloat
                                , Persent_gr   Tfloat
                                ) ON COMMIT DROP;
    INSERT INTO tmpCursor2 (GoodsCode 
                                , GoodsName
                                , GoodsGroupCode 
                                , GoodsGroupName 
                                , GoodsGroupNameFull 
                                , GroupStatId 
                                , GroupStatName
                                , isLoss  
                                , Amount  
                                --, LiveWeight  
                                --, HeadCount  
                                --, SummPrice  
                                --, Summ  
                                , PricePlan, PriceNorm
                               
                                , PriceFact
                                , SummFact
                                , Count_gr 
                                , Str_print
                                , Persent_v
                                , Persent_gr)

    
     SELECT tmpData.GoodsCode
          , tmpData.GoodsName
          , tmpData.GoodsGroupCode
          , tmpData.GoodsGroupName
          , tmpData.GoodsGroupNameFull 
          , tmpData.GroupStatId
          , tmpData.GroupStatName
          , tmpData.isLoss
          , tmpData.Amount
          , tmpData.PricePlan
          , tmpData.PriceNorm
          

          , tmpData.PriceFact ::TFloat
          , tmpData.SummFact ::TFloat
          , tmpData.Count_gr                 -- кол.товаров в группе
          , tmpData.Str_print                --для вывода значения % выхода по группе 
          , tmpData.Persent_v                --% выхода 
          , tmpData.Persent_gr               --% выхода по группе 
      FROM gpSelect_MI_ProductionSeparate_PriceFact(vbOperDate, vbOperDate, 0, 0, vbPartionGoods, inSession) AS tmpData;
       

    OPEN Cursor1 FOR
     WITH 
     --данные по партии для товара 4134 по партии
     tmpGoods_4134 AS (SELECT tmpData.GoodsCode
                            , tmpData.GoodsName
                            , tmpData.Amount
                            , tmpData.PricePlan
                            , tmpData.PriceFact ::TFloat
                            , tmpData.SummFact ::TFloat
                            , tmpData.Persent_v
                       FROM gpSelect_MI_ProductionSeparate_PriceFact(vbOperDate::TDateTime, vbOperDate::TDateTime, 0, 4261, vbvbPartionGoods_GV, inSession) AS tmpData         --4261  - 'товар код 4134'
                       ) 

     -- Результат
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
           , tmpCursor1.AmountPartnerIncome
           , tmpCursor1.AmountPartnerSecondIncome
           , tmpCursor1.HeadCount1 -- цена головы из Income

           , tmpCursor1.PriceIncome
           , tmpCursor1.PriceIncome1
           , tmpCursor1.PriceTransport
           , tmpCursor1.SummCostIncome

           , tmpCursor1.Count_CountPacker
           , tmpCursor1.PercentCount

           , tmpCursor1.CountSeparate
           , tmpCursor1.GoodsNameSeparate
           , tmpCursor1.SummHeadCount1  -- ср вес головы из Separate

           , tmpCursor1.Separate_info   
           
           , tmpGoods_4134.GoodsName      AS GoodsName_4134
           , tmpGoods_4134.PriceFact      AS PriceFact_4134
           , tmpGoods_4134.Amount         AS Amount_4134
           , tmpGoods_4134.Persent_v :: TFloat AS Persent_4134

      FROM tmpCursor1
           LEFT JOIN tmpGoods_4134 ON 1 = 1
      ;    


    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     SELECT tmpCursor2.GoodsCode
          , tmpCursor2.GoodsName
          , tmpCursor2.GoodsGroupCode
          , tmpCursor2.GoodsGroupName
          , tmpCursor2.GoodsGroupNameFull 
          , tmpCursor2.GroupStatId
          , tmpCursor2.GroupStatName
          , tmpCursor2.Amount
          , tmpCursor2.PricePlan
          , tmpCursor2.PriceNorm
          , tmpCursor2.isLoss
          , tmpCursor2.PriceFact                --расчет по файлу 
          , tmpCursor2.SummFact
          , tmpCursor2.Count_gr                 -- кол.товаров в группе
          , tmpCursor2.Str_print                --для вывода значения % выхода по группе 
          , tmpCursor2.Persent_v                --% выхода 
          , tmpCursor2.Persent_gr               --% выхода по группе 
     FROM tmpCursor2;
        
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 29.04.25         *
*/

-- тест
-- 
--SELECT * FROM gpSelect_Movement_ProductionSeparateGV_Print (inMovementId:= 30723210 , inSession:= zfCalc_UserAdmin());
--FETCH ALL "<unnamed portal 98>";