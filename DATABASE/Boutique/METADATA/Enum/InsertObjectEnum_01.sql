
DO $$
BEGIN
     -- !!! Типы аналитик для проводок
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10100(), inDescId:= zc_Object_AnalyzerId(), inCode:= 101, inName:= 'Кол-во, реализация',                       inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10100');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10100(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 111, inName:= 'Сумма, реализация (по прайсу)',            inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10100');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10201(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 121, inName:= 'Сумма, реализация, сезонная скидка',       inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10201');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10202(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 122, inName:= 'Сумма, реализация, скидка outlet',         inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10202');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10203(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 123, inName:= 'Сумма, реализация, скидка клиента',        inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10203');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10204(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 124, inName:= 'Сумма, реализация, Скидка дополнительная', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10204');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 131, inName:= 'Сумма с/с, реализация ',                   inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10300');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnCount_10500(), inDescId:= zc_Object_AnalyzerId(), inCode:= 201, inName:= 'Кол-во, возврат',                        inEnumName:= 'zc_Enum_AnalyzerId_ReturnCount_10500');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnSumm_10501(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 211, inName:= 'Сумма, возврат (по прайсу)',             inEnumName:= 'zc_Enum_AnalyzerId_ReturnSumm_10501');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnSumm_10502(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 212, inName:= 'Сумма, возврат, скидка',                 inEnumName:= 'zc_Enum_AnalyzerId_ReturnSumm_10502');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnSumm_10600(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 231, inName:= 'Сумма с/с, возврат',                     inEnumName:= 'zc_Enum_AnalyzerId_ReturnSumm_10600');
END $$;


DO $$
BEGIN
     -- !!! Типы счетов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активный', inEnumName:= 'zc_Enum_AccountKind_Active');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Passive(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Пассивный', inEnumName:= 'zc_Enum_AccountKind_Passive');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_All(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активно/Пассивный', inEnumName:= 'zc_Enum_AccountKind_All');
END $$;

DO $$
BEGIN
 -- !!! Виды скидок клиента
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Var(), inDescId:= zc_Object_DiscountKind(), inCode:= 1, inName:= 'По накопительной системе' , inEnumName:= 'zc_Enum_DiscountKind_Var');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Const(), inDescId:= zc_Object_DiscountKind(), inCode:= 3, inName:= 'Постоянная скидка' , inEnumName:= 'zc_Enum_DiscountKind_Const');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountKind_Not(), inDescId:= zc_Object_DiscountKind(), inCode:= 2, inName:= 'Нет скидки' , inEnumName:= 'zc_Enum_DiscountKind_Not');
 -- !!! Статусы документов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= 'Не проведен', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(), inName:= 'Проведен', inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(), inName:= 'Удален', inEnumName:= 'zc_Enum_Status_Erased');
END $$;

DO $$
BEGIN
 -- !!! Виды скидок в продаже
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountSaleKind_Period(), inDescId:= zc_Object_DiscountSaleKind(), inCode:= 1, inName:= 'сезонная скидка' , inEnumName:= 'zc_Enum_DiscountSaleKind_Period');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountSaleKind_Client(), inDescId:= zc_Object_DiscountSaleKind(), inCode:= 3, inName:= 'скидка клиента' , inEnumName:= 'zc_Enum_DiscountSaleKind_Client');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DiscountSaleKind_Outlet(), inDescId:= zc_Object_DiscountSaleKind(), inCode:= 2, inName:= 'скидка outlet' , inEnumName:= 'zc_Enum_DiscountSaleKind_Outlet');
END $$;


DO $$
BEGIN
     -- !!!
     -- !!! Баланс: 1-уровень Управленческих Счетов
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 70000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_70000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000,  inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_80000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100000, inDescId:= zc_Object_AccountGroup(), inEnumName:= 'zc_Enum_AccountGroup_100000');

-- 10000 Запасы
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_10000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_10000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 20000 Дебиторы
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_20000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_20000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 30000 Денежные средства
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_30000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_30000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 40000 Необоротные активы
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_40000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_40000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 60000 Кредиторы
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_60000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_60000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 70000 Кредитование
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_70000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_70000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 80000 Расчеты с бюджетом
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_80000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_80000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- 100000 Собственный капитал
CREATE OR REPLACE FUNCTION zc_Enum_AccountGroup_100000() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_AccountGroup_100000' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

     -- !!!
     -- !!! Баланс: 2-уровень Управленческих Счетов
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_10200');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_20300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60100,  inDescId:= zc_Object_AccountDirection(), inEnumName:= 'zc_Enum_AccountDirection_60100');

     -- !!!
     -- !!! Баланс: Управленческие Счета (1+2+3 уровень)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20101,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_20101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20102,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_20102');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30101,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30102,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30201,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30202,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30301,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30301');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30302,  inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_30302');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 100301, inDescId:= zc_Object_Account(), inEnumName:= 'zc_Enum_Account_100301');



     -- !!!
     -- !!! УП: 1-уровень Управленческие группы назначения
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_30000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 40000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_40000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 50000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_50000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 60000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_60000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80000, inDescId:= zc_Object_InfoMoneyGroup(), inEnumName:= 'zc_Enum_InfoMoneyGroup_80000');
     
     -- !!!
     -- !!! УП: 2-уровень Управленческие назначения
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_10300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20100, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20200, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20300, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20300');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20400, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20400');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20500, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20500');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20600, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20600');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20700, inDescId:= zc_Object_InfoMoneyDestination(), inEnumName:= 'zc_Enum_InfoMoneyDestination_20700');

     -- !!!
     -- !!! УП: Управленческие статьи назначения (1+2+3 уровень)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10102, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10102');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10103, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_10103');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20101, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_20101');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 80401, inDescId:= zc_Object_InfoMoney(), inEnumName:= 'zc_Enum_InfoMoney_80401');


     -- !!!
     -- !!! ОПиУ: 1-уровень (Группа ОПиУ)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_10000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 20000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_20000');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30000, inDescId:= zc_Object_ProfitLossGroup(), inEnumName:= 'zc_Enum_ProfitLossGroup_30000');


     -- !!!
     -- !!! ОПиУ: 2-уровень (Аналитика ОПиУ - направление)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10200');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10300, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_10300');

     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30100, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30100');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 30200, inDescId:= zc_Object_ProfitLossDirection(), inEnumName:= 'zc_Enum_ProfitLossDirection_30200');

     -- !!!
     -- !!! ОПиУ: Статья (1+2+3 уровень)
     -- !!!
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10101, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10101');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10201, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10201');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10202, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10202');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10203, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10203');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10204, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10204');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10301, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10301');
     
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10501, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10501');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10502, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10502');
     PERFORM lpUpdate_Object_Enum_byCode (inCode:= 10601, inDescId:= zc_Object_ProfitLoss(), inEnumName:= 'zc_Enum_ProfitLoss_10601');
END $$;


/*
DO $$

Эта ф-ция НЕ нужна
BEGIN
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ConnectParam(),  inDescId:= zc_Object_GlobalConst(), inCode:= 1, inName:= 'http://localhost/boutique/index.php', inEnumName:= 'zc_Enum_GlobalConst_ConnectParam');
END $$;
*/
