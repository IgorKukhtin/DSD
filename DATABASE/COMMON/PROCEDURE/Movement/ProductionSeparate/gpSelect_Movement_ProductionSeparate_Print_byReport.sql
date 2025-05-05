-- Function: gpSelect_Movement_ProductionSeparate_Print_byReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Print_byReport (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Print_byReport (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Print_byReport(
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inFromId             Integer   ,    -- от кого 
    IN inToId               Integer   ,    -- кому
    IN inPriceListId_norm   Integer   ,
    IN inMovementId         Integer  , -- ключ Документа
    IN inGoodsId            Integer  ,
    IN inIsPartion          Boolean   ,
    IN inSession            TVarChar    -- сессия пользователя
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
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId,0) <> 0
     THEN
        -- параметры из документа
        SELECT Movement.DescId
             , Movement.StatusId
             , Movement.OperDate
               INTO vbDescId, vbStatusId, vbOperDate
        FROM Movement
        WHERE Movement.Id = inMovementId;

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

    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;

    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;
    END IF;

    -- ограничения по КОМУ
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;
    END IF;

    --если не выбран прайс норма 
    inPriceListId_norm := CASE WHEN COALESCE (inPriceListId_norm,0) = 0 THEN 12048635 ELSE inPriceListId_norm END;

 CREATE TEMP TABLE tmpCursor1 (MovementId Integer
                             , InvNumber TVarChar
                             , OperDate TDateTime
                             , PartionGoods TVarChar
                             , OperDate_partion TDateTime
                             , GoodsNameMaster TVarChar
                             , CountMaster TFloat
                             , CountMaster_4134 TFloat
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
    INSERT INTO tmpCursor1 (MovementId
                             , InvNumber 
                             , OperDate 
                             , PartionGoods 
                             , OperDate_partion 
                             , GoodsNameMaster 
                             , CountMaster
                             , CountMaster_4134 
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
     , tmpMovement_all AS (SELECT Movement.Id                           AS MovementId
                                , Movement.InvNumber                    AS InvNumber
                                , Movement.OperDate                     AS OperDate
                                , MovementString_PartionGoods.ValueData AS PartionGoods

                                , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                                , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion

                                , MovementLinkObject_From.ObjectId AS FromId
                           FROM Movement
                                LEFT JOIN MovementString AS MovementString_PartionGoods
                                                         ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                        AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           WHERE Movement.Id = inMovementId
                             AND COALESCE (inMovementId,0) <> 0
                          UNION
                           SELECT Movement.Id                           AS MovementId
                                , Movement.InvNumber                    AS InvNumber
                                , Movement.OperDate                     AS OperDate
                                , MovementString_PartionGoods.ValueData AS PartionGoods

                                , zfCalc_PartionGoods_PartnerCode (MovementString_PartionGoods.ValueData) AS PartnerCode_partion
                                , zfCalc_PartionGoods_OperDate (MovementString_PartionGoods.ValueData)    AS OperDate_partion

                                , MovementLinkObject_From.ObjectId AS FromId
                            FROM Movement
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId
                                  
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId
                            
                                  LEFT JOIN MovementString AS MovementString_PartionGoods
                                                           ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                          AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                            WHERE COALESCE (inMovementId,0) = 0
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_ProductionSeparate()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                       )
    --так быстрее работает 
    , tmpMI_MasterALL AS (
                        SELECT MovementItem.*
                        FROM MovementItem 
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_all.MovementId FROM tmpMovement_all) 
                           AND MovementItem.DescId = zc_MI_Master() 
                           AND MovementItem.isErased = FALSE
                        )
     , tmpMI_Master AS (SELECT MovementItem.*
                        FROM tmpMI_MasterALL AS MovementItem 
                        WHERE MovementItem.ObjectId = inGoodsId
                           OR COALESCE (inGoodsId,0) = 0
                        )

      --ограничиваем товаром если выбор нескольких документов по товару
     , tmpMovement AS (SELECT tmpMovement_all.*
                       FROM tmpMovement_all
                       WHERE tmpMovement_all.MovementId IN (SELECT DISTINCT tmpMI_Master.MovementId FROM tmpMI_Master)
                       )
      -- текущий док. элементы расход: количество + суммы
     , tmpMIContainer AS (SELECT MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.DescId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ContainerId       ELSE 0 END) AS ContainerId
                               , MAX (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.ObjectId_analyzer ELSE 0 END) AS GoodsId
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS Amount_count
                               , -1 * SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS Amount_summ
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId IN (SELECT tmpMovement.MovementId FROM tmpMovement)
                            AND MIContainer.isActive = FALSE
                          GROUP BY MIContainer.MovementItemId
                                 , MIContainer.DescId
                                 , MIContainer.MovementId
                         )
        -- текущий док., количество + суммы = в одну строку
     , tmpMI_group AS (SELECT tmpMIContainer.MovementId 
                            , MAX (tmpMIContainer.GoodsId)                        AS GoodsId
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
                       GROUP BY tmpMIContainer.MovementId
                      )
       -- список
     , tmpContainer_all AS (SELECT DISTINCT
                                   CLO_PartionGoods.ObjectId AS PartionGoodsId
                                 , tmpMIContainer.MovementId
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
                             , tmp.MovementId
                        FROM tmpContainer_all AS tmp
                             INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ObjectId = tmp.PartionGoodsId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                             LEFT JOIN Container ON Container.Id =  CLO_PartionGoods.ContainerId
                       )

     , tmpIncome_Container AS (SELECT MIContainer.*
                                    , tmpContainer.MovementId AS MovementId_separate
                               FROM MovementItemContainer AS MIContainer
                                    INNER JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId
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
                           , MIContainer.MovementId_separate
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
                             , MIContainer.MovementId_separate
                             , MIContainer.ObjectId_analyzer 
                     UNION ALL
                      -- находим по партиям из документа (т.к. не партионный учет то проводок по партиям нет)
                      SELECT 0 AS DescId
                           , 0 AS ContainerId
                           , MIContainer.MovementId
                           , tmpContainer.MovementId AS MovementId_separate
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
                             , tmpContainer.MovementId
                     )


       -- список документов разделения для товара из прихода от поставщика
     , tmpSeparate AS (SELECT DISTINCT MIContainer.MovementId
                            , tmpIncome.MovementId AS MovementId_income
                       FROM MovementItemContainer AS MIContainer
                            INNER JOIN tmpIncome ON tmpIncome.ContainerId = MIContainer.ContainerId
                                                AND tmpIncome.DescId = zc_Container_Count()
                       WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpIncome.ContainerId FROM tmpIncome WHERE tmpIncome.DescId = zc_Container_Count())
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

     , tmpSeparateH AS (SELECT tmpSeparateH_All.MovementId
                             , SUM (tmpSeparateH_All.Amount) AS Amount_summ
                        FROM tmpSeparateH_All
                        GROUP BY tmpSeparateH_All.MovementId
                        )


      -- разделение - кол-во приход товаров (если не головы)
     , tmpSeparateS AS (SELECT MIN (MIContainer.ObjectId_analyzer)  AS GoodsId
                             , SUM (MIContainer.Amount)    AS Amount_count
                             , MIContainer.MovementId
                        FROM MovementItemContainer AS MIContainer
                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                        WHERE MIContainer.DescId   = zc_MIContainer_Count()
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementId IN (SELECT DISTINCT tmpSeparate.MovementId FROM tmpSeparate)
                          AND tmpGoods.GoodsId IS NOT NULL
                        GROUP BY MIContainer.MovementId
                       )
      --затраты из приходе поставщика
     , tmpIncomeCost AS (SELECT SUM (COALESCE (MovementFloat_AmountCost.ValueData,0)) AS AmountCost
                              , tmpIncome.MovementId_separate
                         FROM Movement
                              INNER JOIN (SELECT DISTINCT tmpIncome.MovementId, tmpIncome.MovementId_separate
                                          FROM tmpIncome
                                          ) AS tmpIncome ON tmpIncome.MovementId = Movement.ParentId
                              LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                      ON MovementFloat_AmountCost.MovementId = Movement.Id
                                                     AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
                         WHERE Movement.ParentId IN (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                           AND Movement.DescId   = zc_Movement_IncomeCost()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY tmpIncome.MovementId_separate
                         )  
      
     , tmpMLO_income AS (SELECT *
                         FROM MovementLinkObject
                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                           AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_PersonalPacker())
                         )
     
                        
      -- Результат
      SELECT tmpMovement.MovementId
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.PartionGoods
           , tmpMovement.OperDate_partion
           , Object_Goods.ValueData   AS GoodsNameMaster
           , SUM (tmpMI_group.Amount_count) OVER (PARTITION BY CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpMovement.MovementId END) AS CountMaster
           --, (select SUM (COALESCE (MI.Amount,0)) from MovementItem MI where MI.MovementId = inMovementId and MI.Objectid = 4261) AS CountMaster_4134
           , 0 ::TFloat AS CountMaster_4134
           , SUM (tmpMI_group.Amount_summ) OVER (PARTITION BY CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpMovement.MovementId END) AS SummMaster     --, tmpMI_group.Amount_summ  AS SummMaster
           , SUM (tmpMI_group.HeadCount) OVER (PARTITION BY CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpMovement.MovementId END) AS HeadCount     --, tmpMI_group.HeadCount    AS HeadCountMaster
           , CASE WHEN tmpMI_group.Amount_count <> 0 THEN tmpMI_group.Amount_summ / tmpMI_group.Amount_count ELSE 0 END AS PriceMaster

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
           LEFT JOIN tmpMI_group ON tmpMI_group.MovementId = tmpMovement.MovementId
           LEFT JOIN tmpSeparateH ON tmpSeparateH.MovementId = tmpMovement.MovementId
           LEFT JOIN tmpSeparateS ON tmpSeparateS.MovementId = tmpMovement.MovementId
           LEFT JOIN (SELECT MAX (tmpIncome.GoodsId)                                        AS GoodsId
                           , MAX (COALESCE (MovementLinkObject_From.ObjectId, 0))           AS FromId
                           , MAX (COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0)) AS PersonalPackerId
                           , SUM (tmpIncome.Amount_count) AS Amount_count, SUM ( tmpIncome.Amount_summ) AS Amount_summ
                           , SUM (tmpIncome.CountPacker) AS CountPacker, SUM (tmpIncome.HeadCount) AS HeadCount
                           , SUM (tmpIncome.AmountPartner)       AS AmountPartner
                           , SUM (tmpIncome.AmountPartnerSecond) AS AmountPartnerSecond
                           , tmpIncome.MovementId_separate
                      FROM tmpIncome
                           LEFT JOIN tmpMLO_income AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = tmpIncome.MovementId
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN tmpMLO_income AS MovementLinkObject_PersonalPacker
                                                        ON MovementLinkObject_PersonalPacker.MovementId = tmpIncome.MovementId
                                                       AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
                      GROUP BY tmpIncome.MovementId_separate
                     ) AS tmpIncomeAll ON tmpIncomeAll.MovementId_separate = tmpMovement.MovementId
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  tmpMI_group.GoodsId
           LEFT JOIN Object AS Object_Goods_separate ON Object_Goods_separate.Id =  tmpSeparateS.GoodsId
           LEFT JOIN Object AS Object_Goods_income ON Object_Goods_income.Id = tmpIncomeAll.GoodsId
           LEFT JOIN Object AS Object_From ON Object_From.Id = tmpIncomeAll.FromId
           LEFT JOIN Object AS Object_PersonalPacker ON Object_PersonalPacker.Id = tmpIncomeAll.PersonalPackerId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

           LEFT JOIN tmpIncomeCost ON tmpIncomeCost.MovementId_separate = tmpMovement.MovementId
          ;  


   ---даннык строк для курсора2 
    CREATE TEMP TABLE tmpCursor2 (MovementId Integer
                                , GoodsCode Integer
                                , GoodsName TVarChar
                                , GoodsGroupName TVarChar
                                , GoodsGroupNameFull TVarChar
                                , GroupStatId Integer
                                , GroupStatName TVarChar
                                , MeasureName TVarChar
                                , Amount  TFloat
                                , LiveWeight  TFloat
                                , HeadCount  TFloat
                                , SummPrice  TFloat
                                , Summ  TFloat
                                , PricePlan TFloat, PriceNorm TFloat
                                , isLoss  Boolean
                                , PriceFact  Tfloat
                                , SummFact  Tfloat
                                , Count_gr  Tfloat 
                                , Str_print TFloat
                                , Persent_v   Tfloat
                                , Persent_gr   Tfloat
                                ) ON COMMIT DROP;
    INSERT INTO tmpCursor2 (MovementId
                          , GoodsCode 
                          , GoodsName 
                          , GoodsGroupName 
                          , GoodsGroupNameFull 
                          , GroupStatId 
                          , GroupStatName
                          , MeasureName 
                          , Amount  
                          , LiveWeight  
                          , HeadCount  
                          , SummPrice  
                          , Summ  
                          , PricePlan, PriceNorm
                          , isLoss
                          , PriceFact
                          , SummFact
                          , Count_gr 
                          , Str_print
                          , Persent_v
                          , Persent_gr)

    WITH tmpMIContainer AS (SELECT MIContainer.MovementId
                                 , MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                            FROM MovementItemContainer AS MIContainer
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND MIContainer.MovementId IN (SELECT DISTINCT tmpCursor1.MovementId FROM tmpCursor1)
                              AND MIContainer.isActive = TRUE
                            GROUP BY MIContainer.MovementId
                                   , MIContainer.MovementItemId
                           )

      , tmpPrice AS (SELECT lfSelect.GoodsId     AS GoodsId
                          , lfSelect.GoodsKindId AS GoodsKindId
                          , lfSelect.ValuePrice
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= 18886 /*zc_PriceList_ProductionSeparate()*/, inOperDate:= inEndDate) AS lfSelect
                    )
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
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId_norm, inOperDate:= inEndDate) AS lfSelect
                        )                              
  

      , tmpData AS (WITH 
                    tmpMI AS (SELECT MovementItem.*
                              FROM MovementItem
                              WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpCursor1.MovementId FROM tmpCursor1)
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.Amount     <> 0
                                AND MovementItem.isErased   = FALSE
                              )
                  , tmpMovementItemFloat AS (
                                             SELECT *
                                             FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                               AND MovementItemFloat.DescId IN (zc_MIFloat_LiveWeight() 
                                                                              , zc_MIFloat_HeadCount())
                                             )

                    SELECT MovementItem.MovementId
                         , Object_Goods.Id  			         AS GoodsId
                         , Object_Goods.ObjectCode  			 AS GoodsCode
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
              
                         , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId IN (1966 -- СО-НЕ ВХОД. В ВЫХОД маг
                                                                                 , 1967 -- ****СО-ПОТЕРИ - _toolsView_GoodsProperty_Obvalka_isLoss_TWO
                                                                                 , 1973 -- СО-КОСТИ маг
                                                                                  )
                                     THEN TRUE
                                ELSE FALSE
                           END :: Boolean AS isLoss
              
                         --доп расчет для печати 4002
                         --кол.E - плановая цена - ПРАЙС - ПЛАН обвалка (сырье)
                         , COALESCE (tmpPricePlan.ValuePrice, 0) :: TFloat AS PricePlan
                         --кол F  - сумма плановая =  плановая цена * количество
                         , (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0)))::TFloat     AS SummaPlan        --kol_F 
                         , SUM (SUM (MovementItem.Amount * COALESCE (tmpPricePlan.ValuePrice, 0))) OVER () AS TotalSummaPlan   --Total_kol_F 
                         -- - НОРМА ВЫХОДОВ обвалка
                         , COALESCE (tmpPriceNorm.ValuePrice, 0)  AS PriceNorm
                    FROM tmpMI AS MovementItem
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_LiveWeight
                                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                         LEFT JOIN tmpMovementItemFloat AS MIFloat_HeadCount
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
             
                         -- ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
                         -- привязка без вида товара
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
           
                     GROUP BY MovementItem.MovementId
                            , Object_Goods.ObjectCode
                            , Object_Goods.Id
                            , Object_Goods.ValueData
                            , Object_GoodsGroup.ValueData
                            , ObjectString_Goods_GoodsGroupFull.ValueData
                            , Object_Measure.ValueData
                            , COALESCE (tmpPrice.ValuePrice, 0)
                            , ObjectLink_Goods_GoodsGroup.ChildObjectId
                            , COALESCE (tmpPriceNorm.ValuePrice, 0)
                     )                
   , tmpDataCalc AS (SELECT tmpData.MovementId
                          , tmpData.GoodsId
                          , tmpData.GoodsCode
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
                          , tmpData.PriceNorm
               
                          , tmpData.isLoss
               
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
                        LEFT JOIN tmpCursor1 ON tmpCursor1.MovementId = tmpData.MovementId 
                      )

     SELECT tmpData.MovementId
          , tmpData.GoodsCode
          , tmpData.GoodsName
          , tmpData.GoodsGroupName
          , tmpData.GoodsGroupNameFull 
          , Object_GoodsGroupStat.Id        AS GroupStatId
          , Object_GoodsGroupStat.ValueData AS GroupStatName
          , tmpData.MeasureName

          , tmpData.Amount
          , tmpData.LiveWeight
          , tmpData.HeadCount
          , tmpData.SummPrice
          , tmpData.Summ
          , tmpData.PricePlan
          , tmpData.PriceNorm

          , tmpData.isLoss

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
       ;
       

    OPEN Cursor1 FOR
     -- Результат 
    WITH 
    tmpGroupAll AS (SELECT * 
                         , ROW_NUMBER () OVER (PARTITION BY tmp.MovementId ORDER BY tmp.MovementId,tmp.GoodsGroupName asc) AS Ord
                    FROM (SELECT CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpCursor2.MovementId END AS MovementId
                               , tmpCursor2.GoodsGroupName
                               , SUM (tmpCursor2.Amount) AS Amount
                               , SUM (tmpCursor2.Summ)   AS Summ
                          FROM tmpCursor2
                          WHERE tmpCursor2.GroupStatId = 12045233
                          GROUP BY CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpCursor2.MovementId END
                                 , tmpCursor2.GoodsGroupName
                          HAVING SUM (tmpCursor2.Amount) <> 0 AND SUM (tmpCursor2.Summ) <> 0
                          ) AS tmp
                   )
  , tmpGroup AS (SELECT tmp.MovementId
                      , SUM (CASE WHEN tmp.Ord = 1 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr1
                      , SUM (CASE WHEN tmp.Ord = 2 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr2
                      , SUM (CASE WHEN tmp.Ord = 3 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr3
                      , SUM (CASE WHEN tmp.Ord = 4 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr4
                      , SUM (CASE WHEN tmp.Ord = 5 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr5
                      , SUM (CASE WHEN tmp.Ord = 6 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr6
                      , SUM (CASE WHEN tmp.Ord = 7 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr7
                      , SUM (CASE WHEN tmp.Ord = 8 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr8
                      , SUM (CASE WHEN tmp.Ord = 9 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr9
                      , SUM (CASE WHEN tmp.Ord = 10 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_gr10 
                      , MAX (CASE WHEN tmp.Ord = 1 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName1
                      , MAX (CASE WHEN tmp.Ord = 2 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName2
                      , MAX (CASE WHEN tmp.Ord = 3 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName3
                      , MAX (CASE WHEN tmp.Ord = 4 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName4
                      , MAX (CASE WHEN tmp.Ord = 5 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName5
                      , MAX (CASE WHEN tmp.Ord = 6 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName6
                      , MAX (CASE WHEN tmp.Ord = 7 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName7
                      , MAX (CASE WHEN tmp.Ord = 8 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName8
                      , MAX (CASE WHEN tmp.Ord = 9 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName9
                      , MAX (CASE WHEN tmp.Ord = 10 THEN tmp.GoodsGroupName ELSE '' END) AS GoodsGroupName10
                 FROM tmpGroupAll AS tmp
                 GROUP BY tmp.MovementId
                 )

 , tmpData AS (
      SELECT tmpCursor1.MovementId
           , tmpCursor1.InvNumber
           , tmpCursor1.OperDate
           , tmpCursor1.PartionGoods
           , tmpCursor1.OperDate_partion
           , tmpCursor1.GoodsNameMaster
           , tmpCursor1.CountMaster
           , tmpCursor1.CountMaster_4134
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
           , tmpMaster.GoodsName      AS GoodsName_4134
           , tmpMaster.summ           AS summ_4134
           , tmpMaster.Amount         AS Amount_4134
           --, CASE WHEN COALESCE (tmpCursor1.CountMaster,0) <> 0 THEN 100  * tmpMaster.Amount / tmpCursor1.CountMaster ELSE 0 END :: TFloat AS Persent_4134

           --
           , tmpCursor2.GoodsCode
           , tmpCursor2.GoodsName
           , tmpCursor2.GoodsGroupName
           , tmpCursor2.GoodsGroupNameFull 
           , tmpCursor2.GroupStatId
           , tmpCursor2.GroupStatName
           , tmpCursor2.MeasureName
           , tmpCursor2.Amount
           , tmpCursor2.LiveWeight
           , tmpCursor2.HeadCount
           , tmpCursor2.SummPrice
           , tmpCursor2.Summ
           , tmpCursor2.PricePlan
           , tmpCursor2.PriceNorm
           , tmpCursor2.isLoss
           , tmpCursor2.PriceFact                --расчет по файлу 
           , tmpCursor2.SummFact
           , tmpCursor2.Count_gr                 -- кол.товаров в группе
           , tmpCursor2.Str_print                --для вывода значения % выхода по группе 
           , tmpCursor2.Persent_v                --% выхода 
           , tmpCursor2.Persent_gr               --% выхода по группе 
           --
           , SUM (CASE WHEN tmpCursor2.GroupStatId = 12045233 THEN tmpCursor2.Amount ELSE 0 END) OVER (PARTITION BY tmpCursor2.MovementId)  AS Amount_GroupStat_yes
           , SUM (CASE WHEN tmpCursor2.GroupStatId <> 12045233 THEN tmpCursor2.Amount ELSE 0 END) OVER (PARTITION BY tmpCursor2.MovementId) AS Amount_GroupStat_no
           , SUM (CASE WHEN tmpCursor2.GroupStatId = 12045233 THEN tmpCursor2.Summ ELSE 0 END) OVER (PARTITION BY tmpCursor2.MovementId)    AS Summ_GroupStat_yes
           , SUM (CASE WHEN tmpCursor2.GroupStatId <> 12045233 THEN tmpCursor2.Summ ELSE 0 END) OVER (PARTITION BY tmpCursor2.MovementId)   AS Summ_GroupStat_no
           
      FROM tmpCursor1
           LEFT JOIN (SELECT tmpCursor2.MovementId 
                           , tmpCursor2.GoodsName
                           , SUM (tmpCursor2.summ) AS Summ
                           , SUM (tmpCursor2.Amount) AS Amount
                      FROM tmpCursor2
                      WHERE tmpCursor2.GoodsCode = 4134            /* Id ---4261 */
                      GROUP BY tmpCursor2.MovementId 
                             , tmpCursor2.GoodsName
                      ) AS tmpMaster ON tmpMaster.MovementId = tmpCursor1.MovementId 
           LEFT JOIN tmpCursor2 ON tmpCursor2.MovementId = tmpCursor1.MovementId
       )

       SELECT CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.MovementId::TVarChar END AS MovementId
           , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.InvNumber END AS InvNumber
           , MAX (tmpCursor1.OperDate)  AS OperDate
           , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.PartionGoods END ::TVarChar AS PartionGoods
           , MAX (tmpCursor1.OperDate_partion) AS OperDate_partion
           , tmpCursor1.GoodsNameMaster
           ,  (tmpCursor1.CountMaster) AS CountMaster
           , SUM (tmpCursor1.CountMaster_4134) AS CountMaster_4134
           , (tmpCursor1.SummMaster) AS SummMaster
           , (tmpCursor1.HeadCountMaster) AS HeadCountMaster
           , (tmpCursor1.SummMaster / tmpCursor1.CountMaster) AS PriceMaster
           , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.FromName   END AS FromName
           , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.PersonalPackerName END ASPersonalPackerName
           , tmpCursor1.GoodsNameIncome
           , SUM (tmpCursor1.CountIncome) AS CountIncome
           , SUM (tmpCursor1.SummIncome)  AS SummIncome
           , SUM (tmpCursor1.SummDop) AS SummDop
           , SUM (tmpCursor1.HeadCountIncome) AS HeadCountIncome
           , SUM (tmpCursor1.CountPackerIncome)  AS CountPackerIncome
           , SUM (tmpCursor1.AmountPartnerIncome) AS AmountPartnerIncome
           , SUM (tmpCursor1.AmountPartnerSecondIncome) AS AmountPartnerSecondIncome
           , CASE WHEN SUM (tmpCursor1.HeadCountIncome) <> 0 THEN SUM (tmpCursor1.CountIncome) / SUM (tmpCursor1.HeadCountIncome) ELSE 0 END AS HeadCount1 -- цена головы из Income
           , (SUM (tmpCursor1.SummIncome) / SUM (tmpCursor1.CountIncome))                                        AS PriceIncome
           , (SUM (tmpCursor1.SummIncome) / (SUM (tmpCursor1.CountIncome) - SUM (tmpCursor1.CountPackerIncome))) AS PriceIncome1
           , 0 :: Tfloat                                                                                         AS PriceTransport
           , SUM (tmpCursor1.SummCostIncome)   ::TFloat                                                          AS SummCostIncome
           
           , SUM (tmpCursor1.Count_CountPacker) AS Count_CountPacker
           , 100 * (SUM (tmpCursor1.CountSeparate) /SUM (tmpCursor1.CountIncome)) AS PercentCount
           , SUM (tmpCursor1.CountSeparate) AS CountSeparate
           , tmpCursor1.GoodsNameSeparate
           , AVG (tmpCursor1.SummHeadCount1) AS SummHeadCount1  -- ср вес головы из Separate
           , tmpCursor1.Separate_info   
           , tmpCursor1.GoodsName_4134
           , CASE WHEN COALESCE (SUM (tmpCursor1.Amount_4134),0) <> 0 THEN SUM (tmpCursor1.summ) /SUM (tmpCursor1.Amount_4134) ELSE 0 END   AS summprice_4134
           , SUM (tmpCursor1.Amount_4134) AS Amount_4134
           , CASE WHEN COALESCE (SUM (tmpCursor1.CountMaster),0) <> 0 THEN 100  * SUM (tmpCursor1.Amount_4134) / SUM (tmpCursor1.CountMaster) ELSE 0 END :: TFloat AS Persent_4134

           --  tmpCursor2
          , tmpCursor1.GoodsCode
          , tmpCursor1.GoodsName
          , tmpCursor1.GoodsGroupName
          , tmpCursor1.GoodsGroupNameFull 
          , tmpCursor1.GroupStatId
          , tmpCursor1.GroupStatName
          , tmpCursor1.MeasureName
          , SUM (tmpCursor1.Amount) AS Amount
          , SUM (tmpCursor1.LiveWeight) AS LiveWeight
          , SUM (tmpCursor1.HeadCount)  AS HeadCount
          , CASE WHEN SUM (tmpCursor1.Amount) <> 0 THEN SUM (tmpCursor1.Summ) / SUM (tmpCursor1.Amount) ELSE 0 END AS SummPrice
          , SUM (tmpCursor1.Summ) AS Summ
          , tmpCursor1.PricePlan
          , tmpCursor1.PriceNorm
          , tmpCursor1.isLoss
          , (SUM (tmpCursor1.SummFact) / SUM (tmpCursor1.Amount)) AS PriceFact  --, tmpCursor1.PriceFact                --расчет по файлу 
          , SUM (tmpCursor1.SummFact) AS SummFact
           --
           , SUM (tmpCursor1.Amount_GroupStat_yes) AS Amount_GroupStat_yes
           , SUM (tmpCursor1.Amount_GroupStat_no)  AS Amount_GroupStat_no
           , SUM (tmpCursor1.Summ_GroupStat_yes)   AS Summ_GroupStat_yes
           , SUM (tmpCursor1.Summ_GroupStat_no)    AS Summ_GroupStat_no
           
           , tmpGroup.Price_gr1
           , tmpGroup.Price_gr2
           , tmpGroup.Price_gr3
           , tmpGroup.Price_gr4
           , tmpGroup.Price_gr5
           , tmpGroup.Price_gr6
           , tmpGroup.Price_gr7
           , tmpGroup.Price_gr8
           , tmpGroup.Price_gr9
           , tmpGroup.Price_gr10 
           , TRIM (tmpGroup.GoodsGroupName1) AS    GoodsGroupName1 
           , TRIM (tmpGroup.GoodsGroupName2) AS    GoodsGroupName2 
           , TRIM (tmpGroup.GoodsGroupName3) AS    GoodsGroupName3 
           , TRIM (tmpGroup.GoodsGroupName4) AS    GoodsGroupName4 
           , TRIM (tmpGroup.GoodsGroupName5) AS    GoodsGroupName5 
           , TRIM (tmpGroup.GoodsGroupName6) AS    GoodsGroupName6 
           , TRIM (tmpGroup.GoodsGroupName7) AS    GoodsGroupName7 
           , TRIM (tmpGroup.GoodsGroupName8) AS    GoodsGroupName8 
           , TRIM (tmpGroup.GoodsGroupName9) AS    GoodsGroupName9 
           , TRIM (tmpGroup.GoodsGroupName10) AS   GoodsGroupName10

      FROM tmpData AS tmpCursor1
           LEFT JOIN tmpGroup ON CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpGroup.MovementId END = CASE WHEN inisPartion = TRUE THEN 0 ELSE tmpCursor1.MovementId END 
      GROUP BY CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.MovementId::TVarChar END
             , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.PartionGoods END
             , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.InvNumber END
             , tmpCursor1.GoodsNameMaster
             , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.FromName END
             , CASE WHEN inisPartion = TRUE THEN '' ELSE tmpCursor1.PersonalPackerName END
             , tmpCursor1.GoodsNameIncome
             , tmpCursor1.CountMaster
             , tmpCursor1.SummMaster
             , tmpCursor1.HeadCountMaster
             , tmpCursor1.GoodsNameSeparate
             , tmpCursor1.Separate_info   
             , tmpCursor1.GoodsName_4134
  
             --  tmpCursor2
            , tmpCursor1.GoodsCode
            , tmpCursor1.GoodsName
            , tmpCursor1.GoodsGroupName
            , tmpCursor1.GoodsGroupNameFull 
            , tmpCursor1.GroupStatId
            , tmpCursor1.GroupStatName
            , tmpCursor1.MeasureName
            , tmpCursor1.PricePlan
            , tmpCursor1.PriceNorm
            , tmpCursor1.isLoss
             --
             , tmpGroup.Price_gr1
             , tmpGroup.Price_gr2
             , tmpGroup.Price_gr3
             , tmpGroup.Price_gr4
             , tmpGroup.Price_gr5
             , tmpGroup.Price_gr6
             , tmpGroup.Price_gr7
             , tmpGroup.Price_gr8
             , tmpGroup.Price_gr9
             , tmpGroup.Price_gr10 
             , TRIM (tmpGroup.GoodsGroupName1) 
             , TRIM (tmpGroup.GoodsGroupName2) 
             , TRIM (tmpGroup.GoodsGroupName3) 
             , TRIM (tmpGroup.GoodsGroupName4) 
             , TRIM (tmpGroup.GoodsGroupName5) 
             , TRIM (tmpGroup.GoodsGroupName6) 
             , TRIM (tmpGroup.GoodsGroupName7) 
             , TRIM (tmpGroup.GoodsGroupName8) 
             , TRIM (tmpGroup.GoodsGroupName9) 
             , TRIM (tmpGroup.GoodsGroupName10)
   
 ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     SELECT tmpCursor2.MovementId
          , tmpCursor2.GoodsCode
          , tmpCursor2.GoodsName
          , tmpCursor2.GoodsGroupName
          , tmpCursor2.GoodsGroupNameFull 
          , tmpCursor2.GroupStatId
          , tmpCursor2.GroupStatName
          , tmpCursor2.MeasureName
          , tmpCursor2.Amount
          , tmpCursor2.LiveWeight
          , tmpCursor2.HeadCount
          , tmpCursor2.SummPrice
          , tmpCursor2.Summ
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
 23.04.25         *
 18.10.17         *
 24.03.17         *
 03.04.15         *
 03.04.15         *
*/

--select * from gpSelect_Movement_ProductionSeparate_Print_byReport(inStartDate := ('09.01.2025')::TDateTime , inEndDate := ('10.01.2025')::TDateTime , inFromId := 0 , inToId := 0 , inPriceListId_norm := 0 , inMovementId := 0 , inGoodsId := 4234 , inIsPartion := 'True' ,  inSession := '9457');
--FETCH ALL "<unnamed portal 226>";


--select * from gpSelect_Movement_ProductionSeparate_Print_byReport(inStartDate := ('09.01.2025')::TDateTime , inEndDate := ('09.01.2025')::TDateTime , inFromId := 0 , inToId := 0 , inPriceListId_norm := 0 , inMovementId := 0 , inGoodsId := 5225 , inIsPartion := 'True' ,  inSession := '9457');
--FETCH ALL "<unnamed portal 11>";

