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
              -- Вид документа - _bi_Guide_MovementDesc_View
              MovementDescId      Integer,
              -- № документа      
              InvNumber           Integer,
              -- Примечание документ - _bi_Guide_MovementComment_View
              MovementId_comment  Integer,
                                  
              -- Статья ОПиУ - _bi_Guide_ProfitLoss_View
              ProfitLossId        Integer,
              -- Бизнес - _bi_Guide_Object_View
              BusinessId         Integer,

              -- Филиал затрат (Філія) - _bi_Guide_Branch_View
              BranchId_pl         Integer,
              -- Подразделение затрат (Підрозділ) - _bi_Guide_Unit_View
              UnitId_pl           Integer,

              -- Статья УП - _bi_Guide_InfoMoney_View
              InfoMoneyId         Integer,

              -- Подразделение учета (Місце обліку) - _bi_Guide_Unit_View
              UnitId              Integer,
              -- Оборудование (Направление затрат) - _bi_Guide_Asset_View
              AssetId             Integer,
              -- Автомобиль (Направление затрат, место учета) - _bi_Guide_Car_View
              CarId               Integer,
              -- Физ лицо - _bi_Guide_Member_View
              MemberId            Integer,
              -- Статья списания (Стаття списання, Направление затрат) - _bi_Guide_ArticleLoss_View
              ArticleLossId       Integer,
              
              -- Об'єкт напрявлення - _bi_Guide_Object_View
              DirectionId         Integer,
              -- Об'єкт призначення - _bi_Guide_Object_View
              DestinationId       Integer,

              -- От кого (место учета) - информативно - _bi_Guide_Object_View
              FromId              Integer,
              -- Кому (место учета, Направление затрат) - информативно - _bi_Guide_Object_View
              ToId                Integer,

              -- Товар - _bi_Guide_Goods_View
              GoodsId             Integer,
              -- Вид Товара - _bi_Guide_GoodsKind_View
              GoodsKindId         Integer,
              -- Вид Товара (только при производстве сырой ПФ) - _bi_Guide_GoodsKind_View
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
