CREATE OR REPLACE FUNCTION zc_MIContainer_Count() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Count'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_Count', 'Количественный учет' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Count');
  
CREATE OR REPLACE FUNCTION zc_MIContainer_CountCount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_CountCount', 'Количественный учет батонов' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountCount');

CREATE OR REPLACE FUNCTION zc_MIContainer_CountSupplier() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountSupplier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_CountSupplier', 'Количественный учет - долги поставщику' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountSupplier');

CREATE OR REPLACE FUNCTION zc_MIContainer_Summ() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_Summ', 'Суммовой учет' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Summ');

CREATE OR REPLACE FUNCTION zc_MIContainer_SummCurrency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_SummCurrency', 'Суммовой учет в валюте' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummCurrency');

CREATE OR REPLACE FUNCTION zc_MIContainer_SummIncomeMovementPayment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummIncomeMovementPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_SummIncomeMovementPayment', 'суммовая - остаток по оплате приходной накладной' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummIncomeMovementPayment');

CREATE OR REPLACE FUNCTION zc_MIContainer_CountAsset() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_CountAsset', 'Количественный учет ОС' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountAsset');

CREATE OR REPLACE FUNCTION zc_MIContainer_SummAsset() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_SummAsset', 'Суммовой учет ОС' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_SummAsset');

-- !!!Farmacy!!!
CREATE OR REPLACE FUNCTION zc_MIContainer_CountPartionDate() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountPartionDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc (Code, ItemName)
  SELECT 'zc_MIContainer_CountPartionDate', 'Количественный учет (по дате партии)' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountPartionDate');

CREATE OR REPLACE FUNCTION zc_MIContainer_CountHouseholdInventory() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountHouseholdInventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc (Code, ItemName)
  SELECT 'zc_MIContainer_CountHouseholdInventory', 'Количественный учет хозяйственного инвентаря' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_CountHouseholdInventory');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.07.20                                                      * add zc_MIContainer_CountHouseholdInventory
 19.04.19                                        * add zc_MIContainer_CountPartionDate
 11.02.15                         * 
 12.11.14                                        * add zc_MIContainer_SummCurrency
 14.09.13                                        * add zc_MIContainer_CountSupplier
 10.07.13                                        * rename to zc_MI...
 10.07.13                                        * НОВАЯ СХЕМА2 - Create and Insert
 07.07.13         * НОВАЯ СХЕМА
*/

