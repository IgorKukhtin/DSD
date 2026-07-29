DO $$
BEGIN

-- *** 1 - '01.01.2025' AND '31.01.2025'
INSERT INTO _bi_Table_Report_Sale_2025
            (
              -- Id Документа
              MovementId     ,
              -- Вид Документа
              MovementDescId ,
              -- Дата покупателя
              OperDate       ,
              -- Дата Склад
              OperDate_sklad ,
              -- № Документа
              InvNumber      ,

              -- Юр. Лицо
              JuridicalId    ,
              -- Контрагент
              PartnerId      ,

              -- УП Статья назначения
              InfoMoneyId    ,
              -- Форма оплаты
              PaidKindId     ,
              -- Филиал
              BranchId       ,
              -- Договор
              ContractId     ,

              -- Товар
              GoodsId        ,
              -- Вид Товара
              GoodsKindId    ,


              -- Документ Заявка покупателя
              MovementId_order    ,

              -- Документ Акция
              MovementId_promo    ,
              -- NotBudg
              isNotBudg           ,
              PromoId_NotBudg     ,


              -- Вес Продажа - со склада
              Sale_Amount         ,
              -- Шт.
              Sale_Amount_sh      ,

              -- Вес Возврат - на склад
              Return_Amount      ,
              -- Шт.
              Return_Amount_sh   ,


              -- Акция - Вес Продажа
              AmountPartner_promo      ,
              -- Шт.
              AmountPartner_promo_sh   ,

              -- Акция - NotBudg
              Amount_promo_NotBudg     ,
              -- Шт.
              Amount_promo_sh_NotBudg  ,

              -- Вес Продажа у покупателя
              Sale_AmountPartner       ,
              -- Шт.
              Sale_AmountPartner_sh    ,

              -- Вес Возврат у покупателя
              Return_AmountPartner     ,
              -- Шт.
              Return_AmountPartner_sh  ,

              -- Вес Скидка за вес - Продажа
              Sale_Amount_10500        ,
              -- Шт.
              Sale_Amount_10500_sh     ,

              -- Вес потери - Разница в весе - Продажа
              Sale_Amount_40200        ,
              -- Шт.
              Sale_Amount_40200_sh     ,

              -- Вес потери - Разница в весе - Возврат
              Return_Amount_40200      ,
              -- Шт.
              Return_Amount_40200_sh   ,


              -- Акция - Сумма Продажи
              Sale_Summ_promo       ,
              -- Акция - NotBudg
              Summ_promo_NotBudg    ,
              -- Сумма Продажи
              Sale_Summ             ,
              -- Сумма Возврат
              Return_Summ           ,

              -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
              Sale_Summ_10200       ,
              -- Сумма Продажи - Скидка-акция
              Sale_Summ_10250       ,
              -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
              Sale_Summ_10300       ,

              -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
              Return_Summ_10300     ,

              -- Акция - Сумма с/с Продажа
              Sale_SummCost_promo   ,
              -- Акция - Сумма с/с NotBudg
              SummCost_promo_NotBudg,

              -- Сумма с/с Продажа
              Sale_SummCost         ,
              -- Сумма с/с Скидка за вес - Продажа
              Sale_SummCost_10500   ,
              -- Сумма с/с потери - Разница в весе - Продажа
              Sale_SummCost_40200   ,

              -- Сумма с/с Возврат
              Return_SummCost       ,
              -- Сумма с/с потери - Разница в весе - Возврат
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- Вид Документа
              MovementDescId ,
              -- Дата покупателя
              OperDate       ,
              -- Дата Склад
              OperDate_sklad ,
              -- № Документа
              zfConvert_StringToNumber (InvNumber),

              -- Юр. Лицо
              JuridicalId    ,
              -- Контрагент
              PartnerId      ,

              -- УП Статья назначения
              InfoMoneyId    ,
              -- Форма оплаты
              PaidKindId     ,
              -- Филиал
              BranchId       ,
              -- Договор
              ContractId     ,

              -- Товар
              GoodsId        ,
              -- Вид Товара
              GoodsKindId    ,


              -- Документ Заявка покупателя
              MovementId_order    ,

              -- Документ Акция
              MovementId_promo    ,
              -- NotBudg
              isNotBudg           ,
              PromoId_NotBudg     ,


              -- Вес Продажа - со склада
              Sale_Amount         ,
              -- Шт.
              Sale_Amount_sh      ,

              -- Вес Возврат - на склад
              Return_Amount      ,
              -- Шт.
              Return_Amount_sh   ,


              -- Акция - Вес Продажа
              AmountPartner_promo      ,
              -- Шт.
              AmountPartner_promo_sh   ,

              -- Акция - NotBudg
              Amount_promo_NotBudg     ,
              -- Шт.
              Amount_promo_sh_NotBudg  ,

              -- Вес Продажа у покупателя
              Sale_AmountPartner       ,
              -- Шт.
              Sale_AmountPartner_sh    ,

              -- Вес Возврат у покупателя
              Return_AmountPartner     ,
              -- Шт.
              Return_AmountPartner_sh  ,

              -- Вес Скидка за вес - Продажа
              Sale_Amount_10500        ,
              -- Шт.
              Sale_Amount_10500_sh     ,

              -- Вес потери - Разница в весе - Продажа
              Sale_Amount_40200        ,
              -- Шт.
              Sale_Amount_40200_sh     ,

              -- Вес потери - Разница в весе - Возврат
              Return_Amount_40200      ,
              -- Шт.
              Return_Amount_40200_sh   ,


              -- Акция - Сумма Продажи
              Sale_Summ_promo       ,
              -- Акция - NotBudg
              Summ_promo_NotBudg    ,
              -- Сумма Продажи
              Sale_Summ             ,
              -- Сумма Возврат
              Return_Summ           ,

              -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
              Sale_Summ_10200       ,
              -- Сумма Продажи - Скидка-акция
              Sale_Summ_10250       ,
              -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
              Sale_Summ_10300       ,

              -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
              Return_Summ_10300     ,

              -- Акция - Сумма с/с Продажа
              Sale_SummCost_promo   ,
              -- Акция - Сумма с/с NotBudg
              SummCost_promo_NotBudg,

              -- Сумма с/с Продажа
              Sale_SummCost         ,
              -- Сумма с/с Скидка за вес - Продажа
              Sale_SummCost_10500   ,
              -- Сумма с/с потери - Разница в весе - Продажа
              Sale_SummCost_40200   ,

              -- Сумма с/с Возврат
              Return_SummCost       ,
              -- Сумма с/с потери - Разница в весе - Возврат
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.01.2025' AND '31.01.2025'
;


END;
$$;
