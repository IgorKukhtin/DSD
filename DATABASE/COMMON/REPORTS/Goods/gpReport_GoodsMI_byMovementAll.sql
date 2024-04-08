 -- Function: gpReport_GoodsMI_byMovementAll ((все статусы))

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementAll (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovementAll (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   , -- zc_Movement_Sale or zc_Movement_ReturnIn
    IN inUnitId       Integer   , 
    IN inJuridicalId  Integer   , 
    IN inInfoMoneyId  Integer   , -- Управленческая статья  
    IN inPaidKindId   Integer   , --
    IN inGoodsGroupId Integer   ,
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, StatusCode Integer
             , InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, ChangePercent TFloat, PriceListName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , SubjectDocName TVarChar, ReasonName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Price TFloat
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_10500_Weight TFloat, Amount_10500_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat, SummPartner_10200 TFloat, SummPartner_10250 TFloat, SummPartner_10300 TFloat
             , SummDiff TFloat
             , WeightTotal TFloat -- Вес в упаковке - GoodsByGoodsKind
             , ChangePercentAmount TFloat
             , isBarCode  Boolean
             , isWeighing_inf Boolean
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             )   
AS
$BODY$
   DECLARE vbIsGoods Boolean;
   DECLARE vbIsUnit Boolean;

   DECLARE vbIsGoods_show Boolean; 
    DECLARE vbUserId Integer;
BEGIN
    --проверка прав
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    vbIsGoods_show:= TRUE;

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
                            , ContainerLinkObject_Contract.ObjectId  AS ContractId

                            , MIContainer.MovementItemId
                            , MIContainer.MovementId
                            , MIContainer.ObjectId_analyzer          AS GoodsId
                            , MIContainer.ObjectIntId_analyzer       AS GoodsKindId
                               -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                            , (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                    ELSE 0
                               END) AS SummPartner
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
                             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                           ON ContainerLinkObject_Contract.ContainerId = MIContainer.ContainerId_analyzer
                                                          AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()

                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
           
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  MIContainer.MovementId
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

       -- непроведенные и удаленные документы
       , tmpMovement_dop AS (SELECT Movement.Id
                                  , ObjectLink_Partner_Juridical.ChildObjectId  AS JuridicalId
                                  , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                  , MovementLinkObject_From.ObjectId            AS PartnerId
                                  , MovementLinkObject_To.ObjectId              AS UnitId
                                  , MovementLinkObject_Contract.ObjectId        AS ContractId
                             FROM Movement
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                       ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                      AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
       -- LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
       
                               --   LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

                             WHERE Movement.DescId = zc_Movement_ReturnIn()
                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND (_tmpUnit.UnitId > 0 OR vbIsUnit = FALSE)
                               AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                               AND (MovementLinkObject_PaidKind.ObjectId       = inPaidKindId  OR COALESCE (inPaidKindId, 0)  = 0)
                               AND (ObjectLink_Contract_InfoMoney.ChildObjectId        = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             )

       , tmpMB AS (SELECT MovementBoolean_PriceWithVAT.*
                   FROM MovementBoolean AS MovementBoolean_PriceWithVAT
                   WHERE MovementBoolean_PriceWithVAT.MovementId IN (SELECT DISTINCT tmpMovement_dop.Id FROM tmpMovement_dop)
                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                   )
       , tmpMF AS (SELECT MovementFloat.*
                   FROM MovementFloat
                   WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_dop.Id FROM tmpMovement_dop)
                     AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                , zc_MovementFloat_ChangePercent()
                                                , zc_MovementFloat_CurrencyValue()
                                                , zc_MovementFloat_ParValue()
                                                )
                   )

       , tmpMLO AS (SELECT MovementLinkObject_CurrencyDocument.*
                    FROM MovementLinkObject AS MovementLinkObject_CurrencyDocument
                    WHERE MovementLinkObject_CurrencyDocument.MovementId IN (SELECT DISTINCT tmpMovement_dop.Id FROM tmpMovement_dop)
                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                    )
       , tmpMI_dop_all AS (SELECT MovementItem.*
                                , _tmpGoods.MeasureId
                                , _tmpGoods.Weight
                           FROM MovementItem
                            LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                           WHERE MovementItem.MovementId IN (SELECT tmpMovement_dop.Id FROM tmpMovement_dop)
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.isErased = False
                             AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                           )
       , tmpMIF AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_dop_all.Id FROM tmpMI_dop_all)
                      AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                     , zc_MIFloat_CountForPrice()
                                                     , zc_MIFloat_AmountPartner()
                                                     , zc_MIFloat_ChangePercent())
                     )

       , tmpMILO AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_dop_all.Id FROM tmpMI_dop_all)
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                      )

       , tmpMI_dop AS (SELECT Movement.JuridicalId
                            , Movement.InfoMoneyId
                            , Movement.PartnerId
                            , Movement.UnitId
                            , Movement.ContractId

                            , MovementItem.Id AS MovementItemId
                            , Movement.Id AS MovementId
                            , MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                             -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                            , (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData) AS SummPartner
                             -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами + Скидка Акция
                           , 0 AS SummPartner_10200
                             -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами + Скидка Акция
                           , 0 AS SummPartner_10250
                              -- 5.3.4. Сумма у покупателя Скидка / Наценка дополнительная
                            , ( (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData) - ((MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData) * MIFloat_ChangePercent.ValueData/100) ) AS SummPartner_10300

                            , COALESCE (MIFloat_Price.ValueData, 0)
                              -- так переводится факт цена в валюту zc_Enum_Currency_Basis
                            * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                              AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                               -- 1.1. Кол-во, без AnalyzerId
                            , (MovementItem.Amount) AS Amount

                              -- 2.1.1. Кол-во - со Скидкой за вес
                            , (MovementItem.Amount) AS AmountChangePercent
                              -- 2.1.2. Кол-во - Скидка за вес
                            , 0 AS Amount_10500

                              -- 3.1. Кол-во Разница в весе
                            , (COALESCE (MovementItem.Amount,0) - COALESCE (MIFloat_AmountPartner.ValueData,0)) AS Amount_40200

                              -- 5.1. Кол-во у покупателя
                            , (MIFloat_AmountPartner.ValueData) AS AmountPartner

                              -- 5.3.1. Сумма у покупателя По прайсу
                            , (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData) AS SummPartner_calc

                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                            , MovementItem.MeasureId
                            , MovementItem.Weight

                       FROM tmpMovement_dop AS Movement

                            LEFT JOIN tmpMB AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                            LEFT JOIN tmpMF AS MovementFloat_VATPercent
                                            ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                           AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                            LEFT JOIN tmpMF AS MovementFloat_ChangePercent
                                            ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                           AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                            LEFT JOIN tmpMF AS MovementFloat_CurrencyValue
                                            ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                           AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                            LEFT JOIN tmpMF AS MovementFloat_ParValue
                                            ON MovementFloat_ParValue.MovementId = Movement.Id
                                           AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                            LEFT JOIN tmpMLO AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                            --
                            LEFT JOIN tmpMI_dop_all AS MovementItem ON MovementItem.MovementId = Movement.Id

                            LEFT JOIN tmpMIF AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN tmpMIF AS MIFloat_CountForPrice
                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                           LEFT JOIN tmpMIF AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN tmpMIF AS MIFloat_ChangePercent
                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                           LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       --WHERE (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                       )

       , tmpUnion AS (SELECT tmpListContainerSumm.*
                      FROM tmpListContainerSumm
                     UNION 
                      SELECT tmpMI_dop.*
                      FROM tmpMI_dop
                      )                                       
                                                         
       ----
       , tmpMIBoolean_BarCode AS (SELECT MIBoolean_BarCode.*
                                  FROM MovementItemBoolean AS MIBoolean_BarCode 
                                  WHERE MIBoolean_BarCode.MovementItemId IN (SELECT DISTINCT tmpUnion.MovementItemId FROM tmpUnion)
                                    AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                                  )
       , tmpMIFloat_ChangePercentAmount AS (SELECT MovementItemFloat.*
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpUnion.MovementItemId FROM tmpUnion)
                                    AND MovementItemFloat.DescId = zc_MIFloat_ChangePercentAmount()
                                  )

       , tmpOperationGroup_all AS
                (SELECT tmpListContainerSumm.MovementId
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      , tmpListContainerSumm.ContractId

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
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10250)   AS SummPartner_10250
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300

                 FROM (SELECT tmpListContainerSumm.MovementId
                            , tmpListContainerSumm.JuridicalId
                            , tmpListContainerSumm.PartnerId
                            , tmpListContainerSumm.InfoMoneyId
                            , tmpListContainerSumm.UnitId
                            , tmpListContainerSumm.ContractId
                            , tmpListContainerSumm.GoodsId
                            , tmpListContainerSumm.GoodsKindId
                            , tmpListContainerSumm.MeasureId
                            , tmpListContainerSumm.Price
                            , COALESCE (MIBoolean_BarCode.ValueData,FALSE) AS isBarCode
                            , (tmpListContainerSumm.SummPartner)       AS SummPartner
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

                       FROM tmpUnion AS tmpListContainerSumm
                             LEFT JOIN tmpMIBoolean_BarCode AS MIBoolean_BarCode 
                                                            ON MIBoolean_BarCode.MovementItemId = tmpListContainerSumm.MovementItemId
                                                           AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
                             LEFT JOIN tmpMIFloat_ChangePercentAmount AS MIFloat_ChangePercentAmount
                                                                      ON MIFloat_ChangePercentAmount.MovementItemId = tmpListContainerSumm.MovementItemId
                                                                     AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                       ) AS tmpListContainerSumm
                 GROUP BY tmpListContainerSumm.MovementId
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.ContractId
                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                        , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.isBarCode   ELSE FALSE END
                        , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.ChangePercentAmount ELSE 0 END
                )

        , tmpMLO_SubjectDoc AS (SELECT MovementLinkObject_SubjectDoc.*
                                FROM MovementLinkObject AS MovementLinkObject_SubjectDoc
                                WHERE MovementLinkObject_SubjectDoc.MovementId IN (SELECT tmpOperationGroup_all.MovementId FROM tmpOperationGroup_all)
                                  AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                                )

        , tmpMI_Detail AS (SELECT MovementItem.MovementId
                                , STRING_AGG (DISTINCT Object_Reason.ValueData, '; ') ::TVarChar AS ReasonName
                           FROM tmpOperationGroup_all
                                INNER JOIN MovementItem ON MovementItem.MovementId = tmpOperationGroup_all.MovementId
                                                       AND MovementItem.DescId     = zc_MI_Detail()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN MovementItemLinkObject AS MILO_Reason
                                                                  ON MILO_Reason.MovementItemId = MovementItem.Id
                                                                 AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                                LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId
                           GROUP BY MovementItem.MovementId
                           )

       , tmpOperationGroup AS
                (SELECT MovementDesc.ItemName
                      , Movement.Id                            AS MovementId
                      , Movement.StatusId
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementFloat_ChangePercent.ValueData  AS ChangePercent
                      , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      , MovementLinkObject_PriceList.ObjectId  AS PriceListId
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      , tmpListContainerSumm.ContractId

                      , MovementLinkObject_SubjectDoc.ObjectId AS SubjectDocId
                      , tmpListContainerSumm.GoodsId
                      , tmpListContainerSumm.GoodsKindId
                      , tmpListContainerSumm.MeasureId
                      , tmpListContainerSumm.Price
                      , tmpListContainerSumm.isBarCode
                      , tmpListContainerSumm.ChangePercentAmount
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
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10250)   AS SummPartner_10250
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300
                      , SUM (tmpListContainerSumm.SummPartner_calc) AS SummPartner_calc
                 FROM tmpOperationGroup_all AS tmpListContainerSumm
                      LEFT JOIN Movement ON Movement.Id = tmpListContainerSumm.MovementId
                      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId =  tmpListContainerSumm.MovementId
                                            AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                      LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                              ON MovementFloat_ChangePercent.MovementId =  tmpListContainerSumm.MovementId
                                             AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                   ON MovementLinkObject_PriceList.MovementId = tmpListContainerSumm.MovementId
                                                  AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

                      LEFT JOIN tmpMLO_SubjectDoc AS MovementLinkObject_SubjectDoc
                                                  ON MovementLinkObject_SubjectDoc.MovementId = tmpListContainerSumm.MovementId
                      LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId
                 GROUP BY MovementDesc.ItemName
                        , Movement.Id
                        , Movement.StatusId
                        , Movement.InvNumber
                        , Movement.OperDate
                        , MovementFloat_ChangePercent.ValueData
                        , MovementDate_OperDatePartner.ValueData
                        , MovementLinkObject_PriceList.ObjectId
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.ContractId

                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                        , tmpListContainerSumm.isBarCode
                        , tmpListContainerSumm.ChangePercentAmount
                        , MovementLinkObject_SubjectDoc.ObjectId
                )

        -- взвешивание контрагент
        , tmpWeighingPartner AS (SELECT DISTINCT Movement.ParentId
                                 FROM Movement
                                 WHERE Movement.ParentId IN (SELECT tmpOperationGroup.MovementId FROM tmpOperationGroup)
                                   AND Movement.DescId = zc_Movement_WeighingPartner()
                                )
                     
        , tmpInfoMoney_View AS (SELECT View_InfoMoney.*
                                FROM Object_InfoMoney_View AS View_InfoMoney
                                WHERE View_InfoMoney.InfoMoneyId IN (SELECT DISTINCT tmpOperationGroup.InfoMoneyId FROM tmpOperationGroup)
                                )


            
    -- Результат
    SELECT tmpOperationGroup.ItemName
         , Object_Status.ObjectCode    AS StatusCode
         , tmpOperationGroup.InvNumber
         , tmpOperationGroup.OperDate
         , tmpOperationGroup.OperDatePartner
         , tmpOperationGroup.ChangePercent
         , Object_PriceList.ValueData  AS PriceListName
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         , Object_Unit.ObjectCode      AS UnitCode
         , Object_Unit.ValueData       AS UnitName
         , Object_SubjectDoc.ValueData  ::TVarChar AS SubjectDocName
         , tmpMI_Detail.ReasonName      ::TVarChar
         
         , Object_GoodsGroup.ValueData            AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName

         , tmpOperationGroup.Price :: TFloat AS Price

         , tmpOperationGroup.Amount :: TFloat    AS Amount_Weight
         , tmpOperationGroup.Amount_Sh :: TFloat AS Amount_Sh

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
         , tmpOperationGroup.SummPartner_10200 :: TFloat  AS SummPartner_10200
         , tmpOperationGroup.SummPartner_10250 :: TFloat  AS SummPartner_10250
         , tmpOperationGroup.SummPartner_10300 :: TFloat  AS SummPartner_10300
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat  AS SummDiff

    
           -- Вес в упаковке - GoodsByGoodsKind
         , ObjectFloat_WeightTotal.ValueData   :: TFloat  AS WeightTotal
         --% скидки вес
         , tmpOperationGroup.ChangePercentAmount :: TFloat
         , tmpOperationGroup.isBarCode  ::Boolean
         , CASE WHEN tmpWeighingPartner.ParentId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isWeighing_inf

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
         
         , View_Contract_InvNumber.ContractId
         , View_Contract_InvNumber.ContractCode
         , View_Contract_InvNumber.InvNumber AS ContractNumber
         , View_Contract_InvNumber.ContractTagName
         , View_Contract_InvNumber.ContractTagGroupName

     FROM tmpOperationGroup
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpOperationGroup.StatusId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpOperationGroup.UnitId

          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpOperationGroup.ContractId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpOperationGroup.MeasureId
          
          LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = tmpOperationGroup.SubjectDocId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpOperationGroup.PriceListId

          LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          
          -- Товар и Вид товара
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpOperationGroup.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpOperationGroup.GoodsKindId
          -- вес в упаковке: "чистый" вес + вес 1-ого пакета
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
          --взвешивание
          LEFT JOIN tmpWeighingPartner ON tmpWeighingPartner.ParentId = tmpOperationGroup.MovementId

          LEFT JOIN tmpMI_Detail ON tmpMI_Detail.MovementId = tmpOperationGroup.MovementId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 30.03.22         *
*/

-- тест
-- SELECT * from gpReport_GoodsMI_byMovementAll (inStartDate := ('24.11.2023')::TDateTime , inEndDate := ('24.11.2023')::TDateTime , inDescId := 5 , inUnitId := 0 , inJuridicalId := 862910 , inInfoMoneyId := 0 , inPaidKindId := 0 , inGoodsGroupId := 0 , inGoodsId := 1613498 ,  inSession := '9457');
