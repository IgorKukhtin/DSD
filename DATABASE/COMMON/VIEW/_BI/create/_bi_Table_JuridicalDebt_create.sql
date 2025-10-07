-- Таблица - Долги отсрочка по юр лицам

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_JuridicalDebt
TRUNCATE TABLE _bi_Table_JuridicalDebt;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_JuridicalDebt')))
      THEN
           -- DROP TABLE _bi_Table_JuridicalDebt
           --
           CREATE TABLE _bi_Table_JuridicalDebt (
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

              -- Начальный Долг Покупателя
              StartSumm        TFloat,
              -- Начальный Долг Покупателя с отсрочкой
              StartSumm_debt   TFloat,
              -- Продажа
              SaleSumm         TFloat,

              -- Просроченный долг за 1-7 дней
              Summ_debt_7     TFloat,
              -- Просроченный долг за 8-14 дней
              Summ_debt_14     TFloat,
              -- Просроченный долг за 15-21 дней
              Summ_debt_21     TFloat,
              -- Просроченный долг за 22-28 дней
              Summ_debt_28     TFloat,
              -- Просроченный долг за 29 и более дней
              Summ_debt_28_add TFloat,

              -- начальная дата просроченного долга
              StartDate_debt   TDateTime,
              -- Дней отсрочки
              DayCount         Integer,
              -- условие отсрочки
              ConditionKindId  Integer,

              CONSTRAINT pk_bi_Table_JuridicalDebt PRIMARY KEY (Id)
           );

          -- 1.1.
          CREATE INDEX idx_bi_Table_JuridicalDebt_OperDate ON _bi_Table_JuridicalDebt (OperDate
                                                                                     , ContractId
                                                                                      );

          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalDebt TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_JuridicalDebt TO project;

      END IF;

END;
$$;
