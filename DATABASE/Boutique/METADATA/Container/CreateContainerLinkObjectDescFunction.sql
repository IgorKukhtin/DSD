CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_JuridicalBasis', 'Юр.лицо (главное)', zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Business', 'Бизнес', /*zc_Object_Business*/zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Account', 'УП счет', zc_Object_Account() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_ProfitLoss', 'Статьи отчета ОПиУ', zc_Object_ProfitLoss() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_InfoMoney', 'Статьи назначения', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Partner'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Partner', 'Поставщик', zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Client() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Client'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Client', 'Покупатель', zc_Object_Client() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Client');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Currency'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Currency', 'Валюта', zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Currency');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Unit', 'Подразделение', zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Member'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Member', 'Физическое лицо', zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Member');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Goods', 'Товар', zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_GoodsSize() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsSize'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_GoodsSize', 'Размер', zc_Object_GoodsSize() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsSize');


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.06.17                                        *
*/
