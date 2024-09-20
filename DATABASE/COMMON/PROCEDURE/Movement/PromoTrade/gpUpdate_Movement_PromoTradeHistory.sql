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
     CREATE TEMP TABLE _tmpData (SaleAmount TFloat, ReturnAmount TFloat, SaleSumm TFloat, ReturnSumm TFloat) ON COMMIT DROP;
  
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

     INSERT INTO _tmpData (SaleAmount, ReturnAmount, SaleSumm, ReturnSumm) 
     WITH 
      tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                     )
    , tmpContainer AS (SELECT MIContainer.ObjectId_analyzer    AS GoodsId
                            , MIContainer.ObjectIntId_analyzer AS GoodsKindId

                            , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()    
                                             THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                        ELSE 0
                                   END) AS Sale_AmountPartner
                            , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800()
                                             THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                        ELSE 0
                                   END) AS Return_AmountPartner

                            , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                            , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
                       FROM tmpAnalyzer
                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                              AND MIContainer.OperDate BETWEEN vbOperDateStart AND vbOperDateEnd     --'01.06.2024' AND '31.08.2024'--
                                                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) 
                              INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                            AND ContainerLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId    = vbJuridicalId  --15412  -- 14866 --vbJuridicalId inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                                   
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = MIContainer.MovementId
                                                           AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId   = vbContractId

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                  ON ObjectLink_Goods_Measure.ObjectId = MIContainer.ObjectId_analyzer
                                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                   ON ObjectFloat_Weight.ObjectId = MIContainer.ObjectId_analyzer
                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                              --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                               --                  AND (COALESCE (tmpGoods.GoodsKindId,0) = COALESCE (MIContainer.ObjectIntId_analyzer,0) OR COALESCE (tmpGoods.GoodsKindId,0) = 0) 

                       GROUP BY MIContainer.ObjectId_analyzer 
                              , MIContainer.ObjectIntId_analyzer
                       )
                       
        SELECT SUM (tmpContainer.Sale_AmountPartner)   AS SaleAmount
             , SUM (tmpContainer.Return_AmountPartner) AS ReturnAmount
             , SUM (tmpContainer.Sale_Summ)            AS SaleSumm
             , SUM (tmpContainer.Return_Summ)          AS ReturnSumm
        FROM tmpContainer
        ;

     -- Результат - 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSale(), _tmpMI_promotrade.Id, COALESCE (_tmpData.SaleAmount, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSale(), _tmpMI_promotrade.Id, COALESCE (_tmpData.SaleSumm, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReturnIn(), _tmpMI_promotrade.Id, COALESCE (_tmpData.ReturnAmount, 0))
     FROM _tmpMI_promotrade
         LEFT JOIN (SELECT MIN (_tmpMI_promotrade.Id) AS Id FROM _tmpMI_promotrade) AS _tmpMI_promotrade_check ON _tmpMI_promotrade_check.Id = _tmpMI_promotrade.Id
         -- временно - только в первую строчку
         LEFT JOIN _tmpData ON _tmpMI_promotrade_check.Id > 0
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
-- SELECT * FROM gpUpdate_Movement_PromoTradeHistory (inMovementId:= 29309489 , inSession:= zfCalc_UserAdmin())
