-- Function: gpSelect_ProductionSeparate_Print_byReport_TestPart()

DROP FUNCTION IF EXISTS gpSelect_ProductionSeparate_Print_byReport_TestPart (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ProductionSeparate_Print_byReport_TestPart(
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inFromId             Integer   ,    -- от кого 
    IN inToId               Integer   ,    -- кому
    IN inPriceListId_norm   Integer   ,
    IN inMovementId         Integer   , -- ключ Документа
    IN inGoodsId            Integer   ,
    IN inisGroup            Boolean   , --итоговая накладная по гл. партии
    IN inPartionGoods_main  TVarChar  , --главная партия
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbDescId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor; 
    
    DECLARE vbGroup_its Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inPartionGoods_main,'') = ''
     THEN
          -- нет партии
          RAISE EXCEPTION 'Ошибка.Партия не определена.';
     END IF;
     

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

    -- определяем признак что идет итог по пратиям об, мо, пр 
    vbGroup_its := (CASE WHEN inPartionGoods_main ::TVarChar LIKE 'пр-%' THEN TRUE
                         WHEN inPartionGoods_main ::TVarChar LIKE 'об-%' THEN TRUE
                         WHEN inPartionGoods_main ::TVarChar LIKE 'мо-%' THEN TRUE
                         ELSE FALSE
                    END);


   OPEN Cursor1 FOR
   WITH 
       -- список товаров для отличия в Separate основного сырья от голов
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
                             AND inisGroup = FALSE
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
                              AND ((MovementString_PartionGoods.ValueData ILIKE '%'||inPartionGoods_main||'%'  AND inisGroup = TRUE) OR inisGroup = FALSE)
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
                            , CASE WHEN tmpMovement_all.PartionGoods ::TVarChar LIKE 'пр-%' THEN SUBSTRING (tmpMovement_all.PartionGoods::TVarChar FROM 4)
                                   WHEN tmpMovement_all.PartionGoods ::TVarChar LIKE 'об-%' THEN SUBSTRING (tmpMovement_all.PartionGoods::TVarChar FROM 4)
                                   WHEN tmpMovement_all.PartionGoods ::TVarChar LIKE 'мо-%' THEN SUBSTRING (tmpMovement_all.PartionGoods::TVarChar FROM 4)
                                   ELSE tmpMovement_all.PartionGoods ::TVarChar
                              END AS PartionGoods_main
                       FROM tmpMovement_all
                       WHERE tmpMovement_all.MovementId IN (SELECT DISTINCT tmpMI_Master.MovementId FROM tmpMI_Master)
                       )

       --данные по партии для товара 4134 по партии
     ,  tmpGoods_4134 AS (SELECT tmpPartionGoods.PartionGoods_main
                               , tmpData.GoodsCode
                               , tmpData.GoodsName
                               , tmpData.Amount
                               , tmpData.PricePlan
                               , tmpData.PriceFact ::TFloat
                               , tmpData.SummFact ::TFloat
                               , tmpData.Persent_v 
                 FROM (SELECT DISTINCT tmpMovement.PartionGoods_main, MAX (tmpMovement.OperDate) AS OperDate FROM tmpMovement
                      GROUP BY tmpMovement.PartionGoods_main) AS tmpPartionGoods
                  LEFT JOIN gpSelect_MI_ProductionSeparate_PriceFact(tmpPartionGoods.OperDate::TDateTime, tmpPartionGoods.OperDate::TDateTime, 0, inPriceListId_norm, 4261, tmpPartionGoods.PartionGoods_main, inSession) AS tmpData  ON 1=1
                 )

       --данные по документам
     , tmpData AS (SELECT tmpMovement.*
                        , tmpData.*
                      --Свинина НК  - другой расчет цены
                      , CAST (CASE WHEN COALESCE (tmpData.Amount,0) <> 0 
                           THEN (tmpData.SummaPlan_Calc - 
                                ( (tmpData.TotalSummaPlan_calc 
                                  -- 
                                  - ( COALESCE (tmpData.CountMaster,0) * tmpGoods_4134.PriceFact )
                                   ) 
                                   * CASE WHEN COALESCE (tmpData.TotalSummaPlan_calc,0) <> 0 THEN tmpData.SummaPlan_calc / tmpData.TotalSummaPlan_calc ELSE 0 END)   /* kol_H*/      
                                )  /*kol_i */ 
                                / COALESCE (tmpData.Amount,0) 
                                ELSE 0 
                      END AS  NUMERIC(16,8)) AS PriceFact_nk 

                      , tmpGoods_4134.GoodsName      AS GoodsName_4134
                      , tmpGoods_4134.PriceFact      AS PriceFact_4134
                      , tmpGoods_4134.Amount         AS Amount_4134
                      , tmpGoods_4134.Persent_v :: TFloat AS Persent_4134

                   FROM tmpMovement
                     LEFT JOIN gpSelect_MI_ProductionSeparate_PriceFact(tmpMovement.OperDate::TDateTime, tmpMovement.OperDate::TDateTime, tmpMovement.MovementId, inPriceListId_norm, 0, tmpMovement.PartionGoods_main, inSession) AS tmpData  ON 1=1
                     LEFT JOIN tmpGoods_4134 ON tmpGoods_4134.PartionGoods_main = tmpMovement.PartionGoods_main
                   )


     , tmpResult AS (SELECT tmpData.MovementId
                          , tmpData.InvNumber
                          , tmpData.OperDate
                          , tmpData.PartionGoods
                          , tmpData.PartionGoods_main
                          , tmpData.OperDate_partion
                          , tmpData.GoodsNameMaster
                          , tmpData.CountMaster
                          --, tmpData.CountMaster_4134
                          , tmpData.SummMaster
                          , tmpData.HeadCountMaster
                          , tmpData.PriceMaster 
                          --, ((COALESCE (tmpData.SummMaster,0) - COALESCE (tmpData.SummCostIncome,0)) / tmpData.CountMaster ) AS PriceMaster  
                          
                          , tmpData.FromName
                          , tmpData.PersonalPackerName 
                          , tmpData.Separate_info
                          , tmpData.GoodsNameIncome
                          , tmpData.CountIncome
                          , tmpData.SummIncome    
                          
                 
                          , tmpData.HeadCountIncome
                          , tmpData.CountPackerIncome
                          , tmpData.AmountPartnerIncome
                          , tmpData.AmountPartnerSecondIncome
                          , tmpData.HeadCount1 -- цена головы из Income
                          , tmpData.PriceIncome
                          , tmpData.PriceIncome1
                          , tmpData.PriceIncome2           
                          
                          , tmpData.SummCostIncome 
                          , tmpData.CountDocIncome
                          , tmpData.Count_CountPacker
                          , tmpData.PercentCount
                          , tmpData.CountSeparate
                          , tmpData.GoodsNameSeparate
                          , tmpData.SummHeadCount1  -- ср вес головы из Separate
                          --, tmpData.Separate_info   
                          
                          , SUM (CASE WHEN tmpData.GoodsId = 4261 THEN tmpData.SummFact ELSE 0 END) OVER (PARTITION BY tmpData.MovementId)     AS summ_4134
                          , SUM (CASE WHEN tmpData.GoodsId = 4261 THEN tmpData.Amount ELSE 0 END) OVER (PARTITION BY tmpData.MovementId)       AS AmountMaster_4134
                          --, CASE WHEN COALESCE (tmpCursor1.CountMaster,0) <> 0 THEN 100  * tmpMaster.Amount / tmpCursor1.CountMaster ELSE 0 END :: TFloat AS Persent_4134
                          
                          --
                          , tmpData.GoodsId
                          , tmpData.GoodsCode
                          , tmpData.GoodsName 
                          , tmpData.GoodsGroupCode
                          , tmpData.GoodsGroupName
                          , tmpData.GoodsGroupNameFull 
                          , tmpData.GroupStatId
                          , tmpData.GroupStatName
                         
                          , tmpData.Amount
                          , tmpData.PricePlan
                          , tmpData.PriceNorm
                          , tmpData.isLoss
                          , tmpData.PriceFact                --расчет по файлу 
                          , tmpData.SummFact                                   
                          , tmpData.PriceFact_nk
                          , (tmpData.PriceFact_nk * tmpData.Amount) AS SummFact_nk
                          , tmpData.Count_gr                 -- кол.товаров в группе
                          , tmpData.Str_print                --для вывода значения % выхода по группе 
                          , tmpData.Persent_v                --% выхода 
                          , tmpData.Persent_gr               --% выхода по группе 
                          --для проверки
                          , tmpData.TotalSummaPlan_calc        -- итого сумма по цене план* для расчета факта 
                          , tmpData.SummaPlan_calc             -- сумма по цене план* для расчета факта
                          , tmpData.PricePlan_calc             -- цена план* для расчета факта  

                          , tmpData.GoodsName_4134
                          , tmpData.PriceFact_4134
                          , tmpData.Amount_4134
                          , tmpData.Persent_4134
                          --
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN tmpData.Amount ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)      AS Amount_GroupStat
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN tmpData.SummFact ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)    AS SummFact_GroupStat
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN (tmpData.PriceFact_nk * tmpData.Amount) ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)      AS SummFact_nk_GroupStat     --для свинины НК другой расчет цены факт, поэтому суммы дублирую
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN (tmpData.PriceFact_4134 * tmpData.Amount) ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)    AS SummFact_4134_GroupStat 
                          , SUM (tmpData.Amount) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main, tmpData.GoodsGroupNameFull)   ::TFloat AS Amount_Group          --итого количество по группам товаров
                          , SUM (tmpData.SummFact) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main, tmpData.GoodsGroupNameFull) ::TFloat AS SummFact_Group        --итого сумма факт по группам товаров
                          , SUM ((tmpData.PriceFact_nk * tmpData.Amount)) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main, tmpData.GoodsGroupNameFull) ::TFloat AS SummFact_nk_Group        --итого сумма факт по группам товаров
                          --, SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN (tmpGoods_4134.PriceFact * tmpData.Amount) ELSE 0 END) OVER ()        ::TFloat AS SummFact_4134_GroupStat    --итого сумма факт по группам статистики    - входит в выход
           
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN tmpData.Amount ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)  AS Amount_GroupStat_yes
                          , SUM (CASE WHEN tmpData.GroupStatId <> 12045233 THEN tmpData.Amount ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main) AS Amount_GroupStat_no
                          , SUM (CASE WHEN tmpData.GroupStatId = 12045233 THEN tmpData.SummFact ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)    AS Summ_GroupStat_yes
                          , SUM (CASE WHEN tmpData.GroupStatId <> 12045233 THEN tmpData.SummFact ELSE 0 END) OVER (PARTITION BY tmpData.MovementId, tmpData.PartionGoods_main)   AS Summ_GroupStat_no

                     FROM tmpData
                         
                     )

     , tmpGroupAll AS (SELECT * 
                            , ROW_NUMBER () OVER (PARTITION BY tmp.MovementId, tmp.PartionGoods_main ORDER BY tmp.MovementId, tmp.PartionGoods_main, tmp.NumStatGroup, tmp.GoodsGroupCode, tmp.GoodsGroupName asc) AS Ord
                       FROM (SELECT CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpResult.MovementId END AS MovementId
                                  , tmpResult.PartionGoods_main
                                  , CASE WHEN tmpResult.GroupStatId = 12045233 THEN 0 ELSE 1 END AS NumStatGroup
                                  , tmpResult.GoodsGroupCode
                                  , tmpResult.GoodsGroupName
                                  , SUM (tmpResult.Amount)     AS Amount
                                  , SUM (tmpResult.SummFact)   AS Summ
                                  , SUM (tmpResult.PriceFact_nk * tmpResult.Amount)   AS Summ_nk
                             FROM tmpResult
                            -- WHERE tmpResult.GroupStatId = 12045233
                             GROUP BY CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpResult.MovementId END
                                    , tmpResult.PartionGoods_main
                                    , tmpResult.GoodsGroupName   
                                    , CASE WHEN tmpResult.GroupStatId = 12045233 THEN 0 ELSE 1 END 
                                  , tmpResult.GoodsGroupCode
                             HAVING SUM (tmpResult.Amount) <> 0 AND SUM (tmpResult.SummFact) <> 0
                             ) AS tmp
                      )
     , tmpGroup AS (SELECT tmp.MovementId, tmp.PartionGoods_main
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
 
                      , SUM (CASE WHEN tmp.Ord = 1 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr1
                      , SUM (CASE WHEN tmp.Ord = 2 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr2
                      , SUM (CASE WHEN tmp.Ord = 3 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr3
                      , SUM (CASE WHEN tmp.Ord = 4 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr4
                      , SUM (CASE WHEN tmp.Ord = 5 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr5
                      , SUM (CASE WHEN tmp.Ord = 6 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr6
                      , SUM (CASE WHEN tmp.Ord = 7 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr7
                      , SUM (CASE WHEN tmp.Ord = 8 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr8
                      , SUM (CASE WHEN tmp.Ord = 9 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr9
                      , SUM (CASE WHEN tmp.Ord = 10 THEN CASE WHEN COALESCE (tmp.Amount,0) <> 0 THEN tmp.Summ_nk / tmp.Amount ELSE 0 END ELSE 0 END) AS Price_nk_gr10

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
                 GROUP BY tmp.MovementId, tmp.PartionGoods_main
                 )                       
                 
         --группировака данных шапки печати по документам или по гл. партии
     , tmpMain_Group AS (SELECT tmpCursor1.MovementId
                              , tmpCursor1.InvNumber
                              , MIN(tmpCursor1.OperDate) AS OperDate
                              , tmpCursor1.PartionGoods
                              , tmpCursor1.PartionGoods_main
                              , tmpCursor1.OperDate_partion
                              , tmpCursor1.GoodsNameMaster
                              , SUM (tmpCursor1.CountMaster ) AS CountMaster
                              , SUM (tmpCursor1.SummMaster) AS SummMaster
                              , SUM (tmpCursor1.CountMaster_4134 ) AS CountMaster_4134
                              , SUM (tmpCursor1.HeadCountMaster) AS HeadCountMaster
                              , SUM (tmpCursor1.SummMaster) / SUM (tmpCursor1.CountMaster ) AS PriceMaster
                              , tmpCursor1.FromName
                              , tmpCursor1.PersonalPackerName
                              , tmpCursor1.GoodsNameIncome
                              , tmpCursor1.CountIncome
                              , tmpCursor1.SummIncome
                              , tmpCursor1.HeadCountIncome
                              , tmpCursor1.CountPackerIncome
                              , tmpCursor1.AmountPartnerIncome
                              , tmpCursor1.HeadCount1
                              , tmpCursor1.PriceIncome
                              , tmpCursor1.PriceIncome1
                              , tmpCursor1.PriceIncome2
                              , tmpCursor1.SummCostIncome
                              , tmpCursor1.CountDocIncome
                              , tmpCursor1.Count_CountPacker
                              , tmpCursor1.CountSeparate
                              , tmpCursor1.PercentCount
                              , tmpCursor1.GoodsNameSeparate
                              , tmpCursor1.SummHeadCount1
                         FROM (
                           SELECT DISTINCT 
                                  CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.MovementId::TVarChar END AS MovementId
                                , CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.InvNumber END AS InvNumber
                                ,  (tmpCursor1.OperDate)  AS OperDate
                                ,  CASE WHEN inisGroup = TRUE THEN '' ELSE tmpCursor1.PartionGoods END AS PartionGoods
                                --, tmpCursor1.PartionGoods 
                                , tmpCursor1.PartionGoods_main
                                ,  (tmpCursor1.OperDate_partion) AS OperDate_partion
                                , tmpCursor1.GoodsNameMaster
                                , (tmpCursor1.CountMaster) 
                                ,  (COALESCE (tmpCursor1.AmountMaster_4134,0)) AS CountMaster_4134
                                ,  (tmpCursor1.SummMaster) AS SummMaster
                                ,  (tmpCursor1.HeadCountMaster) AS HeadCountMaster
                                , tmpCursor1.PriceMaster
                               -- , SUM ((tmpMI_group.Amount_summ - COALESCE (tmpIncomeCost.AmountCost,0)) /tmpMI_group.Amount_count ) OVER (PARTITION BY CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpMovement.MovementId END) AS PriceMaster
                                
                                , tmpCursor1.FromName 
                                , tmpCursor1.PersonalPackerName
                                , tmpCursor1.GoodsNameIncome
                                ,  (tmpCursor1.CountIncome) AS CountIncome
                                ,  (tmpCursor1.SummIncome)  AS SummIncome
                                ,  (tmpCursor1.HeadCountIncome) AS HeadCountIncome
                                ,  (tmpCursor1.CountPackerIncome)  AS CountPackerIncome
                                ,  (tmpCursor1.AmountPartnerIncome) AS AmountPartnerIncome
                                ,  (tmpCursor1.AmountPartnerSecondIncome) AS AmountPartnerSecondIncome
                                , CASE WHEN  (tmpCursor1.HeadCountIncome) <> 0 THEN  (tmpCursor1.CountIncome) / (tmpCursor1.HeadCountIncome) ELSE 0 END AS HeadCount1 -- цена головы из Income
                                , ((tmpCursor1.SummIncome) /  (tmpCursor1.CountIncome))                                        AS PriceIncome
                                , ( (tmpCursor1.SummIncome) / ( (tmpCursor1.CountIncome) -  (tmpCursor1.CountPackerIncome))) AS PriceIncome1
                                , CASE WHEN (COALESCE (tmpCursor1.AmountPartnerIncome,0)) <> 0 THEN ( (tmpCursor1.SummIncome) / ( (tmpCursor1.AmountPartnerIncome) )) ELSE 0 END ::TFloat AS PriceIncome2
                                ,  (tmpCursor1.SummCostIncome)   ::TFloat                                                          AS SummCostIncome
                                ,  (tmpCursor1.CountDocIncome)   ::TFloat                                                          AS CountDocIncome
                                
                                ,  (tmpCursor1.Count_CountPacker) AS Count_CountPacker
                                , 100 * ((tmpCursor1.CountSeparate) / (tmpCursor1.CountIncome)) AS PercentCount
                                ,  (tmpCursor1.CountSeparate) AS CountSeparate
                                , tmpCursor1.GoodsNameSeparate
                                ,  (tmpCursor1.SummHeadCount1) AS SummHeadCount1  -- ср вес головы из Separate
                        FROM tmpResult AS tmpCursor1
                        ) AS tmpCursor1
                         GROUP BY tmpCursor1.MovementId
                                , tmpCursor1.InvNumber
                                , tmpCursor1.PartionGoods
                                , tmpCursor1.PartionGoods_main
                                , tmpCursor1.OperDate_partion
                                , tmpCursor1.GoodsNameMaster
                                , tmpCursor1.FromName
                                , tmpCursor1.PersonalPackerName
                                , tmpCursor1.GoodsNameIncome
                                , tmpCursor1.CountIncome
                                , tmpCursor1.SummIncome
                                , tmpCursor1.HeadCountIncome
                                , tmpCursor1.CountPackerIncome
                                , tmpCursor1.AmountPartnerIncome
                                , tmpCursor1.HeadCount1
                                , tmpCursor1.PriceIncome
                                , tmpCursor1.PriceIncome1
                                , tmpCursor1.PriceIncome2
                                , tmpCursor1.SummCostIncome
                                , tmpCursor1.CountDocIncome
                                , tmpCursor1.Count_CountPacker
                                , tmpCursor1.CountSeparate
                                , tmpCursor1.PercentCount
                                , tmpCursor1.GoodsNameSeparate
                                , tmpCursor1.SummHeadCount1 
                        )

      
      -- Результат 
      SELECT CASE WHEN vbGroup_its = FALSE THEN tmpMain_Group.MovementId ELSE inPartionGoods_main END AS MovementId
           , CASE WHEN vbGroup_its = FALSE THEN tmpMain_Group.InvNumber ELSE inPartionGoods_main END AS InvNumber
           , tmpMain_Group.OperDate
           , tmpCursor1.PartionGoods
           , tmpMain_Group.PartionGoods_main
           , tmpMain_Group.OperDate_partion
           , tmpMain_Group.GoodsNameMaster
           , tmpMain_Group.CountMaster
           , tmpMain_Group.CountMaster_4134
           , tmpMain_Group.SummMaster
           , tmpMain_Group.HeadCountMaster
           --, tmpMain_Group.PriceMaster
           , tmpMain_Group.FromName
           , tmpMain_Group.PersonalPackerName
           , tmpMain_Group.GoodsNameIncome
           , tmpMain_Group.CountIncome
           , tmpMain_Group.SummIncome
           , tmpMain_Group.HeadCountIncome
           , tmpMain_Group.CountPackerIncome
           , tmpMain_Group.AmountPartnerIncome
           , tmpMain_Group.HeadCount1
           , tmpMain_Group.PriceIncome
           , tmpMain_Group.PriceIncome1
           , tmpMain_Group.PriceIncome2
           , tmpMain_Group.SummCostIncome
           , tmpMain_Group.CountDocIncome
           , tmpMain_Group.Count_CountPacker
           , tmpMain_Group.CountSeparate
           , tmpMain_Group.PercentCount
           , tmpMain_Group.GoodsNameSeparate
           , tmpMain_Group.SummHeadCount1
           , AVG (tmpCursor1.PriceMaster) AS PriceMaster
       
          /*CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.MovementId::TVarChar END AS MovementId
           , CASE WHEN inisGroup = TRUE THEN '' ELSE tmpCursor1.InvNumber END AS InvNumber
           , MAX (tmpCursor1.OperDate)  AS OperDate
           , CASE WHEN inisGroup = TRUE THEN '' ELSE tmpCursor1.PartionGoods END ::TVarChar AS PartionGoods
           , tmpCursor1.PartionGoods_main
           , MAX (tmpCursor1.OperDate_partion) AS OperDate_partion
           , tmpCursor1.GoodsNameMaster
           , SUM (tmpCursor1.CountMaster) OVER (PARTITION BY CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.MovementId::TVarChar END) AS CountMaster
         --  , SUM (COALESCE (tmpCursor1.AmountMaster_4134,0)) AS CountMaster_4134
           , SUM (tmpCursor1.SummMaster)       AS SummMaster
           , SUM (tmpCursor1.HeadCountMaster)  AS HeadCountMaster
           , tmpCursor1.PriceMaster
          -- , SUM ((tmpMI_group.Amount_summ - COALESCE (tmpIncomeCost.AmountCost,0)) /tmpMI_group.Amount_count ) OVER (PARTITION BY CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpMovement.MovementId END) AS PriceMaster
           
           , tmpCursor1.FromName 
           , tmpCursor1.PersonalPackerName
           , tmpCursor1.GoodsNameIncome
           , SUM (tmpCursor1.CountIncome)               AS CountIncome
           , SUM (tmpCursor1.SummIncome)                AS SummIncome
           , SUM (tmpCursor1.HeadCountIncome)           AS HeadCountIncome
           , SUM (tmpCursor1.CountPackerIncome)         AS CountPackerIncome
           , SUM (tmpCursor1.AmountPartnerIncome)       AS AmountPartnerIncome
           , SUM (tmpCursor1.AmountPartnerSecondIncome) AS AmountPartnerSecondIncome
           , CASE WHEN SUM (tmpCursor1.HeadCountIncome) <> 0 THEN SUM (tmpCursor1.CountIncome) / SUM (tmpCursor1.HeadCountIncome) ELSE 0 END AS HeadCount1 -- цена головы из Income
           , (SUM (tmpCursor1.SummIncome) / SUM (tmpCursor1.CountIncome))                                        AS PriceIncome
           , (SUM (tmpCursor1.SummIncome) / (SUM (tmpCursor1.CountIncome) - SUM (tmpCursor1.CountPackerIncome))) AS PriceIncome1
           , CASE WHEN SUM (COALESCE (tmpCursor1.AmountPartnerIncome,0)) <> 0 THEN (SUM (tmpCursor1.SummIncome) / (SUM (tmpCursor1.AmountPartnerIncome) )) ELSE 0 END ::TFloat AS PriceIncome2
           , SUM (tmpCursor1.SummCostIncome)   ::TFloat                                                          AS SummCostIncome
           , SUM (tmpCursor1.CountDocIncome)   ::TFloat                                                          AS CountDocIncome
           
           , SUM (tmpCursor1.Count_CountPacker) AS Count_CountPacker
           , 100 * (SUM (tmpCursor1.CountSeparate) /SUM (tmpCursor1.CountIncome)) AS PercentCount
           , SUM (tmpCursor1.CountSeparate) AS CountSeparate
           , tmpCursor1.GoodsNameSeparate
           , AVG (tmpCursor1.SummHeadCount1) AS SummHeadCount1  -- ср вес головы из Separate
           */
           , tmpCursor1.GoodsName_4134
           , tmpCursor1.PriceFact_4134
           , SUM(tmpCursor1.PriceFact * tmpCursor1.Amount) ::TFloat AS SummFact_4134
           --, CASE WHEN COALESCE (SUM (tmpCursor1.Amount_4134),0) <> 0 THEN SUM (tmpCursor1.summ_4134) /SUM (tmpCursor1.Amount_4134) ELSE 0 END   AS price_4134
           , MAX (tmpCursor1.Amount_4134) AS Amount_4134
           --, tmpMain_Group.CountMaster AS Amount_4134
           --, tmpCursor1.Persent_4134 
           , CASE WHEN COALESCE (SUM (tmpCursor1.CountMaster),0) <> 0 THEN 100  * SUM (tmpCursor1.Amount_4134) / SUM (tmpCursor1.CountMaster) ELSE 0 END :: TFloat AS Persent_4134
           , SUM (tmpCursor1.AmountMaster_4134)  AS AmountMaster_4134    
           --, tmpCursor1.PriceFact_nk  --заменяем на расчет  для варианта итоговой печати
           , CASE WHEN  SUM (tmpCursor1.Amount) <> 0 THEN (SUM (tmpCursor1.SummFact_nk) / SUM (tmpCursor1.Amount)) ELSE 0 END AS PriceFact_nk
           , SUM(tmpCursor1.PriceFact_nk * tmpCursor1.Amount) ::TFloat AS SummFact_nk
           
           , tmpCursor1.GoodsId
           , tmpCursor1.GoodsCode
           , tmpCursor1.GoodsName 
           , tmpCursor1.GoodsGroupCode
           , tmpCursor1.GoodsGroupName
           , tmpCursor1.GoodsGroupNameFull 
           , tmpCursor1.GroupStatId
           , tmpCursor1.GroupStatName
           , SUM (tmpCursor1.Amount) AS Amount
          -- , CASE WHEN SUM (tmpCursor1.Amount) <> 0 THEN SUM (tmpCursor1.Summ) / SUM (tmpCursor1.Amount) ELSE 0 END AS SummPrice
           , tmpCursor1.PricePlan
           , tmpCursor1.PriceNorm
           , CASE WHEN  SUM (tmpCursor1.Amount) <> 0 THEN (SUM (tmpCursor1.SummFact) / SUM (tmpCursor1.Amount)) ELSE 0 END AS PriceFact 
           , SUM (tmpCursor1.SummFact) AS SummFact
           
              --для проверки
           , SUM (tmpCursor1.TotalSummaPlan_calc) AS TotalSummaPlan_calc        -- итого сумма по цене план* для расчета факта 
           , SUM (tmpCursor1.SummaPlan_calc)      AS SummaPlan_calc             -- сумма по цене план* для расчета факта
           , MAX (tmpCursor1.PricePlan_calc)      AS PricePlan_calc             -- цена план* для расчета факта  
           --
           , SUM (tmpCursor1.Amount_GroupStat)          AS Amount_GroupStat
           , SUM (tmpCursor1.SummFact_GroupStat)        AS SummFact_GroupStat
           , SUM (tmpCursor1.Amount_Group)              AS Amount_Group
           , SUM (tmpCursor1.SummFact_Group)            AS SummFact_Group
           , SUM (tmpCursor1.SummFact_4134_GroupStat)   AS SummFact_4134_GroupStat
           , SUM (tmpCursor1.SummFact_nk_GroupStat)     AS SummFact_nk_GroupStat
           , SUM (tmpCursor1.SummFact_nk_Group)         AS SummFact_nk_Group

           , SUM (tmpCursor1.Amount_GroupStat_yes) ::TFloat AS Amount_GroupStat_yes
           , SUM (tmpCursor1.Amount_GroupStat_no)  ::TFloat AS Amount_GroupStat_no
           , SUM (tmpCursor1.Summ_GroupStat_yes)   ::TFloat AS Summ_GroupStat_yes
           , SUM (tmpCursor1.Summ_GroupStat_no)    ::TFloat AS Summ_GroupStat_no
           
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
           
           , tmpGroup.Price_nk_gr1
           , tmpGroup.Price_nk_gr2
           , tmpGroup.Price_nk_gr3
           , tmpGroup.Price_nk_gr4
           , tmpGroup.Price_nk_gr5
           , tmpGroup.Price_nk_gr6
           , tmpGroup.Price_nk_gr7
           , tmpGroup.Price_nk_gr8
           , tmpGroup.Price_nk_gr9
           , tmpGroup.Price_nk_gr10 

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
 
           , tmpCursor1.Separate_info :: TVarChar AS Separate_info
     
           --признак для печати группы статистики в итого по группам ставтистики
           , CASE WHEN tmpCursor1.GroupStatId = 12045233 THEN TRUE ELSE FALSE END ::Boolean AS isPrintGroupStat


           , CASE WHEN tmpCursor1.PartionGoods ::TVarChar LIKE 'пр-%' THEN 'пр' ::TVarChar
                  WHEN tmpCursor1.PartionGoods ::TVarChar LIKE 'об-%' THEN 'об' ::TVarChar
                  WHEN tmpCursor1.PartionGoods ::TVarChar LIKE 'мо-%' THEN 'мо' ::TVarChar
                  ELSE '' ::TVarChar
             END ::TVarChar AS PartionGoods_part
                                      
      FROM tmpResult AS tmpCursor1
           LEFT JOIN tmpGroup ON CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpGroup.MovementId END = CASE WHEN inisGroup = TRUE THEN 0 ELSE tmpCursor1.MovementId END 
                             AND tmpGroup.PartionGoods_main = tmpCursor1.PartionGoods_main  
           -- группировка по док или гл. партии
           LEFT JOIN tmpMain_Group ON tmpMain_Group.MovementId = CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.MovementId::TVarChar END
                                --  AND COALESCE (tmpMain_Group.PartionGoods,'') = COALESCE (tmpCursor1.PartionGoods,'')
      GROUP BY CASE WHEN vbGroup_its = FALSE THEN tmpMain_Group.MovementId ELSE inPartionGoods_main END
           , CASE WHEN vbGroup_its = FALSE THEN tmpMain_Group.InvNumber ELSE inPartionGoods_main END
           , tmpMain_Group.OperDate
          -- , tmpMain_Group.PartionGoods  
           , tmpCursor1.PartionGoods
           , tmpMain_Group.PartionGoods_main
           , tmpMain_Group.OperDate_partion
           , tmpMain_Group.GoodsNameMaster
           , tmpMain_Group.CountMaster
           , tmpMain_Group.CountMaster_4134
           , tmpMain_Group.SummMaster
           , tmpMain_Group.HeadCountMaster
           --, tmpMain_Group.PriceMaster
           , tmpMain_Group.FromName
           , tmpMain_Group.PersonalPackerName
           , tmpMain_Group.GoodsNameIncome
           , tmpMain_Group.CountIncome
           , tmpMain_Group.SummIncome
           , tmpMain_Group.HeadCountIncome
           , tmpMain_Group.CountPackerIncome
           , tmpMain_Group.AmountPartnerIncome
           , tmpMain_Group.HeadCount1
           , tmpMain_Group.PriceIncome
           , tmpMain_Group.PriceIncome1
           , tmpMain_Group.PriceIncome2
           , tmpMain_Group.SummCostIncome
           , tmpMain_Group.CountDocIncome
           , tmpMain_Group.Count_CountPacker
           , tmpMain_Group.CountSeparate
           , tmpMain_Group.PercentCount
           , tmpMain_Group.GoodsNameSeparate
           , tmpMain_Group.SummHeadCount1
           
           /* CASE WHEN inisGroup = TRUE THEN tmpCursor1.PartionGoods_main ELSE tmpCursor1.MovementId::TVarChar END 
           , CASE WHEN inisGroup = TRUE THEN '' ELSE tmpCursor1.InvNumber END 
           , CASE WHEN inisGroup = TRUE THEN '' ELSE tmpCursor1.PartionGoods END 
           , tmpCursor1.PartionGoods_main
           , tmpCursor1.GoodsNameMaster
           , tmpCursor1.FromName 
           , tmpCursor1.PersonalPackerName
           , tmpCursor1.GoodsNameIncome
           , tmpCursor1.GoodsNameSeparate

           , tmpCursor1.PriceMaster
           */      
          -- , tmpCursor1.PriceMaster
           , tmpCursor1.Separate_info  
           , tmpCursor1.GoodsName_4134
           , tmpCursor1.PriceFact_4134
           --  
           , tmpCursor1.GoodsId
           , tmpCursor1.GoodsCode
           , tmpCursor1.GoodsName 
           , tmpCursor1.GoodsGroupCode
           , tmpCursor1.GoodsGroupName
           , tmpCursor1.GoodsGroupNameFull 
           , tmpCursor1.GroupStatId
           , tmpCursor1.GroupStatName
           , tmpCursor1.PricePlan
           , tmpCursor1.PriceNorm
           --, tmpCursor1.PriceFact_nk
           
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

           , tmpGroup.Price_nk_gr1
           , tmpGroup.Price_nk_gr2
           , tmpGroup.Price_nk_gr3
           , tmpGroup.Price_nk_gr4
           , tmpGroup.Price_nk_gr5
           , tmpGroup.Price_nk_gr6
           , tmpGroup.Price_nk_gr7
           , tmpGroup.Price_nk_gr8
           , tmpGroup.Price_nk_gr9
           , tmpGroup.Price_nk_gr10
 
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
     SELECT 1 AS MovementId 
      , 0 AS GoodsCode
      , 0 AS Amount
     ;
        
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

--select * from gpSelect_ProductionSeparate_Print_byReport_Test(inStartDate := ('09.01.2025')::TDateTime , inEndDate := ('10.01.2025')::TDateTime , inFromId := 0 , inToId := 0 , inPriceListId_norm := 0 , inMovementId := 0 , inGoodsId := 4234 , inisGroup := 'True' ,  inSession := '9457');
--FETCH ALL "<unnamed portal 226>";


--select * from gpSelect_ProductionSeparate_Print_byReport_Test(inStartDate := ('09.01.2025')::TDateTime , inEndDate := ('09.01.2025')::TDateTime , inFromId := 0 , inToId := 0 , inPriceListId_norm := 0 , inMovementId := 0 , inGoodsId := 5225 , inisGroup := 'True' ,  inSession := '9457');
--FETCH ALL "<unnamed portal 11>";


-- select * from gpSelect_ProductionSeparate_Print_byReport_TestPart(inStartDate := ('25.05.2025')::TDateTime , inEndDate := ('25.05.2025')::TDateTime , inFromId := 0 , inToId := 0 , inPriceListId_norm := 0 , inMovementId := 0 , inGoodsId := 4234 , inisGroup := 'false' ,  inSession := '9457');
--FETCH ALL "<unnamed portal 226>";
