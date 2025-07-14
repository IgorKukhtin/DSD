-- Таблица - Остатки

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Remains
TRUNCATE TABLE _bi_Table_Remains;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Remains')))
      THEN
           -- DROP TABLE _bi_Table_Remains
           --
           CREATE TABLE _bi_Table_Remains (
              Id             BIGSERIAL NOT NULL,
              -- Дата + время остатков
              OperDate       TDateTime,
              -- Подразделение
              UnitId         Integer,
              -- Товар
              GoodsId        Integer,
              -- Вид Товара
              GoodsKindId    Integer,
              -- Партия Товара
              PartionId      Integer,
              -- Партия Товара - дата
              PartionDate    TDateTime,

              -- Вес Остатки
              Amount         TFloat,
              -- Шт. Остатки
              Amount_sh      TFloat,

              -- Сумма с/с
              SummCost         TFloat,
              -- Сумма по ценам прайса
              SummPriceList         TFloat,

              --
              CONSTRAINT pk_bi_Table_Remains PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Remains_OperDate ON _bi_Table_Remains (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Remains TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Remains TO project;

      END IF;

END;
$$;
