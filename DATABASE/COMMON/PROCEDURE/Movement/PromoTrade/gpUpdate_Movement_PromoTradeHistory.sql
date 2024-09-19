-- Function: gpUpdate_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PromoTradeHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PromoTradeHistory(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd   TDateTime;
   DECLARE vbJuridicalId   Integer;
   DECLARE vbContractId    Integer;
  -- DECLARE vbRetailId      Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());

     -- параметры из документа <Акции>
     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId 
          , MovementLinkObject_Contract.ObjectId        AS ContractId
          , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж
          , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж
 INTO vbJuridicalId, vbContractId, vbOperDateStart, vbOperDateEnd
     FROM Movement AS Movement_PromoTrade
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

     WHERE Movement_PromoTrade.Id = inMovementId
    ;

   /*IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не проведен.';
     END IF;*/



     -- данные по акциям
     CREATE TEMP TABLE _tmpMI_promotrade (Id Integer, GoodsId Integer, GoodsKindId Integer, TradeMarkId Integer) ON COMMIT DROP;
     -- данные по продажам/возвратам
     CREATE TEMP TABLE _tmpData (GoodsId Integer, GoodsKindId Integer, TradeMarkId Integer
                               , SaleAmount TFloat, ReturnAmount TFloat, SaleSumm TFloat, ReturnSumm TFloat
                               , SaleAmount_tm TFloat, ReturnAmount_tm TFloat, SaleSumm_tm TFloat, ReturnSumm_tm TFloat, Ord_tm Integer) ON COMMIT DROP;
  
     -- Данные Promo
     INSERT INTO _tmpMI_promotrade (Id, GoodsId, GoodsKindId, TradeMarkId)
        SELECT MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --ИД обьекта <Вид товара>
             , MILinkObject_TradeMark.ObjectId        AS TradeMarkId         ---торговая марка
        FROM MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND MovementItem.isErased = FALSE;

     INSERT INTO _tmpData (GoodsId, GoodsKindId, TradeMarkId, SaleAmount, ReturnAmount, SaleSumm, ReturnSumm, SaleAmount_tm, ReturnAmount_tm, SaleSumm_tm, ReturnSumm_tm, Ord_tm) 
     WITH 
      tmpGoods AS (SELECT MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
                        , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --ИД обьекта <Вид товара>
                        , ObjectLink_Goods_TradeMark.ChildObjectId AS TradeMarkId         ---торговая марка
                   FROM MovementItem
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                        --
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                             ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                   WHERE MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE 
                     AND COALESCE (MovementItem.ObjectId,0) <> 0
                 UNION     
                 --вариант когда выбрана только торговая сеть
                  SELECT ObjectLink_Goods_TradeMark.ObjectId   AS GoodsId             --ИД объекта <товар>
                       , 0                                     AS GoodsKindId         --ИД обьекта <Вид товара>
                       , MILinkObject_TradeMark.ObjectId       AS TradeMarkId         ---торговая марка
                   FROM MovementItem
                        INNER JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                                          ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                             ON ObjectLink_Goods_TradeMark.ChildObjectId = MILinkObject_TradeMark.ObjectId
                                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark() 
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_TradeMark.ObjectId
                   WHERE MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND COALESCE (MovementItem.ObjectId,0) = 0  
                  )                            
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                     -- WHERE isCost = FALSE OR (isCost = TRUE AND vbIsCost = TRUE)
                     )
    , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer    AS GoodsId
                            , MIContainer.ObjectIntId_analyzer AS GoodsKindId
                            , tmpGoods.TradeMarkId             AS TradeMarkId  

                            , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                            , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                            , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                            , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
                       FROM tmpAnalyzer
                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                              AND MIContainer.OperDate BETWEEN vbOperDateStart AND vbOperDateEnd     --'01.06.2024' AND '31.08.2024'--
                                                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) 
                              INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = vbJuridicalId  --15412  -- 14866 --vbJuridicalId inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                                   
                              INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                                 AND (COALESCE (tmpGoods.GoodsKindId,0) = COALESCE (MIContainer.ObjectIntId_analyzer,0) OR COALESCE (tmpGoods.GoodsKindId,0) = 0) 

                       GROUP BY MIContainer.ObjectId_analyzer 
                              , MIContainer.ObjectIntId_analyzer
                              , tmpGoods.TradeMarkId
                       )
                       
        SELECT tmpContainer.GoodsId
             , tmpContainer.GoodsKindId
             , tmpContainer.TradeMarkId
             , tmpContainer.Sale_AmountPartner   AS SaleAmount
             , tmpContainer.Return_AmountPartner AS ReturnAmount
             , tmpContainer.Sale_Summ            AS SaleSumm
             , tmpContainer.Return_Summ          AS ReturnSumm
             , SUM (tmpContainer.Sale_AmountPartner) OVER (PARTITION BY tmpContainer.TradeMarkId)   AS SaleAmount_tm 
             , SUM (tmpContainer.Return_AmountPartner) OVER (PARTITION BY tmpContainer.TradeMarkId) AS ReturnAmount_tm
             , SUM (tmpContainer.Sale_Summ) OVER (PARTITION BY tmpContainer.TradeMarkId)            AS SaleSumm_tm
             , SUM (tmpContainer.Return_Summ) OVER (PARTITION BY tmpContainer.TradeMarkId)          AS ReturnSumm_tm
             , ROW_NUMBER() OVER (PARTITION BY tmpContainer.TradeMarkId)                            AS Ord_tm
        FROM tmpContainer
        ;

     -- Результат - 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSale(), _tmpMI_promotrade.Id, COALESCE (_tmpData.SaleAmount, _tmpData_TM.SaleAmount_tm, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSale(), _tmpMI_promotrade.Id, COALESCE (_tmpData.SaleSumm, _tmpData_TM.SaleSumm_tm, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReturnIn(), _tmpMI_promotrade.Id, COALESCE (_tmpData.ReturnAmount, _tmpData_TM.ReturnAmount_tm, 0))
     FROM _tmpMI_promotrade
         LEFT JOIN _tmpData ON _tmpData.GoodsId = _tmpMI_promotrade.GoodsId
                           AND COALESCE (_tmpData.GoodsKindId,0) = COALESCE (_tmpMI_promotrade.GoodsKindId,0)
         -- еще раз если выбрана торговая марка  
         LEFT JOIN _tmpData AS _tmpData_TM ON _tmpData_TM.TradeMarkId = _tmpMI_promotrade.TradeMarkId 
                                          AND _tmpData_TM.Ord_tm = 1
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.09.24         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_PromoTradeHistory (inMovementId:= 2641111, inSession:= zfCalc_UserAdmin())

/*

/*
  SELECT ObjectLink_Juridical_Retail.ChildObjectId   AS RetailId
          , ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId 
          , MovementLinkObject_Contract.ObjectId        AS ContractId
          , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж
          , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж
 --INTO vbRetailId, vbJuridicalId, vbContractId, vbOperDateStart, vbOperDateEnd
     FROM Movement AS Movement_PromoTrade
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

     WHERE Movement_PromoTrade.Id = 29197668  --inMovementId
*/

WITH 
tmpGoods AS (SELECT MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --ИД обьекта <Вид товара>
             , ObjectLink_Goods_TradeMark.ChildObjectId AS TradeMarkId         ---торговая марка
        FROM MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = 29197668  --inMovementId
          AND MovementItem.isErased = FALSE 
          AND COALESCE (MovementItem.ObjectId,0) <> 0
      UNION     
      --вариант когда выбрана только торговая сеть
       SELECT ObjectLink_Goods_TradeMark.ObjectId   AS GoodsId             --ИД объекта <товар>
            , 0                                     AS GoodsKindId         --ИД обьекта <Вид товара>
            , MILinkObject_TradeMark.ObjectId       AS TradeMarkId         ---торговая марка
        FROM MovementItem
             INNER JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                               ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                              AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ChildObjectId = MILinkObject_TradeMark.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark() 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_TradeMark.ObjectId
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = 29197668  --inMovementId
          AND MovementItem.isErased = FALSE
          AND COALESCE (MovementItem.ObjectId,0) = 0  
          )                            
 , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                              , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                         FROM Constant_ProfitLoss_AnalyzerId_View
                        -- WHERE isCost = FALSE OR (isCost = TRUE AND vbIsCost = TRUE)
                        )
, tmpContainer AS (SELECT MIContainer.ObjectId_analyzer    AS GoodsId
                        , MIContainer.ObjectIntId_analyzer AS GoodsKindId
                        , tmpGoods.TradeMarkId             AS TradeMarkId  
                     
                        , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                        , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner
                        
                        , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                        , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
                 FROM tmpAnalyzer
                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                              AND MIContainer.OperDate BETWEEN '01.06.2024' AND '31.08.2024'--inStartDate AND inEndDate
                                                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) 
                                INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = 15412  -- 14866 --vbJuridicalId inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                                   
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                                   AND (COALESCE (tmpGoods.GoodsKindId,0) = COALESCE (MIContainer.ObjectIntId_analyzer,0) OR COALESCE (tmpGoods.GoodsKindId,0) = 0) 

                 GROUP BY MIContainer.ObjectId_analyzer 
                      , MIContainer.ObjectIntId_analyzer
                      , tmpGoods.TradeMarkId
                  )
        SELECT tmpContainer.*
             , SUM (tmpContainer.Sale_AmountPartner) OVER (PARTITION BY tmpContainer.TradeMarkId)   AS SaleAmount_tm 
             , SUM (tmpContainer.Return_AmountPartner) OVER (PARTITION BY tmpContainer.TradeMarkId) AS ReturnAmount_tm
             , SUM (tmpContainer.Sale_Summ) OVER (PARTITION BY tmpContainer.TradeMarkId)            AS SaleSumm_tm
             , SUM (tmpContainer.Return_Summ) OVER (PARTITION BY tmpContainer.TradeMarkId)          AS ReturnSumm_tm
             , ROW_NUMBER() OVER (PARTITION BY tmpContainer.TradeMarkId)          AS Ord_tm
        FROM tmpContainer

*/
