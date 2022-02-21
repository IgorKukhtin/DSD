
CREATE OR REPLACE FUNCTION zc_MILinkObject_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Currency', 'Валюта' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Currency_pl() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency_pl'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Currency_pl', 'Валюта (цена прайс)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency_pl');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PaidKind', 'Форма оплаты' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DiscountSaleKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountSaleKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiscountSaleKind', 'Вид скидки при продаже' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountSaleKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Cash', 'Касса обмен' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Cash');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionMI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionMI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionMI', 'Партия элемента продажа/возврат' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionMI');


CREATE OR REPLACE FUNCTION zc_MILinkObject_MoneyPlace() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MoneyPlace', 'Касса /расчетный счет / физ.лицо' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace');

CREATE OR REPLACE FUNCTION zc_MILinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_InfoMoney', 'Статьи назначения' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Unit', 'Подразделение' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Partner', 'Поставщик' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Insert', 'Пользователь (создание)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Goods', 'Комплектующие' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ColorPattern() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ColorPattern'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ColorPattern', 'Шаблон Boat Structure' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ColorPattern');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ProdColorPattern() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdColorPattern'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ProdColorPattern', 'Boat Structure' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdColorPattern');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ProdOptions() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdOptions'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ProdOptions', 'Опция' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdOptions');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ReceiptProdModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReceiptProdModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ReceiptProdModel', 'Шаблон сборка Модели' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ReceiptProdModel');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Product() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Product'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Product', 'Product' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Product');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DiscountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiscountPartner', 'группа скидки у поставщика' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountPartner');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Measure', 'Ед.изм' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Measure');

CREATE OR REPLACE FUNCTION zc_MILinkObject_MeasureParent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MeasureParent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MeasureParent', 'Ед.изм (упакови)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MeasureParent');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 18.02.22         * zc_MILinkObject_MeasureParent
                    zc_MILinkObject_Measure
                    zc_MILinkObject_DiscountPartner
 13.07.21         * zc_MILinkObject_Product
 12.07.21         * zc_MILinkObject_ReceiptProdModel
 10.07.18         * add zc_MILinkObject_MoneyPlace
                      , zc_MILinkObject_InfoMoney
                      , zc_MILinkObject_Unit
 25.05.17                                                          *
 15.05.17         * zc_MILinkObject_PartionMI
*/
