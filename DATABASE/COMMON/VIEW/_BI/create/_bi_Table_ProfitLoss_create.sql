-- Таблица - Отчет о Прибылях и убытках

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_ProfitLoss
TRUNCATE TABLE _bi_Table_ProfitLoss;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_ProfitLoss')))
      THEN
           -- DROP TABLE _bi_Table_ProfitLoss
           --
           CREATE TABLE _bi_Table_ProfitLoss (
              Id                  BIGSERIAL NOT NULL,
              -- Id партии        
              ContainerId_pl      Integer,
              -- Дата             
              OperDate            TDateTime,
              -- Id документа
              MovementId          Integer,
              -- Вид документа
              MovementDescId      Integer,
              -- № документа      
              InvNumber           Integer,
              -- Примечание документ
              MovementId_comment  Integer,
                                  
              -- Статья ОПиУ      
              ProfitLossId        Integer,
              -- Бизнес
              BusinessId         Integer,

              -- Филиал затрат (Філія)
              BranchId_pl         Integer,
              -- Подразделение затрат (Підрозділ)
              UnitId_pl           Integer,

              -- Статья УП        
              InfoMoneyId         Integer,

              -- Подразделение учета (Місце обліку)
              UnitId              Integer,
              -- Оборудование (Направление затрат)
              AssetId             Integer,
              -- Автомобиль (Направление затрат, место учета)
              CarId               Integer,
              -- Физ лицо
              MemberId            Integer,
              -- Статья списания (Стаття списання, Направление затрат)
              ArticleLossId       Integer,
              
              -- Об'єкт напрявлення
              DirectionId         Integer,
              -- Об'єкт призначення
              DestinationId       Integer,

              -- От кого (место учета) - информативно
              FromId              Integer,
              -- Кому (место учета, Направление затрат) - информативно
              ToId                Integer,

              -- Товар
              GoodsId    Integer,
              -- Вид Товара
              GoodsKindId         Integer,
              -- Вид Товара (только при производстве сырой ПФ)
              GoodsKindId_gp      Integer,

              -- Кол-во (вес)
              OperCount           TFloat,
              -- Кол-во (шт.)
              OperCount_sh        TFloat,
              -- Сумма
              OperSumm            TFloat,

              CONSTRAINT pk_bi_Table_ProfitLoss PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_ProfitLoss_OperDate ON _bi_Table_ProfitLoss (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_ProfitLoss TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_ProfitLoss TO project;

      END IF;

END;
$$;
