-- Таблица - Component_Plan

DO $$
BEGIN

/*
-- select count(*) from _bi_Table_Component_Plan
TRUNCATE TABLE _bi_Table_Component_Plan;
*/

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name ILIKE ('_bi_Table_Component_Plan')))
      THEN
           -- DROP TABLE _bi_Table_Component_Plan
           --
           CREATE TABLE _bi_Table_Component_Plan (
              Id              BIGSERIAL NOT NULL
              -- Id Документа
            , MovementId     Integer
              -- Дата Документа
            , OperDate       TDateTime

              -- Подразделение
            , UnitId         Integer
              -- Поставщик
            , PartnerId      Integer

              -- Товар ГП
            , GoodsId_gp       Integer
            , GoodsKindId_gp   Integer
            , MeasureId_gp     Integer
              -- УП Статья назначения
            , InfoMoneyId_gp   Integer
              -- Торговая марка
            , TradeMarkId_gp   Integer

              -- Товар
            , GoodsId          Integer
            , GoodsKindId      Integer
            , MeasureId        Integer
              -- УП Статья назначения
            , InfoMoneyId      Integer


              -- 1.1.Продано Покуп с РК - ГП
            , AmountSale_rk_sh        TFloat
            , AmountSale_rk           TFloat
              -- 1.2.Расход на филиалы с РК - ГП
            , AmountSendOnPrice_rk_sh TFloat
            , AmountSendOnPrice_rk    TFloat

              -- Приход ПФ-ГП - факт - ГП
            , Amount_prod_in_sh       TFloat
            , Amount_prod_in          TFloat

              -- Приход ПФ-ГП - Расчет - ГП
            , Amount_prod_in_calc_sh  TFloat
            , Amount_prod_in_calc     TFloat

              -- Расчет расх на производство - Компоненты
            , Amount_prod_out_calc    TFloat

              -- 2.1.ФАКТ расх на производство - Компоненты
            , Amount_prod_out         TFloat
              -- 2.2.ФАКТ Списание - Компоненты
            , Amount_loss             TFloat
              -- 2.3.ФАКТ Инвентаризация - Компоненты
            , Amount_inv              TFloat
              -- 2.4.ФАКТ Продажа - Компоненты
            , Amount_sale             TFloat

              -- приход от поставщ. - Компоненты
            , Amount_income           TFloat
            , Summ_income             TFloat

              --
            , CONSTRAINT pk_bi_Table_Component_Plan PRIMARY KEY (Id)
           );

          -- CREATE INDEX idx_bi_Table_Component_Plan_OperDate   ON _bi_Table_Component_Plan (OperDate);
          -- CREATE INDEX idx_bi_Table_Component_Plan_MovementId ON _bi_Table_Component_Plan (MovementId);

          GRANT ALL ON TABLE PUBLIC._bi_Table_Component_Plan TO admin;
          GRANT ALL ON TABLE PUBLIC._bi_Table_Component_Plan TO project;

      END IF;

END;
$$;
