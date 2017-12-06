with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code, 'Результат основной деятельности' as Name1, 'Сумма по ценам прайса' as Name2, 'Сумма по ценам прайса' as Name3
union select '10201', 'Результат основной деятельности', 'Скидка', 'Сезонная скидка'
union select '10202', 'Результат основной деятельности', 'Скидка', 'Скидка outlet'
union select '10203', 'Результат основной деятельности', 'Скидка', 'Скидка клиента'
union select '10204', 'Результат основной деятельности', 'Скидка', 'Скидка дополнительная'
union select '10301', 'Результат основной деятельности', 'Себестоимость реализации', 'Себестоимость реализации'
union select '10401', 'Результат основной деятельности', 'Прибыль от реализации', 'Прибыль от реализации'
union select '10501', 'Результат основной деятельности', 'Сумма возвратов', 'Сумма возвратов'
union select '10601', 'Результат основной деятельности', 'Себестоимость возвратов', 'Себестоимость возвратов'
union select '10701', 'Результат основной деятельности', 'Прибыль основной деятельности', 'Прибыль основной деятельности'
union select '20101', 'Административные расходы', 'Содержание админ', 'Заработная плата'
union select '20102', 'Административные расходы', 'Содержание админ', 'Коммунальные услуги'
union select '20103', 'Административные расходы', 'Содержание админ', 'услуги полученные'
union select '20104', 'Административные расходы', 'Содержание админ', 'Командировочные'
union select '20105', 'Административные расходы', 'Содержание админ', 'Инвентарь'
union select '20106', 'Административные расходы', 'Содержание админ', 'Прочие ТМЦ'
union select '20107', 'Административные расходы', 'Содержание админ', 'МНМА'
union select '20108', 'Административные расходы', 'Содержание админ', 'ГСМ'
union select '30101', 'Расходы по магазинам', 'Содержание магазины', 'Заработная плата'
union select '30102', 'Расходы по магазинам', 'Содержание магазины', 'Коммунальные услуги'
union select '30103', 'Расходы по магазинам', 'Содержание магазины', 'услуги полученные'
union select '30104', 'Расходы по магазинам', 'Содержание магазины', 'Командировочные'
union select '30105', 'Расходы по магазинам', 'Содержание магазины', 'Инвентарь'
union select '30106', 'Расходы по магазинам', 'Содержание магазины', 'Прочие ТМЦ'
union select '30107', 'Расходы по магазинам', 'Содержание магазины', 'МНМА'
union select '30108', 'Расходы по магазинам', 'Содержание магазины', 'ГСМ'
union select '40101', 'Налоги', 'Налог на прибыль', 'Налог на прибыль'
union select '40201', 'Налоги', 'НДС', 'НДС'
union select '40301', 'Налоги', 'Налоговые платежи (прочие)', 'Налоговые платежи (прочие)'
union select '40401', 'Налоги', 'Налоговые платежи по ЗП', 'Налоговые платежи по ЗП'
union select '40501', 'Налоги', 'штрафы в бюджет*', 'штрафы в бюджет*'
union select '50101', 'Дополнительная прибыль', 'Прочие доходы', 'Прочие доходы'
union select '50201', 'Дополнительная прибыль', 'услуги предоставленные', 'услуги предоставленные'
union select '50301', 'Дополнительная прибыль', 'Реализация по с/с', 'Сумма по ценам прайса'
union select '50302', 'Дополнительная прибыль', 'Реализация по с/с', 'Скидка'
union select '50303', 'Дополнительная прибыль', 'Реализация по с/с', 'Себестоимость реализации'
union select '50401', 'Дополнительная прибыль', 'Возвраты по с/с', 'Сумма возвратов'
union select '50402', 'Дополнительная прибыль', 'Возвраты по с/с', 'Себестоимость возвратов'
union select '60101', 'Расходы с прибыли', 'Финансовая деятельность', 'проценты по кредитам'
union select '60102', 'Расходы с прибыли', 'Финансовая деятельность', 'Прочее'
union select '60201', 'Расходы с прибыли', 'Курсовая разница', 'Запасы'
union select '60202', 'Расходы с прибыли', 'Курсовая разница', 'Кредиторы'
union select '60203', 'Расходы с прибыли', 'Курсовая разница', 'Дебиторы'
union select '60204', 'Расходы с прибыли', 'Курсовая разница', 'Р/сч'
union select '60205', 'Расходы с прибыли', 'Курсовая разница', 'Касса'
union select '60301', 'Расходы с прибыли', 'Списание задолженности', 'Покупатели'
union select '60302', 'Расходы с прибыли', 'Списание задолженности', 'Поставщики'
union select '60401', 'Расходы с прибыли', 'Прочие', 'Прочее'
union select '70101', 'Чистая прибыль', 'Чистая прибыль', 'Чистая прибыль'
) as tmp
)

, tmpProfitLossGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpProfitLossDirection AS (select distinct Name2, Code2 from tmpAll order by 2)


-- 3 - ProfitLoss
select gpInsertUpdate_Object_ProfitLoss     ((Select Id from Object WHERE DescId = zc_Object_ProfitLoss() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , (Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ObjectCode = Code1) -- ProfitLossGroupId
                                           , (Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2) -- ProfitLossDirectionId
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) -- InfoMoneyDestinationId
                                           , 0
                                           , zfCalc_UserAdmin()
                                            )
from (-- 1 - ProfitLossGroup
      with tmp1 AS (select gpInsertUpdate_Object_ProfitLossGroup ((Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ValueData = Name1)
                                                                    , Code1 :: Integer
                                                                    , Name1
                                                                    , zfCalc_UserAdmin()
                                                                     ) AS Id
                         from tmpProfitLossGroup as tmp
                         
                         union all
                         -- 2 - ProfitLossDirection
                         select gpInsertUpdate_Object_ProfitLossDirection
                                                                     ((Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2)
                                                                    , Code2 :: Integer
                                                                    , Name2
                                                                    , zfCalc_UserAdmin()
                                                                     ) AS Id
                         from tmpProfitLossDirection as tmp
                        )
          , tmp2 AS (SELECT * FROM tmpAll CROSS JOIN (SELECT MAX (Id) AS MAX_Id FROM tmp1) AS tmp_max)
          select Name1, Name2, Name3, Code1, Code2, Code3
           -- , (Select Id from Object WHERE DescId = zc_Object_ProfitLossGroup() and ObjectCode = Code1) AS ProfitLossGroupId
           -- , (Select Id from Object WHERE DescId = zc_Object_ProfitLossDirection() and ObjectCode = Code2) AS ProfitLossDirectionId
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) AS InfoMoneyDestinationId
      from tmp2
      order by Code3
     ) as tmp
;
