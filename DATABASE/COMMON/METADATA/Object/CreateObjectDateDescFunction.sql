--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_DateIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_DateIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_DateOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_DateOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ObjectDate_PartionGoods_Date() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_PartionGoods_Date'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_StartDate', 'Начальная дата составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_ReceiptChild_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_ReceiptChild_EndDate', 'Конечная дата составляющие рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_ReceiptChild_EndDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_StartDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_StartDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Receipt(), 'zc_ObjectDate_Receipt_StartDate', 'Начальная дата Рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_StartDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Receipt_EndDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_EndDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_ReceiptChild(), 'zc_ObjectDate_Receipt_EndDate', 'Конечная дата Рецептур' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Receipt_EndDate');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
01.07.13           * 
*/
