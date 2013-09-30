-- !!! 
-- !!! Роли
-- !!! 

CREATE OR REPLACE FUNCTION zc_Enum_Role_Admin() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Role_Admin' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Типы оплат
-- !!! 

CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Статусы документов
-- !!! 

CREATE OR REPLACE FUNCTION zc_Enum_Status_UnComplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_UnComplete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Complete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Complete' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Status_Erased() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Status_Erased' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Типы счетов
-- !!! 

CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Active() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Active' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_Passive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_Passive' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_AccountKind_All() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountKind_All' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Типы маршрутов
-- !!! 
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_Internal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_Internal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_RouteKind_External() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_RouteKind_External' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Типы рабочего времени
-- !!! 
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Work()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Work'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Holiday()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Holiday'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Hospital() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Hospital' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Skip()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Skip'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_Trainee()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_Trainee'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_WorkTimeKind_DayOff()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_WorkTimeKind_DayOff'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!! 
-- !!! Баланс: 1-уровень Управленческих Счетов
-- !!! 
-- 10000; "Необоротные активы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "Денежные средства "
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Расходы будущих периодов"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "Прибыль будущих периодов"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "Кредитование"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "	"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_90000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_90000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100000; "Собственный капитал"
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_100000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_100000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Баланс: 2-уровень Управленческих Счетов
-- !!! 
-- 20000; "Запасы"; 20200; "на складах"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"; 20400; "на производстве"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"; 20500; "сотрудники (МО)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"; 20600; "сотрудники (экспедиторы)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Запасы"; 20900; "Оборотная тара"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_20900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_20900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30000; "Дебиторы"; 30100; "Покупатели"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30200; "Наши компании"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30300; "услуги предоставленные"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30400; "услуги предоставленные"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30500; "сотрудники (подотчетные лица)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30600; "сотрудники (подотчетные лица)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Дебиторы"; 30700; "векселя полученные"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_30700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_30700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 60000; "Прибыль будущих периодов"; 60100; "сотрудники (экспедиторы)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_60100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_60100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "Прибыль будущих периодов"; 60200; "на филиалах"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_60200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_60200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70000; "Кредиторы"; 70100; "Поставщики"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70200; "услуги полученные"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70300; "Маркетинг"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70400; "Коммунальные услуги
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70500; "Заработная плата
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70600; "сотрудники (заготовители)
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70700; "Административные ОС
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70800; "Производственные ОС
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 70900; "НМА
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_70900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_70900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Кредиторы"; 71000; "векселя выданные
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_71000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_71000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 90000; "Расчеты с бюджетом"; 90100; "Налоговые платежи"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "Расчеты с бюджетом"; 90200; "Налоговые платежи (прочие)"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "Расчеты с бюджетом"; 90300; "Налоговые платежи по ЗП"
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 90000; "Расчеты с бюджетом"; 90400; "штрафы в бюджет
CREATE OR REPLACE FUNCTION zc_Enum_AccountDirection_90400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountDirection_90400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! Баланс: Управленческие Счета (1+2+3 уровень)
-- !!! 
-- 20901; "Оборотная тара";
CREATE OR REPLACE FUNCTION zc_Enum_Account_20901() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_20901' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40101; "Касса"; 
CREATE OR REPLACE FUNCTION zc_Enum_Account_40101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40301; "Расчетный счет"; 
CREATE OR REPLACE FUNCTION zc_Enum_Account_40301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_40301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100301; "прибыль текущего периода"; 
CREATE OR REPLACE FUNCTION zc_Enum_Account_100301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Account_100301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!! 
-- !!! УП: 2-уровень Управленческих назначений
-- !!! 
-- 10000; "Основное сырье"; 10100; "Мясное сырье"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Основное сырье"; 10200; "Прочее сырье"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 20100; "Запчасти и Ремонты"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20200; "Прочие ТМЦ"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20300; "Прочие основные ср-ва"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20400; "ГСМ"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20500; "Оборотная тара"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20600; "Прочие материалы"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20700; "Товары"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20800; "Алан"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 20900; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_20900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_20900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 21000; "Чапли"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 21100; "Дворкин"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20000; "Общефирменные"; 21400; "услуги полученные"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 21500; "Маркетинг"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общефирменные"; 21600; "Коммунальные услуги"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_21600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_21600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 30000; "Доходы"; 30100; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Доходы"; 30200; "Мясное сырье"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Доходы"; 30300; "Переработка"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Доходы"; 30400; "услуги предоставленные"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Доходы"; 30500; "Прочие доходы"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_30500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_30500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 50000; "Расчеты с бюджетом"; 50100; "Налоговые платежи по ЗП"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Расчеты с бюджетом"; 50200; "Налоговые платежи"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Расчеты с бюджетом"; 50300; "Налоговые платежи (прочие)"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Расчеты с бюджетом"; 50400; "штрафы в бюджет"
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoneyDestination_50400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoneyDestination_50400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!! 
-- !!! УП: Управленческие Аналитики (1+2+3 уровень)
-- !!! 
-- 20401; "ГСМ";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_20401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_20401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 21201; "Коммандировочные";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_21201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_21201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80401; "прибыль текущего периода";
CREATE OR REPLACE FUNCTION zc_Enum_InfoMoney_80401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_InfoMoney_80401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


-- !!! 
-- !!! ОПиУ: 1-уровень (Группа ОПиУ)
-- !!! 
-- 10000; "Результат основной деятельности"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000; "Общепроизводственные расходы"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000; "Административные расходы"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000; "Расходы на сбыт"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 50000; "Налоги"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_50000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_50000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000; "Амортизация"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000; "Дополнительная прибыль"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000; "Расходы с прибыли"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLossGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLossGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! ОПиУ: 2-уровень (Аналитика ОПиУ - направление)
-- !!! 
-- 10100; "Сумма реализации"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10200; "Скидка за вес"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10300; "Скидка по акциям"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10400; "Скидка дополнительная"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10500; "Себестоимость реализации"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10700; "Сумма возвратов"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10700() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10700' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10800; "Себестоимость возвратов"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10800() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10800' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10900; "Утилизация возвратов"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_10900() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_10900' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 11100; "Маркетинг"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_11100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_11100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 20100; "Содержание производства"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20200; "Содержание складов"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20300; "Содержание транспорта"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20400; "Содержание Кухни"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20500; "Прочие потери (Списание+инвентаризация)"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20500() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20500' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20600; "Коммунальные услуги"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_20600() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_20600' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40100; "Содержание транспорта"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_40100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_40100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40200; "Содержание филиалов"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_40200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_40200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40300; "Общефирменные"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_40300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_40300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40400; "Прочие потери (Списание+инвентаризация)"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_40400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_40400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 70100; "Реализация нашим компаниям
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_70100() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_70100' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70200; "Прочее
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_70200() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_70200' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70300; "сотрудники (недостачи, порча)
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_70300() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_70300' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70400; "Списание кредиторской задолженности
CREATE OR REPLACE FUNCTION zc_Enum_ProfitDirection_70400() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitDirection_70400' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- !!! 
-- !!! ОПиУ: Статья (1+2+3 уровень)
-- !!! 
-- 10000; "Результат основной деятельности" 10100; "Сумма реализации" 10101; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10100; "Сумма реализации" 10102; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10102() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10102' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10200; "Скидка по акциям" 10201; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10201() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10201' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10200; "Скидка по акциям" 10202; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10202() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10202' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10300; "Скидка дополнительная" 10301; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10301() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10301' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10300; "Скидка дополнительная" 10301; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10302() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10302' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10400; Себестоимость реализации 10401; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10401() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10401' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10400; Себестоимость реализации 10402; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10402() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10402' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10500; "Скидка за вес" 10501; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10501() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10501' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10500; "Скидка за вес" 10502; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10502() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10502' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "Результат основной деятельности" 10700; "Сумма возвратов" 10701; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10701() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10701' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10700; "Сумма возвратов" 10702; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10702() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10702' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10800; "Себестоимость возвратов" 10801; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10801() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10801' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 10800; "Себестоимость возвратов" 10802; "Ирна"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10802() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10802' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 10000; "Результат основной деятельности" 10900; "Утилизация возвратов" 10901; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_10901() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_10901' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 10000; "Результат основной деятельности" 11100; "Маркетинг" 11101; "Продукция"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_11101() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_11101' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- 40000; "Расходы на сбыт" 40200; "Содержание филиалов" 40209; "Разница в весе"
CREATE OR REPLACE FUNCTION zc_Enum_ProfitLoss_40209() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_ProfitLoss_40209' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         * add  Типы рабочего времени
 30.09.13                                        * add zc_Enum_InfoMoney_21201
 27.09.13                                        * add zc_Enum_InfoMoney_20401
 26.09.13         * del zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter  
 25.09.13         * add zc_Enum_RateFuelKind_Summer, zc_Enum_RateFuelKind_Winter, zc_Enum_RouteKind_Internal, zc_Enum_RouteKind_External
 21.09.13                                        * add zc_Enum_InfoMoney_80401
 15.09.13                                        * add zc_Enum_AccountDirection_20900 and zc_Enum_Account_20901
 08.09.13                                        * add zc_Enum_ProfitLoss_1...
 07.09.13                                        * add zc_Enum_ProfitDirection_1... and zc_Enum_ProfitDirection_7...
 01.09.13                                        * add zc_Enum_ProfitDirection_4...
 26.08.13                                        * add ОПиУ
 25.08.13                                        * add zc_Enum_Account_100301
 21.08.13                        * add zc_Enum_Account_40101
 20.07.13                                        * add zc_Enum_AccountDirection_20200, 20400
 18.07.13                                        * add zc_Enum_AccountDirection_20500, 20600
 03.07.13                                        * add 2-уровень Управленческих Счетов
 02.07.13                                        * add 1-уровень Управленческих Счетов
 01.07.13                                        * add 2-уровень Управленческих назначений
 28.06.13                                        *
*/
