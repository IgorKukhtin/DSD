with tmpAll AS (
select floor ((Code :: Integer)  / 1000) * 1000 as code1
     , floor ((Code :: Integer)  / 100) * 100 as code2
     , code :: Integer as code3
     , Name1, Name2, Name3
from
(
 select '10101' as code, 'Запасы' as Name1, 'Магазины' as Name2, 'Товары' as Name3
union select '10102', 'Запасы', 'Магазины', 'Инвентарь'
union select '10201', 'Запасы', 'Склады', 'Товары'
union select '10202', 'Запасы', 'Склады', 'Инвентарь'
union select '20101', 'Дебиторы', 'покупатели ', 'Товары'
union select '20102', 'Дебиторы', 'покупатели ', 'Прибыль будущих периодов'
union select '20201', 'Дебиторы', 'Дебиторы по услугам', 'услуги предоставленные'
union select '20301', 'Дебиторы', 'Прочие дебиторы', 'Прочие доходы'
union select '30101', 'Денежные средства ', 'Касса', 'касса*****'
union select '30102', 'Денежные средства ', 'Касса', 'в валюте'
union select '30201', 'Денежные средства ', 'Касса магазинов', 'касса*****'
union select '30202', 'Денежные средства ', 'Касса магазинов', 'в валюте'
union select '30301', 'Денежные средства ', 'расчетный счет', 'расчетный счет*****'
union select '30302', 'Денежные средства ', 'расчетный счет', 'в валюте'
union select '40101', 'Необоротные активы', 'Административные ОС', 'Основные средства*****'
union select '40102', 'Необоротные активы', 'Административные ОС', 'Капитальный ремонт'
union select '40103', 'Необоротные активы', 'Административные ОС', 'Капитальное строительство'
union select '40104', 'Необоротные активы', 'Административные ОС', 'Капитальные инвестиции'
union select '40201', 'Необоротные активы', 'НМА', 'НМА'
union select '60101', 'Кредиторы', 'поставщики', 'Товары'
union select '60102', 'Кредиторы', 'поставщики', 'Инвентарь'
union select '60201', 'Кредиторы', 'Сотрудники', 'Заработная плата'
union select '60301', 'Кредиторы', 'Кредиторы по услугам', 'услуги полученные'
union select '60401', 'Кредиторы', 'Коммунальные услуги', 'Коммунальные услуги'
union select '60501', 'Кредиторы', 'Административные ОС', 'Капитальный ремонт'
union select '60502', 'Кредиторы', 'Административные ОС', 'Капитальное строительство'
union select '60503', 'Кредиторы', 'Административные ОС', 'Капитальные инвестиции'
union select '70101', 'Кредитование', 'Кредиты банков', 'Кредиты банков'
union select '70201', 'Кредитование', 'Прочие кредиты', 'Прочие кредиты'
union select '70301', 'Кредитование', 'проценты по кредитам', 'проценты по кредитам'
union select '80101', 'Расчеты с бюджетом', 'Налоговые платежи', 'Налоговые платежи'
union select '80201', 'Расчеты с бюджетом', 'Налоговые платежи (прочие)', 'Налоговые платежи (прочие)'
union select '80301', 'Расчеты с бюджетом', 'Налоговые платежи по ЗП', 'Налоговые платежи по ЗП'
union select '80401', 'Расчеты с бюджетом', 'штрафы в бюджет', 'штрафы в бюджет'
union select '100101', 'Собственный капитал', 'Первоначальный капитал', 'Первоначальный капитал'
union select '100201', 'Собственный капитал', 'Дополнительный капитал', 'Дополнительный капитал'
union select '100301', 'Собственный капитал', 'Прибыль текущего периода', 'Прибыль текущего периода*****'
union select '100401', 'Собственный капитал', 'Расчеты с участниками', 'Расчеты с участниками'
union select '100501', 'Собственный капитал', 'Прибыль накопленная', 'Прибыль накопленная*****'
) as tmp
)

, tmpAccountGroup AS (select distinct Name1, Code1  from tmpAll order by 2)
, tmpAccountDirection AS (select distinct Name2, Code2 from tmpAll order by 2)

-- 3 - Account
select gpInsertUpdate_Object_Account        ((Select Id from Object WHERE DescId = zc_Object_Account() and ObjectCode = Code3)
                                           , Code3 :: Integer
                                           , Name3
                                           , (Select Id from Object WHERE DescId = zc_Object_AccountGroup() and ObjectCode = Code1)    --  AccountGroupId
                                           , (Select Id from Object WHERE DescId = zc_Object_AccountDirection() and ObjectCode = Code2) --  AccountDirectionId
                                           , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) -- InfoMoneyDestinationId
                                           , 0
                                           , zfCalc_UserAdmin()
                                            )
from (-- 1 - AccountGroup
      with tmp1 AS (select gpInsertUpdate_Object_AccountGroup ((Select Id from Object WHERE DescId = zc_Object_AccountGroup() and ValueData = Name1)
                                                              , Code1 :: Integer
                                                              , Name1
                                                              , zfCalc_UserAdmin()
                                                               ) AS Id
                   from tmpAccountGroup as tmp
                   
                   union all
                   -- 2 - AccountDirection
                   select gpInsertUpdate_Object_AccountDirection
                                                               ((Select Id from Object WHERE DescId = zc_Object_AccountDirection() and ObjectCode = Code2)
                                                              , Code2 :: Integer
                                                              , Name2
                                                              , zfCalc_UserAdmin()
                                                               ) AS Id
                   from tmpAccountDirection as tmp
                 )
          , tmp2 AS (SELECT * FROM tmpAll CROSS JOIN (SELECT MAX (Id) AS MAX_Id FROM tmp1) AS tmp_max)
      select Name1, Name2, Name3, Code1, Code2, Code3
           -- , (Select Id from Object WHERE DescId = zc_Object_AccountGroup() and ObjectCode = Code1) AS AccountGroupId
           -- , (Select Id from Object WHERE DescId = zc_Object_AccountDirection() and ObjectCode = Code2) AS AccountDirectionId
           -- , (Select Id from Object WHERE DescId = zc_Object_InfoMoneyDestination() and ValueData = Name3) AS InfoMoneyDestinationId
      from tmp2
      
      order by Code3
     ) as tmp
-- where 1=0
;
