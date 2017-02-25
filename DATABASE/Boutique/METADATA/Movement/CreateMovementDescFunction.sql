
CREATE OR REPLACE FUNCTION zc_Movement_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Income', 'Приход от поставщика' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Income');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnOut', 'Возврат поставщику' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut');

CREATE OR REPLACE FUNCTION zc_Movement_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Send', 'Перемещение' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Send');

CREATE OR REPLACE FUNCTION zc_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Sale', 'Продажа' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Sale');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnIn', 'Возврат от покупателя' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn');

CREATE OR REPLACE FUNCTION zc_Movement_Loss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Loss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Loss', 'Списание' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Loss');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionUnion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionUnion', 'Пересортица' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion');

CREATE OR REPLACE FUNCTION zc_Movement_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Inventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Inventory', 'Инвентаризация' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Inventory');

CREATE OR REPLACE FUNCTION zc_Movement_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Cash', 'Касса, приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Cash');

CREATE OR REPLACE FUNCTION zc_Movement_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankAccount', 'Расчетный счет, приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatement', 'Выписка банка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatementItem', 'Элемент выписки банка' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem');

CREATE OR REPLACE FUNCTION zc_Movement_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Service', 'Начисления услуг по Юридическому лицу' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Service');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalService', 'Начисление зарплаты' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalReport', 'Авансовый отчет' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport');

CREATE OR REPLACE FUNCTION zc_Movement_LossDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LossDebt', 'Списание задолженности' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt');

CREATE OR REPLACE FUNCTION zc_Movement_SendDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendDebt', 'Взаимозачет (Юридические лица)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt');

CREATE OR REPLACE FUNCTION zc_Movement_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Currency', 'Курсовая разница' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Currency');

CREATE OR REPLACE FUNCTION zc_Movement_FounderService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_FounderService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_FounderService', 'Начисления учредителям' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_FounderService');

CREATE OR REPLACE FUNCTION zc_Movement_IncomeAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeAsset', 'Приход от поставщика (ОС)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset');

CREATE OR REPLACE FUNCTION zc_Movement_EntryAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EntryAsset', 'Документ ОС - ввод в эксплуатацию' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! РАСПОЛАГАЙТЕ ДЕСКИ ПО АЛФАВИТУ !!!!!!!!!!!!!!!!!!!
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Алексей   Роман
 25.02.17                                        * start
*/
