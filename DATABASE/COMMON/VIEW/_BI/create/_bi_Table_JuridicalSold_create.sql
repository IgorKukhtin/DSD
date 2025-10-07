-- Таблица - Обороты по юр лицам

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_JuridicalSold
TRUNCATE TABLE _bi_Table_JuridicalSold;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_JuridicalSold')))
      THEN
           -- DROP TABLE _bi_Table_JuridicalSold
           --
           CREATE TABLE _bi_Table_JuridicalSold (
              Id             BIGSERIAL NOT NULL,
              -- Дата
              OperDate       TDateTime,
              -- Id партии
              ContainerId    Integer,
              -- Счет
              AccountId      Integer,
              -- Юр.л.
              JuridicalId    Integer,
              -- Контрагент
              PartnerId      Integer,
              -- Договор
              ContractId     Integer,
              -- ФО
              PaidKindId     Integer,
              -- УП статья
              InfoMoneyId    Integer,
              -- Филиал
              BranchId       Integer,
              -- Партионный учет
              PartionMovementId Integer,

              -- Начальный Долг Покупателя - Долг нам
              StartSumm_a     TFloat,
              -- Конечный Долг Покупателя - Долг нам
              EndSumm_a       TFloat,
              -- Начальный Долг Маркетинг - Долг мы
              StartSumm_p     TFloat,
              -- Конечный Долг Маркетинг - Долг мы
              EndSumm_p       TFloat,

              -- Debet
              DebetSumm       TFloat,
              -- Kredit
              KreditSumm      TFloat,

              -- Приход от поставщика - Долг мы
              IncomeSumm_p      TFloat,
              -- Возврат поставщику - Долг мы
              ReturnOutSumm_p   TFloat,

              -- Продажа (факт без уч. скидки) - Долг нам
              SaleRealSumm_total_a      TFloat,
              -- Возврат от пок. (факт без уч. скидки) - Долг нам
              ReturnInRealSumm_total_a  TFloat,
              -- Продажа (факт с уч. скидки) - Долг нам
              SaleRealSumm_a            TFloat,
              -- Возврат от пок. (факт с уч. скидки) - Долг нам
              ReturnInRealSumm_a        TFloat,

              -- Услуги факт оказан. - Долг нам
              ServiceRealSumm_a         TFloat,
              -- Услуги факт получ. - Долг мы
              ServiceRealSumm_p         TFloat,

              -- Оплата прих - Долг нам
              MoneySumm_a               TFloat,
              -- Оплата расх - Долг мы
              MoneySumm_p               TFloat,

              -- Корр. цены - Долг нам +
              PriceCorrectiveSumm_a     TFloat,
              -- Корр. цены - Долг мы  +
              PriceCorrectiveSumm_p     TFloat,

              -- Вз-зачет - Долг нам +
              SendDebtSumm_a            TFloat,
              -- Вз-зачет - Долг мы +
              SendDebtSumm_p            TFloat,

              -- Прочее - Долг нам +
              OthSumm_a                 TFloat,
              -- Прочее - Долг мы +
              OthSumm_p                 TFloat,

              -- Сумма для отсрочки
              SaleSumm_debt             TFloat,
              --
              CONSTRAINT pk_bi_Table_JuridicalSold PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_JuridicalSold_OperDate ON _bi_Table_JuridicalSold (OperDate
                                                                                     , ContractId
                                                                                      );
          -- 1.2.
          CREATE INDEX idx_bi_Table_JuridicalSold_OperDate_all ON _bi_Table_JuridicalSold (OperDate
                                                                                         , ContractId
                                                                                         , JuridicalId
                                                                                         , PartnerId
                                                                                         , PaidKindId
                                                                                         , InfoMoneyId
                                                                                         , BranchId
                                                                                         , AccountId
                                                                                          );
          -- 2.1.
          CREATE INDEX idx_bi_Table_JuridicalSold_ContractId  ON _bi_Table_JuridicalSold (ContractId
                                                                                        , OperDate
                                                                                         );
          -- 2.2.
          CREATE INDEX idx_bi_Table_JuridicalSold_ContractId_all ON _bi_Table_JuridicalSold (ContractId
                                                                                           , OperDate
                                                                                           , JuridicalId
                                                                                           , PartnerId
                                                                                           , PaidKindId
                                                                                           , InfoMoneyId
                                                                                           , BranchId
                                                                                           , AccountId
                                                                                          );

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO project;

      END IF;

END;
$$;
