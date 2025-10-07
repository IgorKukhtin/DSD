-- Таблица - Заявки Филиалов

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_OrderBranch
TRUNCATE TABLE _bi_Table_OrderBranch;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_OrderBranch')))
      THEN
           -- DROP TABLE _bi_Table_OrderBranch
           --
           CREATE TABLE _bi_Table_OrderBranch (
              Id              BIGSERIAL NOT NULL,
              -- Id Документа
              MovementId     Integer,
              -- Дата Филиал
              OperDate       TDateTime,
              -- Дата Склад
              OperDate_sklad TDateTime,
              -- Дата Заявки
              OperDate_order TDateTime,
              -- № Документа
              InvNumber        Integer,

              -- Подразделение - Филиал От кого
              UnitId_from    Integer,
              -- Подразделение - Филиал Кому - Днепр
              UnitId_to      Integer,

              -- Примечание
              Comment        TVarChar,
              Comment_car    TVarChar,

              -- Товар
              GoodsId        Integer,
              -- Вид Товара
              GoodsKindId    Integer,

              -- Документ Акция
              MovementId_promo Integer,

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
              CONSTRAINT pk_bi_Table_OrderBranch PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_OrderBranch_OperDate ON _bi_Table_OrderBranch (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_OrderBranch TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_OrderBranch TO project;

      END IF;

END;
$$;
