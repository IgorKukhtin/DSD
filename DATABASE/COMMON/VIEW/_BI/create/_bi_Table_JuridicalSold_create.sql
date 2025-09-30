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
              --
              ContainerId    Integer,
              -- Юр.л.
              JuridicalId    Integer,
              -- Контрагент
              PartnerId      Integer,
              -- Филиал
              BranchId       Integer,
              -- Договор
              ContractId     Integer,
              -- ФО
              PaidKindId     Integer,
              -- УП статья
              InfoMoneyId    Integer,
              -- Счет
              AccountId      Integer,

              -- Начальный Долг Покупателя
              StartSumm       TFloat,
              -- Конечный Долг Покупателя
              EndSumm         TFloat,
              -- Debet
              DebetSumm       TFloat,
              -- Kredit
              KreditSumm      TFloat,

              -- Продажа (факт без уч. скидки)
              SaleRealSumm_total      TFloat,
              -- Возврат от пок. (факт без уч. скидки)
              ReturnInRealSumm_total  TFloat,
              -- Продажа (факт с уч. скидки)
              SaleRealSumm            TFloat,
              -- Возврат от пок. (факт с уч. скидки)
              ReturnInRealSumm        TFloat,
              -- Оплата (+)прих (-)расх.
              MoneySumm               TFloat,
              -- Корр. цены (+)доход (-)расх.
              PriceCorrectiveSumm     TFloat,
              -- Вз-зачет (+)опл.прих. (-)опл.расх.
              SendDebtSumm            TFloat,
              -- Проочее
              OthSumm                 TFloat,
              --
              CONSTRAINT pk_bi_Table_JuridicalSold PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_JuridicalSold_OperDate ON _bi_Table_JuridicalSold (OperDate);

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalSold TO project;

      END IF;

END;
$$;
