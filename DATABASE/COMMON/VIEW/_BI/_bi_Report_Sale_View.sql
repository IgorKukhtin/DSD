-- View: _bi_Report_Sale_View

DROP VIEW IF EXISTS _bi_Report_Sale_View;

-- Документы - Продажа
CREATE OR REPLACE VIEW _bi_Report_Sale_View
AS

   WITH -- Аналитика для продажи
        tmpAnalyzer AS (SELECT -- Аналитика
                               Constant_ProfitLoss_AnalyzerId_View.AnalyzerId, Constant_ProfitLoss_AnalyzerId_View.ValueData AS AnalyzerName
                               -- Это Продажа или Возврат
                             , Constant_ProfitLoss_AnalyzerId_View.isSale
                               -- Это С/С да/нет
                             , Constant_ProfitLoss_AnalyzerId_View.isCost
                               -- Это Сумма или Кол-во
                             , Constant_ProfitLoss_AnalyzerId_View.isSumm
                        FROM Constant_ProfitLoss_AnalyzerId_View
                       )
        -- Ключ для Товар + Вид
     /*, tmpGoodsByGoodsKind AS (SELECT
                                      ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS Id
                                    , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                    , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               )*/
        -- Результат
              -- Продажа / Возврат
              SELECT -- Id Документа
                     MIContainer.MovementId
                     -- , tmpAnalyzer.AnalyzerId
                     -- Вид Документа
                   , MIContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- Дата покупателя
                   , MIContainer.OperDate
                     -- Дата Склад
                   , Movement.OperDate AS OperDate_sklad
                     -- № Документа
                   , Movement.InvNumber

                     -- Юр. Лицо
                   , CLO_Juridical.ObjectId                AS JuridicalId
                     -- Контрагент
                   , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service()
                               THEN MIContainer.ObjectId_Analyzer
                          ELSE MIContainer.ObjectExtId_Analyzer
                          --ELSE MovementLinkObject_Partner.ObjectId
                     END :: Integer AS PartnerId

                     -- УП Статья назначения
                   , CLO_InfoMoney.ObjectId                      AS InfoMoneyId
                     -- Форма оплаты
                   , CLO_PaidKind.ObjectId                       AS PaidKindId
                     -- Форма оплаты - Договор начисления Бонус
                   , CLO_PaidKind.ObjectId                       AS PaidKindId_bonus
                     -- Филиал
                   , MILinkObject_Branch.ObjectId                AS BranchId
                     -- Договор
                   , CLO_Contract.ObjectId                       AS ContractId

                     -- Товар
                   , MIContainer.ObjectId_Analyzer               AS GoodsId
                   , Object_Goods.ObjectCode                     AS GoodsCode
                   , Object_Goods.ValueData                      AS GoodsName
                     -- Вид Товара
                   , MIContainer.ObjectIntId_Analyzer            AS GoodsKindId
                   , Object_GoodsKind.ObjectCode                 AS GoodsKindCode
                   , Object_GoodsKind.ValueData                  AS GoodsKindName
                     -- Ед.изм. Товара
                   , Object_Measure.ObjectCode                   AS MeasureCode
                   , Object_Measure.ValueData                    AS MeasureName

                     -- Документ Акция
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- Признак Акция да/нет
                   , CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- Типы условия Бонус - нет
                   , 0  :: Integer  AS ContractConditionKindId
                   , '' :: TVarChar AS ContractConditionKindName
                     -- Вид бонуса - нет
                   , 0  :: Integer  AS BonusKindId
                   , '' :: TVarChar AS BonusKindName
                     -- % бонуса - нет
                   , 0  :: TFloat   AS BonusTax


                     -- Вес Продажа - со склада
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                              THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_sh

                     -- Вес Возврат - на склад
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_Amount
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                              THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_Amount_sh


                     -- Акция - Вес Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END
                         ) :: TFloat AS AmountPartner_promo
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * MIContainer.Amount
                               ELSE 0
                          END
                         ) :: TFloat AS AmountPartner_promo_sh

                     -- Вес Продажа у покупателя
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_AmountPartner
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                                                      THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_AmountPartner_sh

                     -- Вес Возврат у покупателя
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_AmountPartner
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_AmountPartner_sh

                     -- Вес Скидка за вес - Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_10500
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_10500_sh

                     -- Вес потери - Разница в весе - Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_40200
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_40200_sh

                     -- Вес потери - Разница в весе - Возврат
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_Amount_40200
                     -- Шт.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_Amount_40200_sh


                     -- Акция - Сумма Продажи
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND MIFloat_PromoMovement.ValueData > 0 THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_promo
                     -- Сумма Продажи
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ
                     -- Сумма Возврат
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ

                     -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10200
                     -- Сумма Продажи - Скидка-акция
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10250
                     -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10300

                     -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ_10300
                     -- Сумма Возврат - ???цена Прайса ОПТ???
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ_10700

                     -- Акция - Сумма с/с Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * COALESCE (MIContainer.Amount, 0)
                               ELSE 0
                          END) :: TFloat AS Sale_SummCost_promo


                     -- Сумма с/с Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost
                     -- Сумма с/с Скидка за вес - Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost_10500
                     -- Сумма с/с потери - Разница в весе - Продажа
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() THEN      COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost_40200

                     -- Сумма с/с Возврат
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Return_SummCost
                     -- Сумма с/с потери - Разница в весе - Возврат
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Return_SummCost_40200


                     -- Затраты - Сумма бонус по условиям - нет
                   , 0 :: TFloat  AS BonusBasis
                     -- Затраты - Сумма бонус "ручные"
                   , 0 :: TFloat  AS Bonus

              FROM tmpAnalyzer
                   -- Проводки
                   INNER JOIN MovementItemContainer AS MIContainer
                                                    ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                 --AND MIContainer.OperDate   BETWEEN inStartDate AND inEndDate
                   -- Юр. Лицо
                   INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                  ON CLO_Juridical.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                   -- УП Статья назначения
                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                  ON CLO_InfoMoney.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                   -- Форма оплаты
                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                  ON CLO_PaidKind.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_PaidKind.DescId       = zc_ContainerLinkObject_PaidKind()
                   -- Договор
                   LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                 ON CLO_Contract.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                   -- Филиал - не из прводок
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                    ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId
                                                   AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                   -- Документ Акция - не из прводок
                   LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                               ON MIFloat_PromoMovement.MovementItemId = MIContainer.MovementItemId
                                              AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                   -- Документ
                   LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                   -- Вид Документа
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                   -- Товар
                   LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MIContainer.ObjectId_Analyzer
                   -- Вид Товара
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MIContainer.ObjectIntId_Analyzer

                   -- Ед.изм. Товара
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                   -- Вес Товара
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

              GROUP BY MIContainer.MovementId
                       --, tmpAnalyzer.AnalyzerId
                     , MIContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MIContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service()
                                 THEN MIContainer.ObjectId_Analyzer
                            ELSE MIContainer.ObjectExtId_Analyzer
                            --ELSE MovementLinkObject_Partner.ObjectId
                       END
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , MILinkObject_Branch.ObjectId
                     , CLO_Contract.ObjectId
                     , MIContainer.ObjectId_Analyzer
                     , Object_Goods.ObjectCode
                     , Object_Goods.ValueData
                     , MIContainer.ObjectIntId_Analyzer
                     , Object_GoodsKind.ObjectCode
                     , Object_GoodsKind.ValueData
                     , Object_Measure.ObjectCode
                     , Object_Measure.ValueData
                     , MIFloat_PromoMovement.ValueData

             UNION ALL
              -- Начисление Бонусов - Затраты
              SELECT -- Id Документа
                     MovementItemContainer.MovementId
                     --, 0 :: Integer AS AnalyzerId
                     -- Вид Документа
                   , MovementItemContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- Дата Документа
                   , MovementItemContainer.OperDate
                     -- Дата Документа
                   , Movement.OperDate AS OperDate_sklad
                     -- № Документа
                   , Movement.InvNumber

                     -- Юр. Лицо
                   , CLO_Juridical.ObjectId          AS JuridicalId
                   , 0                               AS PartnerId
                     -- УП Статья назначения
                   , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                     -- Форма оплаты - Договор продажи / Документ Начисления Бонус
                   , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                     -- Форма оплаты - Документ Начисления Бонус
                   , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                     -- Филиал
                   , 0                               AS BranchId
                     -- Договор продажи / Договор Начисления Бонус
                   , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                     -- Товар - нет
                   , 0  :: Integer  AS GoodsId
                   , 0  :: Integer  AS GoodsCode
                   , '' :: TVarChar AS GoodsName
                     -- Вид Товара - нет
                   , 0  :: Integer  AS GoodsKindId
                   , 0  :: Integer  AS GoodsKindCode
                   , '' :: TVarChar AS GoodsKindName
                     -- Ед.изм. Товара - нет
                   , 0  :: Integer  AS MeasureCode
                   , '' :: TVarChar AS MeasureName

                     -- Документ Акция - нет
                   , 0 :: Integer AS MovementId_promo
                     -- Признак Акция да/нет
                   , FALSE :: Boolean AS isPromo

                     -- Тип условия Бонус
                   , Object_ContractConditionKind.Id                      AS ContractConditionKindId
                   , Object_ContractConditionKind.ValueData               AS ContractConditionKindName
                     -- Вид бонуса
                   , Object_BonusKind.Id                                  AS BonusKindId
                   , Object_BonusKind.ValueData                           AS BonusKindName
                     -- % бонуса
                   , COALESCE (MIFloat_BonusValue.ValueData,0)  :: TFloat AS BonusTax

                     -- КОЛ-ВО Продажа - со склада
                   , 0 :: TFloat AS Sale_Amount
                   , 0 :: TFloat 
                     -- КОЛ-ВО Возврат - на склад
                   , 0 :: TFloat AS Return_Amount
                   , 0 :: TFloat 

                     -- Акция - КОЛ-ВО Продажа
                   , 0 :: TFloat AS AmountPartner_promo
                   , 0 :: TFloat 
                     -- КОЛ-ВО Продажа у покупателя
                   , 0 :: TFloat AS Sale_AmountPartner
                   , 0 :: TFloat 
                     -- КОЛ-ВО Возврат у покупателя
                   , 0 :: TFloat AS Return_AmountPartner
                   , 0 :: TFloat 

                     -- КОЛ-ВО Скидка за вес - Продажа
                   , 0 :: TFloat AS Sale_Amount_10500
                   , 0 :: TFloat 
                     -- КОЛ-ВО потери - Разница в весе - Продажа
                   , 0 :: TFloat AS Sale_Amount_40200
                   , 0 :: TFloat 
                     -- КОЛ-ВО потери - Разница в весе - Возврат
                   , 0 :: TFloat AS Return_Amount_40200
                   , 0 :: TFloat 

                     -- Акция - Сумма Продажи
                   , 0 :: TFloat AS Sale_Summ_promo
                     -- Сумма Продажи
                   , 0 :: TFloat AS Sale_Summ
                     -- Сумма Возврат
                   , 0 :: TFloat AS Return_Summ

                     -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
                   , 0 :: TFloat AS Sale_Summ_10200
                     -- Сумма Продажи - Скидка-акция
                   , 0 :: TFloat AS Sale_Summ_10250
                     -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
                   , 0 :: TFloat AS Sale_Summ_10300

                     -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
                   , 0 :: TFloat AS Return_Summ_10300
                     -- Сумма Возврат - ???цена Прайса ОПТ???
                   , 0 :: TFloat AS Return_Summ_10700

                     -- Акция - Сумма с/с Продажа
                   , 0 :: TFloat AS Sale_SummCost_promo
                     -- Сумма с/с Продажа
                   , 0 :: TFloat AS Sale_SummCost
                     -- Сумма с/с Скидка за вес - Продажа
                   , 0 :: TFloat AS Sale_SummCost_10500
                     -- Сумма с/с потери - Разница в весе - Продажа
                   , 0 :: TFloat AS Sale_SummCost_40200

                     -- Сумма с/с Возврат
                   , 0 :: TFloat AS Return_SummCost
                     -- Сумма с/с потери - Разница в весе - Возврат
                   , 0 :: TFloat AS Return_SummCost_40200

                     -- Затраты - Сумма бонус по условиям
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                  --THEN COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                                    THEN -1 * MovementItemContainer.Amount
                               ELSE 0
                          END) AS BonusBasis
                     -- Затраты - Сумма бонус "ручные"
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN 0
                             --ELSE COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                               ELSE -1 * MovementItemContainer.Amount
                          END) AS Bonus
              -- Документ
              FROM Movement
                   -- Проводки
                   INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                   AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                                                 --AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                   -- !!!Расходы будущих периодов + Услуги по маркетингу!!!
                   INNER JOIN Container ON Container.Id       = MovementItemContainer.ContainerId
                                       AND Container.ObjectId = zc_Enum_Account_50401()

                   -- Юр. Лицо - Документ Начисления Бонус
                   LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                   -- Форма оплаты - Документ Начисления Бонус
                   LEFT JOIN ContainerLinkObject AS CLO_PaidKind  ON CLO_PaidKind.ContainerId  = Container.Id AND CLO_PaidKind.DescId  = zc_ContainerLinkObject_PaidKind()
                   -- Договор - Документ Начисления Бонус
                   LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                   -- УП Статья назначения - Документ Начисления Бонус
                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                   -- Договор продажи
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                    ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                   AND MILinkObject_ContractChild.DescId         = zc_MILinkObject_ContractChild()
                   -- Форма оплаты - Договор продажи
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                        ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                       AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                   -- Автоматическое формирование
                   LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                             ON MovementBoolean_isLoad.MovementId = Movement.Id
                                            AND MovementBoolean_isLoad.DescId     = zc_MovementBoolean_isLoad()

                   -- Строка документа
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE

                   -- Тип условия Бонус
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                    ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_ContractConditionKind.DescId         = zc_MILinkObject_ContractConditionKind()
                   LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

                   -- Вид бонуса
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                    ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()
                   LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

                   -- % бонуса
                   LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                               ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_BonusValue.DescId         = zc_MIFloat_BonusValue()
                   -- Вид Документа
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

              WHERE Movement.DescId = zc_Movement_ProfitLossService()
              GROUP BY MovementItemContainer.MovementId
                     , MovementItemContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MovementItemContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , CLO_Contract.ObjectId
                     , MILinkObject_ContractChild.ObjectId
                     , Object_ContractConditionKind.Id
                     , Object_ContractConditionKind.ValueData
                     , Object_BonusKind.Id
                     , Object_BonusKind.ValueData
                     , MIFloat_BonusValue.ValueData
                     , ObjectLink_Contract_PaidKind.ChildObjectId

             -- Начисление Услуг - Затраты
             UNION ALL
              SELECT -- Id Документа
                     MovementItemContainer.MovementId
                     --, 0 :: Integer AS AnalyzerId
                     -- Вид Документа
                   , MovementItemContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- Дата Документа
                   , MovementItemContainer.OperDate
                     -- Дата Документа
                   , Movement.OperDate AS OperDate_sklad
                     -- № Документа
                   , Movement.InvNumber

                     -- Юр. Лицо
                   , CLO_Juridical.ObjectId          AS JuridicalId
                   , CLO_Partner.ObjectId            AS PartnerId
                     -- УП Статья назначения
                   , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                     -- Форма оплаты - Договор продажи / Документ Начисления Услуг
                   , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                     -- Форма оплаты - Документ Начисления Услуг
                   , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                     -- Филиал
                   , CLO_Branch.ObjectId             AS BranchId
                     -- Договор продажи / Договор Начисления Услуг
                   , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                     -- Товар - нет
                   , 0  :: Integer  AS GoodsId
                   , 0  :: Integer  AS GoodsCode
                   , '' :: TVarChar AS GoodsName
                     -- Вид Товара - нет
                   , 0  :: Integer  AS GoodsKindId
                   , 0  :: Integer  AS GoodsKindCode
                   , '' :: TVarChar AS GoodsKindName
                     -- Ед.изм. Товара - нет
                   , 0  :: Integer  AS MeasureCode
                   , '' :: TVarChar AS MeasureName

                     -- Документ Акция - нет
                   , 0 :: Integer AS MovementId_promo
                     -- Признак Акция да/нет
                   , FALSE :: Boolean AS isPromo

                     -- Тип условия Бонус
                   , Object_ContractConditionKind.Id                      AS ContractConditionKindId
                   , Object_ContractConditionKind.ValueData               AS ContractConditionKindName
                     -- Вид бонуса
                   , Object_BonusKind.Id                                  AS BonusKindId
                   , Object_BonusKind.ValueData                           AS BonusKindName
                     -- % бонуса
                   , COALESCE (MIFloat_BonusValue.ValueData,0)  :: TFloat AS BonusTax

                     -- КОЛ-ВО Продажа - со склада
                   , 0 :: TFloat AS Sale_Amount
                   , 0 :: TFloat 
                     -- КОЛ-ВО Возврат - на склад
                   , 0 :: TFloat AS Return_Amount
                   , 0 :: TFloat 

                     -- Акция - КОЛ-ВО Продажа
                   , 0 :: TFloat AS AmountPartner_promo
                   , 0 :: TFloat 
                     -- КОЛ-ВО Продажа у покупателя
                   , 0 :: TFloat AS Sale_AmountPartner
                   , 0 :: TFloat 
                     -- КОЛ-ВО Возврат у покупателя
                   , 0 :: TFloat AS Return_AmountPartner
                   , 0 :: TFloat 

                     -- КОЛ-ВО Скидка за вес - Продажа
                   , 0 :: TFloat AS Sale_Amount_10500
                   , 0 :: TFloat 
                     -- КОЛ-ВО потери - Разница в весе - Продажа
                   , 0 :: TFloat AS Sale_Amount_40200
                   , 0 :: TFloat 
                     -- КОЛ-ВО потери - Разница в весе - Возврат
                   , 0 :: TFloat AS Return_Amount_40200
                   , 0 :: TFloat 

                     -- Акция - Сумма Продажи
                   , 0 :: TFloat AS Sale_Summ_promo
                     -- Сумма Продажи
                   , 0 :: TFloat AS Sale_Summ
                     -- Сумма Возврат
                   , 0 :: TFloat AS Return_Summ

                     -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
                   , 0 :: TFloat AS Sale_Summ_10200
                     -- Сумма Продажи - Скидка-акция
                   , 0 :: TFloat AS Sale_Summ_10250
                     -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
                   , 0 :: TFloat AS Sale_Summ_10300

                     -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
                   , 0 :: TFloat AS Return_Summ_10300
                     -- Сумма Возврат - ???цена Прайса ОПТ???
                   , 0 :: TFloat AS Return_Summ_10700

                     -- Акция - Сумма с/с Продажа
                   , 0 :: TFloat AS Sale_SummCost_promo
                     -- Сумма с/с Продажа
                   , 0 :: TFloat AS Sale_SummCost
                     -- Сумма с/с Скидка за вес - Продажа
                   , 0 :: TFloat AS Sale_SummCost_10500
                     -- Сумма с/с потери - Разница в весе - Продажа
                   , 0 :: TFloat AS Sale_SummCost_40200

                     -- Сумма с/с Возврат
                   , 0 :: TFloat AS Return_SummCost
                     -- Сумма с/с потери - Разница в весе - Возврат
                   , 0 :: TFloat AS Return_SummCost_40200

                     -- Затраты - Сумма услуг по условиям
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN -1 * MovementItemContainer.Amount
                               ELSE 0
                          END) AS BonusBasis
                     -- Затраты - Сумма услуг "ручные"
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN 0
                               ELSE -1 * MovementItemContainer.Amount
                          END) AS Bonus

              -- Документ
              FROM Movement
                   -- Проводки
                   INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                   AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                                                 --AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                   -- !!! Услуги по маркетингу + Маркетинг
                   INNER JOIN Container ON Container.Id       = MovementItemContainer.ContainerId
                                       AND Container.ObjectId = zc_Enum_Account_70301()
                   -- Форма оплаты - Документ Начисления услуг - НАЛ
                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                 AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                 -- !!! только НАЛ!!!
                                                 AND CLO_PaidKind.ObjectId    = zc_Enum_PaidKind_SecondForm()

                   -- Юр. Лицо - Документ Начисления услуг
                   LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                   -- Договор - Документ Начисления услуг
                   LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                   -- УП Статья назначения - Документ Начисления услуг
                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                   --
                   LEFT JOIN ContainerLinkObject AS CLO_Partner   ON CLO_Partner.ContainerId   = Container.Id AND CLO_Partner.DescId   = zc_ContainerLinkObject_Partner()
                   --
                   LEFT JOIN ContainerLinkObject AS CLO_Branch    ON CLO_Branch.ContainerId    = Container.Id AND CLO_Branch.DescId    = zc_ContainerLinkObject_Branch()

                   -- Договор продажи
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                    ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                   AND MILinkObject_ContractChild.DescId         = zc_MILinkObject_ContractChild()
                   -- Форма оплаты - Договор продажи
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                        ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                       AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                   -- Автоматическое формирование
                   LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                             ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                            AND MovementBoolean_isLoad.DescId     = zc_MovementBoolean_isLoad()

                   -- Строка документа
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   -- Тип условия Бонус
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                    ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_ContractConditionKind.DescId         = zc_MILinkObject_ContractConditionKind()
                   LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

                   -- Вид бонуса
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                    ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()
                   LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

                   -- % бонуса
                   LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                               ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_BonusValue.DescId         = zc_MIFloat_BonusValue()

                   -- Вид Документа
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

              WHERE Movement.DescId = zc_Movement_ProfitLossService()
              GROUP BY MovementItemContainer.MovementId
                     , MovementItemContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MovementItemContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CLO_Partner.ObjectId
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , CLO_Contract.ObjectId
                     , CLO_Branch.ObjectId
                     , MILinkObject_ContractChild.ObjectId

                     , Object_ContractConditionKind.Id
                     , Object_ContractConditionKind.ValueData
                     , Object_BonusKind.Id
                     , Object_BonusKind.ValueData
                     , MIFloat_BonusValue.ValueData
                     , ObjectLink_Contract_PaidKind.ChildObjectId
        ;

ALTER TABLE _bi_Report_Sale_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Report_Sale_View WHERE OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE
