-- Function: gpReport_GoodsMI_InventoryDetail ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_InventoryDetail (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_InventoryDetail (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inPriceListId  Integer   , 
    IN inisPartion    Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Name_Scale TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , AmountIn TFloat, AmountIn_Weight TFloat, AmountIn_Sh TFloat
             , AmountOut TFloat, AmountOut_Weight TFloat, AmountOut_Sh TFloat 
             , Amount TFloat, Amount_Weight TFloat, Amount_Sh TFloat
             , Summ TFloat
             , SummIn_zavod TFloat, SummIn_branch TFloat, SummIn_60000 TFloat
             , SummOut_zavod TFloat, SummOut_branch TFloat, SummOut_60000 TFloat
             , Summ_zavod TFloat, Summ_branch TFloat, Summ_60000 TFloat
             , PriceIn_zavod TFloat, PriceIn_branch TFloat
             , PriceOut_zavod TFloat, PriceOut_branch TFloat
             , Price_zavod TFloat, Price_branch TFloat
             , SummIn_RePrice TFloat, SummOut_RePrice TFloat
             , SummIn_RePrice_60000 TFloat, SummOut_RePrice_60000 TFloat 
             , Summ_pr TFloat  
             , Amount_mi TFloat, AmountWeight_mi TFloat, AmountSh_mi TFloat
             , Amount_diff TFloat, AmountWeight_diff TFloat, AmountSh_diff TFloat
             , PriceWithVAT   TFloat
             , PriceNoVAT     TFloat
             , SummWithVAT_pr TFloat 
             , SummNoVAT_pr   TFloat
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
 DECLARE vbPriceWithVAT Boolean;
 DECLARE vbVATPercent TFloat;
 DECLARE vbIsNotSumm Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_GoodsMI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     
     -- Отчет Инвентаризация - только кол-во
     vbIsNotSumm:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11365936);


     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!определяется!!!
     vbIsGroup:= (inSession = '');


     -- !!!Нет прав!!! - Ограниченние - нет доступа к Отчету по остаткам
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11086934)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;


     -- Бурмага М.Ф. + Гармаш С.М. + Горб Т.Г.
     IF vbUserId IN (5308086, 651642, 439887)
        AND inUnitId NOT IN (8458) -- Склад База ГП
        AND inUnitId NOT IN (8451) -- ЦЕХ упаковки
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> Нет прав формировать отчет для подразделения <%>'
                       , lfGet_Object_ValueData_sh (vbUserId)
                       , CASE WHEN inUnitId = 0 THEN '' ELSE lfGet_Object_ValueData_sh (inUnitId) END
                        ;
     END IF;


     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


     SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
          , ObjectFloat_VATPercent.ValueData     AS VATPercent
    INTO vbPriceWithVAT, vbVATPercent
     FROM Object AS Object_PriceList
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
       WHERE Object_PriceList.DescId = zc_Object_PriceList()
         AND Object_PriceList.Id = inPriceListId
     ;


    -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
          _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
          UNION
           SELECT Object.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )
    , _tmpUnit AS
          (-- подразделение
           SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
           WHERE COALESCE (inUnitId,0) <> 0
          UNION
           SELECT Object.Id AS UnitId FROM Object WHERE Object.DescId = zc_Object_Unit() AND COALESCE (inUnitId,0) = 0
          ) 

     -- цены по прайсу
    , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                          , lfObjectHistory_PriceListItem.GoodsKindId
                          , lfObjectHistory_PriceListItem.ValuePrice AS Price
                          , lfObjectHistory_PriceListItem.ValuePrice * CASE WHEN vbPriceWithVAT = TRUE THEN 1 ELSE (1 + vbVATPercent/100) END              AS PriceWithVAT
                          , lfObjectHistory_PriceListItem.ValuePrice * CASE WHEN vbPriceWithVAT = TRUE THEN 1 - vbVATPercent/(vbVATPercent+100) ELSE 1 END AS PriceNoVAT                                
                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inEndDate) AS lfObjectHistory_PriceListItem
                     WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                    )

    , tmpContainerAll AS (SELECT MIContainer.ContainerId              AS ContainerId
                               , COALESCE (MIContainer.AnalyzerId, 0) AS AnalyzerId
                               , MIContainer.WhereObjectId_analyzer   AS UnitId
                               , MIContainer.ObjectId_Analyzer        AS GoodsId
                               , MIContainer.ObjectIntId_Analyzer     AS GoodsKindId
                               , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                               , MIContainer.MovementId               AS MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.DescId
   
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END) AS AmountIn
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut 
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END)                                 AS Amount                                                     
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.Amount > 0 THEN      MIContainer.Amount ELSE 0 END) AS SummIn
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS SummOut
                               , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END)                                 AS Summ
                            FROM _tmpUnit
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.WhereObjectId_analyzer = _tmpUnit.UnitId
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                               AND COALESCE (MIContainer.AccountId,0) <> zc_Enum_Account_100301() -- Прибыль текущего периода
                                                               AND MIContainer.MovementDescId = zc_Movement_Inventory()
    
                          GROUP BY MIContainer.ContainerId
                                 , MIContainer.AnalyzerId
                                 , MIContainer.WhereObjectId_analyzer
                                 , MIContainer.ObjectId_Analyzer
                                 , MIContainer.ObjectIntId_Analyzer
                                 , COALESCE (MIContainer.AccountId, 0)
                                 , MIContainer.MovementId
                                 , MIContainer.MovementItemId 
                                 , MIContainer.DescId
                             )

  , tmpContainer_find AS (SELECT MAX (tmpContainerAll.MovementItemId) AS MovementItemId
                                 , tmpContainerAll.MovementId
                                 , tmpContainerAll.GoodsId
                                 , tmpContainerAll.GoodsKindId
                            FROM tmpContainerAll
                            GROUP BY tmpContainerAll.GoodsId
                                   , tmpContainerAll.GoodsKindId
                                   , tmpContainerAll.MovementId
                            
                          )

 , tmpMI_all_1 AS (SELECT MovementItem.Id
                         , MovementItem.MovementId
                         , MovementItem.ObjectId
                         , MovementItem.Amount
                         , MovementItem.DescId
                         , MovementItem.isErased
                         , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpContainerAll.MovementId FROM tmpContainerAll)
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
               ) 

  , tmpMI_all AS (SELECT MovementItem.Id AS Id  -- COALESCE (tmpContainer_find.MovementItemId, MovementItem.Id) AS Id
                       , MovementItem.MovementId
                       , MovementItem.ObjectId
                       , MovementItem.Amount
                       , MovementItem.DescId
                       , MovementItem.isErased
                  FROM tmpMI_all_1 AS MovementItem
                       LEFT JOIN tmpContainerAll ON tmpContainerAll.MovementItemId = MovementItem.Id
                       -- !!! нашли
                       LEFT JOIN tmpContainer_find ON tmpContainer_find.GoodsId     = MovementItem.ObjectId
                                                  AND tmpContainer_find.GoodsKindId = MovementItem.GoodsKindId
                                                  AND tmpContainer_find.MovementId  = MovementItem.MovementId
  
                    -- !!! если не нашли
                  WHERE tmpContainerAll.MovementItemId IS NULL

                 UNION ALL
                  SELECT MovementItem.Id
                       , MovementItem.MovementId
                       , MovementItem.ObjectId
                       , MovementItem.Amount
                       , MovementItem.DescId
                       , MovementItem.isErased
                  FROM tmpMI_all_1 AS MovementItem
                  -- !!! не надо искать
                  WHERE MovementItem.Id IN (SELECT tmpContainerAll.MovementItemId FROM tmpContainerAll)
                 )
    , tmpMI AS (SELECT MovementItem.Id
                     , MovementItem.MovementId
                     , MovementItem.ObjectId
                     , SUM (MovementItem.Amount) AS Amount
                     , MovementItem.DescId
                     , MovementItem.isErased
                FROM tmpMI_all AS MovementItem
                GROUP BY MovementItem.Id
                       , MovementItem.MovementId
                       , MovementItem.ObjectId
                       , MovementItem.DescId
                       , MovementItem.isErased
               ) 

    , tmpMI_notFound AS (SELECT MovementItem.*
                         FROM  tmpMI AS MovementItem
                              LEFT JOIN tmpContainerAll AS MIContainer
                                                        ON MovementItem.MovementId = MIContainer.MovementId
                                                       AND MovementItem.Id = MIContainer.MovementItemId
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                                       AND MIContainer.DescId = zc_MIContainer_Count()
                         WHERE MIContainer.MovementId IS NULL 
                           AND COALESCE (MovementItem.Amount,0) <> 0
                           )
                           
     , tmpMILO_GoodsKind AS (SELECT *
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_notFound.Id FROM tmpMI_notFound) 
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )                          

     , tmpMLO_Unit AS (SELECT *
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI_notFound.MovementId FROM tmpMI_notFound) 
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                           )

    , tmpContainer AS (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                            , COALESCE (MIContainer.AnalyzerId, 0) AS AnalyzerId
                            , MIContainer.UnitId                   AS UnitId
                            , MIContainer.GoodsId                  AS GoodsId
                            , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.GoodsKindId END AS GoodsKindId
                            , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                            , CASE WHEN inisPartion = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId

                            , SUM (MIContainer.AmountIn)   AS AmountIn
                            , SUM (MIContainer.AmountOut)  AS AmountOut 
                            , SUM (MIContainer.Amount)     AS Amount                                                     
                            , SUM (MIContainer.SummIn)     AS SummIn
                            , SUM (MIContainer.SummOut)    AS SummOut
                            , SUM (MIContainer.Summ)       AS Summ
                            
                            , SUM (MovementItem.Amount)  AS Amount_mi
                            --, SUM (COALESCE (ContaineMIContainerr.Amount,0))   AS Remains 
                            --, tmpRemains.     AS Remains
                       FROM tmpContainerAll AS MIContainer
                            LEFT JOIN tmpMI AS MovementItem
                                            ON MovementItem.MovementId = MIContainer.MovementId
                                           AND MovementItem.Id = MIContainer.MovementItemId
                                           AND MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.isErased = FALSE
                                           AND MIContainer.DescId = zc_MIContainer_Count()
 
                       GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                              , MIContainer.AnalyzerId
                              , MIContainer.UnitId
                              , MIContainer.GoodsId
                              , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.GoodsKindId END
                              , COALESCE (MIContainer.AccountId, 0)
                              , CASE WHEN inisPartion = TRUE THEN MIContainer.MovementId ELSE 0 END 
                     UNION ALL
                       SELECT  0 AS ContainerId
                         , 0 AS AnalyzerId
                         , MovementLinkObject_From.ObjectId            AS UnitId
                         , MovementItem.ObjectId                 AS GoodsId
                         , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MILinkObject_GoodsKind.ObjectId END AS GoodsKindId
                         , 0  AS AccountId
                         , CASE WHEN inisPartion = TRUE THEN MovementItem.MovementId ELSE 0 END AS MovementId
 
                         , 0  AS AmountIn
                         , 0  AS AmountOut 
                         , 0  AS Amount                                                     
                         , 0  AS SummIn
                         , 0  AS SummOut
                         , 0  AS Summ
                         
                         , SUM (MovementItem.Amount)  AS Amount_mi
                         --, SUM (COALESCE (ContaineMIContainerr.Amount,0))   AS Remains 
                         --, tmpRemains.     AS Remains
                    FROM  tmpMI_notFound AS MovementItem
                            LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                                      
                            LEFT JOIN tmpMLO_Unit AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   
 --where  MovementItem.Id = 311463661
                    GROUP BY MovementLinkObject_From.ObjectId 
                         , MovementItem.ObjectId 
                         , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MILinkObject_GoodsKind.ObjectId END 
                         , CASE WHEN inisPartion = TRUE THEN MovementItem.MovementId ELSE 0 END
                     )

   --
   , tmpGoodsByGoodsKindParam AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                       , Object_GoodsByGoodsKind_View.GoodsKindId
                                       , Object_Goods_basis.ObjectCode        AS GoodsCode_basis
                                       , Object_Goods_basis.ValueData         AS GoodsName_basis
                                       --, Object_Goods_main.ObjectCode         AS GoodsCode_main
                                       --, Object_Goods_main.ValueData          AS GoodsName_main
                                  FROM Object_GoodsByGoodsKind_View
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsBasis.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsBasis.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis()
                                        LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId

                                        /*LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                        LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId*/
                                  WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId, 0) <> 0
                                    -- OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId, 0) <> 0
                                  )


   -- Результат
    SELECT Movement.Id                                AS MovementId
         , Movement.InvNumber
         , Movement.OperDate
         , Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName 
         , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , tmpGoodsByGoodsKindParam.GoodsCode_basis
         , tmpGoodsByGoodsKindParam.GoodsName_basis

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , tmpOperationGroup.AmountIn        :: TFloat AS AmountIn
         , tmpOperationGroup.AmountIn_Weight :: TFloat AS AmountIn_Weight
         , tmpOperationGroup.AmountIn_Sh     :: TFloat AS AmountIn_Sh

         , tmpOperationGroup.AmountOut        :: TFloat AS AmountOut
         , tmpOperationGroup.AmountOut_Weight :: TFloat AS AmountOut_Weight
         , tmpOperationGroup.AmountOut_Sh     :: TFloat AS AmountOut_Sh

         , (tmpOperationGroup.AmountIn        - tmpOperationGroup.AmountOut)        :: TFloat AS Amount
         , (tmpOperationGroup.AmountIn_Weight - tmpOperationGroup.AmountOut_Weight) :: TFloat AS Amount_Weight
         , (tmpOperationGroup.AmountIn_Sh     - tmpOperationGroup.AmountOut_Sh)     :: TFloat AS Amount_Sh

         , tmpOperationGroup.Summ       :: TFloat

         , tmpOperationGroup.SummIn_zavod  :: TFloat AS SummIn_zavod
         , tmpOperationGroup.SummIn_branch :: TFloat AS SummIn_branch
         , tmpOperationGroup.SummIn_60000  :: TFloat AS SummIn_60000

         , tmpOperationGroup.SummOut_zavod  :: TFloat AS SummOut_zavod
         , tmpOperationGroup.SummOut_branch :: TFloat AS SummOut_branch
         , tmpOperationGroup.SummOut_60000  :: TFloat AS SummOut_60000

         , (tmpOperationGroup.SummIn_zavod  - tmpOperationGroup.SummOut_zavod)  :: TFloat AS Summ_zavod
         , (tmpOperationGroup.SummIn_branch - tmpOperationGroup.SummOut_branch) :: TFloat AS Summ_branch
         , (tmpOperationGroup.SummIn_60000  - tmpOperationGroup.SummOut_60000)  :: TFloat AS Summ_60000

         , CASE WHEN tmpOperationGroup.AmountIn <> 0 THEN tmpOperationGroup.SummIn_zavod  / tmpOperationGroup.AmountIn ELSE 0 END :: TFloat AS PriceIn_zavod
         , CASE WHEN tmpOperationGroup.AmountIn <> 0 THEN tmpOperationGroup.SummIn_branch / tmpOperationGroup.AmountIn ELSE 0 END :: TFloat AS PriceIn_branch
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_zavod  / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_zavod
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_branch / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_branch
         , CASE WHEN (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) <> 0 THEN (tmpOperationGroup.SummIn_zavod  - tmpOperationGroup.SummOut_zavod)  / (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) ELSE 0 END :: TFloat AS Price_zavod
         , CASE WHEN (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) <> 0 THEN (tmpOperationGroup.SummIn_branch - tmpOperationGroup.SummOut_branch) / (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut) ELSE 0 END :: TFloat AS Price_branch

         , tmpOperationGroup.SummIn_RePrice        :: TFloat AS SummIn_RePrice
         , tmpOperationGroup.SummOut_RePrice       :: TFloat AS SummOut_RePrice
         , tmpOperationGroup.SummIn_RePrice_60000  :: TFloat AS SummIn_RePrice_60000
         , tmpOperationGroup.SummOut_RePrice_60000 :: TFloat AS SummOut_RePrice_60000     
         
         , (tmpOperationGroup.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) :: TFloat AS Summ_pr --  Сумма (-)убыль (+)эконом. ПРАЙС

         , tmpOperationGroup.Amount_mi       :: TFloat AS Amount_mi
         , tmpOperationGroup.AmountWeight_mi :: TFloat AS AmountWeight_mi
         , tmpOperationGroup.AmountSh_mi     :: TFloat AS AmountSh_mi
         , (tmpOperationGroup.Amount_mi       - (tmpOperationGroup.AmountIn - tmpOperationGroup.AmountOut))               :: TFloat AS Amount_diff
         , (tmpOperationGroup.AmountWeight_mi - (tmpOperationGroup.AmountIn_Weight - tmpOperationGroup.AmountOut_Weight)) :: TFloat AS AmountWeight_diff
         , (tmpOperationGroup.AmountSh_mi     - (tmpOperationGroup.AmountIn_Sh - tmpOperationGroup.AmountOut_Sh))         :: TFloat AS AmountSh_diff 
         
         -- цены прайса
         , COALESCE (tmpPricePR_Kind.PriceWithVAT, tmpPricePR.PriceWithVAT) ::TFloat AS PriceWithVAT
         , COALESCE (tmpPricePR_Kind.PriceNoVAT, tmpPricePR.PriceNoVAT)     ::TFloat AS PriceNoVAT
         , (COALESCE (tmpPricePR_Kind.PriceWithVAT,tmpPricePR.PriceWithVAT) * tmpOperationGroup.Amount) ::TFloat AS SummWithVAT_pr  
         , (COALESCE (tmpPricePR_Kind.PriceNoVAT, tmpPricePR.PriceNoVAT) * tmpOperationGroup.Amount)    ::TFloat AS SummNoVAT_pr 
     FROM (SELECT tmpContainer.UnitId
                , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END AS GoodsId
                , tmpContainer.GoodsKindId
                , CASE WHEN inisPartion = TRUE THEN CLO_PartionGoods.ObjectId ELSE 0 END AS PartionGoodsId
                , tmpContainer.MovementId

                , SUM (tmpContainer.Amount)     AS Amount
                , SUM (tmpContainer.AmountIn)   AS AmountIn
                , SUM (tmpContainer.AmountIn * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS AmountIn_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.AmountIn ELSE 0 END) AS AmountIn_sh

                , SUM (tmpContainer.AmountOut)  AS AmountOut
                , SUM (tmpContainer.AmountOut * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS AmountOut_Weight
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.AmountOut ELSE 0 END) AS AmountOut_sh

                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.Summ ELSE 0 END) END AS Summ
                
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() THEN tmpContainer.SummIn  ELSE 0 END) END AS SummIn_zavod
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() THEN tmpContainer.SummOut ELSE 0 END) END AS SummOut_zavod
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) END AS SummIn_branch        -- zc_Enum_AccountGroup_60000 Прибыль будущих периодов
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) END AS SummOut_branch
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) END AS SummIn_60000
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId <> zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) END AS SummOut_60000

                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) END AS SummIn_RePrice
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) END AS SummOut_RePrice
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn  ELSE 0 END) END AS SummIn_RePrice_60000
                , CASE WHEN vbIsNotSumm = TRUE THEN 0 ELSE SUM (CASE WHEN tmpContainer.AnalyzerId = zc_Enum_AccountGroup_60000() AND COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) END AS SummOut_RePrice_60000
                
                , SUM (tmpContainer.Amount_mi)   AS Amount_mi
                , SUM (tmpContainer.Amount_mi * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)   AS AmountWeight_mi
                , SUM (tmpContainer.Amount_mi * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END)   AS AmountSh_mi

           FROM tmpContainer
               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId
               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                             ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
               LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
           GROUP BY tmpContainer.UnitId
                  , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpContainer.GoodsId END
                  , tmpContainer.GoodsKindId
                  , CASE WHEN inisPartion = TRUE THEN CLO_PartionGoods.ObjectId ELSE 0 END
                  , tmpContainer.MovementId

          ) AS tmpOperationGroup

          LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.UnitId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

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

          LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                 ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

          -- привязываем цены по прайсу 2 раза по виду товара и без
          LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                               ON tmpPricePR_Kind.GoodsId = Object_Goods.Id
                              AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (tmpOperationGroup.GoodsKindId,0)

          LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = Object_Goods.Id
                              AND tmpPricePR.GoodsKindId IS NULL   

          LEFT JOIN tmpGoodsByGoodsKindParam ON tmpGoodsByGoodsKindParam.GoodsId = tmpOperationGroup.GoodsId
                                            AND COALESCE (tmpGoodsByGoodsKindParam.GoodsKindId, 0) = COALESCE (tmpOperationGroup.GoodsKindId, 0)
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.23         *
 25.05.22         * 
 30.11.21         * add inisPartion
 16.08.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_InventoryDetail (inStartDate:= '30.11.2023', inEndDate:= '30.11.2023', inUnitId:= 8444, inGoodsGroupId:= 1940, inPriceListId := 0, inisPartion:= true, inSession:= zfCalc_UserAdmin()) --8417

--  SELECT * FROM gpReport_GoodsMI_InventoryDetail (inStartDate:= '26.12.2024', inEndDate:= '26.12.2024', inUnitId:= 8459, inGoodsGroupId:= 1832, inPriceListId := 0, inisPartion:= true, inSession:= zfCalc_UserAdmin()) --8417
-- where GoodsCode = 2380
