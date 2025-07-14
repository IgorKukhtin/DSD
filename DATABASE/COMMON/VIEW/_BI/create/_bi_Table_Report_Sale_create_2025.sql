-- Таблица - Продажа/Возврат

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Report_Sale_2025
TRUNCATE TABLE _bi_Table_Report_Sale_2025;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Report_Sale_2025')))
      THEN
           -- DROP TABLE _bi_Table_Report_Sale_2025
           --
           CREATE TABLE _bi_Table_Report_Sale_2025 (
              Id              BIGSERIAL NOT NULL,
              -- Id Документа
              MovementId     Integer,
              -- Вид Документа
              MovementDescId Integer,
              -- Дата покупателя
              OperDate       TDateTime,
              -- Дата Склад
              OperDate_sklad TDateTime,
              -- № Документа
              InvNumber      Integer,

              -- Юр. Лицо
              JuridicalId    Integer,
              -- Контрагент
              PartnerId      Integer,

              -- УП Статья назначения
              InfoMoneyId    Integer,
              -- Форма оплаты
              PaidKindId     Integer,
              -- Филиал
              BranchId       Integer,
              -- Договор
              ContractId     Integer,

              -- Товар
              GoodsId        Integer,
              -- Вид Товара
              GoodsKindId    Integer,


              -- Документ Заявка покупателя
              MovementId_order    Integer,

              -- Документ Акция
              MovementId_promo    Integer,


              -- Вес Продажа - со склада
              Sale_Amount         TFloat,
              -- Шт.
              Sale_Amount_sh      TFloat,

              -- Вес Возврат - на склад
              Return_Amount      TFloat,
              -- Шт.
              Return_Amount_sh   TFloat,


              -- Акция - Вес Продажа
              AmountPartner_promo      TFloat,
              -- Шт.
              AmountPartner_promo_sh   TFloat,

              -- Вес Продажа у покупателя
              Sale_AmountPartner       TFloat,
              -- Шт.
              Sale_AmountPartner_sh    TFloat,

              -- Вес Возврат у покупателя
              Return_AmountPartner     TFloat,
              -- Шт.
              Return_AmountPartner_sh  TFloat,

              -- Вес Скидка за вес - Продажа
              Sale_Amount_10500        TFloat,
              -- Шт.
              Sale_Amount_10500_sh     TFloat,

              -- Вес потери - Разница в весе - Продажа
              Sale_Amount_40200        TFloat,
              -- Шт.
              Sale_Amount_40200_sh     TFloat,

              -- Вес потери - Разница в весе - Возврат
              Return_Amount_40200      TFloat,
              -- Шт.
              Return_Amount_40200_sh   TFloat,


              -- Акция - Сумма Продажи
              Sale_Summ_promo       TFloat,
              -- Сумма Продажи
              Sale_Summ             TFloat,
              -- Сумма Возврат
              Return_Summ           TFloat,

              -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
              Sale_Summ_10200       TFloat,
              -- Сумма Продажи - Скидка-акция
              Sale_Summ_10250       TFloat,
              -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
              Sale_Summ_10300       TFloat,

              -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
              Return_Summ_10300     TFloat,

              -- Акция - Сумма с/с Продажа
              Sale_SummCost_promo   TFloat,


              -- Сумма с/с Продажа
              Sale_SummCost         TFloat,
              -- Сумма с/с Скидка за вес - Продажа
              Sale_SummCost_10500   TFloat,
              -- Сумма с/с потери - Разница в весе - Продажа
              Sale_SummCost_40200   TFloat,

              -- Сумма с/с Возврат
              Return_SummCost       TFloat,
              -- Сумма с/с потери - Разница в весе - Возврат
              Return_SummCost_40200 TFloat,

              --
              CONSTRAINT pk_bi_Table_Report_Sale_2025 PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Report_Sale_2025_OperDate ON _bi_Table_Report_Sale_2025 (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_Sale_2025 TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_Sale_2025 TO project;

      END IF;

END;
$$;
