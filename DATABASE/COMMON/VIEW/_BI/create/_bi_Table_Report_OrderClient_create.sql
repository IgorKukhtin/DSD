-- Таблица - Заявки покупателей

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Report_OrderClient
TRUNCATE TABLE _bi_Table_Report_OrderClient;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Report_OrderClient')))
      THEN
           -- DROP TABLE _bi_Table_Report_OrderClient
           --
           CREATE TABLE _bi_Table_Report_OrderClient (
              Id              BIGSERIAL NOT NULL,
              -- Id Документа
              MovementId     Integer,
              -- Вид Документа
              MovementDescId Integer,
              -- Дата покупателя
              OperDate       TDateTime,
              -- Дата Склад
              OperDate_sklad TDateTime,
              -- Дата Заявки
              OperDate_order TDateTime,
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

              -- Документ Акция
              MovementId_promo    Integer,


              -- Вес Заказ ИТОГО
              Amount         TFloat,
              -- Шт.
              Amount_sh      TFloat,

              -- Вес Заказ
              AmountFirst      TFloat,
              -- Шт.
              AmountFirst_sh   TFloat,

              -- Вес дозаказ
              AmountSecond      TFloat,
              -- Шт.
              AmountSecond_sh   TFloat,

              -- Акция - Заказ ИТОГО
              Amount_promo      TFloat,
              -- Шт.
              Amount_promo_sh   TFloat,


              -- Сумма с НДС Заказ ИТОГО
              Summ             TFloat,
              -- Акция - Сумма с НДС ИТОГО
              Summ_promo       TFloat,

              --
              CONSTRAINT pk_bi_Table_Report_OrderClient PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Report_OrderClient_OperDate ON _bi_Table_Report_OrderClient (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_OrderClient TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Report_OrderClient TO project;

      END IF;

END;
$$;
