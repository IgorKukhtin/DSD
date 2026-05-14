-- Function: gpInsert_bi_Table_Component_Plan(tdatetime, tdatetime, tvarchar)

-- DROP FUNCTION gpInsert_bi_Table_Component_Plan(tdatetime, tdatetime, tvarchar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_Component_Plan(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_Component_Plan WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- Заливка - выбранный месяц - 2025 год
      INSERT INTO _bi_Table_Component_Plan
                    (
                      -- Id Документа
                      MovementId
                      -- Дата Документа
                    , OperDate

                      -- Подразделение
                    , UnitId
                      -- Поставщик
                    , PartnerId

                      -- Товар ГП
                    , GoodsId_gp
                    , GoodsKindId_gp
                    , MeasureId_gp
                      -- УП Статья назначения
                    , InfoMoneyId_gp
                      -- Торговая марка
                    , TradeMarkId_gp

                      -- Товар - Компоненты
                    , GoodsId
                    , GoodsKindId
                    , MeasureId
                      -- УП Статья назначения
                    , InfoMoneyId


                      -- 1.1.Продано Покуп с РК - ГП
                    , AmountSale_rk_sh
                    , AmountSale_rk
                      -- 1.2.Расход на филиалы с РК - ГП
                    , AmountSendOnPrice_rk_sh
                    , AmountSendOnPrice_rk

                      -- Приход ПФ-ГП - факт - ГП
                    , Amount_prod_in_sh
                    , Amount_prod_in

                      -- Приход ПФ-ГП - Расчет - ГП
                    , Amount_prod_in_calc_sh
                    , Amount_prod_in_calc

                      -- Расчет расх на производство - Компоненты
                    , Amount_prod_out_calc

                      -- 2.1.ФАКТ расх на производство - Компоненты
                    , Amount_prod_out
                      -- 2.2.ФАКТ Списание - Компоненты
                    , Amount_loss
                      -- 2.3.ФАКТ Инвентаризация - Компоненты
                    , Amount_inv
                      -- 2.4.ФАКТ Продажа - Компоненты
                    , Amount_sale

                      -- приход от поставщ. - Компоненты
                    , Amount_income
                    , Summ_income
                     )

            SELECT MovementId
                   -- Дата Документа
                 , OperDate

                  -- Подразделение
                 , UnitId
                   -- Поставщик
                 , PartnerInId

                   -- Товар ГП
                 , GoodsId_gp
                 , GoodsKindId_gp
                 , MeasureId_gp
                   -- УП Статья назначения
                 , InfoMoneyId_gp
                   -- Торговая марка
                 , TradeMarkId_gp

                   -- Товар - Компоненты
                 , GoodsId
                 , GoodsKindId
                 , MeasureId
                   -- УП Статья назначения
                 , InfoMoneyId


                   -- 1.1.Продано Покуп с РК - ГП
                 , AmountSale_rk_sh
                 , AmountSale_rk
                   -- 1.2.Расход на филиалы с РК - ГП
                 , AmountSendOnPrice_rk_sh
                 , AmountSendOnPrice_rk

                   -- Приход ПФ-ГП - факт - ГП
                 , Amount_prod_in_sh
                 , Amount_prod_in

                   -- Приход ПФ-ГП - Расчет - ГП
                 , Amount_prod_in_calc_sh
                 , Amount_prod_in_calc

                   -- Расчет расх на производство - Компоненты
                 , Amount_prod_out_calc

                   -- 2.1.ФАКТ расх на производство - Компоненты
                 , Amount_prod_out
                   -- 2.2.ФАКТ Списание - Компоненты
                 , Amount_loss
                   -- 2.3.ФАКТ Инвентаризация - Компоненты
                 , Amount_inv
                   -- 2.4.ФАКТ Продажа - Компоненты
                 , Amount_sale

                   -- приход от поставщ. - Компоненты
                 , Amount_income
                 , Summ_income

            FROM (SELECT *
                  FROM gpReport_Component_Plan_Olap (inStartDate          := inStartDate
                                                   , inEndDate            := inEndDate
                                                   , inGoodsGroupId       := 0
                                                   , inInfoMoneyId        := 0
                                                   , inSession            := zfCalc_UserAdmin()
                                                    ) AS tmpReport
                 ) AS tmpReport
           ;

  -- Протокол
  INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        SELECT inSession :: Integer AS UserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , 0 AS Value1
             , 0 AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - CURRENT_TIMESTAMP) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО
             , NULL AS Time2
               -- сколько всего выполнялась проц
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpInsert_bi_Table_Component_Plan'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
   || ' - ' || zfConvert_DateToString (inEndDate)
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-- тест
-- DELETE FROM  _bi_Table_Component_Plan WHERE OperDate between '20.07.2025' and '20.07.2025'
-- SELECT OperDate, sum(AmountSale_rk), sum(AmountSendOnPrice_rk)  FROM _bi_Table_Component_Planwhere OperDate between '01.04.2026' and '01.04.2026' GROUP BY OperDate ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_Component_Plan (inStartDate:= '01.04.2026', inEndDate:= '30.04.2026', inSession:= zfCalc_UserAdmin())
