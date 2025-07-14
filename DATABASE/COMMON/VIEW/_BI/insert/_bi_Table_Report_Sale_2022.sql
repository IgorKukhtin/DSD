DO $$
BEGIN

-- *** 1 - '01.01.2022' AND '28.02.2022'
INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.01.2022' AND '28.02.2022'
;


-- *** 2 - '01.03.2022' AND '30.04.2022'
  INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.03.2022' AND '30.04.2022'
;


-- *** 3 - '01.05.2022' AND '30.06.2022'
  INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.05.2022' AND '30.06.2022'
;


-- *** 4 - '01.07.2022' AND '31.08.2022'
  INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.07.2022' AND '31.08.2022'
;


-- *** 5 - '01.09.2022' AND '31.10.2022'
  INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.09.2022' AND '31.10.2022'
;

-- *** 6 - '01.11.2022' AND '31.12.2022'
  INSERT INTO _bi_Table_Report_Sale
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

WHERE OperDate BETWEEN '01.11.2022' AND '31.12.2022'
;

END;
$$;
