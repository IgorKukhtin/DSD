-- Function: gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar)

-- DROP FUNCTION gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar);

CREATE OR REPLACE FUNCTION gpinsert_bi_table_sale(
    instartdate tdatetime,
    inenddate tdatetime,
    insession tvarchar)
  RETURNS void AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_Report_Sale_2025 WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- Заливка - выбранный месяц - 2025 год
      INSERT INTO _bi_Table_Report_Sale_2025
                    (
                      -- Id Документа
                      MovementId     ,
                      -- Вид Документа
                      MovementDescId ,
                      -- Дата покупателя
                      OperDate       ,
                      -- Дата Склад
                      OperDate_sklad ,
                      -- № Документа
                      InvNumber      ,

                      -- Юр. Лицо
                      JuridicalId    ,
                      -- Контрагент
                      PartnerId      ,

                      -- УП Статья назначения
                      InfoMoneyId    ,
                      -- Форма оплаты
                      PaidKindId     ,
                      -- Филиал
                      BranchId       ,
                      -- Договор
                      ContractId     ,

                      -- Товар
                      GoodsId        ,
                      -- Вид Товара
                      GoodsKindId    ,


                      -- Документ Заявка покупателя
                      MovementId_order    ,

                      -- Документ Акция
                      MovementId_promo    ,


                      -- Вес Продажа - со склада
                      Sale_Amount         ,
                      -- Шт.
                      Sale_Amount_sh      ,

                      -- Вес Возврат - на склад
                      Return_Amount      ,
                      -- Шт.
                      Return_Amount_sh   ,


                      -- Акция - Вес Продажа
                      AmountPartner_promo      ,
                      -- Шт.
                      AmountPartner_promo_sh   ,

                      -- Вес Продажа у покупателя
                      Sale_AmountPartner       ,
                      -- Шт.
                      Sale_AmountPartner_sh    ,

                      -- Вес Возврат у покупателя
                      Return_AmountPartner     ,
                      -- Шт.
                      Return_AmountPartner_sh  ,

                      -- Вес Скидка за вес - Продажа
                      Sale_Amount_10500        ,
                      -- Шт.
                      Sale_Amount_10500_sh     ,

                      -- Вес потери - Разница в весе - Продажа
                      Sale_Amount_40200        ,
                      -- Шт.
                      Sale_Amount_40200_sh     ,

                      -- Вес потери - Разница в весе - Возврат
                      Return_Amount_40200      ,
                      -- Шт.
                      Return_Amount_40200_sh   ,


                      -- Акция - Сумма Продажи
                      Sale_Summ_promo       ,
                      -- Сумма Продажи
                      Sale_Summ             ,
                      -- Сумма Возврат
                      Return_Summ           ,

                      -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
                      Sale_Summ_10200       ,
                      -- Сумма Продажи - Скидка-акция
                      Sale_Summ_10250       ,
                      -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
                      Sale_Summ_10300       ,

                      -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
                      Return_Summ_10300     ,

                      -- Акция - Сумма с/с Продажа
                      Sale_SummCost_promo   ,


                      -- Сумма с/с Продажа
                      Sale_SummCost         ,
                      -- Сумма с/с Скидка за вес - Продажа
                      Sale_SummCost_10500   ,
                      -- Сумма с/с потери - Разница в весе - Продажа
                      Sale_SummCost_40200   ,

                      -- Сумма с/с Возврат
                      Return_SummCost       ,
                      -- Сумма с/с потери - Разница в весе - Возврат
                      Return_SummCost_40200
                     )

            SELECT MovementId     ,
                   -- Вид Документа
                   MovementDescId ,
                   -- Дата покупателя
                   OperDate       ,
                   -- Дата Склад
                   OperDate_sklad ,
                   -- № Документа
                   zfConvert_StringToNumber (InvNumber),

                   -- Юр. Лицо
                   JuridicalId    ,
                   -- Контрагент
                   PartnerId      ,

                   -- УП Статья назначения
                   InfoMoneyId    ,
                   -- Форма оплаты
                   PaidKindId     ,
                   -- Филиал
                   BranchId       ,
                   -- Договор
                   ContractId     ,

                   -- Товар
                   GoodsId        ,
                   -- Вид Товара
                   GoodsKindId    ,


                   -- Документ Заявка покупателя
                   MovementId_order    ,

                   -- Документ Акция
                   MovementId_promo    ,


                   -- Вес Продажа - со склада
                   Sale_Amount         ,
                   -- Шт.
                   Sale_Amount_sh      ,

                   -- Вес Возврат - на склад
                   Return_Amount      ,
                   -- Шт.
                   Return_Amount_sh   ,


                   -- Акция - Вес Продажа
                   AmountPartner_promo      ,
                   -- Шт.
                   AmountPartner_promo_sh   ,

                   -- Вес Продажа у покупателя
                   Sale_AmountPartner       ,
                   -- Шт.
                   Sale_AmountPartner_sh    ,

                   -- Вес Возврат у покупателя
                   Return_AmountPartner     ,
                   -- Шт.
                   Return_AmountPartner_sh  ,

                   -- Вес Скидка за вес - Продажа
                   Sale_Amount_10500        ,
                   -- Шт.
                   Sale_Amount_10500_sh     ,

                   -- Вес потери - Разница в весе - Продажа
                   Sale_Amount_40200        ,
                   -- Шт.
                   Sale_Amount_40200_sh     ,

                   -- Вес потери - Разница в весе - Возврат
                   Return_Amount_40200      ,
                   -- Шт.
                   Return_Amount_40200_sh   ,


                   -- Акция - Сумма Продажи
                   Sale_Summ_promo       ,
                   -- Сумма Продажи
                   Sale_Summ             ,
                   -- Сумма Возврат
                   Return_Summ           ,

                   -- Сумма Продажи - разница от цены Прайса ОПТ (скидка-виртуальная)
                   Sale_Summ_10200       ,
                   -- Сумма Продажи - Скидка-акция
                   Sale_Summ_10250       ,
                   -- Сумма Продажи - Скидка-дополнительная (% и т.п.)
                   Sale_Summ_10300       ,

                   -- Сумма Возврат - Скидка-дополнительная (% и т.п.)
                   Return_Summ_10300     ,

                   -- Акция - Сумма с/с Продажа
                   Sale_SummCost_promo   ,


                   -- Сумма с/с Продажа
                   Sale_SummCost         ,
                   -- Сумма с/с Скидка за вес - Продажа
                   Sale_SummCost_10500   ,
                   -- Сумма с/с потери - Разница в весе - Продажа
                   Sale_SummCost_40200   ,

                   -- Сумма с/с Возврат
                   Return_SummCost       ,
                   -- Сумма с/с потери - Разница в весе - Возврат
                   Return_SummCost_40200

            FROM _bi_Report_Sale_View
            WHERE OperDate BETWEEN inStartDate AND inEndDate
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
             , 'gpInsert_bi_Table_Sale'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
   || ' - ' || zfConvert_DateToString (inEndDate)
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar)
  OWNER TO project;
