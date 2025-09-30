-- Таблица - Отгрузка на Филиалы

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_SendBranch
TRUNCATE TABLE _bi_Table_SendBranch;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_SendBranch')))
      THEN
           -- DROP TABLE _bi_Table_SendBranch
           --
           CREATE TABLE _bi_Table_SendBranch (
              Id              BIGSERIAL NOT NULL,
              -- Id Документа
              MovementId     Integer,
              -- Дата Получатель
              OperDate       TDateTime,
              -- Дата Отправитель
              OperDate_sklad TDateTime,
              -- № Документа
              InvNumber        Integer,

              -- Подразделение - Филиал От кого
              UnitId_from    Integer,
              -- Подразделение - Филиал Кому
              UnitId_to      Integer,

              -- Товар
              GoodsId        Integer,
              -- Вид Товара
              GoodsKindId    Integer,

              -- Документ Заявка покупателя
              MovementId_order    Integer,

              -- Документ Акция
              MovementId_promo Integer,

              -- Вес Отправитель
              Amount         TFloat,
              -- Шт.
              Amount_sh      TFloat,

              -- Вес Получатель
              AmountPartner      TFloat,
              -- Шт.
              AmountPartner_sh   TFloat,

              -- Акция - Получатель
              AmountPartner_promo      TFloat,
              -- Шт.
              AmountPartner_promo_sh   TFloat,


              -- Сумма с НДС Получатель
              SummPartner             TFloat,
              -- Акция - Сумма с НДС Получатель
              SummPartner_promo       TFloat,

              --
              CONSTRAINT pk_bi_Table_SendBranch PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_SendBranch_OperDate ON _bi_Table_SendBranch (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_SendBranch TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_SendBranch TO project;

      END IF;

END;
$$;
