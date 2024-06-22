-- Function: gpReport_GoodsMI_byMovement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovement (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,  
    IN inPriceDate    TDateTime ,
    IN inDescId       Integer   , -- zc_Movement_Sale or zc_Movement_ReturnIn
    IN inUnitId       Integer   , 
    IN inJuridicalId  Integer   , 
    IN inInfoMoneyId  Integer   , -- Управленческая статья  
    IN inPaidKindId   Integer   , --
    IN inGoodsGroupId Integer   ,
    IN inGoodsId      Integer   , 
    IN inIsErased     Boolean   , -- показать удаленные Да / Нет
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, ChangePercent TFloat
             , PriceListId Integer, PriceListName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Price TFloat
             , Amount_Weight TFloat, Amount_Sh TFloat
             , Amount_Weight_del TFloat, Amount_Sh_del TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_10500_Weight TFloat, Amount_10500_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat
             , SummPartner_10100 TFloat, SummPartner_10200 TFloat, SummPartner_10250 TFloat, SummPartner_10300 TFloat
             , SummDiff TFloat
             , WeightTotal TFloat -- Вес в упаковке - GoodsByGoodsKind
             , ChangePercentAmount TFloat
             , isBarCode  Boolean
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar    
             , Price_onDate TFloat, Summ_onDate TFloat  
             , GoodsKindId_price Integer, GoodsKindName_price TVarChar
             , ReasonName TVarChar, SubjectDocName TVarChar
             , StatusCode Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsGoods Boolean;
   DECLARE vbIsUnit Boolean;

   DECLARE vbIsGoods_show Boolean;
   DECLARE vbIsSummIn Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!определяется!!!
    vbIsGoods_show:= TRUE;

    -- !!!определяется!!!
    vbIsSummIn:= -- Ограничение просмотра с/с
                 NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
                ;

/*
    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '1 DAY') < inEndDate AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0 AND COALESCE (inJuridicalId, 0) = 0
    THEN
        -- inStartDate:= inEndDate + (INTERVAL '1 DAY');
        vbIsGoods_show:= FALSE;
    ELSE
    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '32 DAY') < inEndDate AND COALESCE (inGoodsId, 0) = 0
    THEN
        -- inStartDate:= inEndDate + (INTERVAL '1 DAY');
        vbIsGoods_show:= FALSE;
    END IF;
    END IF;

*/
    vbIsGoods:= inGoodsId <> 0 OR inGoodsGroupId <> 0;
    vbIsUnit:= inUnitId <> 0;

    -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
          _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT Object_Goods.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, COALESCE (ObjectFloat_Weight.ValueData, 0) AS Weight
           FROM Object AS Object_Goods
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object_Goods.Id = inGoodsId
          UNION
           SELECT lfObject_Goods_byGoodsGroup.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, COALESCE (ObjectFloat_Weight.ValueData, 0) AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
          UNION
           SELECT Object_Goods.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, COALESCE (ObjectFloat_Weight.ValueData, 0) AS Weight
           FROM Object AS Object_Goods
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object_Goods.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
        UNION
           SELECT Object.Id AS GoodsId
                , 0 AS MeasureId
                , 0 AS Weight
           FROM Object
           WHERE Object.DescId = zc_Object_Asset()
             AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
          )


    , _tmpUnit AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect WHERE inUnitId <> 0)


    , tmpListContainerSumm AS
                      (SELECT ContainerLO_Juridical.ObjectId         AS JuridicalId
                            , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                            , MIContainer.ObjectExtId_analyzer       AS PartnerId
                            , MIContainer.WhereObjectId_analyzer     AS UnitId
                            , MIContainer.MovementItemId
                            , MIContainer.MovementId
                            , MIContainer.ObjectId_analyzer          AS GoodsId
                            , MIContainer.ObjectIntId_analyzer       AS GoodsKindId
                               -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                            , (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    ELSE 0
                               END) AS SummPartner
                            --  Сумма по оптовыми ценам
                           , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- !!!
                                   WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- !!!знак наоборот т.к. это проводка покупателя
                                   ELSE 0
                              END) AS SummPartner_10100
                             -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами + Скидка Акция
                           , (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10200()) THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                   WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                   ELSE 0
                              END) AS SummPartner_10200
                             -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами + Скидка Акция
                           , (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10250()) THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                   ELSE 0
                              END) AS SummPartner_10250
                              -- 5.3.4. Сумма у покупателя Скидка / Наценка дополнительная
                            , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                    WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                    ELSE 0
                               END) AS SummPartner_10300

                            , COALESCE (MIFloat_Price.ValueData, 0)
                              -- так переводится факт цена в валюту zc_Enum_Currency_Basis
                            * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                              AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                               -- 1.1. Кол-во, без AnalyzerId
                            , (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount
                                    WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Count() THEN  1 * MIContainer.Amount
                                    ELSE 0
                               END) AS Amount

                              -- 2.1.1. Кол-во - со Скидкой за вес
                            , (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId NOT IN (zc_Enum_AnalyzerId_SaleCount_10500()) THEN -1 * MIContainer.Amount
                                    WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Count() THEN  1 * MIContainer.Amount
                                    ELSE 0
                               END) AS AmountChangePercent
                              -- 2.1.2. Кол-во - Скидка за вес
                            , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                    ELSE 0
                               END) AS Amount_10500

                              -- 3.1. Кол-во Разница в весе
                            , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                    WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                    ELSE 0
                               END) AS Amount_40200

                              -- 5.1. Кол-во у покупателя
                            , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                    WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                    ELSE 0
                               END) AS AmountPartner


                              -- 5.3.1. Сумма у покупателя По прайсу
                            , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    ELSE 0
                               END) AS SummPartner_calc

                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                            , _tmpGoods.MeasureId
                            , _tmpGoods.Weight 

                       FROM (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                             FROM Constant_ProfitLoss_AnalyzerId_View
                             WHERE (isSale = TRUE  AND isCost = FALSE AND inDescId = zc_Movement_Sale())
                                OR (isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn())
                             ) AS tmpAnalyzer
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer

                             LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                           ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_analyzer
                                                          AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                           ON ContainerLinkObject_InfoMoney.ContainerId = MIContainer.ContainerId_analyzer
                                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                           ON ContainerLinkObject_PaidKind.ContainerId = MIContainer.ContainerId_analyzer
                                                          AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
           
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId = MIContainer.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  MIContainer.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId = MIContainer.MovementId
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                             LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                     ON MovementFloat_CurrencyValue.MovementId =  MIContainer.MovementId
                                                    AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                             LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                     ON MovementFloat_ParValue.MovementId = MIContainer.MovementId
                                                    AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                          ON MovementLinkObject_CurrencyDocument.MovementId = MIContainer.MovementId
                                                         AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                       WHERE (_tmpUnit.UnitId   > 0 OR vbIsUnit = FALSE)
                         AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                         AND (ContainerLinkObject_PaidKind.ObjectId  = inPaidKindId  OR COALESCE (inPaidKindId, 0)  = 0)
                         AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                         AND (ContainerLO_Juridical.ObjectId         = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                      )

       , tmpMIBoolean_BarCode AS (SELECT MIBoolean_BarCode.*
                                  FROM MovementItemBoolean AS MIBoolean_BarCode 
                                  WHERE MIBoolean_BarCode.MovementItemId IN (SELECT DISTINCT tmpListContainerSumm.MovementItemId FROM tmpListContainerSumm)
                                    AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                                  )
       , tmpMIFloat_ChangePercentAmount AS (SELECT MovementItemFloat.*
                                            FROM MovementItemFloat
                                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpListContainerSumm.MovementItemId FROM tmpListContainerSumm)
                                              AND MovementItemFloat.DescId = zc_MIFloat_ChangePercentAmount()
                                            )

       , tmpMI_Reason AS (SELECT MovementItem.ParentId AS MovementItemId      --, STRING_AGG (DISTINCT Object_Reason.ValueData, '; ') ::TVarChar AS ReasonName
                               , STRING_AGG (DISTINCT Object_Reason.ValueData, '; ')     ::TVarChar AS ReasonName
                               , STRING_AGG (DISTINCT Object_SubjectDoc.ValueData, '; ') ::TVarChar AS SubjectDocName
                          FROM MovementItem 
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                            ON MovementLinkObject_SubjectDoc.MovementId = MovementItem.MovementId
                                                           AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                                                           AND inDescId = zc_Movement_ReturnIn()

                               LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                                ON MILO_Reason.MovementItemId = MovementItem.Id
                                                               AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                               LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId
                               
                               LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                                ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                                               AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                               LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = COALESCE (MILO_SubjectDoc.ObjectId, MovementLinkObject_SubjectDoc.ObjectId)

                          WHERE MovementItem.ParentId IN (SELECT DISTINCT tmpListContainerSumm.MovementItemId FROM tmpListContainerSumm)
                            AND MovementItem.DescId   = zc_MI_Detail()
                            AND MovementItem.isErased = FALSE  
                            AND inDescId = zc_Movement_ReturnIn()
                          GROUP BY MovementItem.ParentId  
                         )

       , tmpOperationGroup_all AS
                (SELECT tmpListContainerSumm.MovementId
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      -- , tmpListContainerSumm.GoodsId
                      -- , tmpListContainerSumm.GoodsKindId
                      -- , tmpListContainerSumm.MeasureId
                      -- , tmpListContainerSumm.Price
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.GoodsId     ELSE 0 END AS GoodsId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.GoodsKindId ELSE 0 END AS GoodsKindId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.MeasureId   ELSE 0 END AS MeasureId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.Price       ELSE 0 END AS Price
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.isBarCode   ELSE FALSE END AS isBarCode
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.ChangePercentAmount ELSE 0 END AS ChangePercentAmount
                      , STRING_AGG (DISTINCT tmpListContainerSumm.ReasonName, '; ')           ::TVarChar AS ReasonName
                      , STRING_AGG (DISTINCT tmpListContainerSumm.SubjectDocName, '; ')       ::TVarChar AS SubjectDocName
                      , SUM (tmpListContainerSumm.Amount)              AS Amount
                      , SUM (tmpListContainerSumm.Amount_Sh)           AS Amount_Sh
                      , SUM (tmpListContainerSumm.AmountChangePercent)    AS AmountChangePercent
                      , SUM (tmpListContainerSumm.AmountChangePercent_Sh) AS AmountChangePercent_Sh
                      , SUM (tmpListContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpListContainerSumm.AmountPartner_Sh)    AS AmountPartner_Sh
                      , SUM (tmpListContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpListContainerSumm.Amount_10500_Sh)     AS Amount_10500_Sh
                      , SUM (tmpListContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpListContainerSumm.Amount_40200_Sh)     AS Amount_40200_Sh
                      , SUM (tmpListContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpListContainerSumm.SummPartner_calc)    AS SummPartner_calc
                      , SUM (tmpListContainerSumm.SummPartner_10100)   AS SummPartner_10100
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10250)   AS SummPartner_10250
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300

                 FROM (SELECT tmpListContainerSumm.MovementId
                            , tmpListContainerSumm.JuridicalId
                            , tmpListContainerSumm.PartnerId
                            , tmpListContainerSumm.InfoMoneyId
                            , tmpListContainerSumm.UnitId
                            , tmpListContainerSumm.GoodsId
                            , tmpListContainerSumm.GoodsKindId
                            , tmpListContainerSumm.MeasureId
                            , tmpListContainerSumm.Price
                            , COALESCE (MIBoolean_BarCode.ValueData,FALSE) AS isBarCode
                            , (tmpListContainerSumm.SummPartner)       AS SummPartner
                            , (tmpListContainerSumm.SummPartner_10100) AS SummPartner_10100  
                            , (tmpListContainerSumm.SummPartner_10200) AS SummPartner_10200
                            , (tmpListContainerSumm.SummPartner_10250) AS SummPartner_10250
                            , (tmpListContainerSumm.SummPartner_10300) AS SummPartner_10300

                            , (tmpListContainerSumm.Amount * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount
                            , (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Amount ELSE 0 END) AS Amount_Sh

                            , (tmpListContainerSumm.AmountChangePercent * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS AmountChangePercent
                            , (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.AmountChangePercent ELSE 0 END) AS AmountChangePercent_Sh

                            , (tmpListContainerSumm.Amount_10500 * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount_10500
                            , (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Amount_10500 ELSE 0 END) AS Amount_10500_Sh

                            , (tmpListContainerSumm.Amount_40200 * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount_40200
                            , (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Amount_40200 ELSE 0 END) AS Amount_40200_Sh

                            , (tmpListContainerSumm.AmountPartner * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS AmountPartner
                            , (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.AmountPartner ELSE 0 END) AS AmountPartner_Sh

                            , tmpListContainerSumm.SummPartner_calc
                            , MIFloat_ChangePercentAmount.ValueData AS ChangePercentAmount  
                            
                            , tmpMI_Reason.ReasonName
                            , tmpMI_Reason.SubjectDocName

                       FROM tmpListContainerSumm
                             LEFT JOIN tmpMIBoolean_BarCode AS MIBoolean_BarCode 
                                                            ON MIBoolean_BarCode.MovementItemId = tmpListContainerSumm.MovementItemId
                                                           AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                             LEFT JOIN tmpMIFloat_ChangePercentAmount AS MIFloat_ChangePercentAmount
                                                                      ON MIFloat_ChangePercentAmount.MovementItemId = tmpListContainerSumm.MovementItemId
                                                                     AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()  
                             LEFT JOIN tmpMI_Reason ON tmpMI_Reason.MovementItemId = tmpListContainerSumm.MovementItemId
                       ) AS tmpListContainerSumm
                 GROUP BY tmpListContainerSumm.MovementId
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                        , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.isBarCode   ELSE FALSE END
                        , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.ChangePercentAmount ELSE 0 END
                )

       , tmpMLO_PriceList AS (SELECT MovementLinkObject_PriceList.*
                              FROM MovementLinkObject AS MovementLinkObject_PriceList
                              WHERE MovementLinkObject_PriceList.MovementId IN (SELECT DISTINCT tmpOperationGroup_all.MovementId FROM tmpOperationGroup_all)
                                AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                              )

       , tmpMLO_Contract AS (SELECT MovementLinkObject_Contract.*
                             FROM MovementLinkObject AS MovementLinkObject_Contract
                             WHERE MovementLinkObject_Contract.MovementId IN (SELECT DISTINCT tmpOperationGroup_all.MovementId FROM tmpOperationGroup_all)
                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                            )

       , tmpMD_OperDatePartner AS (SELECT MovementDate.*
                                   FROM MovementDate
                                   WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpOperationGroup_all.MovementId FROM tmpOperationGroup_all)
                                     AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                  )

       , tmpMF_ChangePercent AS (SELECT MovementFloat.*
                                   FROM MovementFloat
                                   WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpOperationGroup_all.MovementId FROM tmpOperationGroup_all)
                                     AND MovementFloat.DescId = zc_MovementFloat_ChangePercent()
                                  )

       , tmpOperationGroup AS
                (SELECT MovementDesc.ItemName
                      , Movement.Id                            AS MovementId
                      , Movement.InvNumber
                      , Movement.OperDate 
                      , Movement.StatusId
                      , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                      , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      , MovementLinkObject_PriceList.ObjectId  AS PriceListId
                      , ObjectBoolean_PriceWithVAT.ValueData   AS isPriceWithVAT   ---для прайса
                      , ObjectFloat_VATPercent.ValueData       AS VATPercent       ---для прайса
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      , tmpListContainerSumm.GoodsId
                      , tmpListContainerSumm.GoodsKindId
                      , tmpListContainerSumm.MeasureId
                      , tmpListContainerSumm.Price
                      , tmpListContainerSumm.isBarCode
                      , tmpListContainerSumm.ChangePercentAmount
                      , STRING_AGG (DISTINCT tmpListContainerSumm.ReasonName, '; ')     ::TVarChar AS ReasonName
                      , STRING_AGG (DISTINCT tmpListContainerSumm.SubjectDocName, '; ') ::TVarChar AS SubjectDocName
                      , SUM (tmpListContainerSumm.Amount)              AS Amount
                      , SUM (tmpListContainerSumm.Amount_Sh)           AS Amount_Sh
                      , SUM (tmpListContainerSumm.AmountChangePercent)    AS AmountChangePercent
                      , SUM (tmpListContainerSumm.AmountChangePercent_Sh) AS AmountChangePercent_Sh
                      , SUM (tmpListContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpListContainerSumm.AmountPartner_Sh)    AS AmountPartner_Sh
                      , SUM (tmpListContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpListContainerSumm.Amount_10500_Sh)     AS Amount_10500_Sh
                      , SUM (tmpListContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpListContainerSumm.Amount_40200_Sh)     AS Amount_40200_Sh
                      , SUM (tmpListContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpListContainerSumm.SummPartner_10100)   AS SummPartner_10100
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10250)   AS SummPartner_10250
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300
                      , SUM (tmpListContainerSumm.SummPartner_calc) AS SummPartner_calc
                 FROM tmpOperationGroup_all AS tmpListContainerSumm
                      LEFT JOIN Movement ON Movement.Id = tmpListContainerSumm.MovementId
                      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                      LEFT JOIN tmpMD_OperDatePartner AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId =  tmpListContainerSumm.MovementId
                                                     AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                      LEFT JOIN tmpMF_ChangePercent AS MovementFloat_ChangePercent
                                                    ON MovementFloat_ChangePercent.MovementId =  tmpListContainerSumm.MovementId
                                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      LEFT JOIN tmpMLO_PriceList AS MovementLinkObject_PriceList
                                                 ON MovementLinkObject_PriceList.MovementId = tmpListContainerSumm.MovementId
                                                AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                              ON ObjectBoolean_PriceWithVAT.ObjectId = MovementLinkObject_PriceList.ObjectId
                                             AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                      LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                            ON ObjectFloat_VATPercent.ObjectId =  MovementLinkObject_PriceList.ObjectId
                                           AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
                 GROUP BY MovementDesc.ItemName
                        , Movement.Id
                        , Movement.InvNumber
                        , Movement.OperDate 
                        , Movement.StatusId
                        , MovementFloat_ChangePercent.ValueData
                        , MovementDate_OperDatePartner.ValueData
                        , MovementLinkObject_PriceList.ObjectId
                        , ObjectBoolean_PriceWithVAT.ValueData   
                        , ObjectFloat_VATPercent.ValueData
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                        , tmpListContainerSumm.isBarCode
                        , tmpListContainerSumm.ChangePercentAmount
                )      

        --выбор удаленных документов  inIsErased = True 
       , tmpMovErased AS (SELECT Movement.* 
                               , MovementDesc.ItemName
                               , MovementLinkObject_To.ObjectId   AS UnitId
                               , MovementLinkObject_From.ObjectId AS FromId
                               , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                          FROM Movement 
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = CASE WHEN inDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = CASE WHEN inDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END

                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                           
                           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                          WHERE inIsErased = TRUE
                            AND Movement.DescId = inDescId
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Erased()
                            AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                            AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                          )
                          
       , tmpMIErased AS (SELECT MovementItem.* 
                              , _tmpGoods.MeasureId 
                              , _tmpGoods.Weight
                         FROM tmpMovErased AS tmpMovement
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.DescId = zc_MI_Master()
                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                        )
       , tmpMIFloat_er AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIErased.Id FROM tmpMIErased)
                             AND MovementItemFloat.DescId = zc_MIFloat_Price()
                           )

       , tmpMIBoolean_er AS (SELECT MovementItemBoolean.*
                             FROM MovementItemBoolean
                             WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMIErased.Id FROM tmpMIErased)
                               AND MovementItemBoolean.DescId = zc_MIBoolean_BarCode()
                             )

       , tmpMLO_GoodsKind AS (SELECT MovementLinkObject.*
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMIErased.Id FROM tmpMIErased)
                               AND MovementLinkObject.DescId = zc_MILinkObject_GoodsKind()
                            )
       , tmpMovementErased AS (SELECT tmp.ItemName
                                    , tmp.MovementId
                                    , tmp.InvNumber
                                    , tmp.OperDate
                                    , Object_Status.ObjectCode AS StatusCode 
                                    , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                                    , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                    , MovementLinkObject_PriceList.ObjectId  AS PriceListId
                                    , ObjectBoolean_PriceWithVAT.ValueData   AS isPriceWithVAT   ---для прайса
                                    , ObjectFloat_VATPercent.ValueData       AS VATPercent       ---для прайса
                                    , tmp.UnitId
                                    , tmp.FromId   AS PartnerId
                                    , tmp.JuridicalId
                                   -- , tmp.PaidKindId
                                    , tmp.GoodsId
                                    , tmp.GoodsKindId 
                                    , tmp.MeasureId
                                    , tmp.Amount
                                    , tmp.Amount_sh 
                                    , tmp.Price 
                                    , tmp.ReasonName
                                    , tmp.SubjectDocName 
                                    , tmp.isBarCode
                               FROM (SELECT tmpMovement.ItemName
                                          , tmpMovement.Id AS MovementId 
                                          , tmpMovement.InvNumber
                                          , tmpMovement.OperDate
                                          , tmpMovement.UnitId
                                          , tmpMovement.FromId
                                          , tmpMovement.JuridicalId
                                          
                                          , CASE WHEN vbIsGoods_show = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                                          , CASE WHEN vbIsGoods_show = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId 
                                          , MovementItem.MeasureId
                                          , SUM (COALESCE (MovementItem.Amount,0) * CASE WHEN MovementItem.MeasureId = zc_Measure_Sh() THEN MovementItem.Weight ELSE 1 END) AS Amount
                                          , SUM (CASE WHEN MovementItem.MeasureId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS Amount_sh    
                                          , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                          --причина возврата
                                          , STRING_AGG (DISTINCT Object_Reason.ValueData, '; ')     ::TVarChar AS ReasonName
                                          , STRING_AGG (DISTINCT Object_SubjectDoc.ValueData, '; ') ::TVarChar AS SubjectDocName 
                                          , CASE WHEN vbIsGoods_show = TRUE THEN COALESCE (MIBoolean_BarCode.ValueData,FALSE) ELSE FALSE END AS isBarCode

                                     FROM tmpMovErased AS tmpMovement
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                                       ON MovementLinkObject_SubjectDoc.MovementId = tmpMovement.Id
                                                                      AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                                                                      AND inDescId = zc_Movement_ReturnIn()
                                         
                                          INNER JOIN tmpMIErased AS MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          
                                          LEFT JOIN tmpMIFloat_er AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                          LEFT JOIN tmpMLO_GoodsKind AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                          LEFT JOIN tmpMIBoolean_er AS MIBoolean_BarCode 
                                                                        ON MIBoolean_BarCode.MovementItemId = MovementItem.Id
                                                                       AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                                                                       AND vbIsGoods_show = TRUE
                    
                                          LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.ParentId = MovementItem.Id
                                                                AND MI_Detail.DescId   = zc_MI_Detail()
                                                                AND MovementItem.isErased = FALSE  
                                                                AND inDescId = zc_Movement_ReturnIn()
                                          LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                                           ON MILO_Reason.MovementItemId = MI_Detail.Id
                                                                          AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                                          LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId
                    
                                          LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                                           ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                                                          AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                                          LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = COALESCE (MILO_SubjectDoc.ObjectId, MovementLinkObject_SubjectDoc.ObjectId)

                                     GROUP BY tmpMovement.ItemName
                                          , tmpMovement.Id
                                          , tmpMovement.InvNumber
                                          , tmpMovement.OperDate
                                          , tmpMovement.UnitId
                                          , tmpMovement.FromId
                                          
                                          , CASE WHEN vbIsGoods_show = TRUE THEN MovementItem.ObjectId ELSE 0 END
                                          , CASE WHEN vbIsGoods_show = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END 
                                          , MovementItem.MeasureId  
                                          , COALESCE (MIFloat_Price.ValueData, 0)  
                                          , CASE WHEN vbIsGoods_show = TRUE THEN COALESCE (MIBoolean_BarCode.ValueData,FALSE) ELSE FALSE END
                                          , tmpMovement.JuridicalId
                                     ) AS tmp   
                                      INNER JOIN Object AS Object_Status ON Object_Status.Id =  tmp.MovementId
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId = 
                                            AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                      LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                              ON MovementFloat_ChangePercent.MovementId =  tmp.MovementId
                                             AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                   ON MovementLinkObject_PriceList.MovementId = tmp.MovementId
                                                  AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                              ON ObjectBoolean_PriceWithVAT.ObjectId = MovementLinkObject_PriceList.ObjectId
                                             AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                      LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                            ON ObjectFloat_VATPercent.ObjectId =  MovementLinkObject_PriceList.ObjectId
                                           AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
                               )


    -- Результат
    SELECT tmpOperationGroup.ItemName
         , tmpOperationGroup.InvNumber
         , tmpOperationGroup.OperDate
         , tmpOperationGroup.OperDatePartner
         , tmpOperationGroup.ChangePercent 
         , Object_PriceList.Id         AS PriceListId
         , Object_PriceList.ValueData  AS PriceListName
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName 
         , Object_Contract.Id          AS ContractId
         , Object_Contract.ValueData   AS ContractName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         , Object_Unit.ObjectCode      AS UnitCode
         , Object_Unit.ValueData       AS UnitName
         , Object_GoodsGroup.ValueData            AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                        AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.Id                    AS GoodsKindId
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName

         , tmpOperationGroup.Price :: TFloat AS Price

         , tmpOperationGroup.Amount :: TFloat    AS Amount_Weight
         , tmpOperationGroup.Amount_Sh :: TFloat AS Amount_Sh
         , 0 :: TFloat    AS Amount_Weight_del
         , 0 :: TFloat    AS Amount_Sh_del

         , tmpOperationGroup.AmountChangePercent :: TFloat    AS AmountChangePercent_Weight
         , tmpOperationGroup.AmountChangePercent_Sh :: TFloat AS AmountChangePercent_Sh
         
         , tmpOperationGroup.AmountPartner    :: TFloat AS AmountPartner_Weight
         , tmpOperationGroup.AmountPartner_Sh :: TFloat AS AmountPartner_Sh

         , tmpOperationGroup.Amount_10500    :: TFloat AS Amount_10500_Weight
         , tmpOperationGroup.Amount_10500_Sh :: TFloat AS Amount_10500_Sh
         , tmpOperationGroup.Amount_40200    :: TFloat AS Amount_40200_Weight
         , tmpOperationGroup.Amount_40200_Sh :: TFloat AS Amount_40200_Sh

         , tmpOperationGroup.SummPartner_calc :: TFloat   AS SummPartner_calc
         , tmpOperationGroup.SummPartner :: TFloat        AS SummPartner
         , tmpOperationGroup.SummPartner_10100 :: TFloat  AS SummPartner_10100
         , tmpOperationGroup.SummPartner_10200 :: TFloat  AS SummPartner_10200
         , tmpOperationGroup.SummPartner_10250 :: TFloat  AS SummPartner_10250
         , tmpOperationGroup.SummPartner_10300 :: TFloat  AS SummPartner_10300
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat  AS SummDiff


         
           -- Вес в упаковке - GoodsByGoodsKind
         , ObjectFloat_WeightTotal.ValueData   :: TFloat  AS WeightTotal
         --% скидки вес
         , tmpOperationGroup.ChangePercentAmount :: TFloat
         , tmpOperationGroup.isBarCode  ::Boolean

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName   
         
         , COALESCE (lfSelectPrice.ValuePrice, lfSelectPrice_.ValuePrice) :: TFloat AS Price_onDate
         , (((tmpOperationGroup.AmountPartner * COALESCE (lfSelectPrice.ValuePrice, lfSelectPrice_.ValuePrice) ) * (1+ COALESCE (tmpOperationGroup.ChangePercent,0)/100))
           * CASE WHEN tmpOperationGroup.isPriceWithVAT = TRUE THEN 1 ELSE (1 + tmpOperationGroup.VATPercent/100) END) :: TFloat AS Summ_onDate  --сумма по цене прайса наа дату
         , CASE WHEN  lfSelectPrice.ValuePrice IS NULL THEN 0 ELSE Object_GoodsKind.Id END             AS GoodsKindId_price
         , CASE WHEN  lfSelectPrice.ValuePrice IS NULL THEN '' ELSE Object_GoodsKind.ValueData END ::TVarChar  AS GoodsKindName_price

         , tmpOperationGroup.ReasonName      ::TVarChar
         , tmpOperationGroup.SubjectDocName  ::TVarChar 
         
         , Object_Status.ObjectCode ::Integer  AS StatusCode
         
     FROM tmpOperationGroup
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpOperationGroup.UnitId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpOperationGroup.MeasureId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpOperationGroup.PriceListId

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          
          -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpOperationGroup.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpOperationGroup.GoodsKindId
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
          
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= tmpOperationGroup.PriceListId
                                                        , inOperDate   := inPriceDate
                                                         ) AS lfSelectPrice ON lfSelectPrice.GoodsId =tmpOperationGroup.GoodsId
                                                                           AND lfSelectPrice.GoodsKindId = tmpOperationGroup.GoodsKindId

          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= tmpOperationGroup.PriceListId
                                                        , inOperDate   := inPriceDate
                                                         ) AS lfSelectPrice_ ON lfSelectPrice_.GoodsId =tmpOperationGroup.GoodsId
                                                                            AND lfSelectPrice_.GoodsKindId IS Null   

          LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = tmpOperationGroup.MovementId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId    
          
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpOperationGroup.StatusId

  UNION ALL
      SELECT tmp.ItemName
         , tmp.InvNumber
         , tmp.OperDate
         , tmp.OperDatePartner
         , tmp.ChangePercent 
         , Object_PriceList.Id         AS PriceListId
         , Object_PriceList.ValueData  AS PriceListName
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName 
         , Object_Contract.Id          AS ContractId
         , Object_Contract.ValueData   AS ContractName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         , Object_Unit.ObjectCode      AS UnitCode
         , Object_Unit.ValueData       AS UnitName
         , Object_GoodsGroup.ValueData            AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                        AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.Id                    AS GoodsKindId
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName

         , tmp.Price :: TFloat AS Price

         , 0 :: TFloat    AS Amount_Weight
         , 0 :: TFloat    AS Amount_Sh
         , tmp.Amount :: TFloat    AS Amount_Weight_del
         , tmp.Amount_Sh :: TFloat AS Amount_Sh_del
         , 0 :: TFloat    AS AmountChangePercent_Weight
         , 0 :: TFloat AS AmountChangePercent_Sh
         
         , 0    :: TFloat AS AmountPartner_Weight
         , 0    :: TFloat AS AmountPartner_Sh

         , 0 :: TFloat AS Amount_10500_Weight
         , 0 :: TFloat AS Amount_10500_Sh
         , 0 :: TFloat AS Amount_40200_Weight
         , 0 :: TFloat AS Amount_40200_Sh

         , 0 :: TFloat  AS SummPartner_calc
         , 0 :: TFloat  AS SummPartner
         , 0 :: TFloat  AS SummPartner_10100
         , 0 :: TFloat  AS SummPartner_10200
         , 0 :: TFloat  AS SummPartner_10250
         , 0 :: TFloat  AS SummPartner_10300
         , 0 :: TFloat  AS SummDiff
         
           -- Вес в упаковке - GoodsByGoodsKind
         , ObjectFloat_WeightTotal.ValueData   :: TFloat  AS WeightTotal
         --% скидки вес
         , 0  :: TFloat   AS ChangePercentAmount
         , tmp.isBarCode  ::Boolean  AS isBarCode

         , NULL ::TVarChar              AS InfoMoneyGroupName
         , NULL ::TVarChar              AS InfoMoneyDestinationName
         , 0    ::Integer               AS InfoMoneyCode
         , NULL ::TVarChar              AS InfoMoneyName   
         
         , COALESCE (lfSelectPrice.ValuePrice, lfSelectPrice_.ValuePrice) :: TFloat AS Price_onDate
         , 0 :: TFloat AS Summ_onDate  --сумма по цене прайса наа дату
         , CASE WHEN  lfSelectPrice.ValuePrice IS NULL THEN 0 ELSE Object_GoodsKind.Id END             AS GoodsKindId_price
         , CASE WHEN  lfSelectPrice.ValuePrice IS NULL THEN '' ELSE Object_GoodsKind.ValueData END ::TVarChar  AS GoodsKindName_price

         , tmp.ReasonName      ::TVarChar
         , tmp.SubjectDocName  ::TVarChar   
         
         , tmp.StatusCode
      FROM tmpMovementErased AS tmp
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmp.PartnerId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmp.JuridicalId
          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmp.PriceListId     
          
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmp.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
          --LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Goods ON View_InfoMoney_Goods.InfoMoneyId = tmp.InfoMoneyId_goods

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmp.MeasureId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

           -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmp.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmp.GoodsKindId
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
          
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= tmp.PriceListId
                                                        , inOperDate   := inPriceDate
                                                         ) AS lfSelectPrice ON lfSelectPrice.GoodsId = tmp.GoodsId
                                                                           AND lfSelectPrice.GoodsKindId = tmp.GoodsKindId

          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= tmp.PriceListId
                                                        , inOperDate   := inPriceDate
                                                         ) AS lfSelectPrice_ ON lfSelectPrice_.GoodsId = tmp.GoodsId
                                                                            AND lfSelectPrice_.GoodsKindId IS Null   

          LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = tmp.MovementId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId



     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_GoodsMI_byMovement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.05.22         * 10100
 15.12.14                                        * all
 12.11.14                                        * add inGoodsId
 18.05.14                                        * all
 06.05.14                                        * add From... and To...
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummChangePercent , AmountChangePercent
 05.02.14         * add inJuridicalId
 22.01.14         *
*/

-- тест
-- SELECT SUM (AmountPartner_Weight), SUM (SummPartner) FROM gpReport_GoodsMI_byMovement (inStartDate:= '01.01.2016', inEndDate:= '01.01.2016', inDescId:= zc_Movement_Sale(), inUnitId:= 0, inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inGoodsId:=0, inSession:= zfCalc_UserAdmin());
--select * from gpReport_GoodsMI_byMovement (inStartDate := ('24.11.2022')::TDateTime , inEndDate := ('24.11.2022')::TDateTime, inPriceDate := ('24.11.2022')::TDateTime , inDescId := 5 , inUnitId := 0 , inJuridicalId := 862910 , inInfoMoneyId := 0 , inPaidKindId := 0 , inGoodsGroupId := 0 , inGoodsId := 1613498 ,  inSession := '9457');



--select * from gpReport_GoodsMI_byMovement (inStartDate := ('18.06.2024')::TDateTime , inEndDate := ('18.06.2024')::TDateTime,inPriceDate:=('18.06.2024')::TDateTime , inDescId := zc_Movement_ReturnIn() , inUnitId := 0 , inJuridicalId := 862910 , inInfoMoneyId := 0 , inPaidKindId := 0 , inGoodsGroupId := 0 , inGoodsId := 0 , inIsErased := TRUE, inSession := '9457');