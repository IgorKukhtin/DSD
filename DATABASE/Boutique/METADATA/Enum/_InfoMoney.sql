with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code , 'Доходы' as Name1, 'Товары' as Name2, 'Одежда' as Name3
union select '10102', 'Доходы', 'Товары', 'Обувь'
union select '10103', 'Доходы', 'Товары', 'Аксессуары'
union select '10201', 'Доходы', 'Прочие доходы', 'Прочие доходы'
union select '10301', 'Доходы', 'услуги предоставленные', 'услуги предоставленные'
union select '20101', 'Общефирменные', 'Инвентарь', 'Инвентарь'
union select '20201', 'Общефирменные', 'Прочие ТМЦ', '***Канц товары'
union select '20202', 'Общефирменные', 'Прочие ТМЦ', '***Прочие ТМЦ'
union select '20301', 'Общефирменные', 'МНМА', '***Мебель'
union select '20302', 'Общефирменные', 'МНМА', '***Комп. и оргтехника'
union select '20303', 'Общефирменные', 'МНМА', '***Быт. техника'
union select '20304', 'Общефирменные', 'МНМА', '***Специнвентарь'
union select '20305', 'Общефирменные', 'МНМА', '***Прочие МНМА'
union select '20401', 'Общефирменные', 'ГСМ', 'ГСМ'
union select '20501', 'Общефирменные', 'Командировочные', '***Командировочные'
union select '20601', 'Общефирменные', 'услуги полученные', '***Комп. и оргтехника'
union select '20602', 'Общефирменные', 'услуги полученные', '***Строительные'
union select '20603', 'Общефирменные', 'услуги полученные', '***Услуги связи'
union select '20604', 'Общефирменные', 'услуги полученные', 'Услуги банка'
union select '20605', 'Общефирменные', 'услуги полученные', '***Аренда помещений'
union select '20606', 'Общефирменные', 'услуги полученные', 'Юридические, нотариальные'
union select '20607', 'Общефирменные', 'услуги полученные', '***Прочие услуги, работы'
union select '20608', 'Общефирменные', 'услуги полученные', '***Реклама'
union select '20609', 'Общефирменные', 'услуги полученные', 'Услуги гос.служб'
union select '20701', 'Общефирменные', 'Коммунальные услуги', 'Электроэнергия'
union select '20702', 'Общефирменные', 'Коммунальные услуги', 'Вода'
union select '20703', 'Общефирменные', 'Коммунальные услуги', 'Газ'
union select '20704', 'Общефирменные', 'Коммунальные услуги', 'вывоз ТБО'
union select '30101', 'Финансовая деятельность', 'Кредиты банков', 'Кредиты банков'
union select '30201', 'Финансовая деятельность', 'Прочие кредиты', 'Прочие кредиты'
union select '30301', 'Финансовая деятельность', 'проценты по кредитам', '% по кредитам банков'
union select '30302', 'Финансовая деятельность', 'проценты по кредитам', '% по прочим кредитам'
union select '30303', 'Финансовая деятельность', 'проценты по кредитам', '% по овердрафту'
union select '30401', 'Финансовая деятельность', 'Ссуды', 'Ссуды'
union select '30402', 'Финансовая деятельность', 'Ссуды', '% по ссудам'
union select '30501', 'Финансовая деятельность', 'Депозиты', 'Депозиты'
union select '30502', 'Финансовая деятельность', 'Депозиты', '% по депозитам'
union select '30601', 'Финансовая деятельность', 'Внутренний оборот', 'Внутренний оборот'
union select '40101', 'Расчеты с бюджетом', 'Налоговые платежи по ЗП', 'Отчисления'
union select '40102', 'Расчеты с бюджетом', 'Налоговые платежи по ЗП', 'Начисления'
union select '40201', 'Расчеты с бюджетом', 'Налоговые платежи', 'Налог на прибыль'
union select '40202', 'Расчеты с бюджетом', 'Налоговые платежи', 'НДС'
union select '40301', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Коммунальный налог'
union select '40302', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Загрязнение окр.среды'
union select '40303', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Налог на воду'
union select '40304', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Налог на землю'
union select '40305', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Аренда земли'
union select '40306', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'НДФЛ сторонний'
union select '40401', 'Расчеты с бюджетом', 'штрафы в бюджет', 'штрафы в бюджет'
union select '50101', 'Заработная плата', 'Заработная плата', 'Заработная плата'
union select '60101', 'Инвестиции', 'Капитальные инвестиции', 'Дома и сооружения'
union select '60102', 'Инвестиции', 'Капитальные инвестиции', 'Торговое оборудование'
union select '60103', 'Инвестиции', 'Капитальные инвестиции', 'Автомобили'
union select '60201', 'Инвестиции', 'Капитальный ремонт', 'Дома и сооружения'
union select '60202', 'Инвестиции', 'Капитальный ремонт', 'Торговое оборудование'
union select '60203', 'Инвестиции', 'Капитальный ремонт', 'Автомобили'
union select '60301', 'Инвестиции', 'Капитальное строительство', 'Капитальное строительство'
union select '60401', 'Инвестиции', 'НМА', 'НМА'
union select '80101', 'Собственный капитал', 'Первоначальный капитал', 'Первоначальный капитал'
union select '80201', 'Собственный капитал', 'Дополнительный капитал', 'Дополнительный капитал'
union select '80301', 'Собственный капитал', 'Расчеты с участниками', '*1'
union select '80302', 'Собственный капитал', 'Расчеты с участниками', '*2'
union select '80303', 'Собственный капитал', 'Расчеты с участниками', '*3'
union select '80304', 'Собственный капитал', 'Расчеты с участниками', '*4'
union select '80401', 'Собственный капитал', 'прибыль текущего периода', 'прибыль текущего периода'
union select '80501', 'Собственный капитал', 'Прочие', 'Расходы с прибыли'
union select '80502', 'Собственный капитал', 'Прочие', 'Расходы учредителей'
) as tmp
)

, tmpInfoMoneyGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpInfoMoneyDestination AS (select distinct Name2, Code2 from tmpAll order by 2)

-- 3 - InfoMoney
select gpInsertUpdate_Object_InfoMoney      ((Select Id from Object WHERE DescId = zc_Object_InfoMoney() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ObjectCode = Code1) -- InfoMoneyGroupId
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2) --  InfoMoneyDestinationId
                                           , FALSE
                                           , zfCalc_UserAdmin()
                                            )
from (-- 1 - InfoMoneyGroup
      with tmp1 AS (select gpInsertUpdate_Object_InfoMoneyGroup ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ValueData = Name1)
                                                               , Code1 :: Integer
                                                               , Name1
                                                               , zfCalc_UserAdmin()
                                                                ) AS Id
                    from tmpInfoMoneyGroup as tmp
                    
                    union all
                    -- 2 - InfoMoneyDestination
                    select gpInsertUpdate_Object_InfoMoneyDestination
                                                                ((Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2)
                                                               , Code2 :: Integer
                                                               , Name2
                                                               , zfCalc_UserAdmin()
                                                                ) AS Id
                    from tmpInfoMoneyDestination as tmp
                   )
          , tmp2 AS (SELECT * FROM tmpAll CROSS JOIN (SELECT MAX (Id) AS MAX_Id FROM tmp1) AS tmp_max)
      select Name1, Name2, Name3, Code1, Code2, Code3
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyGroup() and ObjectCode = Code1) AS InfoMoneyGroupId
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ObjectCode = Code2) AS InfoMoneyDestinationId
      from tmp2
      order by Code3
     ) as tmp
;
