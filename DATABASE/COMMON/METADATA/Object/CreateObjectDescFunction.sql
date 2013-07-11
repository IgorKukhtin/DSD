--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_Object_Cash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Currency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_ContractKind() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ContractKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Business() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Bank() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Bank'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_BankAccount() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Contract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Car'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_CarModel() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CarModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-------------------------
CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_GoodsProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsProperty'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsPropertyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDestination() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDestination'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_JuridicalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_JuridicalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Juridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Object_UnitGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UnitGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Route() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Route'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_RouteSorting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RouteSorting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_Object_AccountPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_AssetGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AssetGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_Asset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Asset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PartionMovement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_TradeMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_TradeMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GoodsByGoodsKind', 'Связи Товары и Виды товаров' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GoodsByGoodsKind');
CREATE OR REPLACE FUNCTION zc_object_receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receipt', 'Рецептуры' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receipt');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptCost', 'Затраты в рецептурах' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptCost');

CREATE OR REPLACE FUNCTION zc_Object_ReceiptChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ReceiptChild', 'Составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ReceiptChild');


CREATE OR REPLACE FUNCTION zc_object_goodskindcomplete() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_goodskindcomplete', 'Виды товаров (готовая продукция)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_goodskindcomplete');

 
CREATE OR REPLACE FUNCTION zc_object_receiptkind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_receiptkind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_receiptkind', 'Виды рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_receiptkind');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.07.13         * переход всего на НОВУЮ СХЕМУ
 28.06.13                                        * НОВАЯ СХЕМА
*/
