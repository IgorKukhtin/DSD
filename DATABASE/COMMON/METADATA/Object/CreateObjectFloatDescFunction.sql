--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Goods_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Goods_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_GoodsPropertyValue_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_GoodsPropertyValue_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ObjectFloat_PartionMovement_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_PartionMovement_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ReceiptChild_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectFloat_ReceiptChild_Value', 'Составляющие рецептур - Значение' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ReceiptChild_Value');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_Value() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_Value', 'Значение (Количество)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_Value');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_ValueCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_ValueCost', 'Значение затрат(Количество)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_ValueCost');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_TaxExit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_TaxExit', ' % выхода' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_TaxExit');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionValue', 'Количество в партии (количество в кутере)' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionValue');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_PartionCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_PartionCount', 'Минимальное количество партий' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_PartionCount');  

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Receipt_WeightPackage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectFloat_Receipt_WeightPackage', 'Вес упаковки' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Receipt_WeightPackage');  

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        * НОВАЯ СХЕМА
*/
